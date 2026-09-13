<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Mis Citas y Visitas" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-calendar2-week text-primary me-2"></i>Mis Citas de Visita</h3>
            <p class="text-muted mb-0">Seguimiento en tiempo real del estado de tus recorridos presenciales</p>
        </div>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary btn-sm rounded-pill px-3">
            <i class="bi bi-plus-lg me-1"></i> Agendar Otra Visita
        </a>
    </div>

    <c:choose>
        <c:when test="${empty citas}">
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center">
                <i class="bi bi-calendar-x text-muted display-3 mb-3"></i>
                <h5 class="fw-bold">No tienes visitas agendadas</h5>
                <p class="text-muted small">Ingresa al detalle de cualquier propiedad del catálogo y utiliza el botón "Agendar Visita".</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive-custom">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Inmueble</th>
                            <th>Agencia Responsable</th>
                            <th>Fecha y Hora</th>
                            <th>Estado</th>
                            <th>Comentarios</th>
                            <th class="text-end">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${citas}">
                            <tr>
                                <td>
                                    <h6 class="fw-bold mb-0">${c.propiedadTitulo}</h6>
                                    <small class="text-muted"><i class="bi bi-geo-alt me-1"></i>${c.propiedadDireccion}</small>
                                </td>
                                <td>
                                    <span class="small fw-semibold text-dark">${c.inmobiliariaNombre}</span>
                                </td>
                                <td>
                                    <span class="fw-bold text-primary"><i class="bi bi-clock me-1"></i>${c.fechaHora}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.estado == 'CONFIRMADA'}">
                                            <span class="badge bg-success rounded-pill px-3 py-2"><i class="bi bi-check-circle me-1"></i>Confirmada</span>
                                        </c:when>
                                        <c:when test="${c.estado == 'PENDIENTE'}">
                                            <span class="badge bg-warning text-dark rounded-pill px-3 py-2"><i class="bi bi-hourglass-split me-1"></i>Pendiente</span>
                                        </c:when>
                                        <c:when test="${c.estado == 'REALIZADA'}">
                                            <span class="badge bg-info text-dark rounded-pill px-3 py-2"><i class="bi bi-flag me-1"></i>Realizada</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary rounded-pill px-3 py-2">Cancelada</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="small text-muted">${not empty c.comentarios ? c.comentarios : 'Sin comentarios'}</span>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/propiedad?id=${c.idPropiedad}" class="btn btn-outline-primary btn-sm rounded-pill">
                                        Ver Ficha
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
