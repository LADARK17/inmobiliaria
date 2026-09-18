<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Catálogo de Inmuebles (Admin)" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-4 my-lg-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3 bg-white p-4 rounded-4 border shadow-sm">
        <div class="d-flex align-items-center gap-3">
            <div class="brand-icon-box bg-danger text-white rounded-circle" style="width: 52px; height: 52px; font-size: 1.5rem;">
                <i class="bi bi-houses-fill"></i>
            </div>
            <div>
                <h3 class="fw-bold mb-0 text-dark"><i class="bi bi-houses-fill text-danger me-2"></i>Catálogo Global de Inmuebles</h3>
                <p class="text-muted small mb-0">Publica nuevos inmuebles, actualiza sus datos y súbelos o bájalos del catálogo público.</p>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary rounded-pill px-3">
                <i class="bi bi-arrow-left me-1"></i> Volver
            </a>
            <a href="${pageContext.request.contextPath}/admin/crear-propiedad" class="btn btn-primary rounded-pill px-3 shadow-sm d-inline-flex align-items-center gap-1">
                <i class="bi bi-plus-lg"></i> Subir Nuevo Inmueble
            </a>
        </div>
    </div>

    <div class="table-responsive-custom">
        <table class="table table-hover align-middle mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Inmueble</th>
                    <th>Inmobiliaria</th>
                    <th>Operación</th>
                    <th>Precio</th>
                    <th>Ubicación</th>
                    <th>Estado</th>
                    <th class="text-end">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${propiedades}">
                    <tr class="${p.estado == 'INACTIVA' ? 'table-light text-muted' : ''}">
                        <td><strong>#${p.id}</strong></td>
                        <td>
                            <div class="d-flex align-items-center gap-3">
                                <img src="${p.imagenPrincipalUrl}" alt="" class="rounded-3 object-fit-cover" style="width: 50px; height: 50px;"
                                     onerror="this.src='https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800'">
                                <div>
                                    <h6 class="fw-bold mb-0">${p.titulo}</h6>
                                    <small class="text-muted">${p.tipoPropiedadNombre} &bull; ${p.matriculaInmobiliaria} &bull; ${p.habitaciones} Hab. &bull; ${p.areaM2} m²</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="small fw-semibold text-dark d-block">${p.inmobiliariaNombre}</span>
                        </td>
                        <td>
                            <span class="badge ${p.tipoOperacion == 'VENTA' ? 'bg-primary-subtle text-primary' : 'bg-success-subtle text-success'} rounded-pill">
                                ${p.tipoOperacion}
                            </span>
                        </td>
                        <td class="fw-bold">
                            <fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                        </td>
                        <td>
                            <span class="small">${p.ciudadNombre}</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.estado == 'DISPONIBLE'}">
                                    <span class="badge bg-success rounded-pill">Disponible</span>
                                </c:when>
                                <c:when test="${p.estado == 'RESERVADA'}">
                                    <span class="badge bg-warning text-dark rounded-pill">Reservada</span>
                                </c:when>
                                <c:when test="${p.estado == 'VENDIDA'}">
                                    <span class="badge bg-info text-dark rounded-pill">Vendida</span>
                                </c:when>
                                <c:when test="${p.estado == 'ARRENDADA'}">
                                    <span class="badge bg-primary rounded-pill">Arrendada</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger rounded-pill">Fuera de Catálogo</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/propiedad?id=${p.id}" target="_blank" class="btn btn-outline-secondary btn-sm" title="Ver ficha pública">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/editar-propiedad?id=${p.id}" class="btn btn-outline-primary btn-sm" title="Editar datos del inmueble">
                                    <i class="bi bi-pencil-fill"></i>
                                </a>
                                <c:if test="${p.estado != 'INACTIVA'}">
                                    <form action="${pageContext.request.contextPath}/admin/cambiar-estado-propiedad" method="POST" class="d-inline" onsubmit="return confirmarAccion('¿Bajar este inmueble del catálogo público? El registro permanecerá en INACTIVA conservando citas y trámites.');">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <input type="hidden" name="nuevoEstado" value="INACTIVA">
                                        <button type="submit" class="btn btn-outline-danger btn-sm" title="Bajar del catálogo (baja lógica)">
                                            <i class="bi bi-slash-circle"></i>
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${p.estado == 'INACTIVA'}">
                                    <form action="${pageContext.request.contextPath}/admin/cambiar-estado-propiedad" method="POST" class="d-inline" onsubmit="return confirmarAccion('¿Volver a subir este inmueble al catálogo público? Se publicará como DISPONIBLE.');">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <input type="hidden" name="nuevoEstado" value="DISPONIBLE">
                                        <button type="submit" class="btn btn-outline-success btn-sm" title="Subir de nuevo al catálogo (reactivar)">
                                            <i class="bi bi-arrow-up-circle"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty propiedades}">
                    <tr>
                        <td colspan="8" class="text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                            No hay inmuebles registrados aún.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>