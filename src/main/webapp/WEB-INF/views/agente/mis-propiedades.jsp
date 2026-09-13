<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Gestión de Inmuebles de la Agencia" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-houses-fill text-primary me-2"></i>Inventario de Inmuebles</h3>
            <p class="text-muted mb-0">Listado de propiedades asignadas a tu inmobiliaria con soporte para baja lógica</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/agente/crear-propiedad" class="btn btn-primary rounded-pill btn-sm px-3">
                <i class="bi bi-plus-lg me-1"></i> Publicar Nueva Propiedad
            </a>
        </div>
    </div>

    <div class="table-responsive-custom">
        <table class="table table-hover align-middle mb-0">
            <thead>
                <tr>
                    <th>Inmueble</th>
                    <th>Matrícula Inmobiliaria</th>
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
                        <td>
                            <div class="d-flex align-items-center gap-3">
                                <img src="${p.imagenPrincipalUrl}" alt="" class="rounded-3 object-fit-cover" style="width: 50px; height: 50px;"
                                     onerror="this.src='https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800'">
                                <div>
                                    <h6 class="fw-bold mb-0">${p.titulo}</h6>
                                    <small class="text-muted">${p.tipoPropiedadNombre} &bull; ${p.habitaciones} Hab. &bull; ${p.areaM2} m²</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <code class="fw-bold">${p.matriculaInmobiliaria}</code>
                        </td>
                        <td>
                            <span class="badge ${p.tipoOperacion == 'VENTA' ? 'bg-primary-subtle text-primary' : 'bg-success-subtle text-success'}">
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
                                    <span class="badge bg-success">Disponible</span>
                                </c:when>
                                <c:when test="${p.estado == 'RESERVADA'}">
                                    <span class="badge bg-warning text-dark">Reservada</span>
                                </c:when>
                                <c:when test="${p.estado == 'VENDIDA'}">
                                    <span class="badge bg-info text-dark">Vendida</span>
                                </c:when>
                                <c:when test="${p.estado == 'ARRENDADA'}">
                                    <span class="badge bg-primary">Arrendada</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Inactiva (Baja Lógica)</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/propiedad?id=${p.id}" target="_blank" class="btn btn-outline-secondary btn-sm" title="Ver ficha pública">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/agente/editar-propiedad?id=${p.id}" class="btn btn-outline-primary btn-sm" title="Editar datos">
                                    <i class="bi bi-pencil-fill"></i>
                                </a>
                                <c:if test="${p.estado != 'INACTIVA'}">
                                    <form action="${pageContext.request.contextPath}/agente/baja-propiedad" method="POST" class="d-inline" onsubmit="return confirmarAccion('¿Confirma que desea dar de baja lógica este inmueble? Cambiará a estado INACTIVA conservando el historial de citas y trámites.');">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <button type="submit" class="btn btn-outline-danger btn-sm" title="Baja lógica">
                                            <i class="bi bi-slash-circle"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
