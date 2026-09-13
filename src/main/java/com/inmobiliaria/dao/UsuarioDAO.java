package com.inmobiliaria.dao;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.model.Perfil;
import com.inmobiliaria.model.Rol;
import com.inmobiliaria.model.Usuario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public Usuario findByCorreo(String correo) throws SQLException {
        String sql = "SELECT u.id, u.correo, u.password_hash, u.estado, u.id_inmobiliaria, u.fecha_registro, " +
                     "p.id AS perfil_id, p.nombres, p.apellidos, p.documento_identidad, p.telefono, p.direccion, p.foto_url " +
                     "FROM usuario u " +
                     "LEFT JOIN perfil p ON u.id = p.id_usuario " +
                     "WHERE u.correo = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = mapUsuario(rs);
                    cargarRoles(conn, u);
                    return u;
                }
            }
        }
        return null;
    }

    public Usuario findById(int id) throws SQLException {
        String sql = "SELECT u.id, u.correo, u.password_hash, u.estado, u.id_inmobiliaria, u.fecha_registro, " +
                     "p.id AS perfil_id, p.nombres, p.apellidos, p.documento_identidad, p.telefono, p.direccion, p.foto_url " +
                     "FROM usuario u " +
                     "LEFT JOIN perfil p ON u.id = p.id_usuario " +
                     "WHERE u.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = mapUsuario(rs);
                    cargarRoles(conn, u);
                    return u;
                }
            }
        }
        return null;
    }

    /**
     * Registra un nuevo usuario con su perfil (1:1) y asigna su rol en una transacción atómica.
     */
    public boolean registrar(Usuario u, Perfil p, int rolId) throws SQLException {
        String sqlUsuario = "INSERT INTO usuario (correo, password_hash, estado, id_inmobiliaria) VALUES (?, ?, 'ACTIVO', ?)";
        String sqlPerfil = "INSERT INTO perfil (id_usuario, nombres, apellidos, documento_identidad, telefono, direccion) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlRol = "INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int idUsuario;
            try (PreparedStatement psU = conn.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS)) {
                psU.setString(1, u.getCorreo());
                psU.setString(2, u.getPasswordHash());
                if (u.getIdInmobiliaria() != null && u.getIdInmobiliaria() > 0) {
                    psU.setInt(3, u.getIdInmobiliaria());
                } else {
                    psU.setNull(3, Types.INTEGER);
                }
                psU.executeUpdate();
                try (ResultSet keys = psU.getGeneratedKeys()) {
                    if (keys.next()) {
                        idUsuario = keys.getInt(1);
                        u.setId(idUsuario);
                    } else {
                        throw new SQLException("No se pudo obtener el ID del usuario insertado.");
                    }
                }
            }

            try (PreparedStatement psP = conn.prepareStatement(sqlPerfil)) {
                psP.setInt(1, idUsuario);
                psP.setString(2, p.getNombres());
                psP.setString(3, p.getApellidos());
                psP.setString(4, p.getDocumentoIdentidad());
                psP.setString(5, p.getTelefono());
                psP.setString(6, p.getDireccion());
                psP.executeUpdate();
            }

            try (PreparedStatement psR = conn.prepareStatement(sqlRol)) {
                psR.setInt(1, idUsuario);
                psR.setInt(2, rolId);
                psR.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignored */ }
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { /* ignored */ }
            }
        }
    }

    public List<Usuario> listarTodos() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.id, u.correo, u.password_hash, u.estado, u.id_inmobiliaria, u.fecha_registro, " +
                     "p.id AS perfil_id, p.nombres, p.apellidos, p.documento_identidad, p.telefono, p.direccion, p.foto_url " +
                     "FROM usuario u " +
                     "LEFT JOIN perfil p ON u.id = p.id_usuario " +
                     "ORDER BY u.id ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario u = mapUsuario(rs);
                cargarRoles(conn, u);
                lista.add(u);
            }
        }
        return lista;
    }

    public void actualizarEstado(int idUsuario, String estado) throws SQLException {
        String sql = "UPDATE usuario SET estado = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
        }
    }

    public void asignarRol(int idUsuario, int idRol) throws SQLException {
        String sql = "INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idRol);
            ps.executeUpdate();
        }
    }

    public void removerRol(int idUsuario, int idRol) throws SQLException {
        String sql = "DELETE FROM usuario_rol WHERE id_usuario = ? AND id_rol = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idRol);
            ps.executeUpdate();
        }
    }

    public List<Rol> listarRoles() throws SQLException {
        List<Rol> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, descripcion FROM rol ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Rol(rs.getInt("id"), rs.getString("nombre"), rs.getString("descripcion")));
            }
        }
        return lista;
    }

    private void cargarRoles(Connection conn, Usuario u) throws SQLException {
        String sql = "SELECT r.id, r.nombre, r.descripcion " +
                     "FROM rol r " +
                     "INNER JOIN usuario_rol ur ON r.id = ur.id_rol " +
                     "WHERE ur.id_usuario = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u.getId());
            try (ResultSet rs = ps.executeQuery()) {
                List<Rol> roles = new ArrayList<>();
                while (rs.next()) {
                    roles.add(new Rol(rs.getInt("id"), rs.getString("nombre"), rs.getString("descripcion")));
                }
                u.setRoles(roles);
            }
        }
    }

    private Usuario mapUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setCorreo(rs.getString("correo"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setEstado(rs.getString("estado"));
        int inmob = rs.getInt("id_inmobiliaria");
        if (!rs.wasNull()) {
            u.setIdInmobiliaria(inmob);
        }
        Timestamp reg = rs.getTimestamp("fecha_registro");
        if (reg != null) u.setFechaRegistro(reg.toLocalDateTime());

        if (rs.getInt("perfil_id") > 0) {
            Perfil p = new Perfil();
            p.setId(rs.getInt("perfil_id"));
            p.setIdUsuario(u.getId());
            p.setNombres(rs.getString("nombres"));
            p.setApellidos(rs.getString("apellidos"));
            p.setDocumentoIdentidad(rs.getString("documento_identidad"));
            p.setTelefono(rs.getString("telefono"));
            p.setDireccion(rs.getString("direccion"));
            p.setFotoUrl(rs.getString("foto_url"));
            u.setPerfil(p);
        }
        return u;
    }
}
