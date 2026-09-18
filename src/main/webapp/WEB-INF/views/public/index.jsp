<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Encuentra tu Inmueble Ideal" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<!-- HERO BANNER CON BUSCADOR RÁPIDO -->
<section class="hero-banner">
    <div class="container position-relative">
        <div class="row justify-content-center text-center">
            <div class="col-lg-9 col-xl-8">
                <div class="hero-badge">
                    <span class="spinner-grow spinner-grow-sm text-warning" role="status" style="width: 10px; height: 10px;"></span>
                    <span>Plataforma Inmobiliaria Líder en Colombia</span>
                </div>
                <h1 class="display-4 fw-extrabold text-white mb-3" style="text-shadow: 0 4px 20px rgba(0, 0, 0, 0.5); letter-spacing: -0.02em;">
                    Encuentra el hogar que siempre soñaste con <span class="hero-gradient-text">total respaldo</span>
                </h1>
                <p class="lead mb-4 px-md-4" style="color: rgba(255, 255, 255, 0.92) !important; text-shadow: 0 2px 12px rgba(0, 0, 0, 0.5); font-size: 1.2rem; line-height: 1.6;">
                    Casas, apartamentos, oficinas y locales comerciales en las mejores zonas con verificación jurídica, matrícula única y citas en tiempo real.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- TARJETA BUSCADOR INTELIGENTE -->
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-11 col-xl-10">
            <div class="search-box-card">
                <!-- Pestañas de tipo de operación -->
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                    <div class="segmented-control" role="group">
                        <input type="radio" class="btn-check" name="opSegment" id="opTodos" autocomplete="off" checked onchange="setOperationFilter('')">
                        <label class="btn" for="opTodos"><i class="bi bi-grid-fill me-1"></i> Todos</label>

                        <input type="radio" class="btn-check" name="opSegment" id="opVenta" autocomplete="off" onchange="setOperationFilter('VENTA')">
                        <label class="btn" for="opVenta"><i class="bi bi-tag-fill me-1"></i> Comprar (Venta)</label>

                        <input type="radio" class="btn-check" name="opSegment" id="opArriendo" autocomplete="off" onchange="setOperationFilter('ARRIENDO')">
                        <label class="btn" for="opArriendo"><i class="bi bi-key-fill me-1"></i> Alquilar (Arriendo)</label>
                    </div>

                    <span class="text-muted small d-none d-md-inline">
                        <i class="bi bi-shield-check text-success me-1"></i>+16 Ciudades Verificadas
                    </span>
                </div>

                <form action="${pageContext.request.contextPath}/catalogo" method="GET" class="row g-3 align-items-end" id="heroSearchForm">
                    <input type="hidden" name="operacion" id="inputOperacion" value="">

                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">
                            <i class="bi bi-geo-alt-fill text-danger me-1"></i>Ciudad o Municipio
                        </label>
                        <select name="ciudad" class="form-select">
                            <option value="">Todas las ciudades</option>
                            <c:forEach var="c" items="${ciudades}">
                                <option value="${c.id}">${c.nombre} (${c.departamento})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">
                            <i class="bi bi-house-door-fill text-primary me-1"></i>Tipo de Inmueble
                        </label>
                        <select name="tipo" class="form-select">
                            <option value="">Todos los tipos</option>
                            <c:forEach var="t" items="${tipos}">
                                <option value="${t.id}">${t.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <button type="submit" class="btn btn-primary w-100 py-2 d-flex align-items-center justify-content-center gap-2">
                            <i class="bi bi-search"></i>
                            <span>Explorar Catálogo</span>
                        </button>
                    </div>
                </form>
            </div>

            <!-- Tira de estadísticas / Trust Bar -->
            <div class="stats-strip">
                <div class="row g-4 text-center text-md-start">
                    <div class="col-6 col-md-3">
                        <div class="stat-item justify-content-center justify-content-md-start">
                            <div class="stat-item-icon bg-primary-subtle text-primary">
                                <i class="bi bi-building-check"></i>
                            </div>
                            <div>
                                <div class="stat-item-number">+500</div>
                                <div class="stat-item-label">Propiedades Activas</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-item justify-content-center justify-content-md-start">
                            <div class="stat-item-icon bg-success-subtle text-success">
                                <i class="bi bi-patch-check-fill"></i>
                            </div>
                            <div>
                                <div class="stat-item-number">100%</div>
                                <div class="stat-item-label">Legal 3FN & Certificado</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-item justify-content-center justify-content-md-start">
                            <div class="stat-item-icon bg-warning-subtle text-warning">
                                <i class="bi bi-calendar-event"></i>
                            </div>
                            <div>
                                <div class="stat-item-number">1:1</div>
                                <div class="stat-item-label">Citas en Tiempo Real</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-item justify-content-center justify-content-md-start">
                            <div class="stat-item-icon bg-info-subtle text-info">
                                <i class="bi bi-shield-lock-fill"></i>
                            </div>
                            <div>
                                <div class="stat-item-number">BCrypt</div>
                                <div class="stat-item-label">Seguridad de Datos</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- SECCIÓN PROPIEDADES DESTACADAS (CARRUSEL CONTINUO INFINITO) -->
<section class="my-5 py-4 overflow-hidden">
    <div class="container">
        <div class="d-flex flex-wrap justify-content-between align-items-end mb-4 gap-3">
            <div>
                <div class="d-inline-flex align-items-center gap-2 text-primary fw-bold small text-uppercase mb-1">
                    <i class="bi bi-stars"></i> Lo más exclusivo
                </div>
                <h2 class="fw-bold text-dark mb-1">Propiedades Destacadas</h2>
                <p class="text-muted mb-0">Inmuebles verificados en movimiento continuo. Pasa el cursor para pausar o explorar.</p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <!-- Controles manuales del carrusel infinito -->
                <button class="btn-nav-carrusel" type="button" onclick="deslizarCarruselInfinito(-1)" title="Desplazar hacia la izquierda">
                    <i class="bi bi-chevron-left fs-5"></i>
                </button>
                <button class="btn-nav-carrusel" type="button" onclick="alternarPausaCarruselInfinito()" title="Pausar / Reanudar movimiento continuo" id="btnPlayPausa">
                    <i class="bi bi-pause-fill fs-5" id="iconoPlayPausa"></i>
                </button>
                <button class="btn-nav-carrusel" type="button" onclick="deslizarCarruselInfinito(1)" title="Desplazar hacia la derecha">
                    <i class="bi bi-chevron-right fs-5"></i>
                </button>
                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary rounded-pill px-4 ms-2 shadow-sm">
                    Ver catálogo (${destacadas.size()}+) <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Carrusel Infinito con Movimiento Continuo (Loop Imperceptible) -->
    <div class="infinite-carousel-outer" id="carruselInfinitoOuter">
        <div class="infinite-carousel-track" id="carruselInfinitoTrack">
            <!-- Primer bucle de propiedades -->
            <c:forEach var="p" items="${destacadas}">
                <div class="infinite-carousel-card-item">
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
                                    Ver Ficha <i class="bi bi-arrow-up-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <!-- Segundo bucle idéntico para que el desplazamiento infinito no tenga saltos -->
            <c:forEach var="p" items="${destacadas}">
                <div class="infinite-carousel-card-item">
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
                                    Ver Ficha <i class="bi bi-arrow-up-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<script>
let carruselEnPausa = false;
const trackInfinito = document.getElementById('carruselInfinitoTrack');

function alternarPausaCarruselInfinito() {
    const icono = document.getElementById('iconoPlayPausa');
    if (!trackInfinito) return;
    carruselEnPausa = !carruselEnPausa;
    if (carruselEnPausa) {
        trackInfinito.classList.add('paused');
        if (icono) {
            icono.classList.remove('bi-pause-fill');
            icono.classList.add('bi-play-fill');
        }
    } else {
        trackInfinito.classList.remove('paused');
        if (icono) {
            icono.classList.remove('bi-play-fill');
            icono.classList.add('bi-pause-fill');
        }
    }
}

function deslizarCarruselInfinito(direccion) {
    if (!trackInfinito) return;
    const computed = window.getComputedStyle(trackInfinito);
    const matrix = new WebKitCSSMatrix(computed.transform);
    let posX = matrix.m41;

    // Pausar animación de keyframes temporalmente para desplazamiento manual suave
    trackInfinito.style.animation = 'none';

    // Desplazamiento proporcional al ancho de tarjeta (360px + 24px gap = 384px)
    posX += (direccion * -384);

    const mitadAncho = trackInfinito.scrollWidth / 2;
    if (Math.abs(posX) >= mitadAncho) {
        posX = 0;
    } else if (posX > 0) {
        posX = -mitadAncho + 384;
    }

    trackInfinito.style.transition = 'transform 0.45s cubic-bezier(0.25, 1, 0.5, 1)';
    trackInfinito.style.transform = `translateX(${posX}px)`;

    setTimeout(() => {
        trackInfinito.style.transition = '';
        trackInfinito.style.animation = '';
        if (carruselEnPausa) {
            trackInfinito.classList.add('paused');
        } else {
            trackInfinito.classList.remove('paused');
        }
    }, 1200);
}
</script>

<!-- SECCIÓN BENEFICIOS Y VALOR AGREGADO -->
<section class="py-5 bg-white border-top border-bottom">
    <div class="container my-3">
        <div class="text-center max-w-700 mx-auto mb-5">
            <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-bold small text-uppercase mb-2">
                ¿Por qué elegir Hábitat Prime?
            </span>
            <h2 class="fw-bold">Gestión inmobiliaria transparente, moderna y segura</h2>
            <p class="text-muted">Desarrollado bajo estándares rigurosos de ingeniería de software para brindarte la mejor experiencia.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon-wrapper bg-primary-subtle text-primary">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Seguridad y Matrícula Única</h5>
                    <p class="text-muted small mb-0">
                        Cada inmueble cuenta con matrícula inmobiliaria validada en base de datos en 3FN contra duplicidades y con soporte documental verificado.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon-wrapper bg-success-subtle text-success">
                        <i class="bi bi-calendar2-check"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Citas Sin Conflictos de Horario</h5>
                    <p class="text-muted small mb-0">
                        Agenda visitas de forma interactiva con validación estricta de concurrencia <code>(id_propiedad, fecha_hora)</code> evitando cruces de citas.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon-wrapper bg-warning-subtle text-warning">
                        <i class="bi bi-folder-check"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Radicación de Trámites 100% Digital</h5>
                    <p class="text-muted small mb-0">
                        Postúlate a la compra o arrendamiento adjuntando documentos probatorios (cédula, extractos, certificados) desde tu panel de cliente.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>



<script>
function setOperationFilter(val) {
    document.getElementById('inputOperacion').value = val;
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
