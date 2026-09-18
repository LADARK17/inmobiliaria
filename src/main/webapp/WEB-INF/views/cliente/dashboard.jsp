<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Panel del Cliente" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-4 my-lg-5">
    <!-- Header del Dashboard -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3 bg-white p-4 rounded-4 border shadow-sm">
        <div class="d-flex align-items-center gap-3">
            <div class="brand-icon-box bg-primary text-white rounded-circle" style="width: 52px; height: 52px; font-size: 1.5rem;">
                <i class="bi bi-person-fill"></i>
            </div>
            <div>
                <div class="d-flex align-items-center gap-2">
                    <h3 class="fw-bold mb-0 text-dark">¡Hola, ${sessionScope.nombre_usuario}!</h3>
                    <span class="badge badge-role-client rounded-pill">Cliente</span>
                </div>
                <p class="text-muted small mb-0">Panel de control personal para seguimiento de inmuebles, visitas presenciales y trámites.</p>
            </div>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary rounded-pill px-4 shadow-sm">
                <i class="bi bi-search me-1"></i> Explorar Inmuebles
            </a>
        </div>
    </div>

    <!-- Tarjetas de Estadísticas KPI -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/cliente/favoritos" class="text-decoration-none">
                <div class="kpi-card" style="--kpi-accent: #ef4444; --kpi-bg: #fee2e2;">
                    <div class="kpi-icon-box" style="color: #ef4444;">
                        <i class="bi bi-heart-fill"></i>
                    </div>
                    <div>
                        <div class="kpi-number">${totalFavoritos}</div>
                        <div class="kpi-label">Mis Favoritos</div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/cliente/citas" class="text-decoration-none">
                <div class="kpi-card" style="--kpi-accent: #1d4ed8; --kpi-bg: #dbeafe;">
                    <div class="kpi-icon-box" style="color: #1d4ed8;">
                        <i class="bi bi-calendar2-check-fill"></i>
                    </div>
                    <div>
                        <div class="kpi-number">${totalCitas}</div>
                        <div class="kpi-label">Visitas Solicitadas</div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/cliente/solicitudes" class="text-decoration-none">
                <div class="kpi-card" style="--kpi-accent: #10b981; --kpi-bg: #d1fae5;">
                    <div class="kpi-icon-box" style="color: #10b981;">
                        <i class="bi bi-file-earmark-text-fill"></i>
                    </div>
                    <div>
                        <div class="kpi-number">${totalSolicitudes}</div>
                        <div class="kpi-label">Trámites Radicados</div>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <div class="row g-4">
        <!-- Próximas Citas -->
        <div class="col-lg-6">
            <div class="table-card h-100 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-calendar2-event text-primary me-2"></i>Mis Próximas Visitas</h5>
                    <a href="${pageContext.request.contextPath}/cliente/citas" class="small text-primary text-decoration-none fw-semibold">
                        Ver todas <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty citasRecientes}">
                        <div class="text-center py-5 text-muted">
                            <i class="bi bi-calendar-x fs-1 mb-2 d-block text-secondary opacity-50"></i>
                            <p class="small mb-0">No tienes citas agendadas actualmente.</p>
                            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary btn-sm rounded-pill mt-3">Agendar Visita</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group list-group-flush">
                            <c:forEach var="c" items="${citasRecientes}">
                                <div class="list-group-item px-0 py-3 d-flex justify-content-between align-items-center border-bottom">
                                    <div>
                                        <h6 class="fw-bold mb-1 text-dark">${c.propiedadTitulo}</h6>
                                        <div class="small text-muted mb-1"><i class="bi bi-clock me-1 text-primary"></i>${c.fechaHora}</div>
                                        <div class="small text-secondary"><i class="bi bi-buildings me-1 text-muted"></i>${c.inmobiliariaNombre}</div>
                                    </div>
                                    <span class="status-badge ${c.estado == 'CONFIRMADA' ? 'status-activa' : (c.estado == 'PENDIENTE' ? 'status-pendiente' : 'status-inactiva')}">
                                        ${c.estado}
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Trámites Recientes -->
        <div class="col-lg-6">
            <div class="table-card h-100 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-folder-check text-success me-2"></i>Estado de Mis Trámites</h5>
                    <a href="${pageContext.request.contextPath}/cliente/solicitudes" class="small text-success text-decoration-none fw-semibold">
                        Ver todos <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty solicitudesRecientes}">
                        <div class="text-center py-5 text-muted">
                            <i class="bi bi-folder-x fs-1 mb-2 d-block text-secondary opacity-50"></i>
                            <p class="small mb-0">No tienes solicitudes de compra o arriendo activas.</p>
                            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-success btn-sm rounded-pill mt-3">Explorar Inmuebles</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group list-group-flush">
                            <c:forEach var="s" items="${solicitudesRecientes}">
                                <div class="list-group-item px-0 py-3 d-flex justify-content-between align-items-center border-bottom">
                                    <div>
                                        <h6 class="fw-bold mb-1 text-dark">${s.propiedadTitulo}</h6>
                                        <div class="small text-muted mb-1">Tipo: <strong>${s.tipoOperacion}</strong> &bull; Radicado: ${s.fechaSolicitud}</div>
                                        <div class="small text-secondary"><i class="bi bi-paperclip me-1 text-primary"></i>Documentos adjuntos: ${s.documentos.size()}</div>
                                    </div>
                                    <span class="status-badge ${s.estado == 'APROBADA' ? 'status-activa' : (s.estado == 'EN_REVISION' ? 'status-agendada' : (s.estado == 'RECHAZADA' ? 'status-inactiva' : 'status-pendiente'))}">
                                        ${s.estado}
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
