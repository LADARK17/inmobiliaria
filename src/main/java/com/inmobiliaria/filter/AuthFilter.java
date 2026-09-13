package com.inmobiliaria.filter;

import com.inmobiliaria.model.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filtro de seguridad que intercepta peticiones a rutas protegidas:
 * /cliente/* -> Requiere rol CLIENTE, AGENTE o ADMINISTRADOR
 * /agente/*  -> Requiere rol AGENTE o ADMINISTRADOR
 * /admin/*   -> Requiere rol ADMINISTRADOR
 * 
 * Implementa además cabeceras anti-caché para impedir que tras cerrar sesión
 * se pueda acceder mediante el botón "Atrás" del navegador.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/cliente/*", "/agente/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Cabeceras estrictas contra el almacenamiento en caché del navegador
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        res.setHeader("Pragma", "no-cache"); // HTTP 1.0
        res.setDateHeader("Expires", 0); // Proxies

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // 1. ¿Hay sesión activa?
        if (usuario == null) {
            req.getSession(true).setAttribute("mensajeError", "Debe iniciar sesión para acceder a este módulo.");
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // 2. ¿Tiene la cuenta activa?
        if (!"ACTIVO".equalsIgnoreCase(usuario.getEstado())) {
            session.invalidate();
            res.sendRedirect(contextPath + "/login?error=cuenta_bloqueada");
            return;
        }

        // 3. Verificación de roles según prefijo de ruta
        boolean tienePermiso = false;

        if (path.startsWith("/admin")) {
            tienePermiso = usuario.hasRol("ADMINISTRADOR");
        } else if (path.startsWith("/agente")) {
            tienePermiso = usuario.hasRol("AGENTE") || usuario.hasRol("ADMINISTRADOR");
        } else if (path.startsWith("/cliente")) {
            tienePermiso = usuario.hasRol("CLIENTE") || usuario.hasRol("AGENTE") || usuario.hasRol("ADMINISTRADOR");
        } else {
            tienePermiso = true;
        }

        if (!tienePermiso) {
            // Acceso denegado: rol insuficiente
            req.setAttribute("tituloError", "403 - Acceso Denegado");
            req.setAttribute("mensajeError", "No cuenta con los permisos o privilegios necesarios para acceder a esta sección del sistema.");
            req.getRequestDispatcher("/WEB-INF/views/common/403.jsp").forward(req, res);
            return;
        }

        // Continuar hacia el Controller / Servlet correspondiente
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
