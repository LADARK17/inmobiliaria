<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Mis Inmuebles Favoritos" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-heart-fill text-danger me-2"></i>Mis Inmuebles Favoritos</h3>
            <p class="text-muted mb-0">Propiedades que has guardado para revisar posteriormente</p>
        </div>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary btn-sm rounded-pill">
            <i class="bi bi-plus-lg me-1"></i> Explorar Más Inmuebles
        </a>
    </div>

    <c:choose>
        <c:when test="${empty favoritos}">
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4">
                <i class="bi bi-heart text-muted display-3 mb-3"></i>
                <h5 class="fw-bold">No tienes inmuebles en favoritos</h5>
                <p class="text-muted small">Explora nuestro catálogo y presiona el botón "Guardar en Favoritos" en las propiedades de tu interés.</p>
                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-primary rounded-pill btn-sm px-4 mx-auto">
                    Ir al Catálogo
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="f" items="${favoritos}">
                    <div class="col-md-6 col-lg-4">
                        <div class="property-card">
                            <div class="position-relative">
                                <img src="${f.propiedad.imagenPrincipalUrl}" alt="${f.propiedad.titulo}" class="property-card-img"
                                     onerror="this.src='https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800'">
                                <span class="badge ${f.propiedad.tipoOperacion == 'VENTA' ? 'bg-primary' : 'bg-success'} badge-operation">
                                    ${f.propiedad.tipoOperacion}
                                </span>
                            </div>
                            <div class="card-body p-4 d-flex flex-column flex-grow-1">
                                <span class="text-primary fw-semibold small mb-1">
                                    <i class="bi bi-geo-alt-fill me-1"></i>${f.propiedad.ciudadNombre}
                                </span>
                                <h5 class="card-title fw-bold text-dark text-truncate" title="${f.propiedad.titulo}">
                                    ${f.propiedad.titulo}
                                </h5>
                                <div class="my-3">
                                    <span class="property-price">
                                        <fmt:formatNumber value="${f.propiedad.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-auto pt-3 border-top">
                                    <a href="${pageContext.request.contextPath}/propiedad?id=${f.propiedad.id}" class="btn btn-primary btn-sm rounded-pill px-3">
                                        Ver Ficha
                                    </a>
                                    <form action="${pageContext.request.contextPath}/cliente/favoritos" method="POST" class="d-inline">
                                        <input type="hidden" name="idPropiedad" value="${f.propiedad.id}">
                                        <input type="hidden" name="accion" value="eliminar">
                                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle" title="Eliminar de favoritos">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
