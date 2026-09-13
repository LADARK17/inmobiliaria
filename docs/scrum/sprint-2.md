# Sprint 2: Núcleo Inmobiliario (Días 8 a 14)

**Meta del Sprint:** Desarrollar el núcleo de negocio de la plataforma inmobiliaria: gestión de perfil 1:1, catálogo público con filtros dinámicos SQL, ficha de detalle con galería 1:N y características N:M, y el módulo de administración de propiedades para agentes con baja lógica.

---

## 1. Historias Comprometidas
- **HU-05:** Gestión de Perfil de Usuario 1:1 (5 SP)
- **HU-06:** Catálogo Público con Filtros Dinámicos SQL (8 SP)
- **HU-07:** Detalle Individual de Propiedad con Galería 1:N y Amenidades N:M (5 SP)
- **HU-08:** CRUD de Propiedades para Agente con Baja Lógica y Matrícula UNIQUE (8 SP)
- **Total:** 26 Story Points

---

## 2. Actividades y Tareas Técnicas
1. **Módulo de Perfil (Relación 1:1):**
   - Creación de `PerfilDAO.java` con métodos para consultar y actualizar datos personales.
   - Integración en `ClienteController.java` para actualización del perfil desde `/cliente/perfil`.
   - Validación de cédula única y visualización de avatar.
2. **Catálogo y Búsqueda Dinámica SQL:**
   - Implementación de `PropiedadDAO.buscarConFiltros()` construyendo dinámicamente sentencias `PreparedStatement` con filtros de ciudad, tipo, rango de precios, tipo de operación y características seleccionadas.
   - Vistas `catalogo.jsp` con sidebar de filtros colapsable y badges informativos.
3. **Ficha de Detalle de Inmueble:**
   - Creación de vista `detalle-propiedad.jsp` con carrusel de imágenes (relación 1:N) y visualización de amenidades con iconos (relación N:M).
   - Ocultamiento de información de contacto sensible para visitantes sin sesión.
4. **CRUD de Propiedades y Baja Lógica:**
   - Formulario `form-propiedad.jsp` con soporte de creación y edición.
   - Restricción de matrícula única (`matricula_inmobiliaria UNIQUE`).
   - Implementación de la baja lógica (`UPDATE propiedad SET estado = 'INACTIVA'`) para preservar integridad referencial de auditoría y citas.
   - Dashboard operativo para el agente en `/agente/dashboard` y `/agente/mis-propiedades`.

---

## 3. Sprint Review (Revisión del Sprint)
- **Entregables Demostrados:**
  - Búsqueda funcional filtrando en tiempo real (ej. Apartamentos en Bucaramanga entre $200M y $400M con piscina y parqueadero).
  - Publicación exitosa de propiedades con galería de fotografías y características seleccionables.
  - Al ingresar una matrícula inmobiliaria existente, el sistema captura el error y notifica amigablemente sin caerse.
  - La baja lógica cambia el estado visual y funcional a INACTIVA sin eliminar el registro físico.
- **Estado:** 100% cumplido con respecto a los criterios de aceptación.

---

## 4. Sprint Retrospective (Retrospectiva del Sprint)
- **¿Qué funcionó bien?**
  - La consulta dinámica en `PropiedadDAO` utilizando `GROUP BY ... HAVING COUNT = ?` para la relación N:M resolvió el filtrado de múltiples amenidades de forma limpia en SQL.
  - Bootstrap 5 garantizó un diseño homogéneo y responsivo tanto en dispositivos móviles como en pantallas grandes.
- **¿Qué podemos mejorar para el Sprint 3?**
  - Asegurar que la subida de documentos y citas cuente con validaciones estrictas de fechas futuras y formatos permitidos.
