# Product Backlog del Sistema Inmobiliario Web MVC

**Metodología:** Scrum  
**Roles del Proyecto:**
- **Product Owner:** Docente evaluador
- **Scrum Master:** Líder de equipo de desarrollo
- **Development Team:** Integrantes del equipo de desarrollo
- **Duración Total:** 3 Sprints &times; 7 días = 21 días

---

## Definición de Hecho (Definition of Done - DoD)
Una historia de usuario se considera terminada (**DONE**) cuando:
1. El código compila sin errores ni advertencias críticas.
2. Cumple con la arquitectura **MVC en Java EE** (Servlet Controlador, DAO JDBC, JSP/JSPF con Bootstrap 5).
3. Todas las operaciones contra la base de datos utilizan sentencias preparadas (`PreparedStatement`) para prevenir inyecciones SQL.
4. Las restricciones de integridad (`UNIQUE`, `NOT NULL`, `FOREIGN KEY`) están controladas y presentan mensajes comprensibles en la vista sin volcar excepciones técnicas.
5. El diseño de la interfaz es completamente responsivo en móvil, tablet y escritorio.
6. El código cuenta con sus respectivos commits descriptivos en el repositorio Git.

---

## Historias de Usuario

| ID | Historia de Usuario | Prioridad | Estimación (Story Points) | Sprint Asignado |
| :---: | :--- | :---: | :---: | :---: |
| **HU-01** | **Landing Page Pública Responsiva:** Como visitante quiero ver una página principal con información de la inmobiliaria, buscador rápido y propiedades destacadas para conocer la oferta. | Alta | 5 SP | Sprint 1 |
| **HU-02** | **Registro de Clientes con Validación UNIQUE:** Como visitante quiero registrarme ingresando mis datos personales y correo único para poder interactuar con la plataforma. | Alta | 8 SP | Sprint 1 |
| **HU-03** | **Inicio de Sesión Seguro con BCrypt:** Como usuario registrado quiero iniciar sesión con mi correo y contraseña para acceder a mi dashboard según mi rol. | Alta | 5 SP | Sprint 1 |
| **HU-04** | **Control de Acceso por Roles con Servlet Filter:** Como administrador quiero que el sistema bloquee el acceso por URL directa a usuarios sin los privilegios requeridos. | Alta | 8 SP | Sprint 1 |
| **HU-05** | **Gestión de Perfil de Usuario 1:1:** Como cliente quiero consultar y actualizar mis datos personales de contacto manteniendo un único perfil asociado a mi cuenta. | Media | 5 SP | Sprint 2 |
| **HU-06** | **Catálogo Público con Filtros Dinámicos SQL:** Como usuario quiero buscar inmuebles por ciudad, tipo, rango de precio y características para encontrar la propiedad ideal. | Alta | 8 SP | Sprint 2 |
| **HU-07** | **Detalle Individual de Propiedad con Galería 1:N:** Como usuario quiero ver la ficha completa de un inmueble con carrusel de fotografías, amenidades N:M y datos de la agencia. | Alta | 5 SP | Sprint 2 |
| **HU-08** | **CRUD de Propiedades con Baja Lógica:** Como agente quiero crear, editar y dar de baja lógica propiedades verificando que la matrícula inmobiliaria sea única. | Alta | 8 SP | Sprint 2 |
| **HU-09** | **Gestión de Inmuebles Favoritos:** Como cliente quiero marcar y desmarcar propiedades favoritas para revisarlas posteriormente desde mi panel. | Media | 5 SP | Sprint 3 |
| **HU-10** | **Agendamiento de Citas con Horario Único:** Como cliente quiero agendar una visita presencial a un inmueble impidiendo que otro cliente reserve en el mismo horario. | Media | 8 SP | Sprint 3 |
| **HU-11** | **Gestión y Confirmación de Citas por Agente:** Como agente quiero revisar las citas solicitadas a mis inmuebles y cambiar su estado (Confirmada, Realizada o Cancelada). | Media | 5 SP | Sprint 3 |
| **HU-12** | **Radicación de Solicitudes y Documentos 1:N:** Como cliente quiero iniciar un trámite de compra o arriendo y adjuntar cédula y certificaciones en formato digital. | Media | 8 SP | Sprint 3 |
| **HU-13** | **Revisión y Aprobación de Trámites Inmobiliarios:** Como agente quiero revisar los documentos radicados por el cliente y aprobar o rechazar la solicitud formalmente. | Media | 5 SP | Sprint 3 |
| **HU-14** | **Reportes Gerenciales Basados en SQL Agregado:** Como administrador quiero consultar reportes de precios por ciudad con `GROUP BY + HAVING` y propiedades sin citas con `LEFT JOIN`. | Media | 8 SP | Sprint 3 |
| **HU-15** | **Administración de Usuarios y Asignación de Roles N:M:** Como administrador quiero activar/inactivar cuentas y asignar o revocar múltiples roles a cualquier usuario. | Alta | 5 SP | Sprint 3 |
| **HU-16** | **Trazabilidad y Consulta de Auditoría:** Como administrador quiero consultar el registro de eventos y operaciones críticas realizadas en la plataforma con su IP y fecha. | Baja | 3 SP | Sprint 3 |

**Total Puntos de Historia:** 99 Story Points distribuidos equitativamente a lo largo de los 3 Sprints.
