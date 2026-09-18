<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${propiedad.titulo}" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<div class="container my-4 my-lg-5">
    <!-- Breadcrumb de Navegación -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/inicio" class="text-decoration-none text-primary"><i class="bi bi-house-door me-1"></i>Inicio</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none text-primary">Catálogo</a></li>
            <li class="breadcrumb-item active text-muted" aria-current="page">${propiedad.titulo}</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- COLUMNA PRINCIPAL: GALERÍA Y DETALLES -->
        <div class="col-lg-8">
            <!-- Galería de Fotografías (Relación 1:N con imagen_propiedad) -->
            <div id="carruselPropiedad" class="carousel slide rounded-4 overflow-hidden shadow-sm mb-4 border position-relative" data-bs-ride="carousel">
                <div class="carousel-inner" style="max-height: 480px; background-color: #0f172a;">
                    <c:choose>
                        <c:when test="${not empty propiedad.imagenes}">
                            <c:forEach var="img" items="${propiedad.imagenes}" varStatus="status">
                                <div class="carousel-item ${status.first ? 'active' : ''}">
                                    <img src="${img.urlImagen}" class="d-block w-100 object-fit-cover" style="height: 480px;" alt="${img.descripcion}"
                                         onerror="this.src='https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800'">
                                    <c:if test="${not empty img.descripcion}">
                                        <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-75 rounded-pill px-4 py-2 mb-3">
                                            <p class="mb-0 small text-white">${img.descripcion}</p>
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

                <!-- Badges flotantes en la imagen -->
                <span class="badge-operation-pill ${propiedad.tipoOperacion == 'VENTA' ? 'badge-operation-venta' : 'badge-operation-arriendo'}">
                    ${propiedad.tipoOperacion}
                </span>

                <c:if test="${propiedad.imagenes.size() > 1}">
                    <button class="carousel-control-prev" type="button" data-bs-target="#carruselPropiedad" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon p-3 bg-dark bg-opacity-50 rounded-circle" aria-hidden="true"></span>
                        <span class="visually-hidden">Anterior</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carruselPropiedad" data-bs-slide="next">
                        <span class="carousel-control-next-icon p-3 bg-dark bg-opacity-50 rounded-circle" aria-hidden="true"></span>
                        <span class="visually-hidden">Siguiente</span>
                    </button>
                </c:if>
            </div>

            <!-- Ficha de Información Principal -->
            <div class="detail-hero-box">
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-3">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1 rounded-pill small fw-bold">
                                ${propiedad.tipoPropiedadNombre}
                            </span>
                            <span class="badge ${propiedad.estado == 'ACTIVA' ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'} border px-3 py-1 rounded-pill small fw-bold">
                                ${propiedad.estado}
                            </span>
                        </div>
                        <h2 class="fw-bold text-dark mb-2">${propiedad.titulo}</h2>
                        <p class="text-secondary mb-0">
                            <i class="bi bi-geo-alt-fill text-danger me-1"></i>${propiedad.direccion}, <strong>${propiedad.ciudadNombre}</strong> (${propiedad.departamentoNombre})
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
                                    <button type="submit" class="btn btn-danger btn-sm rounded-pill px-3 shadow-sm d-flex align-items-center gap-1">
                                        <i class="bi bi-heart-fill"></i> Guardado
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" name="accion" value="agregar">
                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3 shadow-sm d-flex align-items-center gap-1">
                                        <i class="bi bi-heart"></i> Favorito
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </c:if>
                </div>

                <!-- Matriz de Especificaciones Técnicas Clave -->
                <div class="detail-specs-bar">
                    <div class="detail-spec-card">
                        <i class="bi bi-arrows-angle-expand"></i>
                        <div class="value">${propiedad.areaM2} m²</div>
                        <div class="label">Área Construida</div>
                    </div>
                    <div class="detail-spec-card">
                        <i class="bi bi-door-open"></i>
                        <div class="value">${propiedad.habitaciones}</div>
                        <div class="label">Habitaciones</div>
                    </div>
                    <div class="detail-spec-card">
                        <i class="bi bi-droplet"></i>
                        <div class="value">${propiedad.banos}</div>
                        <div class="label">Baños</div>
                    </div>
                    <div class="detail-spec-card">
                        <i class="bi bi-layers"></i>
                        <div class="value">${propiedad.estrato}</div>
                        <div class="label">Estrato</div>
                    </div>
                    <div class="detail-spec-card">
                        <i class="bi bi-shield-check"></i>
                        <div class="value text-truncate" style="font-size: 0.95rem;">${propiedad.matriculaInmobiliaria}</div>
                        <div class="label">Matrícula Única</div>
                    </div>
                </div>

                <!-- Descripción Detallada -->
                <div class="mt-4 pt-2">
                    <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-text-paragraph text-primary"></i> Descripción del Inmueble
                    </h5>
                    <div class="p-3 bg-light rounded-3 text-secondary" style="white-space: pre-line; line-height: 1.8;">
                        ${propiedad.descripcion}
                    </div>
                </div>

                <!-- Características Asociadas (Relación N:M) -->
                <div class="mt-4 pt-3 border-top">
                    <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-check2-circle text-success"></i> Características y Amenidades
                    </h5>
                    <div class="d-flex flex-wrap gap-2">
                        <c:choose>
                            <c:when test="${not empty propiedad.caracteristicas}">
                                <c:forEach var="c" items="${propiedad.caracteristicas}">
                                    <span class="characteristic-pill">
                                        <i class="bi ${c.icono} text-success"></i>
                                        <span>${c.nombre}</span>
                                    </span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted small">No se especificaron amenidades adicionales.</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- COLUMNA LATERAL: PRECIO, ACCIONES Y CONTACTO (STICKY) -->
        <div class="col-lg-4">
            <div class="sticky-action-card">
                <span class="text-muted small d-block mb-1 text-uppercase fw-bold" style="font-size: 0.72rem; letter-spacing: 0.05em;">Valor de Publicación</span>
                <div class="property-price-tag display-6 mb-3">
                    <fmt:formatNumber value="${propiedad.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                </div>

                <!-- Botones de Acción para Clientes -->
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                        <div class="d-grid gap-2 mb-4">
                            <button type="button" class="btn btn-primary py-2 d-flex align-items-center justify-content-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalCita">
                                <i class="bi bi-calendar-event-fill"></i>
                                <span>Agendar Visita al Inmueble</span>
                            </button>
                            <button type="button" class="btn btn-success py-2 d-flex align-items-center justify-content-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalSolicitud">
                                <i class="bi bi-file-earmark-check-fill"></i>
                                <span>Radicar Solicitud Digital</span>
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Información para visitante sin sesión -->
                        <div class="p-3 bg-light border rounded-3 mb-3">
                            <div class="d-flex align-items-center gap-2 text-primary fw-bold small mb-1">
                                <i class="bi bi-info-circle-fill"></i> ¿Interesado en este inmueble?
                            </div>
                            <p class="small text-muted mb-0">
                                Inicia sesión o regístrate como cliente para agendar citas presenciales en tiempo real y radicar solicitudes con documentos.
                            </p>
                        </div>
                        <div class="d-grid gap-2 mb-4">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary py-2 fw-semibold">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar Sesión
                            </a>
                            <a href="${pageContext.request.contextPath}/registro" class="btn btn-outline-primary py-2 fw-semibold">
                                <i class="bi bi-person-plus-fill me-1"></i> Crear Cuenta Gratis
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Tarjeta Inmobiliaria Responsable (1:N) -->
                <div class="p-3 border rounded-3 bg-light">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <div class="stat-item-icon bg-primary-subtle text-primary" style="width: 40px; height: 40px; font-size: 1.2rem;">
                            <i class="bi bi-buildings"></i>
                        </div>
                        <div>
                            <span class="text-muted small d-block" style="font-size: 0.72rem; text-transform: uppercase;">Agencia Asignada</span>
                            <h6 class="fw-bold mb-0 text-dark">${propiedad.inmobiliariaNombre}</h6>
                        </div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                            <div class="border-top pt-2 mt-2 small">
                                <p class="mb-1 text-secondary"><i class="bi bi-telephone-fill text-success me-2"></i>${propiedad.inmobiliariaTelefono}</p>
                                <p class="mb-0 text-secondary"><i class="bi bi-envelope-fill text-primary me-2"></i>${propiedad.inmobiliariaCorreo}</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="small text-muted fst-italic mb-0 border-top pt-2 mt-2">
                                <i class="bi bi-lock-fill text-warning me-1"></i> Teléfono y correo visibles al autenticarse.
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
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <form action="${pageContext.request.contextPath}/cliente/agendar-cita" method="POST">
                    <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-dark" id="modalCitaLabel">
                            <i class="bi bi-calendar2-plus-fill text-primary me-2"></i>Agendar Visita al Inmueble
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted mb-3">
                            Seleccione fecha y hora para realizar el recorrido guiado en <strong>${propiedad.titulo}</strong>.
                        </p>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Fecha y Hora de la Visita *</label>
                            <input type="datetime-local" name="fechaHora" id="inputFechaCita" class="form-control" required>
                            <div class="invalid-feedback" id="feedbackCitaTurno"></div>
                            <div class="form-text small">
                                Cada inmueble admite <strong>un solo turno por horario</strong>. Los turnos ya reservados por otros clientes aparecen bloqueados; las citas canceladas quedan liberadas.
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Turnos ocupados para este inmueble</label>
                            <c:choose>
                                <c:when test="${not empty horariosOcupados}">
                                    <div class="d-flex flex-wrap gap-1">
                                        <c:forEach var="h" items="${horariosOcupados}">
                                            <span class="badge bg-secondary-subtle text-secondary border small"><i class="bi bi-clock me-1"></i>${h}</span>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="small text-muted">No hay turnos reservados todavía; todos los horarios futuros están disponibles.</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Comentarios para el Agente</label>
                            <textarea name="comentarios" class="form-control" rows="3" placeholder="Ej: Asistiré con mi arquitecto para toma de medidas y verificación de acabados..."></textarea>
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
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <form action="${pageContext.request.contextPath}/cliente/crear-solicitud" method="POST">
                    <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-dark" id="modalSolicitudLabel">
                            <i class="bi bi-file-earmark-check-fill text-success me-2"></i>Iniciar Trámite de Adquisición
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
                            <textarea name="observaciones" class="form-control" rows="3" placeholder="Indique si cuenta con crédito preaprobado, porcentaje de cuota inicial, codeudores o fecha estimada de mudanza..."></textarea>
                        </div>
                        <div class="p-3 bg-light rounded-3 small text-muted">
                            <i class="bi bi-shield-check text-success me-1"></i> Una vez radicada la solicitud, podrá adjuntar su cédula, extractos bancarios y certificaciones laborales desde su panel de cliente.
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

    <script>
        window.TURNOS_OCUPADOS = [
            <c:forEach var="h" items="${horariosOcupados}" varStatus="st">"${h}"${st.last ? '' : ','}</c:forEach>
        ];
    </script>
</c:if>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
