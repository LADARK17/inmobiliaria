<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Panel de Administración Global" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-shield-lock-fill text-danger me-2"></i>Panel Maestro de Administración</h3>
            <p class="text-muted mb-0">Gestión de usuarios, control de roles N:M, auditoría del sistema y reportes agregados</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/reportes" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                <i class="bi bi-bar-chart-line-fill me-1"></i> Reportes SQL
            </a>
            <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-primary btn-sm rounded-pill px-3">
                <i class="bi bi-people-fill me-1"></i> Administrar Usuarios
            </a>
        </div>
    </div>

    <!-- KPIs Globales -->
    <div class="row g-4 mb-5">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-primary-subtle text-primary">
                    <i class="bi bi-buildings"></i>
                </div>
                <div>
                    <span class="text-muted small d-block">Inmuebles Activos</span>
                    <h3 class="fw-bold mb-0 text-dark">${resumen.propiedades}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-success-subtle text-success">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div>
                    <span class="text-muted small d-block">Usuarios Registrados</span>
                    <h3 class="fw-bold mb-0 text-dark">${resumen.usuarios}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-warning-subtle text-warning">
                    <i class="bi bi-calendar2-check"></i>
                </div>
                <div>
                    <span class="text-muted small d-block">Citas Pendientes</span>
                    <h3 class="fw-bold mb-0 text-dark">${resumen.citas_pendientes}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-danger-subtle text-danger">
                    <i class="bi bi-folder-fill"></i>
                </div>
                <div>
                    <span class="text-muted small d-block">Trámites Pendientes</span>
                    <h3 class="fw-bold mb-0 text-dark">${resumen.solicitudes_pendientes}</h3>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Usuarios del Sistema -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-person-lines-fill text-primary me-2"></i>Cuentas Recientes</h5>
                    <a href="${pageContext.request.contextPath}/admin/usuarios" class="small text-decoration-none">Ver todos los usuarios</a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle small mb-0">
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
                                        <span class="fw-bold text-dark d-block">${not empty u.perfil ? u.perfil.nombreCompleto : 'Sin perfil'}</span>
                                        <small class="text-muted">${u.correo}</small>
                                    </td>
                                    <td>
                                        <c:forEach var="r" items="${u.roles}">
                                            <span class="badge bg-secondary-subtle text-dark me-1">${r.nombre}</span>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <span class="badge ${u.estado == 'ACTIVO' ? 'bg-success' : 'bg-danger'}">
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
            <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-clock-history text-danger me-2"></i>Eventos de Auditoría</h5>
                    <a href="${pageContext.request.contextPath}/admin/auditoria" class="small text-decoration-none">Ver auditoría completa</a>
                </div>

                <div class="list-group list-group-flush small">
                    <c:forEach var="log" items="${logsRecientes}">
                        <div class="list-group-item px-0 py-2">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="badge bg-dark">${log.accion}</span>
                                <small class="text-muted">${log.fechaHora}</small>
                            </div>
                            <span class="text-dark d-block">${log.detalles}</span>
                            <small class="text-muted"><i class="bi bi-person me-1"></i>${log.usuarioCorreo} &bull; IP: ${log.ipOrigen}</small>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
