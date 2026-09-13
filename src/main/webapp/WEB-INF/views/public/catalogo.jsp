<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Catálogo de Inmuebles" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<div class="container my-5">
    <div class="row g-4">
        <!-- BARRA LATERAL DE FILTROS -->
        <div class="col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 p-4 sticky-top" style="top: 90px; z-index: 5;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-funnel-fill text-primary me-2"></i>Filtros</h5>
                    <a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none small text-muted">Limpiar</a>
                </div>

                <form action="${pageContext.request.contextPath}/catalogo" method="GET">
                    <!-- Operación -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Operación</label>
                        <select name="operacion" class="form-select form-select-sm">
                            <option value="">Todas las operaciones</option>
                            <option value="VENTA" ${fOperacion == 'VENTA' ? 'selected' : ''}>Venta</option>
                            <option value="ARRIENDO" ${fOperacion == 'ARRIENDO' ? 'selected' : ''}>Arriendo</option>
                        </select>
                    </div>

                    <!-- Ciudad -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Ciudad</label>
                        <select name="ciudad" class="form-select form-select-sm">
                            <option value="">Todas las ciudades</option>
                            <c:forEach var="c" items="${ciudades}">
                                <option value="${c.id}" ${fCiudad == c.id ? 'selected' : ''}>${c.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Tipo de Propiedad -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tipo de Inmueble</label>
                        <select name="tipo" class="form-select form-select-sm">
                            <option value="">Todos los tipos</option>
                            <c:forEach var="t" items="${tipos}">
                                <option value="${t.id}" ${fTipo == t.id ? 'selected' : ''}>${t.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Rango de Precios -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Precio Mínimo (COP)</label>
                        <input type="number" name="precioMin" class="form-control form-control-sm" placeholder="Ej: 100000000" value="${fPrecioMin}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Precio Máximo (COP)</label>
                        <input type="number" name="precioMax" class="form-control form-control-sm" placeholder="Ej: 500000000" value="${fPrecioMax}">
                    </div>

                    <!-- Características (Relación N:M) -->
                    <div class="mb-4">
                        <label class="form-label small fw-semibold">Características Deseadas</label>
                        <div class="overflow-auto" style="max-height: 180px;">
                            <c:forEach var="car" items="${caracteristicas}">
                                <div class="form-check form-check-sm mb-1">
                                    <input class="form-check-input" type="checkbox" name="caracteristica" value="${car.id}" id="car_${car.id}"
                                        <c:forEach var="sel" items="${fCaracs}">
                                            <c:if test="${sel == car.id}">checked</c:if>
                                        </c:forEach>
                                    >
                                    <label class="form-check-label small" for="car_${car.id}">
                                        ${car.nombre}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-pill btn-sm fw-semibold">
                        <i class="bi bi-filter me-1"></i> Aplicar Filtros
                    </button>
                </form>
            </div>
        </div>

        <!-- LISTADO DE PROPIEDADES -->
        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0">Catálogo de Propiedades</h4>
                <span class="text-muted small">${propiedades.size()} propiedades encontradas</span>
            </div>

            <c:choose>
                <c:when test="${empty propiedades}">
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center">
                        <i class="bi bi-search text-muted display-3 mb-3"></i>
                        <h5 class="fw-bold">No se encontraron inmuebles</h5>
                        <p class="text-muted small">Intente ajustar o eliminar algunos criterios de búsqueda o precios.</p>
                        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary btn-sm rounded-pill mx-auto">
                            Ver todo el catálogo
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach var="p" items="${propiedades}">
                            <div class="col-md-6">
                                <div class="property-card">
                                    <div class="position-relative">
                                        <img src="${p.imagenPrincipalUrl}" alt="${p.titulo}" class="property-card-img" 
                                             onerror="this.src='https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800'">
                                        <span class="badge ${p.tipoOperacion == 'VENTA' ? 'bg-primary' : 'bg-success'} badge-operation">
                                            ${p.tipoOperacion}
                                        </span>
                                        <span class="badge bg-dark bg-opacity-75 position-absolute bottom-0 end-0 m-2 small">
                                            <i class="bi bi-upc-scan me-1"></i>${p.matriculaInmobiliaria}
                                        </span>
                                    </div>
                                    <div class="card-body p-4 d-flex flex-column flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="text-primary fw-semibold small">
                                                <i class="bi bi-geo-alt-fill me-1"></i>${p.ciudadNombre}
                                            </span>
                                            <span class="badge bg-light text-dark border small">${p.tipoPropiedadNombre}</span>
                                        </div>
                                        <h5 class="card-title fw-bold text-dark mb-2 text-truncate" title="${p.titulo}">
                                            ${p.titulo}
                                        </h5>
                                        <p class="card-text text-muted small flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${p.descripcion}
                                        </p>
                                        
                                        <div class="d-flex justify-content-between text-muted small border-top pt-3 my-3">
                                            <span><i class="bi bi-door-open me-1"></i>${p.habitaciones} Hab.</span>
                                            <span><i class="bi bi-badge-wc me-1"></i>${p.banos} Baños</span>
                                            <span><i class="bi bi-arrows-fullscreen me-1"></i>${p.areaM2} m²</span>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center mt-auto">
                                            <div>
                                                <span class="text-muted d-block small" style="font-size: 0.75rem;">Precio</span>
                                                <span class="property-price">
                                                    <fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                                </span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/propiedad?id=${p.id}" class="btn btn-primary btn-sm rounded-pill px-3">
                                                Ver Detalle <i class="bi bi-chevron-right ms-1"></i>
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
