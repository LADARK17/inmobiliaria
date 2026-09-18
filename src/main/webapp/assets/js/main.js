// Scripts generales y microinteracciones de InmoGest

document.addEventListener('DOMContentLoaded', () => {
    // 1. Inicializar tooltips de Bootstrap
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    // 2. Desvanecer alertas automáticamente después de 5 segundos
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // 3. Efecto dinámico de Navbar al hacer scroll
    const navbar = document.querySelector('.navbar-custom');
    if (navbar) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 20) {
                navbar.classList.add('shadow-sm');
                navbar.style.background = 'rgba(255, 255, 255, 0.96)';
            } else {
                navbar.classList.remove('shadow-sm');
                navbar.style.background = 'rgba(255, 255, 255, 0.88)';
            }
        });
    }
});

// Función de confirmación para baja lógica o acciones irreversibles
function confirmarAccion(mensaje) {
    return confirm(mensaje || '¿Está seguro de que desea realizar esta acción?');
}

// Función global para autocompletar credenciales demo
function fillCredentials(correo, pass) {
    const correoInput = document.getElementById('correoInput');
    const passwordInput = document.getElementById('passwordInput');
    if (correoInput && passwordInput) {
        correoInput.value = correo;
        passwordInput.value = pass;
        correoInput.classList.add('is-valid');
        passwordInput.classList.add('is-valid');
    }
}
