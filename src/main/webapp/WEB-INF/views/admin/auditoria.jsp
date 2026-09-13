<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Registro de Auditoría" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-clock-history text-danger me-2"></i>Auditoría del Sistema</h3>
            <p class="text-muted mb-0">Trazabilidad de operaciones críticas: autenticación, creación de propiedades y cambios de estado</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm rounded-pill">
            <i class="bi bi-arrow-left me-1"></i> Volver al Dashboard
        </a>
    </div>

    <div class="table-responsive-custom">
        <table class="table table-hover align-middle small mb-0">
            <thead>
                <tr>
                    <th>Fecha y Hora</th>
                    <th>Usuario Responsable</th>
                    <th>Acción</th>
                    <th>Entidad Afectada</th>
                    <th>ID Registro</th>
                    <th>Detalles</th>
                    <th>IP Origen</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="l" items="${logs}">
                    <tr>
                        <td class="text-nowrap text-muted">
                            <i class="bi bi-calendar3 me-1"></i>${l.fechaHora}
                        </td>
                        <td>
                            <strong class="text-dark">${l.usuarioCorreo}</strong>
                        </td>
                        <td>
                            <span class="badge ${l.accion.startsWith('LOGIN') ? 'bg-info text-dark' : (l.accion.startsWith('CREAR') ? 'bg-success' : (l.accion.startsWith('BAJA') || l.accion.startsWith('REMOVER') ? 'bg-danger' : 'bg-primary'))}">
                                ${l.accion}
                            </span>
                        </td>
                        <td><code>${l.entidadAfectada}</code></td>
                        <td>${not empty l.idEntidad ? l.idEntidad : '-'}</td>
                        <td>${l.detalles}</td>
                        <td><span class="text-muted">${l.ipOrigen}</span></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
