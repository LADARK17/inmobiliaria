<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Iniciar Sesión" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-5 py-4">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-5">
            <div class="auth-card mx-auto">
                <div class="text-center mb-4">
                    <div class="brand-icon-box mx-auto mb-3" style="width: 56px; height: 56px; font-size: 1.75rem; border-radius: 16px;">
                        <i class="bi bi-person-lock"></i>
                    </div>
                    <h3 class="fw-bold text-dark mb-1">Bienvenido a Hábitat Prime</h3>
                    <p class="text-muted small">Ingresa tus credenciales para acceder a tu panel de control</p>
                </div>

                <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Correo Electrónico *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="correo" id="correoInput" class="form-control border-start-0" required placeholder="correo@ejemplo.com" value="${correoPrevio}">
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label class="form-label small fw-semibold mb-0">Contraseña *</label>
                        </div>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-key"></i></span>
                            <input type="password" name="password" id="passwordInput" class="form-control border-start-0 border-end-0" required placeholder="••••••••">
                            <button class="btn btn-outline-secondary border-start-0 bg-light text-muted" type="button" onclick="togglePasswordVisibility()">
                                <i class="bi bi-eye" id="toggleIcon"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-semibold shadow-sm mb-3">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar Sesión
                    </button>

                    <div class="text-center small text-muted">
                        ¿Aún no tienes cuenta? 
                        <a href="${pageContext.request.contextPath}/registro" class="text-primary fw-bold text-decoration-none ms-1">
                            Regístrate aquí
                        </a>
                    </div>
                </form>

                <!-- Credenciales demo con botón de autocompletado en un clic -->
                <div class="demo-credentials-box">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="fw-bold small text-dark"><i class="bi bi-magic text-warning me-1"></i>Acceso Rápido Demo</span>
                        <span class="text-muted small" style="font-size: 0.72rem;">Clic para autocompletar</span>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <button type="button" class="demo-pill-btn" onclick="fillCredentials('admin@inmobiliaria.com', '123456')">
                            <span class="badge badge-role-admin rounded-pill">Admin</span>
                            <span>Admin General</span>
                        </button>
                        <button type="button" class="demo-pill-btn" onclick="fillCredentials('agente.carlos@santander.com', '123456')">
                            <span class="badge badge-role-agent rounded-pill">Agente</span>
                            <span>Carlos Agente</span>
                        </button>
                        <button type="button" class="demo-pill-btn" onclick="fillCredentials('cliente.juan@gmail.com', '123456')">
                            <span class="badge badge-role-client rounded-pill">Cliente</span>
                            <span>Juan Cliente</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function fillCredentials(correo, pass) {
    document.getElementById('correoInput').value = correo;
    document.getElementById('passwordInput').value = pass;
}

function togglePasswordVisibility() {
    const input = document.getElementById('passwordInput');
    const icon = document.getElementById('toggleIcon');
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('bi-eye');
        icon.classList.add('bi-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.remove('bi-eye-slash');
        icon.classList.add('bi-eye');
    }
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>
