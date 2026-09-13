package com.inmobiliaria.dao;

import com.inmobiliaria.config.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class ReporteDAO {

    /**
     * Consulta 5 pedagógica: GROUP BY + HAVING con agregaciones SQL.
     */
    public List<Map<String, Object>> reporteCiudadesPreciosVenta() throws SQLException {
        String sql = "SELECT c.nombre AS ciudad, c.departamento, " +
                     "COUNT(p.id) AS total_inmuebles, " +
                     "AVG(p.precio) AS precio_promedio, " +
                     "MIN(p.precio) AS precio_minimo, " +
                     "MAX(p.precio) AS precio_maximo " +
                     "FROM ciudad c " +
                     "INNER JOIN propiedad p ON c.id = p.id_ciudad " +
                     "WHERE p.tipo_operacion = 'VENTA' AND p.estado != 'INACTIVA' " +
                     "GROUP BY c.id, c.nombre, c.departamento " +
                     "HAVING COUNT(p.id) >= 1 " +
                     "ORDER BY AVG(p.precio) DESC";

        List<Map<String, Object>> resultados = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("ciudad", rs.getString("ciudad"));
                fila.put("departamento", rs.getString("departamento"));
                fila.put("total_inmuebles", rs.getInt("total_inmuebles"));
                fila.put("precio_promedio", rs.getBigDecimal("precio_promedio"));
                fila.put("precio_minimo", rs.getBigDecimal("precio_minimo"));
                fila.put("precio_maximo", rs.getBigDecimal("precio_maximo"));
                resultados.add(fila);
            }
        }
        return resultados;
    }

    /**
     * Consulta 4 pedagógica: LEFT JOIN para inmuebles sin visitas agendadas.
     */
    public List<Map<String, Object>> reportePropiedadesSinCitas() throws SQLException {
        String sql = "SELECT p.id, p.matricula_inmobiliaria, p.titulo, p.precio, p.tipo_operacion, " +
                     "c.nombre AS ciudad_nombre, inm.nombre AS inmobiliaria_nombre " +
                     "FROM propiedad p " +
                     "INNER JOIN ciudad c ON p.id_ciudad = c.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "LEFT JOIN cita cit ON p.id = cit.id_propiedad " +
                     "WHERE cit.id IS NULL AND p.estado = 'DISPONIBLE' " +
                     "ORDER BY p.id ASC";

        List<Map<String, Object>> resultados = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("id", rs.getInt("id"));
                fila.put("matricula", rs.getString("matricula_inmobiliaria"));
                fila.put("titulo", rs.getString("titulo"));
                fila.put("precio", rs.getBigDecimal("precio"));
                fila.put("tipo_operacion", rs.getString("tipo_operacion"));
                fila.put("ciudad", rs.getString("ciudad_nombre"));
                fila.put("inmobiliaria", rs.getString("inmobiliaria_nombre"));
                resultados.add(fila);
            }
        }
        return resultados;
    }

    /**
     * Agregación: Citas distribuidas por estado.
     */
    public Map<String, Integer> reporteCitasPorEstado() throws SQLException {
        String sql = "SELECT estado, COUNT(id) AS total FROM cita GROUP BY estado";
        Map<String, Integer> datos = new LinkedHashMap<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                datos.put(rs.getString("estado"), rs.getInt("total"));
            }
        }
        return datos;
    }

    /**
     * Agregación: Solicitudes por inmobiliaria.
     */
    public List<Map<String, Object>> reporteSolicitudesPorInmobiliaria() throws SQLException {
        String sql = "SELECT inm.nombre AS inmobiliaria, COUNT(s.id) AS total_solicitudes, " +
                     "SUM(CASE WHEN s.estado = 'APROBADA' THEN 1 ELSE 0 END) AS aprobadas, " +
                     "SUM(CASE WHEN s.estado = 'PENDIENTE' THEN 1 ELSE 0 END) AS pendientes, " +
                     "SUM(CASE WHEN s.estado = 'RECHAZADA' THEN 1 ELSE 0 END) AS rechazadas " +
                     "FROM inmobiliaria inm " +
                     "INNER JOIN propiedad p ON inm.id = p.id_inmobiliaria " +
                     "INNER JOIN solicitud s ON p.id = s.id_propiedad " +
                     "GROUP BY inm.id, inm.nombre " +
                     "ORDER BY total_solicitudes DESC";

        List<Map<String, Object>> resultados = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("inmobiliaria", rs.getString("inmobiliaria"));
                fila.put("total_solicitudes", rs.getInt("total_solicitudes"));
                fila.put("aprobadas", rs.getInt("aprobadas"));
                fila.put("pendientes", rs.getInt("pendientes"));
                fila.put("rechazadas", rs.getInt("rechazadas"));
                resultados.add(fila);
            }
        }
        return resultados;
    }

    /**
     * Estadísticas rápidas para los dashboards.
     */
    public Map<String, Integer> resumenGlobal() throws SQLException {
        Map<String, Integer> resumen = new HashMap<>();
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM propiedad WHERE estado != 'INACTIVA') AS total_propiedades, " +
                     "(SELECT COUNT(*) FROM usuario WHERE estado = 'ACTIVO') AS total_usuarios, " +
                     "(SELECT COUNT(*) FROM cita WHERE estado = 'PENDIENTE') AS citas_pendientes, " +
                     "(SELECT COUNT(*) FROM solicitud WHERE estado = 'PENDIENTE') AS solicitudes_pendientes";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                resumen.put("propiedades", rs.getInt("total_propiedades"));
                resumen.put("usuarios", rs.getInt("total_usuarios"));
                resumen.put("citas_pendientes", rs.getInt("citas_pendientes"));
                resumen.put("solicitudes_pendientes", rs.getInt("solicitudes_pendientes"));
            }
        }
        return resumen;
    }
}
