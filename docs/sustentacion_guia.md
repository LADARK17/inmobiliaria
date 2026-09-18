# Guía Maestra para la Sustentación del Proyecto Inmobiliario MVC

> [!IMPORTANT]
> Esta guía contiene los argumentos técnicos, conceptuales y de arquitectura para defender con éxito el proyecto ante el docente evaluador.

---

## 1. El Modelo de Base de Datos y Normalización

### Pregunta 1: "¿Por qué el modelo está normalizado hasta la Tercera Forma Normal (3FN)?"
**Respuesta sugerida:**
- **1FN:** Cada columna contiene valores atómicos e indivisibles (no hay listas separadas por comas ni arreglos de amenidades dentro de `propiedad`). Además, cada tabla tiene una clave primaria única.
- **2FN:** Cumple 1FN y no existen dependencias funcionales parciales respecto a claves primarias compuestas. En las tablas `usuario_rol` (`id_usuario`, `id_rol`) y `propiedad_caracteristica` (`id_propiedad`, `id_caracteristica`), todos los atributos no clave dependen de la totalidad de la clave compuesta.
- **3FN:** Cumple 2FN y no existen dependencias transitivas (ningún atributo no clave depende de otro atributo no clave). Por ejemplo, en `propiedad` no guardamos el nombre del departamento o de la ciudad, sino la clave foránea `id_ciudad`, evitando redundancias y anomalías de actualización.

---

### Pregunta 2: "¿Dónde están demostradas las relaciones 1:1, 1:N y N:M?"
**Respuesta sugerida:**
1. **Relación 1:1 Estricta:** Entre `usuario` y `perfil`.
   - *¿Cómo se garantiza en la base de datos?* La columna `perfil.id_usuario` tiene una restricción `UNIQUE` y es `FOREIGN KEY` referenciando a `usuario(id)`. Esto impide físicamente que un usuario tenga más de un perfil.
2. **Relaciones 1:N:**
   - `inmobiliaria` &rarr; `propiedad` (una inmobiliaria gestiona muchas propiedades; una propiedad pertenece a una agencia).
   - `propiedad` &rarr; `imagen_propiedad` (una propiedad tiene una galería de N fotos; cada foto pertenece a un solo inmueble).
   - `solicitud` &rarr; `documento_solicitud` (un trámite de compra/arriendo tiene muchos documentos radicados).
   - `cliente` &rarr; `cita` (un cliente puede solicitar múltiples citas).
3. **Relaciones N:M:**
   - `usuario` &harr; `rol` resuelta con la tabla asociativa `usuario_rol` (un usuario puede ser Administrador y Agente al mismo tiempo, y un rol lo tienen muchos usuarios). Llave compuesta: `PRIMARY KEY (id_usuario, id_rol)`.
   - `propiedad` &harr; `caracteristica` resuelta con `propiedad_caracteristica` (un inmueble tiene varias amenidades y una amenidad aplica a muchos inmuebles). Llave compuesta: `PRIMARY KEY (id_propiedad, id_caracteristica)`.

---

### Pregunta 3: "¿Cuáles son las restricciones UNIQUE obligatorias y cómo las maneja el backend?"
**Respuesta sugerida:**
- `usuario.correo`: Evita duplicar cuentas.
- `propiedad.matricula_inmobiliaria`: Evita registrar dos veces el mismo predio legal.
- `perfil.id_usuario` y `perfil.documento_identidad`: Aseguran la relación 1:1 y documento civil único.
- `cita(id_propiedad, fecha_hora)`: Impide que dos clientes agenden la misma propiedad en el mismo horario (turno único). En Supabase se usa un **índice único parcial** `WHERE estado <> 'CANCELADA'`, de modo que una cita cancelada libera el turno.
- `favorito(id_usuario, id_propiedad)`: Evita guardar dos veces el mismo inmueble en favoritos.
- *Manejo en Java:* En `DatabaseConnection.translateSQLException()` capturamos el código de error `1062` o `SQLIntegrityConstraintViolationException` e inspeccionamos el mensaje para traducirlo en un texto amigable al usuario (ej: *"El correo ya está registrado"* o *"Ya existe una cita en esa hora"*), impidiendo volcados de trazas técnicas al navegador.

---

## 2. Seguridad y Control de Acceso

### Pregunta 4: "¿Por qué no basta con ocultar botones en el frontend? ¿Cómo protege el servidor el acceso por URL?"
**Respuesta sugerida:**
- Ocultar un botón en JSP es solo experiencia de usuario (UX), no seguridad. Un usuario podría escribir directamente en el navegador `/admin/usuarios` o `/agente/propiedades`.
- La seguridad está garantizada en el backend mediante un **`ServletFilter`** (`AuthFilter.java`).
- El filtro intercepta cada solicitud antes de que llegue a cualquier Servlet. Verifica:
  1. Si existe una sesión activa (`session != null` y `usuarioLogueado != null`). Si no, redirige al `/login`.
  2. Si el usuario tiene el rol permitido mediante el método `usuario.hasRol()`.
  3. Si no tiene el rol, detiene la cadena de ejecución y despacha una página `403 - Acceso Denegado`.
  4. Agrega cabeceras HTTP anti-caché (`Cache-Control: no-cache, no-store, must-revalidate`) para que el botón "Atrás" del navegador no recupere información sensible una vez cerrada la sesión.

