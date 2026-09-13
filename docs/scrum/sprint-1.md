# Sprint 1: Cimientos y Acceso (Días 1 a 7)

**Meta del Sprint:** Establecer la infraestructura de base de datos relacional normalizada (3FN), la conexión centralizada JDBC, el mecanismo de autenticación segura con BCrypt y el control de acceso en backend mediante Servlet Filter, dejando una landing page responsiva y navegable.

---

## 1. Historias Comprometidas
- **HU-01:** Landing Page Pública Responsiva (5 SP)
- **HU-02:** Registro de Clientes con Validación de Correo UNIQUE (8 SP)
- **HU-03:** Inicio de Sesión Seguro con BCrypt y Gestión de Sesión HTTP (5 SP)
- **HU-04:** Control de Acceso por Roles con Servlet Filter y Anti-Caché (8 SP)
- **Total:** 26 Story Points

---

## 2. Actividades y Tareas Técnicas
1. **Modelado y Scripts SQL:**
   - Diseño del MER y Modelo Relacional en 3FN.
   - Creación del script `01_ddl_inmobiliaria.sql` con llaves foráneas, primarias compuestas y restricciones `UNIQUE`.
   - Creación del script `02_dml_inmobiliaria.sql` con al menos 10 registros por tabla principal.
2. **Capa de Infraestructura Java EE:**
   - Configuración de `pom.xml` con dependencias Maven (Servlet 4.0, JSP 2.3, JSTL 1.2, MySQL Connector/J, jBCrypt).
   - Implementación de `DatabaseConnection.java` con carga externa de `db.properties` y traducción de excepciones de integridad.
   - Implementación de `PasswordHasher.java` con algoritmo BCrypt.
3. **Controladores y Seguridad:**
   - Creación de `AuthController.java` para login, registro y logout con invalidación de sesión.
   - Creación de `AuthFilter.java` interceptando `/cliente/*`, `/agente/*`, `/admin/*` y verificando `hasRol()`.
   - Configuración de cabeceras HTTP anti-caché para bloquear el botón "Atrás" del navegador tras logout.
4. **Vistas Frontend Bootstrap 5:**
   - Creación de fragmentos reutilizables: `header.jspf`, `navbar.jspf`, `alerts.jspf`, `footer.jspf`.
   - Creación de `index.jsp` con hero banner, buscador rápido y propiedades destacadas.
   - Creación de formularios `login.jsp` y `registro.jsp`.
   - Creación de páginas de error `403.jsp` (Acceso Denegado) y `404.jsp`.

---

## 3. Sprint Review (Revisión del Sprint)
- **Entregables Demostrados:**
  - Base de datos operativa con 16 tablas creadas e insertadas.
  - Registro funcional con validación inmediata si el correo ya existe (sin arrojar errores de consola ni trazas de SQL).
  - Login validado con contraseñas cifradas en BCrypt.
  - Al intentar ingresar directamente por URL a `/admin/dashboard` sin credenciales, el filtro redirige a `/login`. Al ingresar con un cliente, el filtro muestra la vista amigable `403 - Acceso Denegado`.
- **Estado:** 100% de historias cumplidas según la Definition of Done.

---

## 4. Sprint Retrospective (Retrospectiva del Sprint)
- **¿Qué funcionó bien?**
  - La traducción centralizada de errores SQL en `DatabaseConnection` simplificó el manejo de alertas amigables en todos los controladores.
  - El uso de `javax.servlet.Filter` protegió todo el sistema de accesos no autorizados sin duplicar código en cada Servlet.
- **¿Qué podemos mejorar para el Sprint 2?**
  - Coordinar la estructura de carpetas de vistas para que la edición de propiedades reutilice modales o componentes comunes.
