package com.inmobiliaria.controller;

import com.inmobiliaria.dao.FavoritoDAO;
import com.inmobiliaria.dao.PropiedadDAO;
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
import java.util.List;

@WebServlet(name = "PublicController", urlPatterns = {"", "/inicio", "/catalogo", "/propiedad"})
public class PublicController extends HttpServlet {

    private PropiedadDAO propiedadDAO = new PropiedadDAO();
    private FavoritoDAO favoritoDAO = new FavoritoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/catalogo".equals(path)) {
                mostrarCatalogo(req, resp);
            } else if ("/propiedad".equals(path)) {
                mostrarDetallePropiedad(req, resp);
            } else {
                mostrarLanding(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error al consultar la información: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/public/index.jsp").forward(req, resp);
        }
    }

    private void mostrarLanding(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        List<Propiedad> destacadas = propiedadDAO.listarDestacadas(6);
        req.setAttribute("destacadas", destacadas);
        req.setAttribute("ciudades", propiedadDAO.listarCiudades());
        req.setAttribute("tipos", propiedadDAO.listarTiposPropiedad());
        req.getRequestDispatcher("/WEB-INF/views/public/index.jsp").forward(req, resp);
    }

    private void mostrarCatalogo(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        // Carga de parámetros de filtro
        String ciudadParam = req.getParameter("ciudad");
        String tipoParam = req.getParameter("tipo");
        String operacionParam = req.getParameter("operacion");
        String precioMinParam = req.getParameter("precioMin");
        String precioMaxParam = req.getParameter("precioMax");
        String[] caracParams = req.getParameterValues("caracteristica");

        Integer idCiudad = (ciudadParam != null && !ciudadParam.isEmpty()) ? Integer.parseInt(ciudadParam) : null;
        Integer idTipo = (tipoParam != null && !tipoParam.isEmpty()) ? Integer.parseInt(tipoParam) : null;
        BigDecimal precioMin = (precioMinParam != null && !precioMinParam.isEmpty()) ? new BigDecimal(precioMinParam) : null;
        BigDecimal precioMax = (precioMaxParam != null && !precioMaxParam.isEmpty()) ? new BigDecimal(precioMaxParam) : null;

        List<Integer> idCaracteristicas = new ArrayList<>();
        if (caracParams != null) {
            for (String cp : caracParams) {
                if (!cp.isEmpty()) idCaracteristicas.add(Integer.parseInt(cp));
            }
        }

        List<Propiedad> resultados = propiedadDAO.buscarConFiltros(idCiudad, idTipo, precioMin, precioMax, operacionParam, idCaracteristicas);

        req.setAttribute("propiedades", resultados);
        req.setAttribute("ciudades", propiedadDAO.listarCiudades());
        req.setAttribute("tipos", propiedadDAO.listarTiposPropiedad());
        req.setAttribute("caracteristicas", propiedadDAO.listarCaracteristicas());

        // Mantener estados de filtros en vista
        req.setAttribute("fCiudad", idCiudad);
        req.setAttribute("fTipo", idTipo);
        req.setAttribute("fOperacion", operacionParam);
        req.setAttribute("fPrecioMin", precioMinParam);
        req.setAttribute("fPrecioMax", precioMaxParam);
        req.setAttribute("fCaracs", idCaracteristicas);

        req.getRequestDispatcher("/WEB-INF/views/public/catalogo.jsp").forward(req, resp);
    }

    private void mostrarDetallePropiedad(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/catalogo");
            return;
        }

        int id = Integer.parseInt(idParam);
        Propiedad prop = propiedadDAO.obtenerPorId(id);

        if (prop == null || "INACTIVA".equals(prop.getEstado())) {
            req.setAttribute("tituloError", "Propiedad no disponible");
            req.setAttribute("mensajeError", "El inmueble solicitado no existe o fue dado de baja del catálogo.");
            req.getRequestDispatcher("/WEB-INF/views/common/404.jsp").forward(req, resp);
            return;
        }

        // Si el usuario tiene sesión, verificar si la tiene en favoritos
        HttpSession session = req.getSession(false);
        boolean esFavorito = false;
        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
            esFavorito = favoritoDAO.esFavorito(u.getId(), id);
        }

        req.setAttribute("propiedad", prop);
        req.setAttribute("esFavorito", esFavorito);
        req.getRequestDispatcher("/WEB-INF/views/public/detalle-propiedad.jsp").forward(req, resp);
    }
}
