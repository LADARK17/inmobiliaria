<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="pageTitle" value="Acceso Denegado - 403" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>

<main class="container my-5 py-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="badge bg-danger-subtle text-danger p-3 rounded-circle mb-3">
                <i class="bi bi-shield-x display-1"></i>
            </div>
            <h1 class="display-5 fw-bold text-danger">${not empty tituloError ? tituloError : '403 - Acceso Denegado'}</h1>
            <p class="lead text-muted my-3">
                ${not empty mensajeError ? mensajeError : 'El servidor ha detectado que su rol actual no cuenta con privilegios para acceder a esta ruta protegida.'}
            </p>
            <div class="alert alert-warning text-start mx-auto" style="max-width: 500px;">
                <h6 class="fw-bold mb-1"><i class="bi bi-info-circle-fill me-2"></i>Control de Seguridad Activo:</h6>
                <small>Este bloqueo fue aplicado a nivel de servidor mediante un <code>Servlet Filter</code> en el backend, impidiendo el acceso directo a rutas privadas sin el rol correspondiente.</small>
            </div>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/inicio" class="btn btn-primary rounded-pill px-4">
                    <i class="bi bi-house-door-fill me-2"></i> Volver a Navegar
                </a>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
