# Sprint 3: Operación, Reportes y Cierre (Días 15 a 21)

**Meta del Sprint:** Completar el ciclo de vida del negocio inmobiliario mediante la gestión de favoritos, agendamiento de citas con validación de horarios únicos, radicación y revisión de solicitudes con documentos (1:N), módulo de reportes SQL avanzados (`GROUP BY + HAVING`, `LEFT JOIN`) y panel de auditoría y administración de roles N:M.

---

## 1. Historias Comprometidas
- **HU-09:** Gestión de Inmuebles Favoritos con Restricción Compuesta (5 SP)
- **HU-10:** Agendamiento de Citas con Restricción `UNIQUE(id_propiedad, fecha_hora)` (8 SP)
- **HU-11:** Gestión y Confirmación de Citas por Agente (5 SP)
- **HU-12:** Radicación de Solicitudes y Documentos 1:N (8 SP)
- **HU-13:** Revisión y Aprobación de Trámites Inmobiliarios (5 SP)
- **HU-14:** Reportes Gerenciales Basados en SQL Agregado (8 SP)
- **HU-15:** Administración de Usuarios y Asignación de Roles N:M (5 SP)
- **HU-16:** Trazabilidad y Consulta de Auditoría (3 SP)
- **Total:** 47 Story Points

---

## 2. Actividades y Tareas Técnicas
1. **Módulo de Favoritos:**
   - Creación de `FavoritoDAO.java` con constraint `UNIQUE(id_usuario, id_propiedad)`.
   - Vistas para marcar favoritos desde el detalle y listado en `/cliente/favoritos`.
2. **Citas y Visitas Presenciales:**
   - Creación de `CitaDAO.java` con constraint `UNIQUE(id_propiedad, fecha_hora)` para prevenir doble reserva.
   - Vista `/cliente/citas` y panel de confirmación `/agente/citas`.
3. **Solicitudes de Compra/Arriendo y Documentos 1:N:**
   - Creación de `SolicitudDAO.java` y modelos `Solicitud` y `DocumentoSolicitud`.
   - Flujo de postulación desde la propiedad, carga de documentos digitales y revisión con aprobación/rechazo por el agente en `/agente/solicitudes`.
4. **Reportes SQL Avanzados (Requisitos Académicos Obligatorios):**
   - Implementación de `ReporteDAO.java` con las 5 consultas requeridas:
     - 2 `INNER JOIN` de 3+ tablas.
     - 1 consulta de relación N:M con `GROUP_CONCAT`.
     - 1 `LEFT JOIN` para propiedades sin citas.
     - 1 `GROUP BY + HAVING` para análisis estadístico de precios por ciudad.
   - Vista ejecutiva `/admin/reportes` presentando los datos en tablas y badges analíticos.
5. **Administración de Roles y Auditoría:**
   - `AdminController.java` y vistas `/admin/usuarios` y `/admin/auditoria`.
   - Operaciones para activar/desactivar cuentas y asignar/revocar roles en la tabla intermedia `usuario_rol`.
   - Registro automático de operaciones críticas en la tabla `auditoria`.
6. **Empaquetado y Pruebas Finales:**
   - Compilación y empaquetado del archivo WAR (`target/inmobiliaria.war`).
   - Verificación de ausencia de errores en consola y validación contra inyección SQL.

---

## 3. Sprint Review (Revisión del Sprint)
- **Demostración de Extremo a Extremo:**
  - El flujo completo de negocio opera sin fisuras: un usuario se registra como cliente, busca un inmueble con filtros, lo guarda en favoritos, agenda una visita (se valida el horario), radica una solicitud de compra, adjunta su cédula digital, el agente revisa el documento, aprueba la solicitud y el administrador consulta la auditoría y los reportes SQL agregados.
- **Estado:** 100% de historias de usuario terminadas bajo la Definition of Done.

---

## 4. Sprint Retrospective (Retrospectiva del Sprint)
- **Logros Destacados:**
  - Se alcanzaron todos los objetivos técnicos y académicos del parcial con una arquitectura MVC limpia y desacoplada.
  - La base de datos demuestra rigor técnico en la aplicación de la 3FN y en las restricciones `UNIQUE`.
- **Preparación para la Sustentación:**
  - El equipo cuenta con la guía de sustentación para responder fluidamente sobre el modelo de datos, la seguridad en Java EE y la justificación de las consultas SQL.
