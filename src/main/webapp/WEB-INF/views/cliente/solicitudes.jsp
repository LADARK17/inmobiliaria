<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Mis Solicitudes y Documentos" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-file-earmark-text text-success me-2"></i>Mis Solicitudes de Trámite</h3>
            <p class="text-muted mb-0">Radicación de documentos y seguimiento de compras o arriendos</p>
        </div>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary btn-sm rounded-pill px-3">
            <i class="bi bi-search me-1"></i> Ver Inmuebles Disponibles
        </a>
    </div>

    <c:choose>
        <c:when test="${empty solicitudes}">
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center">
                <i class="bi bi-folder-x text-muted display-3 mb-3"></i>
                <h5 class="fw-bold">No tienes solicitudes radicadas</h5>
                <p class="text-muted small">Desde la ficha de cualquier inmueble puedes postularte para iniciar el proceso de compra o arriendo.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="s" items="${solicitudes}">
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <span class="badge ${s.tipoOperacion == 'COMPRA' ? 'bg-primary' : 'bg-success'} mb-2">
                                        TRÁMITE DE ${s.tipoOperacion}
                                    </span>
                                    <h5 class="fw-bold mb-1">${s.propiedadTitulo}</h5>
                                    <small class="text-muted d-block">
                                        <i class="bi bi-upc-scan me-1"></i>Matrícula: ${s.propiedadMatricula} | Agencia: ${s.inmobiliariaNombre}
                                    </small>
                                </div>
                                <span class="badge ${s.estado == 'APROBADA' ? 'bg-success' : (s.estado == 'EN_REVISION' ? 'bg-info text-dark' : (s.estado == 'RECHAZADA' ? 'bg-danger' : 'bg-warning text-dark'))} rounded-pill px-3 py-2">
                                    ${s.estado}
                                </span>
                            </div>

                            <p class="small text-secondary mb-3">
                                <strong>Observaciones del trámite:</strong> ${not empty s.observaciones ? s.observaciones : 'En estudio por parte del agente inmobiliario.'}
                            </p>

                            <!-- Documentos Radicados (Relación 1:N con documento_solicitud) -->
                            <div class="border-top pt-3 mt-auto">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="fw-bold mb-0 small text-uppercase text-muted">
                                        <i class="bi bi-paperclip me-1"></i>Documentos Adjuntos (1:N)
                                    </h6>
                                    <button type="button" class="btn btn-outline-primary btn-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#modalDoc_${s.id}">
                                        <i class="bi bi-upload me-1"></i> Radicar Archivo
                                    </button>
                                </div>

                                <c:choose>
                                    <c:when test="${empty s.documentos}">
                                        <div class="alert alert-light border small py-2 mb-0 text-muted">
                                            <i class="bi bi-exclamation-circle me-1"></i> No has adjuntado documentos aún. Se requiere documento de identidad y soportes.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <ul class="list-group list-group-flush small">
                                            <c:forEach var="doc" items="${s.documentos}">
                                                <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <i class="bi bi-file-earmark-pdf-fill text-danger me-1"></i>
                                                        <strong>${doc.tipoDocumento}:</strong> ${doc.nombreArchivo}
                                                    </div>
                                                    <span class="badge ${doc.estado == 'APROBADO' ? 'bg-success' : (doc.estado == 'RECHAZADO' ? 'bg-danger' : 'bg-secondary')}">
                                                        ${doc.estado}
                                                    </span>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- MODAL PARA ADJUNTAR DOCUMENTO -->
                    <div class="modal fade" id="modalDoc_${s.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content rounded-4 border-0 shadow">
                                <form action="${pageContext.request.contextPath}/cliente/subir-documento" method="POST">
                                    <input type="hidden" name="idSolicitud" value="${s.id}">
                                    <div class="modal-header border-0 pb-0">
                                        <h5 class="modal-title fw-bold">
                                            <i class="bi bi-cloud-arrow-up text-primary me-2"></i>Radicar Documento al Trámite
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold">Tipo de Documento *</label>
                                            <select name="tipoDocumento" class="form-select" required>
                                                <option value="Cédula de Ciudadanía">Cédula de Ciudadanía</option>
                                                <option value="Certificación Laboral">Certificación Laboral</option>
                                                <option value="Extractos Bancarios">Extractos Bancarios (Últimos 3 meses)</option>
                                                <option value="Declaración de Renta">Declaración de Renta</option>
                                                <option value="RUT o Cámara de Comercio">RUT / Cámara de Comercio</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold">Nombre del Archivo Digital *</label>
                                            <input type="text" name="nombreArchivo" class="form-control" required placeholder="Ej: Cedula_Juan_Perez.pdf">
                                            <div class="form-text small">Simulación de radicación electrónica de expedientes.</div>
                                        </div>
                                    </div>
                                    <div class="modal-footer border-0 pt-0">
                                        <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">Subir y Radicar</button>
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
