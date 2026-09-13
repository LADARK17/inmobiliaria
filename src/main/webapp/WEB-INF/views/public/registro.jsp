<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Registro de Nuevo Usuario" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5 py-3">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="bg-primary-subtle text-primary stat-icon mx-auto mb-3 rounded-circle" style="width: 60px; height: 60px;">
                        <i class="bi bi-person-plus-fill fs-2"></i>
                    </div>
                    <h3 class="fw-bold text-dark">Crear Cuenta de Cliente</h3>
                    <p class="text-muted small">Regístrese para agendar citas, guardar favoritos y radicar solicitudes</p>
                </div>

                <form action="${pageContext.request.contextPath}/registro" method="POST" class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Nombres *</label>
                        <input type="text" name="nombres" class="form-control" required value="${nombres}" placeholder="Ej: Juan David">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Apellidos *</label>
                        <input type="text" name="apellidos" class="form-control" required value="${apellidos}" placeholder="Ej: Pérez Moreno">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Documento de Identidad (C.C. / C.E.) *</label>
                        <input type="text" name="documento" class="form-control" required value="${documento}" placeholder="Ej: 1098765432">
                        <div class="form-text small">Restricción UNIQUE para garantizar relación 1:1.</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Teléfono de Contacto</label>
                        <input type="tel" name="telefono" class="form-control" value="${telefono}" placeholder="Ej: 3157890000">
                    </div>

                    <div class="col-12">
                        <label class="form-label small fw-semibold">Dirección de Residencia</label>
                        <input type="text" name="direccion" class="form-control" value="${direccion}" placeholder="Ej: Calle 35 # 28-14, Bucaramanga">
                    </div>

                    <div class="col-12">
                        <label class="form-label small fw-semibold">Correo Electrónico (Credencial Principal) *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="correo" class="form-control" required value="${correo}" placeholder="ejemplo@correo.com">
                        </div>
                        <div class="form-text small">El correo es único en el sistema (restricción UNIQUE).</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Contraseña *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                            <input type="password" name="password" class="form-control" required placeholder="Mínimo 6 caracteres">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Confirmar Contraseña *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-shield-check"></i></span>
                            <input type="password" name="confirmPassword" class="form-control" required placeholder="Repita la contraseña">
                        </div>
                    </div>

                    <div class="col-12 mt-4">
                        <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> Completar Registro
                        </button>
                    </div>

                    <div class="col-12 text-center small text-muted mt-3">
                        ¿Ya tienes una cuenta registrada? 
                        <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold text-decoration-none">
                            Inicia sesión aquí
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
