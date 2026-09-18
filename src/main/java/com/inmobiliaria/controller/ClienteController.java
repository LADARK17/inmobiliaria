package com.inmobiliaria.controller;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.dao.*;
import com.inmobiliaria.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "ClienteController", urlPatterns = {
    "/cliente/dashboard",
    "/cliente/perfil",
    "/cliente/favoritos",
    "/cliente/citas",
    "/cliente/agendar-cita",
    "/cliente/solicitudes",
    "/cliente/crear-solicitud",
    "/cliente/subir-documento"
})
public class ClienteController extends HttpServlet {

    private PerfilDAO perfilDAO = new PerfilDAO();
    private FavoritoDAO favoritoDAO = new FavoritoDAO();
    private CitaDAO citaDAO = new CitaDAO();
    private SolicitudDAO solicitudDAO = new SolicitudDAO();
    private AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        Usuario usuario = getUsuarioSesion(req);

        try {
            switch (path) {
                case "/cliente/perfil":
                    mostrarPerfil(req, resp, usuario);
                    break;
                case "/cliente/favoritos":
                    mostrarFavoritos(req, resp, usuario);
                    break;
                case "/cliente/citas":
                    mostrarCitas(req, resp, usuario);
                    break;
                case "/cliente/solicitudes":
                    mostrarSolicitudes(req, resp, usuario);
                    break;
                case "/cliente/dashboard":
                default:
                    mostrarDashboard(req, resp, usuario);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error en base de datos: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/cliente/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        Usuario usuario = getUsuarioSesion(req);

        try {
            switch (path) {
                case "/cliente/perfil":
                    actualizarPerfil(req, resp, usuario);
                    break;
                case "/cliente/favoritos":
                    gestionarFavorito(req, resp, usuario);
                    break;
                case "/cliente/agendar-cita":
                    agendarCita(req, resp, usuario);
                    break;
                case "/cliente/crear-solicitud":
                    crearSolicitud(req, resp, usuario);
                    break;
                case "/cliente/subir-documento":
                    subirDocumento(req, resp, usuario);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/cliente/dashboard");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String msg = DatabaseConnection.translateSQLException(e);
            req.setAttribute("error", msg);
            doGet(req, resp);
        }
    }

    private void mostrarDashboard(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, ServletException, IOException {
        List<Favorito> favoritos = favoritoDAO.listarPorUsuario(u.getId());
        List<Cita> citas = citaDAO.listarPorCliente(u.getId());
        List<Solicitud> solicitudes = solicitudDAO.listarPorCliente(u.getId());

        req.setAttribute("totalFavoritos", favoritos.size());
        req.setAttribute("totalCitas", citas.size());
        req.setAttribute("totalSolicitudes", solicitudes.size());
        req.setAttribute("citasRecientes", citas.size() > 3 ? citas.subList(0, 3) : citas);
        req.setAttribute("solicitudesRecientes", solicitudes.size() > 3 ? solicitudes.subList(0, 3) : solicitudes);

        req.getRequestDispatcher("/WEB-INF/views/cliente/dashboard.jsp").forward(req, resp);
    }

    private void mostrarPerfil(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, ServletException, IOException {
        Perfil p = perfilDAO.findByUsuarioId(u.getId());
        req.setAttribute("perfil", p);
        req.getRequestDispatcher("/WEB-INF/views/cliente/perfil.jsp").forward(req, resp);
    }

    private void actualizarPerfil(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException, ServletException {
        Perfil p = new Perfil();
        p.setIdUsuario(u.getId());
        p.setNombres(req.getParameter("nombres"));
        p.setApellidos(req.getParameter("apellidos"));
        p.setDocumentoIdentidad(req.getParameter("documento"));
        p.setTelefono(req.getParameter("telefono"));
        p.setDireccion(req.getParameter("direccion"));
        p.setFotoUrl(req.getParameter("fotoUrl"));

        perfilDAO.actualizar(p);
        u.setPerfil(p);
        req.getSession().setAttribute("nombre_usuario", p.getNombreCompleto());

        auditoriaDAO.registrar(new Auditoria(u.getId(), "ACTUALIZAR_PERFIL", "perfil", u.getId(), "Perfil 1:1 actualizado", req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/cliente/perfil?exito=Perfil+actualizado+correctamente.");
    }

    private void mostrarFavoritos(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, ServletException, IOException {
        req.setAttribute("favoritos", favoritoDAO.listarPorUsuario(u.getId()));
        req.getRequestDispatcher("/WEB-INF/views/cliente/favoritos.jsp").forward(req, resp);
    }

    private void gestionarFavorito(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException {
        int idPropiedad = Integer.parseInt(req.getParameter("idPropiedad"));
        String accion = req.getParameter("accion"); // 'agregar' o 'eliminar'

        if ("eliminar".equalsIgnoreCase(accion)) {
            favoritoDAO.eliminar(u.getId(), idPropiedad);
        } else {
            favoritoDAO.agregar(u.getId(), idPropiedad);
        }

        String origen = req.getParameter("origen");
        if ("detalle".equalsIgnoreCase(origen)) {
            resp.sendRedirect(req.getContextPath() + "/propiedad?id=" + idPropiedad);
        } else {
            resp.sendRedirect(req.getContextPath() + "/cliente/favoritos");
        }
    }

    private void mostrarCitas(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, ServletException, IOException {
        req.setAttribute("citas", citaDAO.listarPorCliente(u.getId()));
        req.getRequestDispatcher("/WEB-INF/views/cliente/citas.jsp").forward(req, resp);
    }

    private void agendarCita(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException {
        int idPropiedad = Integer.parseInt(req.getParameter("idPropiedad"));
        String fechaHoraStr = req.getParameter("fechaHora");
        String comentarios = req.getParameter("comentarios");
        String origenError = req.getContextPath() + "/propiedad?id=" + idPropiedad + "&error=";

        if (fechaHoraStr == null || fechaHoraStr.trim().isEmpty()) {
            resp.sendRedirect(origenError + java.net.URLEncoder.encode("Debe seleccionar una fecha y hora para la visita.", "UTF-8"));
            return;
        }

        try {
            LocalDateTime fechaHora = LocalDateTime.parse(fechaHoraStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

            if (fechaHora.isBefore(LocalDateTime.now())) {
                resp.sendRedirect(origenError + java.net.URLEncoder.encode("La fecha y hora de la visita debe ser posterior al momento actual.", "UTF-8"));
                return;
            }

            if (citaDAO.existeCitaActiva(idPropiedad, fechaHora)) {
                resp.sendRedirect(origenError + java.net.URLEncoder.encode("Ese turno ya está reservado por otro cliente. Seleccione un horario disponible según el calendario.", "UTF-8"));
                return;
            }

            Cita cita = new Cita();
            cita.setIdCliente(u.getId());
            cita.setIdPropiedad(idPropiedad);
            cita.setFechaHora(fechaHora);
            cita.setComentarios(comentarios);

            if (!citaDAO.agendar(cita)) {
                resp.sendRedirect(origenError + java.net.URLEncoder.encode("No se pudo reservar el turno. Por favor intente nuevamente.", "UTF-8"));
                return;
            }

            auditoriaDAO.registrar(new Auditoria(u.getId(), "AGENDAR_CITA", "cita", idPropiedad, "Visita agendada para el " + fechaHoraStr, req.getRemoteAddr()));
            resp.sendRedirect(req.getContextPath() + "/cliente/citas?exito=Visita+agendada+correctamente.+El+agente+confirmara+el+horario.");
        } catch (DateTimeParseException ex) {
            resp.sendRedirect(origenError + java.net.URLEncoder.encode("El formato de fecha y hora ingresado no es válido.", "UTF-8"));
        } catch (SQLException ex) {
            String errorMsg = DatabaseConnection.translateSQLException(ex);
            resp.sendRedirect(origenError + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }

    private void mostrarSolicitudes(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, ServletException, IOException {
        req.setAttribute("solicitudes", solicitudDAO.listarPorCliente(u.getId()));
        req.getRequestDispatcher("/WEB-INF/views/cliente/solicitudes.jsp").forward(req, resp);
    }

    private void crearSolicitud(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException {
        int idPropiedad = Integer.parseInt(req.getParameter("idPropiedad"));
        String tipoOperacion = req.getParameter("tipoOperacion");
        String observaciones = req.getParameter("observaciones");

        Solicitud s = new Solicitud();
        s.setIdCliente(u.getId());
        s.setIdPropiedad(idPropiedad);
        s.setTipoOperacion(tipoOperacion);
        s.setObservaciones(observaciones);

        int idSol = solicitudDAO.crear(s);
        auditoriaDAO.registrar(new Auditoria(u.getId(), "RADICAR_SOLICITUD", "solicitud", idSol, "Trámite de " + tipoOperacion + " para propiedad " + idPropiedad, req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/cliente/solicitudes?exito=Solicitud+radicada+exitosamente.+Ahora+puede+adjuntar+sus+documentos.");
    }

    private void subirDocumento(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException {
        int idSolicitud = Integer.parseInt(req.getParameter("idSolicitud"));
        String tipoDoc = req.getParameter("tipoDocumento");
        String nombreArchivo = req.getParameter("nombreArchivo");

        DocumentoSolicitud doc = new DocumentoSolicitud();
        doc.setIdSolicitud(idSolicitud);
        doc.setTipoDocumento(tipoDoc);
        doc.setNombreArchivo(nombreArchivo != null && !nombreArchivo.isEmpty() ? nombreArchivo : "Documento_Cliente_" + u.getId() + ".pdf");
        doc.setRutaArchivo("uploads/docs/" + doc.getNombreArchivo());

        solicitudDAO.agregarDocumento(doc);
        auditoriaDAO.registrar(new Auditoria(u.getId(), "SUBIR_DOCUMENTO", "documento_solicitud", idSolicitud, "Documento radicado: " + tipoDoc, req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/cliente/solicitudes?exito=Documento+radicado+exitosamente.");
    }

    private Usuario getUsuarioSesion(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (Usuario) s.getAttribute("usuarioLogueado") : null;
    }
}
