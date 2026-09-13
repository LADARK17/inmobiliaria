<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${propiedad.titulo}" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<div class="container my-5">
    <!-- Breadcrumb de Navegación -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/inicio" class="text-decoration-none">Inicio</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none">Catálogo</a></li>
            <li class="breadcrumb-item active" aria-current="page">${propiedad.titulo}</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- COLUMNA PRINCIPAL: GALERÍA Y DETALLES -->
        <div class="col-lg-8">
            <!-- Galería de Fotografías (Relación 1:N con imagen_propiedad) -->
            <div id="carruselPropiedad" class="carousel slide rounded-4 overflow-hidden shadow-sm mb-4" data-bs-ride="carousel">
                <div class="carousel-inner" style="max-height: 480px;">
                    <c:choose>
                        <c:when test="${not empty propiedad.imagenes}">
                            <c:forEach var="img" items="${propiedad.imagenes}" varStatus="status">
                                <div class="carousel-item ${status.first ? 'active' : ''}">
                                    <img src="${img.urlImagen}" class="d-block w-100 object-fit-cover" style="height: 480px;" alt="${img.descripcion}"
                                         onerror="this.src='https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800'">
                                    <c:if test="${not empty img.descripcion}">
                                        <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 rounded-3 p-2">
                                            <p class="mb-0 small">${img.descripcion}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="carousel-item active">
                                <img src="https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800" class="d-block w-100" style="height: 480px;" alt="Imagen general">
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${propiedad.imagenes.size() > 1}">
                    <button class="carousel-control-prev" type="button" data-bs-target="#carruselPropiedad" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-aria-hidden="true"></span>
                        <span class="visually-hidden">Anterior</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carruselPropiedad" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Siguiente</span>
                    </button>
                </c:if>
            </div>

            <!-- Título y Datos Clave -->
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-3">
                    <div>
                        <span class="badge ${propiedad.tipoOperacion == 'VENTA' ? 'bg-primary' : 'bg-success'} px-3 py-2 rounded-pill mb-2">
                            ${propiedad.tipoOperacion}
                        </span>
                        <span class="badge bg-secondary px-3 py-2 rounded-pill mb-2">
                            ${propiedad.estado}
                        </span>
                        <h2 class="fw-bold text-dark">${propiedad.titulo}</h2>
                        <p class="text-muted mb-0">
                            <i class="bi bi-geo-alt-fill text-danger me-1"></i>${propiedad.direccion}, ${propiedad.ciudadNombre} (${propiedad.departamentoNombre})
                        </p>
                    </div>

                    <!-- Botón de Favorito (Solo para clientes autenticados) -->
                    <c:if test="${not empty sessionScope.usuarioLogueado}">
                        <form action="${pageContext.request.contextPath}/cliente/favoritos" method="POST">
                            <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                            <input type="hidden" name="origen" value="detalle">
                            <c:choose>
                                <c:when test="${esFavorito}">
                                    <input type="hidden" name="accion" value="eliminar">
                                    <button type="submit" class="btn btn-danger btn-sm rounded-pill px-3">
                                        <i class="bi bi-heart-fill me-1"></i> En Favoritos
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" name="accion" value="agregar">
                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                        <i class="bi bi-heart me-1"></i> Guardar en Favoritos
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </c:if>
                </div>

                <!-- Matriz de Especificaciones Técnicas -->
                <div class="row g-3 py-3 border-top border-bottom text-center">
                    <div class="col-4 col-md-2">
                        <span class="text-muted small d-block">Tipo</span>
                        <strong class="text-dark">${propiedad.tipoPropiedadNombre}</strong>
                    </div>
                    <div class="col-4 col-md-2">
                        <span class="text-muted small d-block">Área</span>
                        <strong class="text-dark">${propiedad.areaM2} m²</strong>
                    </div>
                    <div class="col-4 col-md-2">
                        <span class="text-muted small d-block">Habitaciones</span>
                        <strong class="text-dark">${propiedad.habitaciones}</strong>
                    </div>
                    <div class="col-4 col-md-2">
                        <span class="text-muted small d-block">Baños</span>
                        <strong class="text-dark">${propiedad.banos}</strong>
                    </div>
                    <div class="col-4 col-md-2">
                        <span class="text-muted small d-block">Estrato</span>
                        <strong class="text-dark">${propiedad.estrato}</strong>
                    </div>
                    <div class="col-4 col-md-2">
                        <span class="text-muted small d-block">Matrícula</span>
                        <strong class="text-dark small">${propiedad.matriculaInmobiliaria}</strong>
                    </div>
                </div>

                <!-- Descripción Completa -->
                <div class="mt-4">
                    <h5 class="fw-bold mb-3">Descripción General</h5>
                    <p class="text-secondary" style="white-space: pre-line; line-height: 1.7;">
                        ${propiedad.descripcion}
                    </p>
                </div>

                <!-- Características Asociadas (Relación N:M) -->
                <div class="mt-4 pt-3 border-top">
                    <h5 class="fw-bold mb-3">Características y Amenidades (N:M)</h5>
                    <div class="d-flex flex-wrap gap-2">
                        <c:forEach var="c" items="${propiedad.caracteristicas}">
                            <span class="badge-feature">
                                <i class="bi ${c.icono} text-primary"></i> ${c.nombre}
                            </span>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- COLUMNA LATERAL: PRECIO, ACCIONES Y CONTACTO -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 p-4 sticky-top" style="top: 90px;">
                <span class="text-muted small">Precio de publicación</span>
                <div class="display-6 fw-extrabold text-primary mb-3">
                    <fmt:formatNumber value="${propiedad.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                </div>

                <!-- Botones de Acción para Clientes -->
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                        <div class="d-grid gap-2 mb-4">
                            <button type="button" class="btn btn-primary rounded-pill py-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#modalCita">
                                <i class="bi bi-calendar-event-fill me-2"></i> Agendar Visita
                            </button>
                            <button type="button" class="btn btn-success rounded-pill py-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#modalSolicitud">
                                <i class="bi bi-file-earmark-text-fill me-2"></i> Postular Trámite
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Información para visitante sin sesión -->
                        <div class="alert alert-info border-0 rounded-3 small mb-4">
                            <i class="bi bi-info-circle-fill me-1"></i>
                            <strong>¿Interesado en este inmueble?</strong>
                            <p class="mb-0 mt-1">Inicie sesión o regístrese como cliente para agendar visitas presenciales, radicar solicitudes y ver datos de contacto directos.</p>
                        </div>
                        <div class="d-grid gap-2 mb-4">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary rounded-pill py-2 fw-semibold">
                                <i class="bi bi-box-arrow-in-right me-2"></i> Iniciar Sesión para Contactar
                            </a>
                            <a href="${pageContext.request.contextPath}/registro" class="btn btn-outline-primary rounded-pill py-2 fw-semibold">
                                <i class="bi bi-person-plus-fill me-2"></i> Crear Cuenta Gratuita
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Tarjeta Inmobiliaria Responsable (1:N) -->
                <div class="border rounded-3 p-3 bg-light">
                    <span class="text-muted small d-block mb-1">Agencia Responsable:</span>
                    <h6 class="fw-bold mb-2 text-dark"><i class="bi bi-buildings me-1"></i>${propiedad.inmobiliariaNombre}</h6>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                            <p class="small mb-1 text-secondary"><i class="bi bi-telephone-fill text-success me-2"></i>${propiedad.inmobiliariaTelefono}</p>
                            <p class="small mb-0 text-secondary"><i class="bi bi-envelope-fill text-primary me-2"></i>${propiedad.inmobiliariaCorreo}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="small text-muted fst-italic mb-0">
                                <i class="bi bi-lock-fill me-1"></i> Contacto visible para usuarios registrados.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL PARA AGENDAR CITA (RESTRICCIÓN UNIQUE id_propiedad, fecha_hora) -->
