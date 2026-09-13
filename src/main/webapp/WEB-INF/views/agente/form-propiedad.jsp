<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${esEdicion ? 'Editar Inmueble' : 'Publicar Nuevo Inmueble'}" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">
                <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                    <div>
                        <h3 class="fw-bold text-dark mb-1">${esEdicion ? 'Editar Propiedad' : 'Publicar Nueva Propiedad'}</h3>
                        <p class="text-muted small mb-0">Complete la información requerida del inmueble. La matrícula inmobiliaria debe ser única.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/agente/propiedades" class="btn btn-outline-secondary btn-sm rounded-pill">
                        <i class="bi bi-arrow-left me-1"></i> Volver al Listado
                    </a>
                </div>

                <form action="${pageContext.request.contextPath}/agente/${esEdicion ? 'editar-propiedad' : 'crear-propiedad'}" method="POST" class="row g-3">
                    <c:if test="${esEdicion}">
                        <input type="hidden" name="id" value="${propiedad.id}">
                    </c:if>

                    <!-- Título -->
                    <div class="col-md-8">
                        <label class="form-label small fw-semibold">Título de la Publicación *</label>
                        <input type="text" name="titulo" class="form-control" required value="${propiedad.titulo}" placeholder="Ej: Espectacular Apartamento en Cabecera del Llano">
                    </div>

                    <!-- Matrícula Inmobiliaria (UNIQUE) -->
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Matrícula Inmobiliaria *</label>
                        <input type="text" name="matriculaInmobiliaria" class="form-control" required value="${propiedad.matriculaInmobiliaria}" placeholder="Ej: MAT-BGA-00999">
                        <div class="form-text small">Restricción UNIQUE obligatoria.</div>
                    </div>

                    <!-- Ciudad y Tipo de Inmueble -->
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Ciudad de Ubicación *</label>
                        <select name="idCiudad" class="form-select" required>
                            <c:forEach var="c" items="${ciudades}">
                                <option value="${c.id}" ${propiedad.idCiudad == c.id ? 'selected' : ''}>${c.nombre} (${c.departamento})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Tipo de Propiedad *</label>
                        <select name="idTipoPropiedad" class="form-select" required>
                            <c:forEach var="t" items="${tipos}">
                                <option value="${t.id}" ${propiedad.idTipoPropiedad == t.id ? 'selected' : ''}>${t.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Precio y Operación -->
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Precio en Pesos (COP) *</label>
                        <input type="number" step="1000" name="precio" class="form-control" required value="${propiedad.precio}" placeholder="Ej: 350000000">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Tipo de Operación *</label>
                        <select name="tipoOperacion" class="form-select" required>
                            <option value="VENTA" ${propiedad.tipoOperacion == 'VENTA' ? 'selected' : ''}>VENTA</option>
                            <option value="ARRIENDO" ${propiedad.tipoOperacion == 'ARRIENDO' ? 'selected' : ''}>ARRIENDO</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Estado del Inmueble</label>
                        <select name="estado" class="form-select">
                            <option value="DISPONIBLE" ${propiedad.estado == 'DISPONIBLE' ? 'selected' : ''}>DISPONIBLE</option>
                            <option value="RESERVADA" ${propiedad.estado == 'RESERVADA' ? 'selected' : ''}>RESERVADA</option>
                            <option value="VENDIDA" ${propiedad.estado == 'VENDIDA' ? 'selected' : ''}>VENDIDA</option>
                            <option value="ARRENDADA" ${propiedad.estado == 'ARRENDADA' ? 'selected' : ''}>ARRENDADA</option>
                            <option value="INACTIVA" ${propiedad.estado == 'INACTIVA' ? 'selected' : ''}>INACTIVA (Baja Lógica)</option>
                        </select>
                    </div>

                    <!-- Especificaciones Físicas -->
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Área Construida (m²)</label>
                        <input type="number" step="0.1" name="areaM2" class="form-control" value="${not empty propiedad.areaM2 ? propiedad.areaM2 : 0}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Habitaciones</label>
                        <input type="number" name="habitaciones" class="form-control" value="${not empty propiedad.habitaciones ? propiedad.habitaciones : 0}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Baños</label>
                        <input type="number" name="banos" class="form-control" value="${not empty propiedad.banos ? propiedad.banos : 0}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Estrato Socioeconómico</label>
                        <input type="number" name="estrato" class="form-control" value="${not empty propiedad.estrato ? propiedad.estrato : 3}" min="1" max="6">
                    </div>

                    <!-- Dirección -->
                    <div class="col-12">
                        <label class="form-label small fw-semibold">Dirección Exacta del Inmueble *</label>
                        <input type="text" name="direccion" class="form-control" required value="${propiedad.direccion}" placeholder="Ej: Carrera 35 # 48-22 Apto 1204">
                    </div>

                    <!-- Descripción -->
                    <div class="col-12">
                        <label class="form-label small fw-semibold">Descripción Detallada *</label>
                        <textarea name="descripcion" class="form-control" rows="4" required placeholder="Describa la distribución, acabados, vistas y amenidades...">${propiedad.descripcion}</textarea>
                    </div>

                    <!-- Características (Relación N:M) -->
                    <div class="col-12 border-top pt-3">
                        <label class="form-label small fw-bold text-uppercase text-muted">Características del Inmueble (Relación N:M)</label>
                        <div class="row g-2">
                            <c:forEach var="car" items="${caracteristicas}">
                                <div class="col-md-4 col-sm-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="caracteristicas" value="${car.id}" id="fc_${car.id}"
                                            <c:forEach var="pCar" items="${propiedad.caracteristicas}">
                                                <c:if test="${pCar.id == car.id}">checked</c:if>
                                            </c:forEach>
                                        >
                                        <label class="form-check-label small" for="fc_${car.id}">
                                            <i class="bi ${car.icono} text-primary me-1"></i>${car.nombre}
                                        </label>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Galería de Imágenes (Relación 1:N) -->
                    <c:if test="${!esEdicion}">
                        <div class="col-12 border-top pt-3">
                            <label class="form-label small fw-bold text-uppercase text-muted">Galería de Imágenes (1:N)</label>
                            <p class="small text-muted mb-2">Ingrese las URLs de las fotografías (una por línea). La primera será la foto principal.</p>
                            <textarea name="imagenesUrls" class="form-control" rows="3" placeholder="https://images.unsplash.com/photo-1...&#10;https://images.unsplash.com/photo-2..."></textarea>
                        </div>
                    </c:if>

                    <!-- Destacada Checkbox -->
                    <div class="col-12">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="destacada" id="swDestacada" ${propiedad.destacada ? 'checked' : ''}>
                            <label class="form-check-label small fw-semibold" for="swDestacada">Marcar como Propiedad Destacada en la Landing Page</label>
                        </div>
                    </div>

                    <div class="col-12 text-end border-top pt-4">
                        <a href="${pageContext.request.contextPath}/agente/propiedades" class="btn btn-light rounded-pill px-4 me-2">Cancelar</a>
                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-semibold">
                            <i class="bi bi-cloud-check-fill me-1"></i> ${esEdicion ? 'Actualizar Propiedad' : 'Publicar Inmueble'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
