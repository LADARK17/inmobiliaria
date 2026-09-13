<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Gestión de Citas - Agente" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-calendar2-check-fill text-primary me-2"></i>Gestión de Citas de Visitas</h3>
            <p class="text-muted mb-0">Confirma, reprograma o finaliza los recorridos solicitados por los clientes</p>
        </div>
    </div>

    <div class="table-responsive-custom">
        <table class="table table-hover align-middle mb-0">
            <thead>
                <tr>
                    <th>Inmueble</th>
                    <th>Cliente Solicitante</th>
                    <th>Fecha y Hora</th>
                    <th>Comentarios</th>
                    <th>Estado Actual</th>
                    <th class="text-end">Acciones del Agente</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${citas}">
                    <tr>
                        <td>
                            <h6 class="fw-bold mb-0">${c.propiedadTitulo}</h6>
                            <code class="small">${c.propiedadMatricula}</code>
                        </td>
                        <td>
                            <span class="fw-semibold text-dark d-block">${c.clienteNombre}</span>
                            <small class="text-muted"><i class="bi bi-telephone me-1"></i>${c.clienteTelefono}</small>
                            <small class="text-muted d-block"><i class="bi bi-envelope me-1"></i>${c.clienteCorreo}</small>
                        </td>
                        <td>
                            <span class="fw-bold text-primary"><i class="bi bi-clock me-1"></i>${c.fechaHora}</span>
                        </td>
                        <td>
                            <span class="small text-muted">${not empty c.comentarios ? c.comentarios : 'Sin comentarios'}</span>
                        </td>
                        <td>
                            <span class="badge ${c.estado == 'CONFIRMADA' ? 'bg-success' : (c.estado == 'PENDIENTE' ? 'bg-warning text-dark' : (c.estado == 'REALIZADA' ? 'bg-info text-dark' : 'bg-danger'))} rounded-pill px-3 py-2">
                                ${c.estado}
                            </span>
                        </td>
                        <td class="text-end">
                            <form action="${pageContext.request.contextPath}/agente/citas" method="POST" class="d-inline-flex gap-1 justify-content-end">
                                <input type="hidden" name="idCita" value="${c.id}">
                                <c:if test="${c.estado == 'PENDIENTE'}">
                                    <button type="submit" name="nuevoEstado" value="CONFIRMADA" class="btn btn-success btn-sm rounded-pill" title="Confirmar cita">
                                        <i class="bi bi-check-lg"></i> Confirmar
                                    </button>
                                    <button type="submit" name="nuevoEstado" value="CANCELADA" class="btn btn-outline-danger btn-sm rounded-pill" title="Rechazar cita">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </c:if>
                                <c:if test="${c.estado == 'CONFIRMADA'}">
                                    <button type="submit" name="nuevoEstado" value="REALIZADA" class="btn btn-primary btn-sm rounded-pill" title="Marcar como realizada">
                                        <i class="bi bi-check2-all"></i> Realizada
                                    </button>
                                    <button type="submit" name="nuevoEstado" value="CANCELADA" class="btn btn-outline-danger btn-sm rounded-pill" title="Cancelar">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </c:if>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
