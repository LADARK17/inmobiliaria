package com.inmobiliaria.controller;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.model.Auditoria;
import com.inmobiliaria.model.Perfil;
import com.inmobiliaria.model.Usuario;
import com.inmobiliaria.util.PasswordHasher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AuthController", urlPatterns = {"/login", "/registro", "/logout"})
public class AuthController extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
                if (u != null) {
                    auditoriaDAO.registrar(new Auditoria(
                        u.getId(), "LOGOUT", "usuario", u.getId(),
                        "Cierre de sesión del usuario: " + u.getCorreo(),
                        req.getRemoteAddr()
                    ));
                }
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login?mensaje=Sesion+finalizada+exitosamente");
            return;
        }

        if ("/registro".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/public/registro.jsp").forward(req, resp);
            return;
        }

        // Por defecto: /login
        req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            procesarLogin(req, resp);
        } else if ("/registro".equals(path)) {
            procesarRegistro(req, resp);
        }
    }

    private void procesarLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String correo = req.getParameter("correo");
        String password = req.getParameter("password");

        if (correo == null || correo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Por favor ingrese su correo electrónico y contraseña.");
            req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
            return;
        }

        try {
            Usuario u = usuarioDAO.findByCorreo(correo.trim());

            if (u == null || !PasswordHasher.check(password, u.getPasswordHash())) {
                req.setAttribute("error", "Credenciales incorrectas. Verifique su correo o contraseña.");
                req.setAttribute("correoPrevio", correo);
                req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
                return;
            }

            if (!"ACTIVO".equalsIgnoreCase(u.getEstado())) {
                req.setAttribute("error", "Su cuenta se encuentra inactiva o bloqueada por el administrador.");
                req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
                return;
            }

            // Iniciar sesión y fijar atributos requeridos
            HttpSession session = req.getSession(true);
            session.setAttribute("usuarioLogueado", u);
            session.setAttribute("id_usuario", u.getId());
            session.setAttribute("correo_usuario", u.getCorreo());
            session.setAttribute("roles", u.getRoles());
            session.setAttribute("nombre_usuario", (u.getPerfil() != null) ? u.getPerfil().getNombreCompleto() : u.getCorreo());

            // Auditoría del login
            auditoriaDAO.registrar(new Auditoria(
                u.getId(), "LOGIN", "usuario", u.getId(),
                "Inicio de sesión exitoso desde " + req.getRemoteAddr(),
                req.getRemoteAddr()
            ));

            // Redirigir al dashboard adecuado según el rol de mayor jerarquía
            if (u.hasRol("ADMINISTRADOR")) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if (u.hasRol("AGENTE")) {
                resp.sendRedirect(req.getContextPath() + "/agente/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/cliente/dashboard");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error de base de datos al validar credenciales: " + DatabaseConnection.translateSQLException(e));
            req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
        }
    }

    private void procesarRegistro(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String correo = req.getParameter("correo");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String nombres = req.getParameter("nombres");
        String apellidos = req.getParameter("apellidos");
        String documento = req.getParameter("documento");
        String telefono = req.getParameter("telefono");
        String direccion = req.getParameter("direccion");

        // Validaciones obligatorias de servidor
        if (correo == null || correo.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            nombres == null || nombres.trim().isEmpty() ||
            apellidos == null || apellidos.trim().isEmpty() ||
            documento == null || documento.trim().isEmpty()) {

            req.setAttribute("error", "Todos los campos marcados con asterisco son obligatorios.");
            mantenerFormulario(req, correo, nombres, apellidos, documento, telefono, direccion);
            req.getRequestDispatcher("/WEB-INF/views/public/registro.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Las contraseñas ingresadas no coinciden.");
            mantenerFormulario(req, correo, nombres, apellidos, documento, telefono, direccion);
            req.getRequestDispatcher("/WEB-INF/views/public/registro.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "La contraseña debe tener un mínimo de 6 caracteres.");
            mantenerFormulario(req, correo, nombres, apellidos, documento, telefono, direccion);
            req.getRequestDispatcher("/WEB-INF/views/public/registro.jsp").forward(req, resp);
            return;
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setCorreo(correo.trim().toLowerCase());
        nuevoUsuario.setPasswordHash(PasswordHasher.hash(password));

        Perfil nuevoPerfil = new Perfil();
        nuevoPerfil.setNombres(nombres.trim());
        nuevoPerfil.setApellidos(apellidos.trim());
        nuevoPerfil.setDocumentoIdentidad(documento.trim());
        nuevoPerfil.setTelefono(telefono != null ? telefono.trim() : "");
        nuevoPerfil.setDireccion(direccion != null ? direccion.trim() : "");

        try {
            // Rol 3 = CLIENTE
            usuarioDAO.registrar(nuevoUsuario, nuevoPerfil, 3);

            auditoriaDAO.registrar(new Auditoria(
                nuevoUsuario.getId(), "REGISTRO", "usuario", nuevoUsuario.getId(),
                "Registro de nuevo cliente: " + nuevoUsuario.getCorreo(),
                req.getRemoteAddr()
            ));

            resp.sendRedirect(req.getContextPath() + "/login?exito=Cuenta+creada+exitosamente.+Ya+puede+iniciar+sesion.");

        } catch (SQLException e) {
            // Transformar la violación de restricción UNIQUE en mensaje amigable
            String errorAmigable = DatabaseConnection.translateSQLException(e);
            req.setAttribute("error", errorAmigable);
            mantenerFormulario(req, correo, nombres, apellidos, documento, telefono, direccion);
            req.getRequestDispatcher("/WEB-INF/views/public/registro.jsp").forward(req, resp);
        }
    }

    private void mantenerFormulario(HttpServletRequest req, String correo, String nombres, String apellidos,
                                   String documento, String telefono, String direccion) {
        req.setAttribute("correo", correo);
        req.setAttribute("nombres", nombres);
        req.setAttribute("apellidos", apellidos);
        req.setAttribute("documento", documento);
        req.setAttribute("telefono", telefono);
        req.setAttribute("direccion", direccion);
    }
}
