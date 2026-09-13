<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<c:set var="pageTitle" value="Error interno - 500" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>

<main class="container my-5 py-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <i class="bi bi-exclamation-octagon text-warning display-1"></i>
            <h1 class="display-5 fw-bold mt-4">500 - Error Interno del Servidor</h1>
            <p class="lead text-muted my-3">
                Ocurrió una eventualidad inesperada en el servidor. El equipo de soporte ha sido notificado.
            </p>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/inicio" class="btn btn-primary rounded-pill px-4">
                    <i class="bi bi-arrow-left me-2"></i> Regresar al Inicio
                </a>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
