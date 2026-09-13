package com.inmobiliaria.dao;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.model.Favorito;
import com.inmobiliaria.model.Propiedad;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoritoDAO {

    public boolean agregar(int idUsuario, int idPropiedad) throws SQLException {
        String sql = "INSERT INTO favorito (id_usuario, id_propiedad) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idPropiedad);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean eliminar(int idUsuario, int idPropiedad) throws SQLException {
        String sql = "DELETE FROM favorito WHERE id_usuario = ? AND id_propiedad = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idPropiedad);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean esFavorito(int idUsuario, int idPropiedad) throws SQLException {
        String sql = "SELECT id FROM favorito WHERE id_usuario = ? AND id_propiedad = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Favorito> listarPorUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT f.id, f.id_usuario, f.id_propiedad, f.fecha_agregado, " +
                     "p.titulo, p.precio, p.tipo_operacion, p.estado, p.matricula_inmobiliaria, " +
                     "c.nombre AS ciudad_nombre, " +
                     "(SELECT img.url_imagen FROM imagen_propiedad img WHERE img.id_propiedad = p.id ORDER BY img.es_principal DESC LIMIT 1) AS img_principal " +
                     "FROM favorito f " +
                     "INNER JOIN propiedad p ON f.id_propiedad = p.id " +
                     "INNER JOIN ciudad c ON p.id_ciudad = c.id " +
                     "WHERE f.id_usuario = ? " +
                     "ORDER BY f.fecha_agregado DESC";

        List<Favorito> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Favorito f = new Favorito();
                    f.setId(rs.getInt("id"));
                    f.setIdUsuario(rs.getInt("id_usuario"));
                    f.setIdPropiedad(rs.getInt("id_propiedad"));
                    Timestamp ts = rs.getTimestamp("fecha_agregado");
                    if (ts != null) f.setFechaAgregado(ts.toLocalDateTime());

                    Propiedad p = new Propiedad();
                    p.setId(f.getIdPropiedad());
                    p.setTitulo(rs.getString("titulo"));
                    p.setPrecio(rs.getBigDecimal("precio"));
                    p.setTipoOperacion(rs.getString("tipo_operacion"));
                    p.setEstado(rs.getString("estado"));
                    p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
                    p.setCiudadNombre(rs.getString("ciudad_nombre"));
                    p.setImagenPrincipalUrl(rs.getString("img_principal"));
                    if (p.getImagenPrincipalUrl() == null || p.getImagenPrincipalUrl().isEmpty()) {
                        p.setImagenPrincipalUrl("https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800");
                    }
                    f.setPropiedad(p);
                    lista.add(f);
                }
            }
        }
        return lista;
    }
}
