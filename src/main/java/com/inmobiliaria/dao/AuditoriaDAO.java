package com.inmobiliaria.dao;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.model.Auditoria;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditoriaDAO {

    public void registrar(Auditoria a) {
        String sql = "INSERT INTO auditoria (id_usuario, accion, entidad_afectada, id_entidad, detalles, ip_origen) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (a.getIdUsuario() != null && a.getIdUsuario() > 0) {
                ps.setInt(1, a.getIdUsuario());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, a.getAccion());
            ps.setString(3, a.getEntidadAfectada());
            if (a.getIdEntidad() != null && a.getIdEntidad() > 0) {
                ps.setInt(4, a.getIdEntidad());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, a.getDetalles());
            ps.setString(6, a.getIpOrigen());
            ps.executeUpdate();
        } catch (SQLException e) {
            // No bloquear el flujo principal si la auditoría falla
            e.printStackTrace();
        }
    }

    public List<Auditoria> listarRecientes(int limit) throws SQLException {
        String sql = "SELECT a.*, u.correo AS usuario_correo " +
                     "FROM auditoria a " +
                     "LEFT JOIN usuario u ON a.id_usuario = u.id " +
                     "ORDER BY a.fecha_hora DESC LIMIT ?";

        List<Auditoria> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Auditoria a = new Auditoria();
                    a.setId(rs.getInt("id"));
                    int idU = rs.getInt("id_usuario");
                    if (!rs.wasNull()) a.setIdUsuario(idU);
                    a.setUsuarioCorreo(rs.getString("usuario_correo") != null ? rs.getString("usuario_correo") : "Sistema / Anónimo");
                    a.setAccion(rs.getString("accion"));
                    a.setEntidadAfectada(rs.getString("entidad_afectada"));
                    int idE = rs.getInt("id_entidad");
                    if (!rs.wasNull()) a.setIdEntidad(idE);
                    a.setDetalles(rs.getString("detalles"));
                    a.setIpOrigen(rs.getString("ip_origen"));
                    Timestamp ts = rs.getTimestamp("fecha_hora");
                    if (ts != null) a.setFechaHora(ts.toLocalDateTime());
                    lista.add(a);
                }
            }
        }
        return lista;
    }
}
