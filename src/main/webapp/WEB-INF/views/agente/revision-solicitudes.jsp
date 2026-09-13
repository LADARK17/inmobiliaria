<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Revisión de Solicitudes y Documentos" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-file-earmark-check-fill text-success me-2"></i>Revisión de Solicitudes de Trámites</h3>
            <p class="text-muted mb-0">Verifica la documentación 1:N radicada por los clientes y toma decisiones sobre la compra o arriendo</p>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty solicitudes}">
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center">
                <i class="bi bi-folder-check text-muted display-3 mb-3"></i>
                <h5 class="fw-bold">No hay solicitudes pendientes</h5>
                <p class="text-muted small">Actualmente no existen trámites de compra o arriendo pendientes de revisión para tus inmuebles.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="s" items="${solicitudes}">
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <span class="badge ${s.tipoOperacion == 'COMPRA' ? 'bg-primary' : 'bg-success'} mb-1">
                                        SOLICITUD DE ${s.tipoOperacion}
                                    </span>
                                    <h5 class="fw-bold mb-0">${s.propiedadTitulo}</h5>
                                    <code class="small text-muted">${s.propiedadMatricula}</code>
                                </div>
                                <span class="badge ${s.estado == 'APROBADA' ? 'bg-success' : (s.estado == 'EN_REVISION' ? 'bg-info text-dark' : (s.estado == 'RECHAZADA' ? 'bg-danger' : 'bg-warning text-dark'))} rounded-pill px-3 py-2">
                                    ${s.estado}
                                </span>
                            </div>

                            <div class="bg-light rounded-3 p-3 mb-3 small">
                                <strong>Datos del Cliente Postulado:</strong>
                                <div class="mt-1">
                                    <span><i class="bi bi-person me-1"></i>${s.clienteNombre}</span> &bull; 
                                    <span><i class="bi bi-telephone me-1"></i>${s.clienteTelefono}</span> &bull; 
                                    <span><i class="bi bi-envelope me-1"></i>${s.clienteCorreo}</span>
                                </div>
                                <div class="mt-2 text-muted">
                                    <em>"${s.observaciones}"</em>
                                </div>
                            </div>

                            <!-- Documentación Adjunta (1:N) -->
                            <h6 class="fw-bold small text-uppercase text-muted mb-2">
                                <i class="bi bi-paperclip me-1"></i>Documentos Radicados (${s.documentos.size()})
                            </h6>
                            <c:choose>
                                <c:when test="${empty s.documentos}">
                                    <p class="small text-muted fst-italic">El cliente no ha subido archivos todavía.</p>
                                </c:when>
                                <c:otherwise>
                                    <ul class="list-group list-group-flush small mb-3">
                                        <c:forEach var="doc" items="${s.documentos}">
                                            <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                                                <div>
                                                    <i class="bi bi-file-earmark-pdf-fill text-danger me-1"></i>
                                                    <strong>${doc.tipoDocumento}:</strong> ${doc.nombreArchivo}
                                                </div>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="badge ${doc.estado == 'APROBADO' ? 'bg-success' : (doc.estado == 'RECHAZADO' ? 'bg-danger' : 'bg-secondary')}">
                                                        ${doc.estado}
                                                    </span>
                                                    <!-- Acciones sobre documento individual -->
                                                    <form action="${pageContext.request.contextPath}/agente/gestionar-solicitud" method="POST" class="d-inline">
                                                        <input type="hidden" name="idSolicitud" value="${s.id}">
                                                        <input type="hidden" name="idDocumento" value="${doc.id}">
                                                        <input type="hidden" name="accion" value="${s.estado}">
                                                        <button type="submit" name="estadoDocumento" value="APROBADO" class="btn btn-outline-success btn-sm py-0 px-2" title="Aprobar documento">
                                                            <i class="bi bi-check"></i>
                                                        </button>
                                                        <button type="submit" name="estadoDocumento" value="RECHAZADO" class="btn btn-outline-danger btn-sm py-0 px-2" title="Rechazar documento">
                                                            <i class="bi bi-x"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:otherwise>
                            </c:choose>

                            <!-- Decisión Global sobre el Trámite -->
                            <div class="border-top pt-3 mt-auto">
                                <form action="${pageContext.request.contextPath}/agente/gestionar-solicitud" method="POST">
                                    <input type="hidden" name="idSolicitud" value="${s.id}">
                                    <div class="mb-2">
                                        <input type="text" name="observaciones" class="form-control form-control-sm" placeholder="Dictamen u observaciones para el cliente..." value="${s.observaciones}">
                                    </div>
                                    <div class="d-flex gap-2">
                                        <button type="submit" name="accion" value="APROBADA" class="btn btn-success btn-sm rounded-pill flex-grow-1">
                                            <i class="bi bi-check2-circle me-1"></i> Aprobar Solicitud
                                        </button>
                                        <button type="submit" name="accion" value="RECHAZADA" class="btn btn-danger btn-sm rounded-pill flex-grow-1">
                                            <i class="bi bi-x-circle me-1"></i> Rechazar
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
