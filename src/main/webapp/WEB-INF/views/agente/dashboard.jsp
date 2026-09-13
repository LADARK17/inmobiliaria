<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Panel Operativo del Agente" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-briefcase-fill text-primary me-2"></i>Panel de Control de Inmobiliaria</h3>
            <p class="text-muted mb-0">Gestión de cartera de propiedades, visitas programadas y verificación de solicitudes</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/agente/crear-propiedad" class="btn btn-primary rounded-pill btn-sm px-3">
                <i class="bi bi-plus-circle-fill me-1"></i> Publicar Nueva Propiedad
            </a>
        </div>
    </div>

    <!-- Indicadores Clave (KPIs) -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon bg-primary-subtle text-primary">
                    <i class="bi bi-houses-fill"></i>
                </div>
                <div>
                    <span class="text-muted small d-block">Propiedades Publicadas</span>
                    <h3 class="fw-bold mb-0 text-dark">${totalPropiedades}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon bg-warning-subtle text-warning">
                    <i class="bi bi-calendar2-range-fill"></i>
                </div>
                <div>
                    <span class="text-muted small d-block">Citas Pendientes de Aprobación</span>
                    <h3 class="fw-bold mb-0 text-dark">${citasPendientes}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon bg-info-subtle text-info">
                    <i class="bi bi-file-earmark-check-fill"></i>
                </div>
                <div>
                    <span class="text-muted small d-block">Solicitudes en Revisión</span>
                    <h3 class="fw-bold mb-0 text-dark">${solicitudesPendientes}</h3>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Últimas Propiedades Gestionadas -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-collection-fill text-primary me-2"></i>Inventario de Inmuebles</h5>
                    <a href="${pageContext.request.contextPath}/agente/propiedades" class="small text-decoration-none">Administrar todos</a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle small mb-0">
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
                                        <span class="text-muted small">${p.ciudadNombre}</span>
                                    </td>
                                    <td><code>${p.matriculaInmobiliaria}</code></td>
                                    <td class="fw-semibold">
                                        <fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                        <span class="badge ${p.estado == 'DISPONIBLE' ? 'bg-success' : (p.estado == 'INACTIVA' ? 'bg-danger' : 'bg-secondary')}">
                                            ${p.estado}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/agente/editar-propiedad?id=${p.id}" class="btn btn-outline-secondary btn-sm" title="Editar">
                                            <i class="bi bi-pencil-fill"></i>
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
            <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-clock-history text-warning me-2"></i>Citas por Gestionar</h5>
                    <a href="${pageContext.request.contextPath}/agente/citas" class="small text-decoration-none">Ver todas</a>
                </div>

                <div class="list-group list-group-flush">
                    <c:forEach var="c" items="${ultimasCitas}">
                        <div class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                            <div>
                                <span class="fw-semibold text-dark small d-block">${c.propiedadTitulo}</span>
                                <small class="text-muted"><i class="bi bi-person me-1"></i>${c.clienteNombre} (${c.clienteTelefono})</small>
                                <small class="text-primary d-block"><i class="bi bi-clock me-1"></i>${c.fechaHora}</small>
                            </div>
                            <span class="badge ${c.estado == 'CONFIRMADA' ? 'bg-success' : 'bg-warning text-dark'} rounded-pill">
                                ${c.estado}
                            </span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
