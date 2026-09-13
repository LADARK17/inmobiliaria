<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Iniciar Sesión" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5 py-4">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="bg-primary-subtle text-primary stat-icon mx-auto mb-3 rounded-circle" style="width: 60px; height: 60px;">
                        <i class="bi bi-person-lock fs-2"></i>
                    </div>
                    <h3 class="fw-bold text-dark">Bienvenido</h3>
                    <p class="text-muted small">Ingrese sus credenciales de acceso</p>
                </div>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Correo Electrónico *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="correo" class="form-control" required placeholder="ejemplo@inmobiliaria.com" value="${correoPrevio}">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-semibold">Contraseña *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-key"></i></span>
                            <input type="password" name="password" class="form-control" required placeholder="Contraseña">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-semibold mb-3">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar Sesión
                    </button>

                    <div class="text-center small text-muted">
                        ¿Aún no tienes cuenta? 
                        <a href="${pageContext.request.contextPath}/registro" class="text-primary fw-semibold text-decoration-none">
                            Regístrate aquí
                        </a>
                    </div>
                </form>

                <!-- Credenciales demo pedagógicas -->
                <div class="mt-4 pt-3 border-top text-start">
                    <span class="badge bg-secondary mb-2">Cuentas de Demostración:</span>
                    <ul class="list-unstyled small text-muted mb-0" style="font-size: 0.78rem;">
                        <li><strong>Admin:</strong> <code>admin@inmobiliaria.com</code> / <code>123456</code></li>
                        <li><strong>Agente:</strong> <code>agente.carlos@santander.com</code> / <code>123456</code></li>
                        <li><strong>Cliente:</strong> <code>cliente.juan@gmail.com</code> / <code>123456</code></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
