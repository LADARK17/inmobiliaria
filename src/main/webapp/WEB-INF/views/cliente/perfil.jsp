<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Mi Perfil" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">
                <div class="d-flex align-items-center gap-3 mb-4 border-bottom pb-3">
                    <img src="${not empty perfil.fotoUrl ? perfil.fotoUrl : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'}" 
                         alt="Avatar" class="rounded-circle object-fit-cover shadow-sm" style="width: 70px; height: 70px;">
                    <div>
                        <h4 class="fw-bold mb-0">${perfil.nombreCompleto}</h4>
                        <span class="badge bg-primary-subtle text-primary">Relación 1:1 (Usuario - Perfil)</span>
                        <p class="text-muted small mb-0 mt-1">Cuenta: ${sessionScope.correo_usuario}</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/cliente/perfil" method="POST" class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Nombres *</label>
                        <input type="text" name="nombres" class="form-control" required value="${perfil.nombres}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Apellidos *</label>
                        <input type="text" name="apellidos" class="form-control" required value="${perfil.apellidos}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Documento de Identidad (Cédula) *</label>
                        <input type="text" name="documento" class="form-control" required value="${perfil.documentoIdentidad}">
                        <div class="form-text small">Restricción UNIQUE para integridad 1:1.</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Teléfono / Celular</label>
                        <input type="tel" name="telefono" class="form-control" value="${perfil.telefono}">
                    </div>
                    <div class="col-12">
                        <label class="form-label small fw-semibold">Dirección de Residencia</label>
                        <input type="text" name="direccion" class="form-control" value="${perfil.direccion}">
                    </div>
                    <div class="col-12">
                        <label class="form-label small fw-semibold">URL Fotografía de Perfil</label>
                        <input type="url" name="fotoUrl" class="form-control" value="${perfil.fotoUrl}" placeholder="https://images.unsplash.com/...">
                    </div>

                    <div class="col-12 mt-4 text-end">
                        <a href="${pageContext.request.contextPath}/cliente/dashboard" class="btn btn-light rounded-pill px-4 me-2">Cancelar</a>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">
                            <i class="bi bi-save me-1"></i> Guardar Cambios
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
