<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${esEdicion ? 'Actualizar Inmueble' : 'Subir Nuevo Inmueble'}" />
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<%@ include file="/WEB-INF/views/common/navbar.jspf" %>
<%@ include file="/WEB-INF/views/common/alerts.jspf" %>

<main class="container my-4 my-lg-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">
                <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                    <div>
                        <h3 class="fw-bold text-dark mb-1">${esEdicion ? 'Actualizar Inmueble del Catálogo' : 'Subir Nuevo Inmueble al Catálogo'}</h3>
                        <p class="text-muted small mb-0">Ingrese los datos requeridos del inmueble. La matrícula inmobiliaria debe ser única.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/propiedades" class="btn btn-outline-secondary btn-sm rounded-pill">
                        <i class="bi bi-arrow-left me-1"></i> Volver al Catálogo
                    </a>
                </div>

                <form action="${pageContext.request.contextPath}/admin/${esEdicion ? 'editar-propiedad' : 'crear-propiedad'}" method="POST" class="row g-3" id="formPropiedad">
                    <c:if test="${esEdicion}">
                        <input type="hidden" name="id" value="${propiedad.id}">
                    </c:if>

                    <!-- Inmobiliaria (Solo Admin) -->
                    <div class="col-12 border-bottom pb-3">
                        <label class="form-label small fw-semibold">Inmobiliaria Propietaria de la Publicación *</label>
                        <select name="idInmobiliaria" class="form-select" required>
                            <c:forEach var="inm" items="${inmobiliarias}">
                                <option value="${inm.id}" ${(not empty propiedad && propiedad.idInmobiliaria == inm.id) ? 'selected' : ''}>${inm.nombre} (${inm.correo})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Título -->
                    <div class="col-md-8">
                        <label class="form-label small fw-semibold">Título de la Publicación *</label>
                        <input type="text" name="titulo" class="form-control" required value="${propiedad.titulo}" placeholder="Ej: Espectacular Apartamento en Cabecera del Llano">
                    </div>

                    <!-- Matrícula Inmobiliaria (UNIQUE) -->
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Matrícula Inmobiliaria *</label>
                        <input type="text" name="matriculaInmobiliaria" class="form-control" required value="${propiedad.matriculaInmobiliaria}" placeholder="Ej: MAT-BGA-00999">
                        <div class="form-text small text-muted">Restricción UNIQUE obligatoria.</div>
                    </div>

                    <!-- Ciudad y Tipo de Inmueble -->
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Ciudad de Ubicación *</label>
                        <select name="idCiudad" class="form-select" required>
                            <c:forEach var="c" items="${ciudades}">
                                <option value="${c.id}" ${not empty propiedad && propiedad.idCiudad == c.id ? 'selected' : ''}>${c.nombre} (${c.departamento})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Tipo de Propiedad *</label>
                        <select name="idTipoPropiedad" class="form-select" required>
                            <c:forEach var="t" items="${tipos}">
                                <option value="${t.id}" ${not empty propiedad && propiedad.idTipoPropiedad == t.id ? 'selected' : ''}>${t.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Precio y Operación -->
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Precio en Pesos (COP) *</label>
                        <input type="number" step="1000" name="precio" class="form-control" required value="${propiedad.precio}" placeholder="Ej: 350000000">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Tipo de Operación *</label>
                        <select name="tipoOperacion" class="form-select" required>
                            <option value="VENTA" ${propiedad.tipoOperacion == 'VENTA' ? 'selected' : ''}>VENTA</option>
                            <option value="ARRIENDO" ${propiedad.tipoOperacion == 'ARRIENDO' ? 'selected' : ''}>ARRIENDO</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Estado del Inmueble</label>
                        <select name="estado" class="form-select">
                            <option value="DISPONIBLE" ${propiedad.estado == 'DISPONIBLE' ? 'selected' : ''}>DISPONIBLE</option>
                            <option value="RESERVADA" ${propiedad.estado == 'RESERVADA' ? 'selected' : ''}>RESERVADA</option>
                            <option value="VENDIDA" ${propiedad.estado == 'VENDIDA' ? 'selected' : ''}>VENDIDA</option>
                            <option value="ARRENDADA" ${propiedad.estado == 'ARRENDADA' ? 'selected' : ''}>ARRENDADA</option>
                            <option value="INACTIVA" ${propiedad.estado == 'INACTIVA' ? 'selected' : ''}>INACTIVA (Fuera de Catálogo)</option>
                        </select>
                    </div>

                    <!-- Especificaciones Físicas -->
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Área Construida (m²)</label>
                        <input type="number" step="0.1" name="areaM2" class="form-control" value="${not empty propiedad.areaM2 ? propiedad.areaM2 : 0}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Habitaciones</label>
                        <input type="number" name="habitaciones" class="form-control" value="${not empty propiedad.habitaciones ? propiedad.habitaciones : 0}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Baños</label>
                        <input type="number" name="banos" class="form-control" value="${not empty propiedad.banos ? propiedad.banos : 0}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Estrato Socioeconómico</label>
                        <input type="number" name="estrato" class="form-control" value="${not empty propiedad.estrato ? propiedad.estrato : 3}" min="1" max="6">
                    </div>

                    <!-- Dirección -->
                    <div class="col-12">
                        <label class="form-label small fw-semibold">Dirección Exacta del Inmueble *</label>
                        <input type="text" name="direccion" class="form-control" required value="${propiedad.direccion}" placeholder="Ej: Carrera 35 # 48-22 Apto 1204">
                    </div>

                    <!-- Descripción -->
                    <div class="col-12">
                        <label class="form-label small fw-semibold">Descripción Detallada *</label>
                        <textarea name="descripcion" class="form-control" rows="4" required placeholder="Describa la distribución, acabados, vistas y amenidades...">${propiedad.descripcion}</textarea>
                    </div>

                    <!-- Características (Relación N:M) -->
                    <div class="col-12 border-top pt-3">
                        <label class="form-label small fw-bold text-uppercase text-muted">Características del Inmueble (Relación N:M)</label>
                        <div class="row g-2">
                            <c:forEach var="car" items="${caracteristicas}">
                                <div class="col-md-4 col-sm-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="caracteristicas" value="${car.id}" id="fc_${car.id}"
                                            <c:forEach var="pCar" items="${propiedad.caracteristicas}">
                                                <c:if test="${pCar.id == car.id}">checked</c:if>
                                            </c:forEach>
                                        >
                                        <label class="form-check-label small" for="fc_${car.id}">
                                            <i class="bi ${car.icono} text-primary me-1"></i>${car.nombre}
                                        </label>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- ============================================================== -->
                    <!-- GALERÍA DE FOTOGRAFÍAS (RELACIÓN 1:N) CON CARGA DIRECTA A NUBE -->
                    <!-- ============================================================== -->
                    <div class="col-12 border-top pt-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div>
                                <label class="form-label fw-bold text-dark mb-0">
                                    <i class="bi bi-images text-primary me-1"></i> Fotografías del Inmueble (1:N)
                                </label>
                                <p class="small text-muted mb-0">
                                    Sube las fotos directamente desde tu equipo. Se almacenan de forma permanente en la nube y se genera automáticamente su enlace público. La primera imagen será la portada principal.
                                </p>
                            </div>
                        </div>

                        <!-- Zona de Carga Directa (Dropzone) -->
                        <div class="p-4 border border-2 border-dashed rounded-4 bg-light text-center my-3" id="dropZoneFotos" style="border-color: #cbd5e1 !important;">
                            <div class="brand-icon-box mx-auto mb-3" style="width: 50px; height: 50px; font-size: 1.5rem; border-radius: 14px;">
                                <i class="bi bi-cloud-arrow-up-fill"></i>
                            </div>
                            <h6 class="fw-bold text-dark mb-1">Selecciona o arrastra las fotos del inmueble</h6>
                            <p class="text-muted small mb-3">Formatos compatibles: JPG, PNG, WebP (hasta 15 MB por foto)</p>

                            <input type="file" id="inputFotosArchivo" accept="image/jpeg,image/png,image/webp,image/jpg" multiple class="d-none" onchange="procesarArchivosFotos(this.files)">
                            <button type="button" class="btn btn-primary rounded-pill px-4 shadow-sm" onclick="document.getElementById('inputFotosArchivo').click()">
                                <i class="bi bi-folder2-open me-2"></i> Seleccionar Fotos desde tu Dispositivo
                            </button>

                            <!-- Barra de progreso durante la subida -->
                            <div id="uploadStatusBox" class="alert alert-info py-2 px-3 small d-none align-items-center justify-content-center gap-2 mt-3 mb-0 mx-auto" style="max-width: 460px;">
                                <div class="spinner-border spinner-border-sm text-primary" role="status"></div>
                                <span id="uploadStatusText">Subiendo fotografía al almacenamiento seguro en la nube...</span>
                            </div>
                        </div>

                        <!-- Cuadrícula de fotos cargadas (Previsualización en tiempo real) -->
                        <div class="mb-3">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="small fw-semibold text-secondary" id="totalFotosLabel">0 fotografías cargadas</span>
                                <button type="button" class="btn btn-link text-decoration-none btn-sm text-muted p-0" onclick="toggleManualUrlInput()">
                                    <i class="bi bi-link-45deg"></i> O agregar por enlace directo
                                </button>
                            </div>

                            <!-- Input opcional para pegar URL directa -->
                            <div id="manualUrlBox" class="d-none mb-3 p-3 bg-white border rounded-3">
                                <label class="form-label small fw-semibold">Ingresar enlace de imagen externa:</label>
                                <div class="input-group">
                                    <input type="url" id="manualUrlInput" class="form-control form-control-sm" placeholder="https://images.unsplash.com/photo-...">
                                    <button class="btn btn-outline-primary btn-sm" type="button" onclick="agregarUrlManual()">
                                        <i class="bi bi-plus-lg me-1"></i> Agregar Enlace
                                    </button>
                                </div>
                            </div>

                            <!-- Contenedor dinámico de miniaturas de fotos -->
                            <div class="row g-3" id="contenedorPreviewFotos">
                                <!-- Se renderiza mediante JavaScript -->
                            </div>
                        </div>

                        <!-- Textarea oculto/sincronizado con las URLs finales para el envío en BD -->
                        <textarea name="imagenesUrls" id="imagenesUrlsTextarea" class="form-control d-none"></textarea>
                    </div>

                    <!-- Destacada Checkbox -->
                    <div class="col-12 border-top pt-3">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="destacada" id="swDestacada" ${propiedad.destacada ? 'checked' : ''}>
                            <label class="form-check-label small fw-semibold" for="swDestacada">Marcar como Propiedad Destacada en la Landing Page</label>
                        </div>
                    </div>

                    <div class="col-12 text-end border-top pt-4">
                        <a href="${pageContext.request.contextPath}/admin/propiedades" class="btn btn-light rounded-pill px-4 me-2">Cancelar</a>
                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-semibold shadow-sm">
                            <i class="bi bi-check2-circle me-1"></i> ${esEdicion ? 'Actualizar Inmueble' : 'Subir Inmueble al Catálogo'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
let fotosGaleria = [];

<c:if test="${esEdicion && not empty propiedad.imagenes}">
    <c:forEach var="img" items="${propiedad.imagenes}">
        fotosGaleria.push('${img.urlImagen}');
    </c:forEach>
</c:if>

document.addEventListener('DOMContentLoaded', () => {
    actualizarVistaFotos();

    const dropZone = document.getElementById('dropZoneFotos');
    if (dropZone) {
        ['dragenter', 'dragover'].forEach(eventName => {
            dropZone.addEventListener(eventName, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropZone.classList.add('bg-white');
            }, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropZone.addEventListener(eventName, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropZone.classList.remove('bg-white');
            }, false);
        });

        dropZone.addEventListener('drop', (e) => {
            const dt = e.dataTransfer;
            const files = dt.files;
            if (files && files.length > 0) {
                procesarArchivosFotos(files);
            }
        }, false);
    }
});

async function procesarArchivosFotos(fileList) {
    if (!fileList || fileList.length === 0) return;

    const statusBox = document.getElementById('uploadStatusBox');
    const statusText = document.getElementById('uploadStatusText');
    statusBox.classList.remove('d-none');
    statusBox.classList.add('d-flex');

    const total = fileList.length;
    let subidas = 0;

    for (let i = 0; i < total; i++) {
        const file = fileList[i];
        statusText.innerText = 'Subiendo fotografía ' + (i + 1) + ' de ' + total + ' al almacenamiento seguro en la nube...';

        const formData = new FormData();
        formData.append('foto', file);

        try {
            const resp = await fetch('${pageContext.request.contextPath}/upload-imagen', {
                method: 'POST',
                body: formData
            });

            const data = await resp.json();
            if (data.success && data.url) {
                fotosGaleria.push(data.url);
                subidas++;
                actualizarVistaFotos();
            } else {
                alert('Error al cargar la foto ' + file.name + ': ' + (data.mensaje || 'Respuesta inválida'));
            }
        } catch (err) {
            console.error('Error de red al subir imagen:', err);
            alert('Error de conexión al cargar la fotografía ' + file.name);
        }
    }

    statusBox.classList.remove('d-flex');
    statusBox.classList.add('d-none');
    document.getElementById('inputFotosArchivo').value = '';
}

function agregarUrlManual() {
    const input = document.getElementById('manualUrlInput');
    const url = input.value ? input.value.trim() : '';
    if (!url) return;

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
        alert('Por favor ingrese un enlace válido que empiece por http:// o https://');
        return;
    }

    fotosGaleria.push(url);
    input.value = '';
    actualizarVistaFotos();
}

