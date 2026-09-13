package com.inmobiliaria.dao;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.model.DocumentoSolicitud;
import com.inmobiliaria.model.Solicitud;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SolicitudDAO {

    public int crear(Solicitud s) throws SQLException {
        String sql = "INSERT INTO solicitud (id_cliente, id_propiedad, tipo_operacion, estado, observaciones) " +
                     "VALUES (?, ?, ?, 'PENDIENTE', ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, s.getIdCliente());
            ps.setInt(2, s.getIdPropiedad());
            ps.setString(3, s.getTipoOperacion());
            ps.setString(4, s.getObservaciones());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean agregarDocumento(DocumentoSolicitud doc) throws SQLException {
        String sql = "INSERT INTO documento_solicitud (id_solicitud, nombre_archivo, ruta_archivo, tipo_documento, estado) " +
                     "VALUES (?, ?, ?, ?, 'SUBIDO')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doc.getIdSolicitud());
            ps.setString(2, doc.getNombreArchivo());
            ps.setString(3, doc.getRutaArchivo());
            ps.setString(4, doc.getTipoDocumento());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Solicitud> listarPorCliente(int idCliente) throws SQLException {
        String sql = "SELECT s.*, p.titulo AS prop_titulo, p.matricula_inmobiliaria, p.precio AS prop_precio, " +
                     "p.direccion AS prop_direccion, inm.nombre AS inm_nombre " +
                     "FROM solicitud s " +
                     "INNER JOIN propiedad p ON s.id_propiedad = p.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "WHERE s.id_cliente = ? " +
                     "ORDER BY s.fecha_solicitud DESC";

        List<Solicitud> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitud s = mapSolicitud(rs);
                    cargarDocumentos(conn, s);
                    lista.add(s);
                }
            }
        }
        return lista;
    }

    public List<Solicitud> listarPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = "SELECT s.*, p.titulo AS prop_titulo, p.matricula_inmobiliaria, p.precio AS prop_precio, " +
                     "p.direccion AS prop_direccion, inm.nombre AS inm_nombre, " +
                     "u.correo AS cliente_correo, per.telefono AS cliente_telefono, " +
                     "CONCAT(per.nombres, ' ', per.apellidos) AS cliente_nombre " +
                     "FROM solicitud s " +
                     "INNER JOIN propiedad p ON s.id_propiedad = p.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "INNER JOIN usuario u ON s.id_cliente = u.id " +
                     "LEFT JOIN perfil per ON u.id = per.id_usuario " +
                     "WHERE p.id_inmobiliaria = ? " +
                     "ORDER BY s.fecha_solicitud DESC";

        List<Solicitud> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idInmobiliaria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitud s = mapSolicitud(rs);
                    s.setClienteNombre(rs.getString("cliente_nombre"));
                    s.setClienteCorreo(rs.getString("cliente_correo"));
                    s.setClienteTelefono(rs.getString("cliente_telefono"));
                    cargarDocumentos(conn, s);
                    lista.add(s);
                }
            }
        }
        return lista;
    }

    public Solicitud obtenerPorId(int idSolicitud) throws SQLException {
        String sql = "SELECT s.*, p.titulo AS prop_titulo, p.matricula_inmobiliaria, p.precio AS prop_precio, " +
                     "p.direccion AS prop_direccion, inm.nombre AS inm_nombre, " +
                     "u.correo AS cliente_correo, per.telefono AS cliente_telefono, " +
                     "CONCAT(per.nombres, ' ', per.apellidos) AS cliente_nombre " +
                     "FROM solicitud s " +
                     "INNER JOIN propiedad p ON s.id_propiedad = p.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "INNER JOIN usuario u ON s.id_cliente = u.id " +
                     "LEFT JOIN perfil per ON u.id = per.id_usuario " +
                     "WHERE s.id = ?";

        Solicitud s = null;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSolicitud);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    s = mapSolicitud(rs);
                    s.setClienteNombre(rs.getString("cliente_nombre"));
                    s.setClienteCorreo(rs.getString("cliente_correo"));
                    s.setClienteTelefono(rs.getString("cliente_telefono"));
                    cargarDocumentos(conn, s);
                }
            }
        }
        return s;
    }

    public boolean actualizarEstado(int idSolicitud, String estado, String observaciones) throws SQLException {
        String sql = "UPDATE solicitud SET estado = ?, observaciones = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setString(2, observaciones);
            ps.setInt(3, idSolicitud);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean actualizarEstadoDocumento(int idDoc, String estado) throws SQLException {
        String sql = "UPDATE documento_solicitud SET estado = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, idDoc);
            return ps.executeUpdate() > 0;
        }
    }

    private void cargarDocumentos(Connection conn, Solicitud s) throws SQLException {
        String sql = "SELECT id, id_solicitud, nombre_archivo, ruta_archivo, tipo_documento, estado, fecha_subida " +
                     "FROM documento_solicitud WHERE id_solicitud = ? ORDER BY fecha_subida ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, s.getId());
            try (ResultSet rs = ps.executeQuery()) {
                List<DocumentoSolicitud> docs = new ArrayList<>();
                while (rs.next()) {
                    DocumentoSolicitud d = new DocumentoSolicitud();
                    d.setId(rs.getInt("id"));
                    d.setIdSolicitud(rs.getInt("id_solicitud"));
                    d.setNombreArchivo(rs.getString("nombre_archivo"));
                    d.setRutaArchivo(rs.getString("ruta_archivo"));
                    d.setTipoDocumento(rs.getString("tipo_documento"));
                    d.setEstado(rs.getString("estado"));
                    Timestamp ts = rs.getTimestamp("fecha_subida");
                    if (ts != null) d.setFechaSubida(ts.toLocalDateTime());
                    docs.add(d);
                }
                s.setDocumentos(docs);
            }
        }
    }

    private Solicitud mapSolicitud(ResultSet rs) throws SQLException {
        Solicitud s = new Solicitud();
        s.setId(rs.getInt("id"));
        s.setIdCliente(rs.getInt("id_cliente"));
        s.setIdPropiedad(rs.getInt("id_propiedad"));
        s.setTipoOperacion(rs.getString("tipo_operacion"));
        s.setEstado(rs.getString("estado"));
        s.setObservaciones(rs.getString("observaciones"));
        Timestamp ts = rs.getTimestamp("fecha_solicitud");
        if (ts != null) s.setFechaSolicitud(ts.toLocalDateTime());
        Timestamp tu = rs.getTimestamp("fecha_actualizacion");
        if (tu != null) s.setFechaActualizacion(tu.toLocalDateTime());

        s.setPropiedadTitulo(rs.getString("prop_titulo"));
        s.setPropiedadMatricula(rs.getString("matricula_inmobiliaria"));
        s.setPropiedadPrecio(rs.getBigDecimal("prop_precio"));
        s.setPropiedadDireccion(rs.getString("prop_direccion"));
        s.setInmobiliariaNombre(rs.getString("inm_nombre"));
        return s;
    }
}
