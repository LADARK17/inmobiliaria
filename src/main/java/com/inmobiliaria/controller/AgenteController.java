package com.inmobiliaria.controller;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.CitaDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.dao.SolicitudDAO;
import com.inmobiliaria.model.*;

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

@WebServlet(name = "AgenteController", urlPatterns = {
    "/agente/dashboard",
    "/agente/propiedades",
    "/agente/crear-propiedad",
    "/agente/editar-propiedad",
    "/agente/baja-propiedad",
    "/agente/citas",
    "/agente/solicitudes",
    "/agente/gestionar-solicitud"
})
public class AgenteController extends HttpServlet {

    private PropiedadDAO propiedadDAO = new PropiedadDAO();
    private CitaDAO citaDAO = new CitaDAO();
    private SolicitudDAO solicitudDAO = new SolicitudDAO();
    private AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        Usuario usuario = getUsuarioSesion(req);
        int idInmobiliaria = (usuario.getIdInmobiliaria() != null && usuario.getIdInmobiliaria() > 0) ? usuario.getIdInmobiliaria() : 1;

        try {
            switch (path) {
                case "/agente/propiedades":
                    listarPropiedades(req, resp, idInmobiliaria);
                    break;
                case "/agente/crear-propiedad":
                    mostrarFormularioCrear(req, resp);
                    break;
                case "/agente/editar-propiedad":
                    mostrarFormularioEditar(req, resp);
                    break;
                case "/agente/citas":
                    listarCitasAgencia(req, resp, idInmobiliaria);
                    break;
                case "/agente/solicitudes":
                    listarSolicitudesAgencia(req, resp, idInmobiliaria);
                    break;
                case "/agente/dashboard":
                default:
                    mostrarDashboardAgente(req, resp, idInmobiliaria);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error en la consulta: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/agente/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        Usuario usuario = getUsuarioSesion(req);
        int idInmobiliaria = (usuario.getIdInmobiliaria() != null && usuario.getIdInmobiliaria() > 0) ? usuario.getIdInmobiliaria() : 1;

        try {
            switch (path) {
                case "/agente/crear-propiedad":
                    guardarNuevaPropiedad(req, resp, usuario, idInmobiliaria);
                    break;
                case "/agente/editar-propiedad":
                    actualizarPropiedad(req, resp, usuario);
                    break;
                case "/agente/baja-propiedad":
                    darDeBajaPropiedad(req, resp, usuario);
                    break;
                case "/agente/citas":
                    cambiarEstadoCita(req, resp, usuario);
                    break;
                case "/agente/gestionar-solicitud":
                    gestionarSolicitud(req, resp, usuario);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/agente/dashboard");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String msg = DatabaseConnection.translateSQLException(e);
            req.setAttribute("error", msg);
            try {
                if ("/agente/crear-propiedad".equals(path)) {
                    mostrarFormularioCrear(req, resp);
                } else if ("/agente/editar-propiedad".equals(path)) {
                    mostrarFormularioEditar(req, resp);
                } else {
                    doGet(req, resp);
                }
            } catch (SQLException ex) {
                resp.sendRedirect(req.getContextPath() + "/agente/dashboard?error=" + java.net.URLEncoder.encode(msg, "UTF-8"));
            }
        }
    }

    private void mostrarDashboardAgente(HttpServletRequest req, HttpServletResponse resp, int idInmobiliaria) throws SQLException, ServletException, IOException {
        List<Propiedad> props = propiedadDAO.listarPorInmobiliaria(idInmobiliaria);
        List<Cita> citas = citaDAO.listarPorInmobiliaria(idInmobiliaria);
        List<Solicitud> solicitudes = solicitudDAO.listarPorInmobiliaria(idInmobiliaria);

        long pendientesCitas = citas.stream().filter(c -> "PENDIENTE".equalsIgnoreCase(c.getEstado())).count();
        long pendientesSol = solicitudes.stream().filter(s -> "PENDIENTE".equalsIgnoreCase(s.getEstado()) || "EN_REVISION".equalsIgnoreCase(s.getEstado())).count();

        req.setAttribute("totalPropiedades", props.size());
        req.setAttribute("citasPendientes", pendientesCitas);
        req.setAttribute("solicitudesPendientes", pendientesSol);
        req.setAttribute("ultimasPropiedades", props.size() > 4 ? props.subList(0, 4) : props);
        req.setAttribute("ultimasCitas", citas.size() > 4 ? citas.subList(0, 4) : citas);

        req.getRequestDispatcher("/WEB-INF/views/agente/dashboard.jsp").forward(req, resp);
    }

    private void listarPropiedades(HttpServletRequest req, HttpServletResponse resp, int idInmobiliaria) throws SQLException, ServletException, IOException {
        req.setAttribute("propiedades", propiedadDAO.listarPorInmobiliaria(idInmobiliaria));
        req.getRequestDispatcher("/WEB-INF/views/agente/mis-propiedades.jsp").forward(req, resp);
    }

    private void mostrarFormularioCrear(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        req.setAttribute("ciudades", propiedadDAO.listarCiudades());
        req.setAttribute("tipos", propiedadDAO.listarTiposPropiedad());
        req.setAttribute("caracteristicas", propiedadDAO.listarCaracteristicas());
        req.setAttribute("esEdicion", false);
        req.getRequestDispatcher("/WEB-INF/views/agente/form-propiedad.jsp").forward(req, resp);
    }

    private void mostrarFormularioEditar(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Propiedad p = propiedadDAO.obtenerPorId(id);
        req.setAttribute("propiedad", p);
        req.setAttribute("ciudades", propiedadDAO.listarCiudades());
        req.setAttribute("tipos", propiedadDAO.listarTiposPropiedad());
        req.setAttribute("caracteristicas", propiedadDAO.listarCaracteristicas());
        req.setAttribute("esEdicion", true);
        req.getRequestDispatcher("/WEB-INF/views/agente/form-propiedad.jsp").forward(req, resp);
    }

    private void guardarNuevaPropiedad(HttpServletRequest req, HttpServletResponse resp, Usuario u, int idInmobiliaria) throws SQLException, IOException {
        Propiedad p = poblarPropiedadDesdeRequest(req, idInmobiliaria);

        String[] caracIds = req.getParameterValues("caracteristicas");
        List<Integer> listCaracs = new ArrayList<>();
        if (caracIds != null) {
            for (String cid : caracIds) listCaracs.add(Integer.parseInt(cid));
        }

        String urlsImgParam = req.getParameter("imagenesUrls");
        List<String> urls = new ArrayList<>();
        if (urlsImgParam != null && !urlsImgParam.trim().isEmpty()) {
            urls = Arrays.asList(urlsImgParam.split("\n"));
        } else {
            urls.add("https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800");
        }

        propiedadDAO.insertar(p, listCaracs, urls);
        auditoriaDAO.registrar(new Auditoria(u.getId(), "CREAR_PROPIEDAD", "propiedad", p.getId(), "Propiedad matricula " + p.getMatriculaInmobiliaria(), req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/agente/propiedades?exito=Inmueble+publicado+exitosamente.");
    }

    private void actualizarPropiedad(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        int idInmobiliaria = (u.getIdInmobiliaria() != null && u.getIdInmobiliaria() > 0) ? u.getIdInmobiliaria() : 1;
        Propiedad p = poblarPropiedadDesdeRequest(req, idInmobiliaria);
        p.setId(id);

        String[] caracIds = req.getParameterValues("caracteristicas");
        List<Integer> listCaracs = new ArrayList<>();
        if (caracIds != null) {
            for (String cid : caracIds) listCaracs.add(Integer.parseInt(cid));
        }

        String urlsImgParam = req.getParameter("imagenesUrls");
        List<String> urls = null;
        if (urlsImgParam != null && !urlsImgParam.trim().isEmpty()) {
            urls = Arrays.asList(urlsImgParam.split("\n"));
        }

        propiedadDAO.actualizar(p, listCaracs, urls);
        auditoriaDAO.registrar(new Auditoria(u.getId(), "ACTUALIZAR_PROPIEDAD", "propiedad", id, "Modificación de datos del inmueble", req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/agente/propiedades?exito=Propiedad+actualizada+correctamente.");
    }

    private void darDeBajaPropiedad(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        propiedadDAO.bajaLogica(id);
        auditoriaDAO.registrar(new Auditoria(u.getId(), "BAJA_LOGICA_PROPIEDAD", "propiedad", id, "Estado cambiado a INACTIVA", req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/agente/propiedades?exito=Inmueble+dado+de+baja+logica+satisfactoriamente.");
    }

    private void listarCitasAgencia(HttpServletRequest req, HttpServletResponse resp, int idInmobiliaria) throws SQLException, ServletException, IOException {
        req.setAttribute("citas", citaDAO.listarPorInmobiliaria(idInmobiliaria));
        req.getRequestDispatcher("/WEB-INF/views/agente/gestion-citas.jsp").forward(req, resp);
    }

    private void cambiarEstadoCita(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException {
        int idCita = Integer.parseInt(req.getParameter("idCita"));
        String nuevoEstado = req.getParameter("nuevoEstado");
        citaDAO.cambiarEstado(idCita, nuevoEstado);
        auditoriaDAO.registrar(new Auditoria(u.getId(), "CAMBIAR_ESTADO_CITA", "cita", idCita, "Nuevo estado: " + nuevoEstado, req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/agente/citas?exito=Estado+de+la+cita+actualizado.");
    }

    private void listarSolicitudesAgencia(HttpServletRequest req, HttpServletResponse resp, int idInmobiliaria) throws SQLException, ServletException, IOException {
        req.setAttribute("solicitudes", solicitudDAO.listarPorInmobiliaria(idInmobiliaria));
        req.getRequestDispatcher("/WEB-INF/views/agente/revision-solicitudes.jsp").forward(req, resp);
    }

    private void gestionarSolicitud(HttpServletRequest req, HttpServletResponse resp, Usuario u) throws SQLException, IOException {
        int idSol = Integer.parseInt(req.getParameter("idSolicitud"));
        String accion = req.getParameter("accion"); // 'APROBADA', 'RECHAZADA'
        String observaciones = req.getParameter("observaciones");

        solicitudDAO.actualizarEstado(idSol, accion, observaciones);

        // Si se aprueba o rechaza un documento individual
        String docIdParam = req.getParameter("idDocumento");
        if (docIdParam != null && !docIdParam.isEmpty()) {
            solicitudDAO.actualizarEstadoDocumento(Integer.parseInt(docIdParam), req.getParameter("estadoDocumento"));
        }

        auditoriaDAO.registrar(new Auditoria(u.getId(), "RESOLVER_SOLICITUD", "solicitud", idSol, "Trámite marcado como: " + accion, req.getRemoteAddr()));
        resp.sendRedirect(req.getContextPath() + "/agente/solicitudes?exito=Solicitud+actualizada+satisfactoriamente.");
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

    private Usuario getUsuarioSesion(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (Usuario) s.getAttribute("usuarioLogueado") : null;
    }
}
