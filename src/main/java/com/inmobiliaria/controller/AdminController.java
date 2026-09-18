package com.inmobiliaria.controller;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.dao.ReporteDAO;
import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.model.Auditoria;
import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "AdminController", urlPatterns = {
    "/admin/dashboard",
    "/admin/usuarios",
    "/admin/cambiar-estado-usuario",
    "/admin/asignar-rol",
    "/admin/remover-rol",
    "/admin/auditoria",
    "/admin/reportes",
    "/admin/propiedades",
    "/admin/crear-propiedad",
    "/admin/editar-propiedad",
    "/admin/cambiar-estado-propiedad"
})
public class AdminController extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private AuditoriaDAO auditoriaDAO = new AuditoriaDAO();
    private ReporteDAO reporteDAO = new ReporteDAO();
    private PropiedadDAO propiedadDAO = new PropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            switch (path) {
                case "/admin/usuarios":
                    mostrarUsuarios(req, resp);
                    break;
                case "/admin/auditoria":
                    mostrarAuditoria(req, resp);
                    break;
                case "/admin/reportes":
                    mostrarReportes(req, resp);
                    break;
                case "/admin/propiedades":
                    listarPropiedades(req, resp);
                    break;
                case "/admin/crear-propiedad":
                    mostrarFormularioCrear(req, resp);
                    break;
                case "/admin/editar-propiedad":
                    mostrarFormularioEditar(req, resp);
                    break;
                case "/admin/dashboard":
                default:
                    mostrarDashboard(req, resp);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error en base de datos: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        Usuario adminLogueado = getUsuarioSesion(req);

        try {
            switch (path) {
                case "/admin/cambiar-estado-usuario":
                    cambiarEstadoUsuario(req, resp, adminLogueado);
                    break;
                case "/admin/asignar-rol":
                    asignarRol(req, resp, adminLogueado);
                    break;
                case "/admin/remover-rol":
                    removerRol(req, resp, adminLogueado);
                    break;
                case "/admin/crear-propiedad":
                    guardarNuevaPropiedad(req, resp, adminLogueado);
                    break;
                case "/admin/editar-propiedad":
                    actualizarPropiedad(req, resp, adminLogueado);
                    break;
                case "/admin/cambiar-estado-propiedad":
                    cambiarEstadoPropiedad(req, resp, adminLogueado);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMsg = DatabaseConnection.translateSQLException(e);
            String urlVolver = (path != null && path.contains("propiedad"))
                    ? "/admin/propiedades" : "/admin/usuarios";
            resp.sendRedirect(req.getContextPath() + urlVolver + "?error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }

    private void mostrarDashboard(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        req.setAttribute("resumen", reporteDAO.resumenGlobal());
        req.setAttribute("ultimosUsuarios", usuarioDAO.listarTodos());
        req.setAttribute("logsRecientes", auditoriaDAO.listarRecientes(5));
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void mostrarUsuarios(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        req.setAttribute("usuarios", usuarioDAO.listarTodos());
        req.setAttribute("rolesDisponibles", usuarioDAO.listarRoles());
        req.getRequestDispatcher("/WEB-INF/views/admin/usuarios.jsp").forward(req, resp);
    }

    private void mostrarAuditoria(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        req.setAttribute("logs", auditoriaDAO.listarRecientes(50));
        req.getRequestDispatcher("/WEB-INF/views/admin/auditoria.jsp").forward(req, resp);
    }

    private void mostrarReportes(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        // Consulta 5 obligatoria: GROUP BY + HAVING
        req.setAttribute("reporteCiudades", reporteDAO.reporteCiudadesPreciosVenta());
        // Consulta 4 obligatoria: LEFT JOIN sin citas
        req.setAttribute("propiedadesSinCitas", reporteDAO.reportePropiedadesSinCitas());
        // Reporte citas por estado
        req.setAttribute("citasPorEstado", reporteDAO.reporteCitasPorEstado());
        // Reporte solicitudes por inmobiliaria
        req.setAttribute("solicitudesPorInmobiliaria", reporteDAO.reporteSolicitudesPorInmobiliaria());

        req.getRequestDispatcher("/WEB-INF/views/admin/reportes.jsp").forward(req, resp);
    }

    private void listarPropiedades(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        req.setAttribute("propiedades", propiedadDAO.listarTodas());
        req.getRequestDispatcher("/WEB-INF/views/admin/propiedades.jsp").forward(req, resp);
    }

    private void mostrarFormularioCrear(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        prepararCatalogos(req);
        req.setAttribute("esEdicion", false);
        req.getRequestDispatcher("/WEB-INF/views/admin/form-propiedad.jsp").forward(req, resp);
    }

    private void mostrarFormularioEditar(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("propiedad", propiedadDAO.obtenerPorId(id));
        prepararCatalogos(req);
        req.setAttribute("esEdicion", true);
        req.getRequestDispatcher("/WEB-INF/views/admin/form-propiedad.jsp").forward(req, resp);
    }

    private void prepararCatalogos(HttpServletRequest req) throws SQLException {
        req.setAttribute("inmobiliarias", propiedadDAO.listarInmobiliarias());
        req.setAttribute("ciudades", propiedadDAO.listarCiudades());
        req.setAttribute("tipos", propiedadDAO.listarTiposPropiedad());
        req.setAttribute("caracteristicas", propiedadDAO.listarCaracteristicas());
    }

    private void guardarNuevaPropiedad(HttpServletRequest req, HttpServletResponse resp, Usuario admin) throws SQLException, IOException {
        int idInmobiliaria = Integer.parseInt(req.getParameter("idInmobiliaria"));
        Propiedad p = poblarPropiedadDesdeRequest(req, idInmobiliaria);

        List<Integer> listCaracs = parseCaracteristicas(req);

        String urlsImgParam = req.getParameter("imagenesUrls");
        List<String> urls = new ArrayList<>();
        if (urlsImgParam != null && !urlsImgParam.trim().isEmpty()) {
            urls = Arrays.asList(urlsImgParam.split("\n"));
        } else {
            urls.add("https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800");
        }

        propiedadDAO.insertar(p, listCaracs, urls);
        auditoriaDAO.registrar(new Auditoria(admin.getId(), "CREAR_PROPIEDAD", "propiedad", p.getId(), "Propiedad matricula " + p.getMatriculaInmobiliaria(), req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/admin/propiedades?exito=Inmueble+publicado+exitosamente.");
    }

    private void actualizarPropiedad(HttpServletRequest req, HttpServletResponse resp, Usuario admin) throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        int idInmobiliaria = Integer.parseInt(req.getParameter("idInmobiliaria"));
        Propiedad p = poblarPropiedadDesdeRequest(req, idInmobiliaria);
        p.setId(id);

        List<Integer> listCaracs = parseCaracteristicas(req);

        String urlsImgParam = req.getParameter("imagenesUrls");
        List<String> urls = null;
        if (urlsImgParam != null && !urlsImgParam.trim().isEmpty()) {
            urls = Arrays.asList(urlsImgParam.split("\n"));
        }

        propiedadDAO.actualizar(p, listCaracs, urls);
        auditoriaDAO.registrar(new Auditoria(admin.getId(), "ACTUALIZAR_PROPIEDAD", "propiedad", id, "Modificación de datos del inmueble", req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/admin/propiedades?exito=Propiedad+actualizada+correctamente.");
    }

    private void cambiarEstadoPropiedad(HttpServletRequest req, HttpServletResponse resp, Usuario admin) throws SQLException, IOException {
        int idPropiedad = Integer.parseInt(req.getParameter("id"));
        String nuevoEstado = req.getParameter("nuevoEstado");
        if (nuevoEstado == null || nuevoEstado.trim().isEmpty()) {
            nuevoEstado = "INACTIVA";
        }
        nuevoEstado = nuevoEstado.trim().toUpperCase();

        if ("INACTIVA".equals(nuevoEstado)) {
            propiedadDAO.bajaLogica(idPropiedad);
        } else {
            propiedadDAO.cambiarEstado(idPropiedad, nuevoEstado);
        }
        String accion = "INACTIVA".equals(nuevoEstado) ? "BAJA_LOGICA_PROPIEDAD" : "REACTIVAR_PROPIEDAD";
        auditoriaDAO.registrar(new Auditoria(admin.getId(), accion, "propiedad", idPropiedad, "Estado del catálogo cambiado a: " + nuevoEstado, req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/admin/propiedades?exito=" + java.net.URLEncoder.encode("INACTIVA".equals(nuevoEstado) ? "Inmueble bajado del catalogo." : "Inmueble publicado de forma activa.", "UTF-8"));
    }

    private List<Integer> parseCaracteristicas(HttpServletRequest req) {
        String[] caracIds = req.getParameterValues("caracteristicas");
        List<Integer> listCaracs = new ArrayList<>();
        if (caracIds != null) {
            for (String cid : caracIds) listCaracs.add(Integer.parseInt(cid));
        }
        return listCaracs;
    }

    private Propiedad poblarPropiedadDesdeRequest(HttpServletRequest req, int idInmobiliaria) {
        Propiedad p = new Propiedad();
        p.setIdInmobiliaria(idInmobiliaria);
        p.setIdCiudad(Integer.parseInt(req.getParameter("idCiudad")));
        p.setIdTipoPropiedad(Integer.parseInt(req.getParameter("idTipoPropiedad")));
        p.setMatriculaInmobiliaria(req.getParameter("matriculaInmobiliaria").trim());
        p.setTitulo(req.getParameter("titulo").trim());
        p.setDescripcion(req.getParameter("descripcion").trim());
        p.setPrecio(new BigDecimal(req.getParameter("precio")));
        p.setAreaM2(new BigDecimal(req.getParameter("areaM2") != null && !req.getParameter("areaM2").isEmpty() ? req.getParameter("areaM2") : "0"));
        p.setHabitaciones(Integer.parseInt(req.getParameter("habitaciones")));
        p.setBanos(Integer.parseInt(req.getParameter("banos")));
        p.setEstrato(Integer.parseInt(req.getParameter("estrato")));
        p.setDireccion(req.getParameter("direccion").trim());
        p.setDestacada(req.getParameter("destacada") != null);
        p.setTipoOperacion(req.getParameter("tipoOperacion"));
        p.setEstado(req.getParameter("estado") != null ? req.getParameter("estado") : "DISPONIBLE");
        return p;
    }

    private void cambiarEstadoUsuario(HttpServletRequest req, HttpServletResponse resp, Usuario admin) throws SQLException, IOException {
        int idUsuario = Integer.parseInt(req.getParameter("idUsuario"));
        String nuevoEstado = req.getParameter("nuevoEstado");

        usuarioDAO.actualizarEstado(idUsuario, nuevoEstado);
        auditoriaDAO.registrar(new Auditoria(admin.getId(), "MODIFICAR_ESTADO_CUENTA", "usuario", idUsuario, "Cuenta cambiada a: " + nuevoEstado, req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios?exito=Estado+de+la+cuenta+actualizado.");
    }

    private void asignarRol(HttpServletRequest req, HttpServletResponse resp, Usuario admin) throws SQLException, IOException {
        int idUsuario = Integer.parseInt(req.getParameter("idUsuario"));
        int idRol = Integer.parseInt(req.getParameter("idRol"));

        usuarioDAO.asignarRol(idUsuario, idRol);
        auditoriaDAO.registrar(new Auditoria(admin.getId(), "ASIGNAR_ROL", "usuario_rol", idUsuario, "Asignado rol ID: " + idRol, req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios?exito=Rol+asignado+satisfactoriamente.");
    }

    private void removerRol(HttpServletRequest req, HttpServletResponse resp, Usuario admin) throws SQLException, IOException {
        int idUsuario = Integer.parseInt(req.getParameter("idUsuario"));
        int idRol = Integer.parseInt(req.getParameter("idRol"));

        usuarioDAO.removerRol(idUsuario, idRol);
        auditoriaDAO.registrar(new Auditoria(admin.getId(), "REMOVER_ROL", "usuario_rol", idUsuario, "Removido rol ID: " + idRol, req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios?exito=Rol+revocado+correctamente.");
    }

    private Usuario getUsuarioSesion(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (Usuario) s.getAttribute("usuarioLogueado") : null;
    }
}
