package com.inmobiliaria.controller;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.ReporteDAO;
import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.model.Auditoria;
import com.inmobiliaria.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AdminController", urlPatterns = {
    "/admin/dashboard",
    "/admin/usuarios",
    "/admin/cambiar-estado-usuario",
    "/admin/asignar-rol",
    "/admin/remover-rol",
    "/admin/auditoria",
    "/admin/reportes"
})
public class AdminController extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private AuditoriaDAO auditoriaDAO = new AuditoriaDAO();
    private ReporteDAO reporteDAO = new ReporteDAO();

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
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMsg = DatabaseConnection.translateSQLException(e);
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios?error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
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
