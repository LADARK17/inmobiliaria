<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Panel de Administración Global" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-4 my-lg-5">
    <!-- Header del Dashboard Admin -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3 bg-white p-4 rounded-4 border shadow-sm">
        <div class="d-flex align-items-center gap-3">
            <div class="brand-icon-box bg-danger text-white rounded-circle" style="width: 52px; height: 52px; font-size: 1.5rem;">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <div>
                <div class="d-flex align-items-center gap-2">
                    <h3 class="fw-bold mb-0 text-dark">Panel Maestro de Administración</h3>
                    <span class="badge badge-role-admin rounded-pill">Administrador</span>
                </div>
                <p class="text-muted small mb-0">Control global de usuarios, roles múltiples (N:M), registros de auditoría y reportes SQL.</p>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/reportes" class="btn btn-outline-primary rounded-pill px-3 shadow-sm d-flex align-items-center gap-1">
                <i class="bi bi-bar-chart-line-fill"></i> Reportes SQL
            </a>
            <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-primary rounded-pill px-3 shadow-sm d-flex align-items-center gap-1">
                <i class="bi bi-people-fill"></i> Administrar Usuarios
            </a>
            <a href="${pageContext.request.contextPath}/admin/auditoria" class="btn btn-outline-secondary rounded-pill px-3">
                <i class="bi bi-clock-history"></i> Auditoría
            </a>
        </div>
    </div>

    <!-- KPIs Globales -->
    <div class="row g-4 mb-4">
        <div class="col-6 col-lg-3">
            <div class="kpi-card" style="--kpi-accent: #1d4ed8; --kpi-bg: #dbeafe;">
                <div class="kpi-icon-box" style="color: #1d4ed8;">
                    <i class="bi bi-buildings"></i>
                </div>
                <div>
                    <div class="kpi-number">${resumen.propiedades}</div>
                    <div class="kpi-label">Inmuebles Activos</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="kpi-card" style="--kpi-accent: #10b981; --kpi-bg: #d1fae5;">
                <div class="kpi-icon-box" style="color: #10b981;">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div>
                    <div class="kpi-number">${resumen.usuarios}</div>
                    <div class="kpi-label">Usuarios Registrados</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="kpi-card" style="--kpi-accent: #f59e0b; --kpi-bg: #fef3c7;">
                <div class="kpi-icon-box" style="color: #f59e0b;">
                    <i class="bi bi-calendar2-check"></i>
                </div>
                <div>
                    <div class="kpi-number">${resumen.citas_pendientes}</div>
                    <div class="kpi-label">Citas Pendientes</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="kpi-card" style="--kpi-accent: #ef4444; --kpi-bg: #fee2e2;">
                <div class="kpi-icon-box" style="color: #ef4444;">
                    <i class="bi bi-folder-fill"></i>
                </div>
                <div>
                    <div class="kpi-number">${resumen.solicitudes_pendientes}</div>
                    <div class="kpi-label">Trámites Pendientes</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Usuarios del Sistema -->
        <div class="col-lg-7">
            <div class="table-card h-100">
                <div class="table-card-header">
                    <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-person-lines-fill text-primary me-2"></i>Cuentas Recientes del Sistema</h5>
                    <a href="${pageContext.request.contextPath}/admin/usuarios" class="small text-primary text-decoration-none fw-semibold">
                        Ver todos <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern align-middle small mb-0">
                        <thead>
                            <tr>
                                <th>Usuario / Perfil</th>
                                <th>Roles (N:M)</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${ultimosUsuarios}" end="5">
                                <tr>
                                    <td>
                                        <span class="fw-bold text-dark d-block">${not empty u.perfil ? u.perfil.nombreCompleto : 'Sin perfil asignado'}</span>
                                        <small class="text-muted"><i class="bi bi-envelope me-1"></i>${u.correo}</small>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-wrap gap-1">
                                            <c:forEach var="r" items="${u.roles}">
                                                <span class="badge ${r.nombre == 'ADMINISTRADOR' ? 'badge-role-admin' : (r.nombre == 'AGENTE' ? 'badge-role-agent' : 'badge-role-client')} rounded-pill px-2 py-1" style="font-size: 0.72rem;">
                                                    ${r.nombre}
                                                </span>
                                            </c:forEach>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-badge ${u.estado == 'ACTIVO' ? 'status-activa' : 'status-inactiva'}">
                                            ${u.estado}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Registro de Auditoría Rápido -->
        <div class="col-lg-5">
            <div class="table-card h-100 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-clock-history text-danger me-2"></i>Auditoría del Sistema</h5>
                    <a href="${pageContext.request.contextPath}/admin/auditoria" class="small text-danger text-decoration-none fw-semibold">
                        Bitácora completa <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

                <div class="list-group list-group-flush small">
                    <c:forEach var="log" items="${logsRecientes}">
                        <div class="list-group-item px-0 py-3 border-bottom">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="badge bg-dark bg-opacity-75 rounded-pill px-2 py-1">${log.accion}</span>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i>${log.fechaHora}</small>
                            </div>
                            <span class="text-dark fw-semibold d-block mb-1">${log.detalles}</span>
                            <div class="small text-muted d-flex align-items-center gap-2">
                                <span><i class="bi bi-person me-1"></i>${log.usuarioCorreo}</span>
                                <span>&bull;</span>
                                <span>IP: ${log.ipOrigen}</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
