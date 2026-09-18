<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Panel Operativo del Agente" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-4 my-lg-5">
    <!-- Header del Dashboard Agente -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3 bg-white p-4 rounded-4 border shadow-sm">
        <div class="d-flex align-items-center gap-3">
            <div class="brand-icon-box bg-success text-white rounded-circle" style="width: 52px; height: 52px; font-size: 1.5rem;">
                <i class="bi bi-briefcase-fill"></i>
            </div>
            <div>
                <div class="d-flex align-items-center gap-2">
                    <h3 class="fw-bold mb-0 text-dark">Panel Operativo del Agente</h3>
                    <span class="badge badge-role-agent rounded-pill">Agente</span>
                </div>
                <p class="text-muted small mb-0">Gestión integral del inventario de inmuebles, visitas programadas y verificación documental.</p>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/agente/crear-propiedad" class="btn btn-primary rounded-pill px-3 shadow-sm d-flex align-items-center gap-1">
                <i class="bi bi-plus-circle-fill"></i> Publicar Nueva Propiedad
            </a>
            <a href="${pageContext.request.contextPath}/agente/citas" class="btn btn-outline-secondary rounded-pill px-3">
                <i class="bi bi-calendar-check"></i> Citas
            </a>
        </div>
    </div>

    <!-- Indicadores Clave (KPIs) -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="kpi-card" style="--kpi-accent: #1d4ed8; --kpi-bg: #dbeafe;">
                <div class="kpi-icon-box" style="color: #1d4ed8;">
                    <i class="bi bi-houses-fill"></i>
                </div>
                <div>
                    <div class="kpi-number">${totalPropiedades}</div>
                    <div class="kpi-label">Propiedades Asignadas</div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card" style="--kpi-accent: #f59e0b; --kpi-bg: #fef3c7;">
                <div class="kpi-icon-box" style="color: #f59e0b;">
                    <i class="bi bi-calendar2-range-fill"></i>
                </div>
                <div>
                    <div class="kpi-number">${citasPendientes}</div>
                    <div class="kpi-label">Citas por Confirmar</div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="kpi-card" style="--kpi-accent: #06b6d4; --kpi-bg: #cffafe;">
                <div class="kpi-icon-box" style="color: #06b6d4;">
                    <i class="bi bi-file-earmark-check-fill"></i>
                </div>
                <div>
                    <div class="kpi-number">${solicitudesPendientes}</div>
                    <div class="kpi-label">Solicitudes en Revisión</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Últimas Propiedades Gestionadas -->
        <div class="col-lg-7">
            <div class="table-card h-100">
                <div class="table-card-header">
                    <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-collection-fill text-primary me-2"></i>Inventario de Inmuebles</h5>
                    <a href="${pageContext.request.contextPath}/agente/propiedades" class="small text-primary text-decoration-none fw-semibold">
                        Administrar todos <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern align-middle small mb-0">
                        <thead>
                            <tr>
                                <th>Inmueble</th>
                                <th>Matrícula</th>
                                <th>Precio</th>
                                <th>Estado</th>
                                <th class="text-end">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${ultimasPropiedades}">
                                <tr>
                                    <td>
                                        <span class="fw-bold text-dark d-block">${p.titulo}</span>
                                        <span class="text-muted small"><i class="bi bi-geo-alt me-1 text-danger"></i>${p.ciudadNombre}</span>
                                    </td>
                                    <td><code class="fw-bold">${p.matriculaInmobiliaria}</code></td>
                                    <td class="fw-bold text-dark">
                                        <fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                        <span class="status-badge ${p.estado == 'DISPONIBLE' ? 'status-activa' : (p.estado == 'INACTIVA' ? 'status-inactiva' : 'status-pendiente')}">
                                            ${p.estado}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/agente/editar-propiedad?id=${p.id}" class="btn btn-outline-primary btn-sm rounded-pill py-1 px-3" title="Editar Propiedad">
                                            <i class="bi bi-pencil-fill me-1"></i> Editar
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Citas Recientes de la Agencia -->
        <div class="col-lg-5">
            <div class="table-card h-100 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-clock-history text-warning me-2"></i>Citas por Gestionar</h5>
                    <a href="${pageContext.request.contextPath}/agente/citas" class="small text-warning text-decoration-none fw-semibold">
                        Ver todas <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty ultimasCitas}">
                        <div class="text-center py-5 text-muted">
                            <i class="bi bi-calendar-check fs-1 text-muted opacity-50 mb-2 d-block"></i>
                            <p class="small mb-0">No hay citas pendientes para tus propiedades.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group list-group-flush">
                            <c:forEach var="c" items="${ultimasCitas}">
                                <div class="list-group-item px-0 py-3 d-flex justify-content-between align-items-center border-bottom">
                                    <div>
                                        <span class="fw-bold text-dark small d-block mb-1">${c.propiedadTitulo}</span>
                                        <div class="small text-secondary mb-1"><i class="bi bi-person-fill text-primary me-1"></i>${c.clienteNombre} (${c.clienteTelefono})</div>
                                        <div class="small text-muted"><i class="bi bi-calendar-event me-1 text-warning"></i>${c.fechaHora}</div>
                                    </div>
                                    <span class="status-badge ${c.estado == 'CONFIRMADA' ? 'status-activa' : 'status-pendiente'}">
                                        ${c.estado}
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