---

### Pregunta 5: "¿Cómo se almacenan las contraseñas en la base de datos?"
**Respuesta sugerida:**
- Nunca en texto plano. Se utiliza el algoritmo de derivación de claves **BCrypt** (`org.mindrot:jbcrypt`), que incluye automáticamente un *salt* criptográfico aleatorio y un factor de costo computacional (10 rondas).
- En la base de datos solo se guarda el hash resultante (que comienza por `$2a$10$...`). Al hacer login, `BCrypt.checkpw(plain, hash)` verifica la validez sin necesidad de descifrar el hash.

---

## 3. Arquitectura MVC y Capa de Datos JDBC

### Pregunta 6: "¿Cómo se implementó la arquitectura MVC en el proyecto?"
**Respuesta sugerida:**
- **Modelo (Model):** Clases POJO (`Propiedad`, `Usuario`, `Cita`, `Solicitud`, etc.) que representan la estructura de datos y las relaciones del negocio.
- **Vista (View):** Archivos `JSP` y fragmentos `JSPF` con etiquetas `JSTL` (`<c:forEach>`, `<c:if>`) y diseño responsivo en Bootstrap 5. Las vistas solo presentan datos y no contienen sentencias SQL.
- **Controlador (Controller):** Clases que heredan de `HttpServlet` (`AuthController`, `PublicController`, `ClienteController`, `AgenteController`, `AdminController`). Procesan las peticiones HTTP (`GET`/`POST`), invocan a los DAOs y redirigen o despachan a las vistas.
- **Acceso a Datos (DAO / JDBC):** Clases DAO (`UsuarioDAO`, `PropiedadDAO`, etc.) con conexión centralizada en `DatabaseConnection`, consultas parametrizadas con `PreparedStatement` y transacciones atómicas con `setAutoCommit(false)` para registros de múltiples tablas.

---

## 4. Consultas SQL Demostrables

### Pregunta 7: "Muestre las 5 consultas SQL exigidas y explique qué hace cada una"
**Respuesta sugerida:**
1. **INNER JOIN con 4 tablas (Catálogo completo):** Une `propiedad` con `ciudad`, `tipo_propiedad` e `inmobiliaria` para mostrar la ficha pública del inmueble con los datos de contacto de su agencia.
2. **INNER JOIN con 4 tablas (Usuarios y roles):** Une `usuario`, `perfil`, `usuario_rol` y `rol` para auditar qué personas tienen qué perfiles civiles y qué roles asignados.
3. **Consulta de Relación N:M (Inmuebles y características):** Une `propiedad`, `propiedad_caracteristica` y `caracteristica` usando la función de agregación `GROUP_CONCAT()` para listar en un solo campo todas las amenidades del inmueble separadas por barra (` | `).
4. **LEFT JOIN (Propiedades sin citas):** Realiza `propiedad LEFT JOIN cita ON p.id = cita.id_propiedad WHERE cita.id IS NULL` para identificar qué inmuebles disponibles no han recibido solicitudes de visita.
5. **GROUP BY + HAVING (Reporte gerencial de precios por ciudad):** Agrupa por ciudad (`GROUP BY c.id, c.nombre`) calculando funciones estadísticas (`COUNT(p.id)`, `AVG(p.precio)`, `MIN(p.precio)`, `MAX(p.precio)`) y filtra con `HAVING COUNT(p.id) >= 1` ordenando de mayor a menor precio promedio.

---

## 5. Metodología Scrum y Ciclo de Vida

### Pregunta 8: "¿Cómo se organizó el desarrollo mediante Scrum?"
**Respuesta sugerida:**
- El proyecto se dividió en **3 Sprints de 7 días (21 días en total)**:
  - **Sprint 1 (Cimientos y Acceso):** Base de datos 3FN, conexión JDBC, seguridad BCrypt, sesiones HTTP, Servlet Filter y landing page.
  - **Sprint 2 (Núcleo Inmobiliario):** Perfil 1:1, catálogo público con filtros dinámicos SQL, detalle con galería 1:N y amenidades N:M, y CRUD de propiedades con baja lógica (`INACTIVA`).
  - **Sprint 3 (Operación, Reportes y Cierre):** Favoritos, agendamiento de citas con horario único, solicitudes de compra/arriendo con documentos 1:N, reportes SQL agregados y auditoría.
- Cada sprint cuenta con su documento de planificación, tareas técnicas, Definition of Done, Sprint Review y Retrospectiva en la carpeta `docs/scrum/`.