function toggleManualUrlInput() {
    const box = document.getElementById('manualUrlBox');
    box.classList.toggle('d-none');
}

function eliminarFoto(index) {
    if (index >= 0 && index < fotosGaleria.length) {
        fotosGaleria.splice(index, 1);
        actualizarVistaFotos();
    }
}

function establecerComoPrincipal(index) {
    if (index > 0 && index < fotosGaleria.length) {
        const foto = fotosGaleria.splice(index, 1)[0];
        fotosGaleria.unshift(foto);
        actualizarVistaFotos();
    }
}

function actualizarVistaFotos() {
    const contenedor = document.getElementById('contenedorPreviewFotos');
    const textarea = document.getElementById('imagenesUrlsTextarea');
    const label = document.getElementById('totalFotosLabel');

    contenedor.innerHTML = '';
    label.innerText = fotosGaleria.length + ' fotografía(s) en la galería';

    textarea.value = fotosGaleria.join('\n');

    if (fotosGaleria.length === 0) {
        contenedor.innerHTML = '<div class="col-12">'
            + '<div class="p-3 text-center text-muted small bg-light rounded-3 border">'
            + '<i class="bi bi-image text-muted fs-4 d-block mb-1"></i>'
            + 'Aún no has agregado fotos a esta propiedad. Se utilizará una imagen por defecto si no subes ninguna.'
            + '</div></div>';
        return;
    }

    fotosGaleria.forEach((url, idx) => {
        const esPrincipal = (idx === 0);
        const col = document.createElement('div');
        col.className = 'col-6 col-md-4 col-lg-3';

        const badgeFoto = esPrincipal
            ? '<span class="badge bg-primary position-absolute top-0 start-0 m-2 small"><i class="bi bi-star-fill text-warning me-1"></i>Principal</span>'
            : '<span class="badge bg-dark bg-opacity-75 position-absolute top-0 start-0 m-2 small">#' + (idx + 1) + '</span>';

        const accionFoto = !esPrincipal
            ? '<button type="button" class="btn btn-outline-primary btn-sm py-0 px-2" title="Establecer como foto principal" onclick="establecerComoPrincipal(' + idx + ')"><i class="bi bi-star"></i> Principal</button>'
            : '<span class="small fw-bold text-primary">Portada</span>';

        col.innerHTML = '<div class="card h-100 border shadow-sm rounded-3 overflow-hidden position-relative">'
            + '<img src="' + url + '" class="card-img-top object-fit-cover" style="height: 140px;" onerror="this.src=\'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800\'">'
            + badgeFoto
            + '<div class="card-body p-2 d-flex justify-content-between align-items-center bg-white border-top">'
            + accionFoto
            + '<button type="button" class="btn btn-outline-danger btn-sm py-0 px-2" title="Eliminar fotografía" onclick="eliminarFoto(' + idx + ')"><i class="bi bi-trash"></i></button>'
            + '</div></div>';

        contenedor.appendChild(col);
    });
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jspf" %>