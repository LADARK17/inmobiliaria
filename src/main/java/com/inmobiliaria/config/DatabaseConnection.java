package com.inmobiliaria.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Conexión centralizada a la base de datos relacional mediante JDBC.
 * Compatible tanto con Supabase (PostgreSQL) en la nube como con MySQL / XAMPP local.
 * Lee los parámetros dinámicamente desde db.properties.
 */
public class DatabaseConnection {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConnection.class.getName());
    private static Properties props = new Properties();

    static {
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

            String driver = props.getProperty("db.driver");
            if (driver != null && !driver.trim().isEmpty()) {
                Class.forName(driver.trim());
            } else {
                Class.forName("org.postgresql.Driver");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al inicializar el driver JDBC o cargar db.properties", e);
        }
    }

    /**
     * Obtiene una nueva conexión activa con la base de datos configurada.
     */
    public static Connection getConnection() throws SQLException {
        String url = props.getProperty("db.url");
        String user = props.getProperty("db.user");
        String password = props.getProperty("db.password");
        return DriverManager.getConnection(url, user, password);
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
