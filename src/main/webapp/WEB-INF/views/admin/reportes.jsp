<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Reportes SQL y Analítica Gerencial" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-graph-up-arrow text-primary me-2"></i>Reportes Gerenciales Basados en SQL</h3>
            <p class="text-muted mb-0">Demostración académica de agregaciones SQL: <code>GROUP BY + HAVING</code>, <code>LEFT JOIN</code> y funciones estadísticas</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm rounded-pill">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <!-- REPORTE 1: GROUP BY + HAVING (CONSULTA 5 OBLIGATORIA) -->
    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <span class="badge bg-primary mb-1">Consulta Pedagógica 5</span>
                <h5 class="fw-bold mb-0">Inmuebles en Venta por Ciudad y Análisis de Precios (GROUP BY + HAVING)</h5>
                <small class="text-muted">Filtra ciudades con conteo &ge; 1 inmuebles y calcula promedio, mínimo y máximo directamente en MySQL.</small>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Ciudad</th>
                        <th>Departamento</th>
                        <th class="text-center">Total Inmuebles en Venta</th>
                        <th>Precio Promedio (AVG)</th>
                        <th>Precio Mínimo (MIN)</th>
                        <th>Precio Máximo (MAX)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="fila" items="${reporteCiudades}">
                        <tr>
                            <td><strong>${fila.ciudad}</strong></td>
                            <td>${fila.departamento}</td>
                            <td class="text-center">
                                <span class="badge bg-primary rounded-pill px-3 py-2">${fila.total_inmuebles}</span>
                            </td>
                            <td class="fw-bold text-success">
                                <fmt:formatNumber value="${fila.precio_promedio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                            </td>
                            <td>
                                <fmt:formatNumber value="${fila.precio_minimo}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                            </td>
                            <td>
                                <fmt:formatNumber value="${fila.precio_maximo}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- REPORTE 2: LEFT JOIN (CONSULTA 4 OBLIGATORIA) -->
    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <span class="badge bg-warning text-dark mb-1">Consulta Pedagógica 4</span>
                <h5 class="fw-bold mb-0">Inmuebles Disponibles sin Ninguna Cita de Visita Registrada (LEFT JOIN)</h5>
                <small class="text-muted">Identifica propiedades mediante <code>LEFT JOIN cita cit ON p.id = cit.id_propiedad WHERE cit.id IS NULL</code>.</small>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle small mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Matrícula</th>
                        <th>Título de Propiedad</th>
                        <th>Ciudad</th>
                        <th>Inmobiliaria</th>
                        <th>Operación</th>
                        <th>Precio</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="prop" items="${propiedadesSinCitas}">
                        <tr>
                            <td><code>${prop.matricula}</code></td>
                            <td><strong>${prop.titulo}</strong></td>
                            <td>${prop.ciudad}</td>
                            <td>${prop.inmobiliaria}</td>
                            <td><span class="badge bg-secondary">${prop.tipo_operacion}</span></td>
                            <td class="fw-bold text-primary">
                                <fmt:formatNumber value="${prop.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- REPORTES AGREGADOS ADICIONALES: CITAS Y SOLICITUDES -->
    <div class="row g-4">
        <!-- Citas por Estado -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                <h5 class="fw-bold mb-3"><i class="bi bi-pie-chart-fill text-info me-2"></i>Citas por Estado</h5>
                <div class="list-group list-group-flush">
                    <c:forEach var="entry" items="${citasPorEstado}">
                        <div class="list-group-item px-0 py-3 d-flex justify-content-between align-items-center">
                            <span class="fw-semibold">${entry.key}</span>
                            <span class="badge bg-primary rounded-pill fs-6 px-3">${entry.value} citas</span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Solicitudes por Inmobiliaria -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                <h5 class="fw-bold mb-3"><i class="bi bi-buildings-fill text-success me-2"></i>Trámites por Agencia</h5>
                <div class="table-responsive">
                    <table class="table table-hover align-middle small mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Inmobiliaria</th>
                                <th class="text-center">Total</th>
                                <th class="text-center text-success">Aprobadas</th>
                                <th class="text-center text-warning">Pendientes</th>
                                <th class="text-center text-danger">Rechazadas</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inm" items="${solicitudesPorInmobiliaria}">
                                <tr>
                                    <td><strong>${inm.inmobiliaria}</strong></td>
                                    <td class="text-center"><span class="badge bg-dark">${inm.total_solicitudes}</span></td>
                                    <td class="text-center text-success fw-bold">${inm.aprobadas}</td>
                                    <td class="text-center text-warning fw-bold">${inm.pendientes}</td>
                                    <td class="text-center text-danger fw-bold">${inm.rechazadas}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
