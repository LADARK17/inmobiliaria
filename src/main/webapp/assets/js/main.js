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

// Agendamiento de citas por turno único: bloquea fechas pasadas y turnos ya ocupados
const inputFechaCita = document.getElementById('inputFechaCita');
if (inputFechaCita) {
    const feedback = document.getElementById('feedbackCitaTurno');
    const ocupados = Array.isArray(window.TURNOS_OCUPADOS) ? window.TURNOS_OCUPADOS : [];

    const aMinutos = (v) => (v ? String(v).slice(0, 16) : null);
    const formatoLocal = (d) => {
        const pad = (n) => String(n).padStart(2, '0');
        return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) +
               'T' + pad(d.getHours()) + ':' + pad(d.getMinutes());
    };

    const minimo = new Date(Date.now() + 60 * 60 * 1000);
    inputFechaCita.min = formatoLocal(minimo);

    const validar = () => {
        const sel = aMinutos(inputFechaCita.value);
        let mensaje = '';
        if (!sel) {
            inputFechaCita.classList.remove('is-valid');
            inputFechaCita.classList.remove('is-invalid');
            if (feedback) feedback.textContent = '';
            return;
        }
        if (ocupados.includes(sel)) {
            mensaje = 'Este horario ya está reservado por otro cliente. Elija otro turno.';
            inputFechaCita.classList.add('is-invalid');
            inputFechaCita.classList.remove('is-valid');
        } else if (sel < formatoLocal(minimo)) {
            mensaje = 'La visita debe agendarse al menos 1 hora después del momento actual.';
            inputFechaCita.classList.add('is-invalid');
            inputFechaCita.classList.remove('is-valid');
        } else {
            inputFechaCita.classList.remove('is-invalid');
            inputFechaCita.classList.add('is-valid');
        }
        if (feedback) feedback.textContent = mensaje;
    };

    inputFechaCita.addEventListener('input', validar);
    document.getElementById('modalCita').addEventListener('shown.bs.modal', validar);

    const formCita = document.querySelector('#modalCita form');
    if (formCita) {
        formCita.addEventListener('submit', (e) => {
            const sel = aMinutos(inputFechaCita.value);
            if (!sel || ocupados.includes(sel) || sel < formatoLocal(minimo)) {
                e.preventDefault();
                validar();
            }
        });
    }
}