<c:if test="${not empty sessionScope.usuarioLogueado}">
    <div class="modal fade" id="modalCita" tabindex="-1" aria-labelledby="modalCitaLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/cliente/agendar-cita" method="POST">
                    <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold" id="modalCitaLabel">
                            <i class="bi bi-calendar2-plus text-primary me-2"></i>Agendar Visita al Inmueble
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted mb-3">
                            Seleccione la fecha y hora deseada para realizar el recorrido presencial por <strong>${propiedad.titulo}</strong>.
                        </p>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Fecha y Hora de la Visita *</label>
                            <input type="datetime-local" name="fechaHora" class="form-control" required>
                            <div class="form-text small">
                                El sistema valida que no exista otra cita agendada en el mismo horario.
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Comentarios o Indicaciones Adicionales</label>
                            <textarea name="comentarios" class="form-control" rows="3" placeholder="Ej: Asistiré con mi arquitecto para toma de medidas..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">Confirmar Cita</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL PARA POSTULAR SOLICITUD DE COMPRA / ARRIENDO -->
    <div class="modal fade" id="modalSolicitud" tabindex="-1" aria-labelledby="modalSolicitudLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/cliente/crear-solicitud" method="POST">
                    <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold" id="modalSolicitudLabel">
                            <i class="bi bi-file-earmark-text text-success me-2"></i>Iniciar Trámite de Adquisición
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tipo de Operación *</label>
                            <select name="tipoOperacion" class="form-select" required>
                                <option value="${propiedad.tipoOperacion}" selected>${propiedad.tipoOperacion}</option>
                                <option value="COMPRA">COMPRA</option>
                                <option value="ARRIENDO">ARRIENDO</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Observaciones / Oferta Inicial</label>
                            <textarea name="observaciones" class="form-control" rows="3" placeholder="Indique si cuenta con crédito preaprobado, cuota inicial, codeudores, etc."></textarea>
                        </div>
                        <div class="alert alert-info small mb-0">
                            Una vez radicada la solicitud, podrá adjuntar su cédula, extractos bancarios y certificaciones desde su panel de cliente.
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Cerrar</button>
                        <button type="submit" class="btn btn-success rounded-pill px-4 fw-semibold">Radicar Trámite</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:if>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
