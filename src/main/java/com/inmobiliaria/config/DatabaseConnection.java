package com.inmobiliaria.config;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Conexión centralizada a la base de datos relacional mediante JDBC y Connection Pooling de alto rendimiento.
 * Compatible tanto con Supabase (PostgreSQL en la nube) como con MySQL / XAMPP local.
 * Implementa Apache Tomcat JDBC Pool para mantener conexiones abiertas, eliminando la latencia de
 * handshake TCP/TLS en cada consulta y acelerando la navegación entre pestañas de segundos a milisegundos.
 */
public class DatabaseConnection {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConnection.class.getName());
    private static Properties props = new Properties();
    private static DataSource dataSource;
    private static volatile boolean poolInitialized = false;

    static {
        inicializarPool();
    }

    private static synchronized void inicializarPool() {
        try (InputStream input = DatabaseConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
            } else {
                LOGGER.warning("Archivo db.properties no encontrado en classpath. Usando Supabase por defecto.");
                props.setProperty("db.driver", "org.postgresql.Driver");
                props.setProperty("db.url", "jdbc:postgresql://aws-0-us-west-2.pooler.supabase.com:5432/postgres?sslmode=require");
                props.setProperty("db.user", "postgres.izvgvqqecuztatpflnwy");
                props.setProperty("db.password", "ZwwILjIV6ISHIqr6");
            }

            String driver = props.getProperty("db.driver", "org.postgresql.Driver").trim();
            String url = props.getProperty("db.url").trim();
            String user = props.getProperty("db.user").trim();
            String password = props.getProperty("db.password").trim();

            Class.forName(driver);

            // Configuración optimizada del Connection Pool de Tomcat
            PoolProperties p = new PoolProperties();
            p.setUrl(url);
            p.setDriverClassName(driver);
            p.setUsername(user);
            p.setPassword(password);

            // Parámetros de capacidad y rapidez
            int maxConns = Integer.parseInt(props.getProperty("db.pool.maxConnections", "15").trim());
            p.setInitialSize(4);                 // 4 conexiones calientes listas de inmediato
            p.setMaxActive(maxConns);            // Hasta el límite configurado
            p.setMaxIdle(10);                    // Mantener hasta 10 conexiones en reposo listas
            p.setMinIdle(4);                     // Mínimo 4 conexiones siempre abiertas
            p.setMaxWait(10000);                 // 10s máximo si el pool estuviera ocupado

            // Validación de conexiones inteligente (no sobrecargar la red si se usó hace menos de 30s)
            p.setTestOnBorrow(true);
            p.setValidationQuery("SELECT 1");
            p.setValidationInterval(30000);

            // Mantenimiento y prevención de fugas de conexión
            p.setTestWhileIdle(true);
            p.setTimeBetweenEvictionRunsMillis(30000);
            p.setMinEvictableIdleTimeMillis(60000);
            p.setRemoveAbandoned(true);
            p.setRemoveAbandonedTimeout(60);

            dataSource = new DataSource();
            dataSource.setPoolProperties(p);
            poolInitialized = true;
            LOGGER.info("Tomcat JDBC Connection Pool inicializado exitosamente hacia: " + url);

        } catch (Throwable e) {
            LOGGER.log(Level.SEVERE, "No se pudo inicializar Tomcat JDBC Pool. Se usará fallback a DriverManager: " + e.getMessage(), e);
            poolInitialized = false;
        }
    }

    /**
     * Obtiene una conexión activa reutilizada del Pool (o DriverManager como fallback seguro).
     */
    public static Connection getConnection() throws SQLException {
        if (poolInitialized && dataSource != null) {
            try {
                return dataSource.getConnection();
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error al obtener conexión del pool, reintentando con DriverManager...", ex);
            }
        }

        // Fallback para entornos independientes
        String url = props.getProperty("db.url");
        String user = props.getProperty("db.user");
        String password = props.getProperty("db.password");
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Cierra el pool de conexiones de manera ordenada al detener la aplicación.
     */
    public static synchronized void closePool() {
        if (dataSource != null) {
            try {
                dataSource.close();
                LOGGER.info("Tomcat JDBC Connection Pool cerrado limpiamente.");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error al cerrar el pool de conexiones", e);
            } finally {
                dataSource = null;
                poolInitialized = false;
            }
        }
    }

    /**
     * Convierte excepciones técnicas de integridad de SQL (tanto MySQL como PostgreSQL / Supabase)
     * en mensajes comprensibles y amigables para el usuario.
     */
    public static String translateSQLException(SQLException ex) {
        String sqlState = ex.getSQLState();
        int errorCode = ex.getErrorCode();
        String msg = ex.getMessage();

        // Error 1062 en MySQL o 23505 (unique_violation) en PostgreSQL
        boolean esDuplicado = (ex instanceof SQLIntegrityConstraintViolationException) ||
                              errorCode == 1062 ||
                              "23505".equals(sqlState);

        // Error 1451/1452 en MySQL o 23503 (foreign_key_violation) en PostgreSQL
        boolean esForanea = errorCode == 1451 || errorCode == 1452 || "23503".equals(sqlState);

        if (esDuplicado) {
            if (msg != null) {
                String lower = msg.toLowerCase();
                if (lower.contains("correo") || lower.contains("usuario_correo_key")) {
                    return "El correo electrónico ya se encuentra registrado en el sistema.";
                } else if (lower.contains("matricula") || lower.contains("matricula_inmobiliaria")) {
                    return "La matrícula inmobiliaria ya pertenece a otra propiedad registrada.";
                } else if (lower.contains("uq_cita") || lower.contains("fecha_hora")) {
                    return "Ya existe una cita programada para esta propiedad exactamente en esa misma fecha y hora.";
                } else if (lower.contains("documento_identidad")) {
                    return "El documento de identidad ingresado ya se encuentra registrado en otro perfil.";
                } else if (lower.contains("favorito") || lower.contains("uq_favorito")) {
                    return "Esta propiedad ya se encuentra guardada en tus favoritos.";
                } else if (lower.contains("usuariorol") || lower.contains("usuario_rol")) {
                    return "El usuario ya tiene asignado dicho rol en el sistema.";
                }
            }
            return "No se pudo guardar la información porque ya existe un registro con datos idénticos (restricción UNIQUE).";
        } else if (esForanea) {
            return "No es posible realizar esta acción porque el registro está relacionado con otras entidades activas (citas, solicitudes o favoritos).";
        }

        return "Ocurrió un error al procesar la solicitud en la base de datos: " + (msg != null ? msg : "Error general");
    }
}
