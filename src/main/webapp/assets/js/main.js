// Scripts generales de la aplicación inmobiliaria

document.addEventListener('DOMContentLoaded', () => {
    // Inicializar tooltips de Bootstrap
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    // Desvanecer alertas automáticamente después de 5 segundos
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});

// Función de confirmación para baja lógica o acciones irreversibles
function confirmarAccion(mensaje) {
    return confirm(mensaje || '¿Está seguro de que desea realizar esta acción?');
}
