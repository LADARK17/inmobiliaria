package com.inmobiliaria.dao;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.model.Cita;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {

    public boolean agendar(Cita c) throws SQLException {
        String sql = "INSERT INTO cita (id_cliente, id_propiedad, fecha_hora, estado, comentarios) " +
                     "VALUES (?, ?, ?, 'PENDIENTE', ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getIdCliente());
            ps.setInt(2, c.getIdPropiedad());
            ps.setTimestamp(3, Timestamp.valueOf(c.getFechaHora()));
            ps.setString(4, c.getComentarios());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean existeCitaActiva(int idPropiedad, LocalDateTime fechaHora) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cita " +
                     "WHERE id_propiedad = ? AND fecha_hora = ? AND estado <> 'CANCELADA'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            ps.setTimestamp(2, Timestamp.valueOf(fechaHora));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public List<LocalDateTime> listarHorariosOcupados(int idPropiedad) throws SQLException {
        String sql = "SELECT fecha_hora FROM cita " +
                     "WHERE id_propiedad = ? AND estado <> 'CANCELADA' ORDER BY fecha_hora";
        List<LocalDateTime> ocupados = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("fecha_hora");
                    if (ts != null) ocupados.add(ts.toLocalDateTime());
                }
            }
        }
        return ocupados;
    }

    public List<Cita> listarPorCliente(int idCliente) throws SQLException {
        String sql = "SELECT c.*, p.titulo AS prop_titulo, p.matricula_inmobiliaria, p.direccion AS prop_direccion, " +
                     "inm.nombre AS inm_nombre " +
                     "FROM cita c " +
                     "INNER JOIN propiedad p ON c.id_propiedad = p.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "WHERE c.id_cliente = ? " +
                     "ORDER BY c.fecha_hora DESC";

        List<Cita> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapCita(rs));
                }
            }
        }
        return lista;
    }

    public List<Cita> listarPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = "SELECT c.*, p.titulo AS prop_titulo, p.matricula_inmobiliaria, p.direccion AS prop_direccion, " +
                     "inm.nombre AS inm_nombre, " +
                     "u.correo AS cliente_correo, per.telefono AS cliente_telefono, " +
                     "CONCAT(per.nombres, ' ', per.apellidos) AS cliente_nombre " +
                     "FROM cita c " +
                     "INNER JOIN propiedad p ON c.id_propiedad = p.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "INNER JOIN usuario u ON c.id_cliente = u.id " +
                     "LEFT JOIN perfil per ON u.id = per.id_usuario " +
                     "WHERE p.id_inmobiliaria = ? " +
                     "ORDER BY c.fecha_hora DESC";

        List<Cita> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idInmobiliaria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita cita = mapCita(rs);
                    cita.setClienteNombre(rs.getString("cliente_nombre"));
                    cita.setClienteCorreo(rs.getString("cliente_correo"));
                    cita.setClienteTelefono(rs.getString("cliente_telefono"));
                    lista.add(cita);
                }
            }
        }
        return lista;
    }

    public boolean cambiarEstado(int idCita, String nuevoEstado) throws SQLException {
        String sql = "UPDATE cita SET estado = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idCita);
            return ps.executeUpdate() > 0;
        }
    }

    private Cita mapCita(ResultSet rs) throws SQLException {
        Cita c = new Cita();
        c.setId(rs.getInt("id"));
        c.setIdCliente(rs.getInt("id_cliente"));
        c.setIdPropiedad(rs.getInt("id_propiedad"));
        Timestamp ts = rs.getTimestamp("fecha_hora");
        if (ts != null) c.setFechaHora(ts.toLocalDateTime());
        c.setEstado(rs.getString("estado"));
        c.setComentarios(rs.getString("comentarios"));
        Timestamp tc = rs.getTimestamp("fecha_creacion");
        if (tc != null) c.setFechaCreacion(tc.toLocalDateTime());

        c.setPropiedadTitulo(rs.getString("prop_titulo"));
        c.setPropiedadMatricula(rs.getString("matricula_inmobiliaria"));
        c.setPropiedadDireccion(rs.getString("prop_direccion"));
        c.setInmobiliariaNombre(rs.getString("inm_nombre"));
        return c;
    }
}
