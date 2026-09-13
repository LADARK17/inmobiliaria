<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Panel del Cliente" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <!-- Header del Dashboard -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold mb-1">¡Hola, ${sessionScope.nombre_usuario}!</h3>
            <p class="text-muted mb-0">Bienvenido a tu panel de cliente para gestión de favoritos, visitas y trámites.</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary rounded-pill btn-sm px-3">
                <i class="bi bi-search me-1"></i> Explorar Inmuebles
            </a>
        </div>
    </div>

    <!-- Tarjetas de Estadísticas / Accesos Rápidos -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/cliente/favoritos" class="text-decoration-none">
                <div class="stat-card">
                    <div class="stat-icon bg-danger-subtle text-danger">
                        <i class="bi bi-heart-fill"></i>
                    </div>
                    <div>
                        <span class="text-muted small d-block">Mis Favoritos</span>
                        <h3 class="fw-bold mb-0 text-dark">${totalFavoritos}</h3>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/cliente/citas" class="text-decoration-none">
                <div class="stat-card">
                    <div class="stat-icon bg-primary-subtle text-primary">
                        <i class="bi bi-calendar-check-fill"></i>
                    </div>
                    <div>
                        <span class="text-muted small d-block">Visitas Solicitadas</span>
                        <h3 class="fw-bold mb-0 text-dark">${totalCitas}</h3>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/cliente/solicitudes" class="text-decoration-none">
                <div class="stat-card">
                    <div class="stat-icon bg-success-subtle text-success">
                        <i class="bi bi-file-earmark-text-fill"></i>
                    </div>
                    <div>
                        <span class="text-muted small d-block">Trámites Radicados</span>
                        <h3 class="fw-bold mb-0 text-dark">${totalSolicitudes}</h3>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <div class="row g-4">
        <!-- Próximas Citas -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-calendar2-event text-primary me-2"></i>Mis Próximas Visitas</h5>
                    <a href="${pageContext.request.contextPath}/cliente/citas" class="small text-decoration-none">Ver todas</a>
                </div>

                <c:choose>
                    <c:when test="${empty citasRecientes}">
                        <div class="text-center py-4 text-muted">
                            <i class="bi bi-calendar-x fs-2 mb-2 d-block"></i>
                            <p class="small mb-0">No tienes citas agendadas actualmente.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group list-group-flush">
                            <c:forEach var="c" items="${citasRecientes}">
                                <div class="list-group-item px-0 py-3 d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="fw-bold mb-1">${c.propiedadTitulo}</h6>
                                        <small class="text-muted d-block"><i class="bi bi-clock me-1"></i>${c.fechaHora}</small>
                                        <small class="text-muted"><i class="bi bi-buildings me-1"></i>${c.inmobiliariaNombre}</small>
                                    </div>
                                    <span class="badge ${c.estado == 'CONFIRMADA' ? 'bg-success' : (c.estado == 'PENDIENTE' ? 'bg-warning text-dark' : 'bg-secondary')} rounded-pill px-3 py-2">
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
            <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-folder text-success me-2"></i>Estado de Mis Trámites</h5>
                    <a href="${pageContext.request.contextPath}/cliente/solicitudes" class="small text-decoration-none">Ver todos</a>
                </div>

                <c:choose>
                    <c:when test="${empty solicitudesRecientes}">
                        <div class="text-center py-4 text-muted">
                            <i class="bi bi-folder-x fs-2 mb-2 d-block"></i>
                            <p class="small mb-0">No tienes solicitudes de compra o arriendo activas.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group list-group-flush">
                            <c:forEach var="s" items="${solicitudesRecientes}">
                                <div class="list-group-item px-0 py-3 d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="fw-bold mb-1">${s.propiedadTitulo}</h6>
                                        <small class="text-muted d-block">Tipo: <strong>${s.tipoOperacion}</strong> | Radicado: ${s.fechaSolicitud}</small>
                                        <small class="text-muted">Documentos radicados: ${s.documentos.size()}</small>
                                    </div>
                                    <span class="badge ${s.estado == 'APROBADA' ? 'bg-success' : (s.estado == 'EN_REVISION' ? 'bg-info text-dark' : (s.estado == 'RECHAZADA' ? 'bg-danger' : 'bg-warning text-dark'))} rounded-pill px-3 py-2">
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
