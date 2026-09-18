<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Catálogo de Inmuebles" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<div class="container my-4 my-lg-5">
    <!-- Breadcrumbs de navegación -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/inicio" class="text-decoration-none text-primary"><i class="bi bi-house-door me-1"></i>Inicio</a></li>
            <li class="breadcrumb-item active text-muted" aria-current="page">Catálogo Inmobiliario</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- BARRA LATERAL DE FILTROS (STICKY) -->
        <div class="col-lg-3">
            <div class="catalog-sidebar sticky-top" style="top: 95px; z-index: 10;">
                <div class="catalog-sidebar-title">
                    <span><i class="bi bi-sliders2-vertical text-primary me-2"></i>Filtros Avanzados</span>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-secondary btn-sm py-1 px-2 rounded-pill small" title="Limpiar todos los filtros">
                        <i class="bi bi-arrow-counterclockwise"></i> Limpiar
                    </a>
                </div>

                <form action="${pageContext.request.contextPath}/catalogo" method="GET" id="filterForm">
                    <!-- Operación -->
                    <div class="mb-3">
                        <label class="filter-group-title d-block">Tipo de Operación</label>
                        <select name="operacion" class="form-select form-select-sm">
                            <option value="">Todas (Venta y Arriendo)</option>
                            <option value="VENTA" ${fOperacion == 'VENTA' ? 'selected' : ''}>Comprar (Venta)</option>
                            <option value="ARRIENDO" ${fOperacion == 'ARRIENDO' ? 'selected' : ''}>Alquilar (Arriendo)</option>
                        </select>
                    </div>

                    <!-- Ciudad -->
                    <div class="mb-3">
                        <label class="filter-group-title d-block">Ciudad / Ubicación</label>
                        <select name="ciudad" class="form-select form-select-sm">
                            <option value="">Todas las ciudades</option>
                            <c:forEach var="c" items="${ciudades}">
                                <option value="${c.id}" ${fCiudad == c.id ? 'selected' : ''}>${c.nombre} (${c.departamento})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Tipo de Inmueble -->
                    <div class="mb-3">
                        <label class="filter-group-title d-block">Tipo de Propiedad</label>
                        <select name="tipo" class="form-select form-select-sm">
                            <option value="">Todos los tipos</option>
                            <c:forEach var="t" items="${tipos}">
                                <option value="${t.id}" ${fTipo == t.id ? 'selected' : ''}>${t.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Rango de Precios -->
                    <div class="mb-3">
                        <label class="filter-group-title d-block">Presupuesto (COP)</label>
                        <div class="row g-2">
                            <div class="col-6">
                                <input type="number" name="precioMin" class="form-control form-control-sm" placeholder="Mínimo" value="${fPrecioMin}">
                            </div>
                            <div class="col-6">
                                <input type="number" name="precioMax" class="form-control form-control-sm" placeholder="Máximo" value="${fPrecioMax}">
                            </div>
                        </div>
                    </div>

                    <!-- Características N:M -->
                    <div class="mb-4">
                        <label class="filter-group-title d-block">Características Deseadas</label>
                        <div class="p-2 border rounded-3 bg-light" style="max-height: 180px; overflow-y: auto;">
                            <c:forEach var="car" items="${caracteristicas}">
                                <div class="form-check small mb-1">
                                    <input class="form-check-input" type="checkbox" name="caracteristica" value="${car.id}" id="car_${car.id}"
                                        <c:forEach var="sel" items="${fCaracs}">
                                            <c:if test="${sel == car.id}">checked</c:if>
                                        </c:forEach>
                                    >
                                    <label class="form-check-label text-secondary" for="car_${car.id}">
                                        ${car.nombre}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 shadow-sm d-flex align-items-center justify-content-center gap-2">
                        <i class="bi bi-funnel-fill"></i>
                        <span>Aplicar Filtros</span>
                    </button>
                </form>
            </div>
        </div>

        <!-- ÁREA PRINCIPAL: RESULTADOS -->
        <div class="col-lg-9">
            <!-- Barra superior de resultados -->
            <div class="catalog-results-header">
                <div>
                    <h4 class="fw-bold mb-0 text-dark">Explorador de Inmuebles</h4>
                    <span class="text-muted small">Mostrando listado de propiedades verificadas</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-bold">
                        <i class="bi bi-buildings me-1"></i>${propiedades.size()} Inmuebles Encontrados
                    </span>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty propiedades}">
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4">
                        <div class="stat-icon bg-light text-muted mx-auto mb-3 rounded-circle" style="width: 80px; height: 80px;">
                            <i class="bi bi-search fs-1"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-2">No se encontraron inmuebles</h4>
                        <p class="text-muted small mb-4">No hay propiedades que coincidan con los filtros seleccionados actualmente.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary rounded-pill px-4">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Restablecer Filtros
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach var="p" items="${propiedades}">
                            <div class="col-md-6">
                                <div class="property-card">
                                    <div class="property-img-wrapper">
                                        <img src="${p.imagenPrincipalUrl}" alt="${p.titulo}" class="property-card-img" 
                                             onerror="this.src='https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800'">
                                        
                                        <span class="badge-operation-pill ${p.tipoOperacion == 'VENTA' ? 'badge-operation-venta' : 'badge-operation-arriendo'}">
                                            ${p.tipoOperacion}
                                        </span>

                                        <span class="badge-type-pill">
                                            <i class="bi bi-building me-1"></i>${p.tipoPropiedadNombre}
                                        </span>
                                    </div>

                                    <div class="card-body p-4 d-flex flex-column flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="text-primary fw-semibold small">
                                                <i class="bi bi-geo-alt-fill text-danger me-1"></i>${p.ciudadNombre}
                                            </span>
                                            <span class="text-muted small">
                                                <i class="bi bi-upc me-1"></i><code>${p.matriculaInmobiliaria}</code>
                                            </span>
                                        </div>

                                        <h5 class="card-title fw-bold text-dark mb-2 text-truncate" title="${p.titulo}">
                                            ${p.titulo}
                                        </h5>

                                        <p class="card-text text-muted small flex-grow-1 mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.5;">
                                            ${p.descripcion}
                                        </p>

                                        <!-- Ficha de especificaciones rápida -->
                                        <div class="property-specs-grid">
                                            <div class="spec-chip" title="Habitaciones">
                                                <i class="bi bi-door-open"></i>
                                                <span>${p.habitaciones} Hab</span>
                                            </div>
                                            <div class="spec-chip" title="Baños">
                                                <i class="bi bi-droplet"></i>
                                                <span>${p.banos} Baños</span>
                                            </div>
                                            <div class="spec-chip" title="Área">
                                                <i class="bi bi-arrows-angle-expand"></i>
                                                <span>${p.areaM2} m²</span>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center mt-3 pt-2">
                                            <div>
                                                <span class="text-muted d-block small" style="font-size: 0.72rem; text-transform: uppercase; font-weight: 700;">Precio</span>
                                                <span class="property-price-tag">
                                                    <fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                                </span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/propiedad?id=${p.id}" class="btn btn-primary btn-sm rounded-pill px-3 shadow-sm">
                                                Ver Detalle <i class="bi bi-arrow-up-right ms-1"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
