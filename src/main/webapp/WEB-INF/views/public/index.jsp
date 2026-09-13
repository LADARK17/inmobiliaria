<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Encuentra tu Inmueble Ideal" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<!-- HERO BANNER CON BUSCADOR RÁPIDO -->
<section class="hero-banner">
    <div class="container text-center">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                <span class="badge bg-light text-primary px-3 py-2 rounded-pill fw-bold mb-3">
                    <i class="bi bi-star-fill text-warning me-1"></i> Líderes en Gestión Inmobiliaria
                </span>
                <h1 class="display-4 fw-extrabold text-white mb-3">
                    El hogar de tus sueños a un solo clic de distancia
                </h1>
                <p class="lead text-white-50 mb-4">
                    Explora casas, apartamentos, oficinas y locales en las mejores ciudades de Colombia con total respaldo legal y transparencia.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- TARJETA BUSCADOR RÁPIDO (DESDE LA LANDING) -->
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="search-box-card">
                <form action="${pageContext.request.contextPath}/catalogo" method="GET" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-bold small text-muted">¿Qué operación buscas?</label>
                        <select name="operacion" class="form-select">
                            <option value="">Todas (Venta y Arriendo)</option>
                            <option value="VENTA">Comprar (Venta)</option>
                            <option value="ARRIENDO">Alquilar (Arriendo)</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold small text-muted">Ciudad</label>
                        <select name="ciudad" class="form-select">
                            <option value="">Todas las ciudades</option>
                            <c:forEach var="c" items="${ciudades}">
                                <option value="${c.id}">${c.nombre} (${c.departamento})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold small text-muted">Tipo de Inmueble</label>
                        <select name="tipo" class="form-select">
                            <option value="">Todos los tipos</option>
                            <c:forEach var="t" items="${tipos}">
                                <option value="${t.id}">${t.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-search me-1"></i> Buscar Inmuebles
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- SECCIÓN PROPIEDADES DESTACADAS -->
<section class="container my-5 py-4">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <h2 class="fw-bold text-dark mb-1">Propiedades Destacadas</h2>
            <p class="text-muted mb-0">Selección exclusiva de inmuebles con alta demanda y acabados de primera</p>
        </div>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary rounded-pill btn-sm px-3">
            Ver todas (${destacadas.size()}+) <i class="bi bi-arrow-right ms-1"></i>
        </a>
    </div>

    <div class="row g-4">
        <c:forEach var="p" items="${destacadas}">
            <div class="col-lg-4 col-md-6">
                <div class="property-card">
                    <div class="position-relative">
                        <img src="${p.imagenPrincipalUrl}" alt="${p.titulo}" class="property-card-img" 
                             onerror="this.src='https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800'">
                        <span class="badge ${p.tipoOperacion == 'VENTA' ? 'bg-primary' : 'bg-success'} badge-operation">
                            ${p.tipoOperacion}
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
                                Ficha Detalle <i class="bi bi-chevron-right ms-1"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<!-- SECCIÓN BENEFICIOS Y CONFIANZA -->
<section class="bg-white py-5 border-top border-bottom">
    <div class="container">
        <div class="row text-center g-4">
            <div class="col-md-4">
                <div class="p-4">
                    <div class="bg-primary-subtle text-primary stat-icon mx-auto mb-3 rounded-circle" style="width: 70px; height: 70px;">
                        <i class="bi bi-shield-check fs-2"></i>
                    </div>
                    <h5 class="fw-bold">Matrículas Verificadas</h5>
                    <p class="text-muted small mb-0">Cada propiedad cuenta con matrícula inmobiliaria única validada contra duplicados y con soporte documental.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-4">
                    <div class="bg-success-subtle text-success stat-icon mx-auto mb-3 rounded-circle" style="width: 70px; height: 70px;">
                        <i class="bi bi-calendar2-check fs-2"></i>
                    </div>
                    <h5 class="fw-bold">Citas en Tiempo Real</h5>
                    <p class="text-muted small mb-0">Agenda visitas presenciales con confirmación directa de los agentes autorizados sin doble reserva de horario.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-4">
                    <div class="bg-warning-subtle text-warning stat-icon mx-auto mb-3 rounded-circle" style="width: 70px; height: 70px;">
                        <i class="bi bi-folder-check fs-2"></i>
                    </div>
                    <h5 class="fw-bold">Radicación Digital</h5>
                    <p class="text-muted small mb-0">Postula a trámites de arriendo o compra adjuntando cédula, extractos y certificaciones desde tu panel de cliente.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
