<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Gestión de Usuarios y Roles" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="bi bi-people-fill text-primary me-2"></i>Gestión de Usuarios y Roles (N:M)</h3>
            <p class="text-muted mb-0">Control de activación de cuentas y administración de la relación muchos a muchos con roles</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm rounded-pill">
            <i class="bi bi-arrow-left me-1"></i> Volver al Dashboard
        </a>
    </div>

    <div class="table-responsive-custom">
        <table class="table table-hover align-middle mb-0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Usuario / Perfil (1:1)</th>
                    <th>Documento</th>
                    <th>Teléfono</th>
                    <th>Estado de Cuenta</th>
                    <th>Roles Asignados (N:M)</th>
                    <th class="text-end">Operaciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${usuarios}">
                    <tr>
                        <td><strong>#${u.id}</strong></td>
                        <td>
                            <span class="fw-bold text-dark d-block">
                                ${not empty u.perfil ? u.perfil.nombreCompleto : 'Perfil Pendiente'}
                            </span>
                            <small class="text-muted"><i class="bi bi-envelope me-1"></i>${u.correo}</small>
                        </td>
                        <td>
                            <code class="small">${not empty u.perfil ? u.perfil.documentoIdentidad : 'N/A'}</code>
                        </td>
                        <td>
                            <span class="small">${not empty u.perfil ? u.perfil.telefono : 'N/A'}</span>
                        </td>
                        <td>
                            <span class="badge ${u.estado == 'ACTIVO' ? 'bg-success' : 'bg-danger'} rounded-pill px-3 py-2">
                                ${u.estado}
                            </span>
                        </td>
                        <td>
                            <div class="d-flex flex-wrap gap-1 align-items-center">
                                <c:forEach var="r" items="${u.roles}">
                                    <span class="badge bg-primary d-inline-flex align-items-center gap-1">
                                        ${r.nombre}
                                        <!-- Revocar rol si tiene más de 1 rol o no es el único admin -->
                                        <form action="${pageContext.request.contextPath}/admin/remover-rol" method="POST" class="d-inline" onsubmit="return confirmarAccion('¿Desea revocar este rol al usuario?');">
                                            <input type="hidden" name="idUsuario" value="${u.id}">
                                            <input type="hidden" name="idRol" value="${r.id}">
                                            <button type="submit" class="btn btn-link p-0 text-white text-decoration-none" style="font-size: 0.75rem;" title="Revocar rol">
                                                <i class="bi bi-x-circle-fill"></i>
                                            </button>
                                        </form>
                                    </span>
                                </c:forEach>
                            </div>
                        </td>
                        <td class="text-end">
                            <div class="d-inline-flex gap-2">
                                <!-- Asignar Nuevo Rol Modal Trigger -->
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#modalRol_${u.id}" title="Asignar nuevo rol">
                                    <i class="bi bi-person-gear"></i> Rol
                                </button>

                                <!-- Activar / Inactivar Cuenta -->
                                <form action="${pageContext.request.contextPath}/admin/cambiar-estado-usuario" method="POST" class="d-inline">
                                    <input type="hidden" name="idUsuario" value="${u.id}">
                                    <c:choose>
                                        <c:when test="${u.estado == 'ACTIVO'}">
                                            <input type="hidden" name="nuevoEstado" value="INACTIVO">
                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill" title="Bloquear o inactivar cuenta">
                                                <i class="bi bi-slash-circle"></i> Inactivar
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="nuevoEstado" value="ACTIVO">
                                            <button type="submit" class="btn btn-outline-success btn-sm rounded-pill" title="Reactivar cuenta">
                                                <i class="bi bi-check-circle"></i> Activar
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                            </div>
                        </td>
                    </tr>

                    <!-- MODAL PARA ASIGNAR ROL (N:M) -->
                    <div class="modal fade" id="modalRol_${u.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content rounded-4 border-0 shadow">
                                <form action="${pageContext.request.contextPath}/admin/asignar-rol" method="POST">
                                    <input type="hidden" name="idUsuario" value="${u.id}">
                                    <div class="modal-header border-0 pb-0">
                                        <h5 class="modal-title fw-bold">
                                            <i class="bi bi-person-plus text-primary me-2"></i>Asignar Rol a ${u.correo}
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p class="small text-muted mb-3">
                                            Seleccione el rol que desea añadir. El sistema utiliza una llave compuesta en la tabla <code>usuario_rol</code> para evitar duplicidades.
                                        </p>
                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold">Seleccionar Rol *</label>
                                            <select name="idRol" class="form-select" required>
                                                <c:forEach var="rolDisp" items="${rolesDisponibles}">
                                                    <option value="${rolDisp.id}">${rolDisp.nombre} - ${rolDisp.descripcion}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer border-0 pt-0">
                                        <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">Asignar Rol</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
