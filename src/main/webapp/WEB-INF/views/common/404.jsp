<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="pageTitle" value="Página no encontrada - 404" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>

<main class="container my-5 py-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <i class="bi bi-compass text-primary display-1"></i>
            <h1 class="display-4 fw-bold mt-4">${not empty tituloError ? tituloError : '404 - Página no encontrada'}</h1>
            <p class="lead text-muted my-3">
                ${not empty mensajeError ? mensajeError : 'El recurso o inmueble solicitado no existe, cambió de dirección o fue dado de baja del catálogo.'}
            </p>
            <div class="mt-4 d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/inicio" class="btn btn-primary rounded-pill px-4">
                    <i class="bi bi-house-door-fill me-2"></i> Ir al Inicio
                </a>
                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-secondary rounded-pill px-4">
                    <i class="bi bi-grid-fill me-2"></i> Explorar Catálogo
                </a>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
