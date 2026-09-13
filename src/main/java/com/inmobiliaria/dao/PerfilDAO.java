package com.inmobiliaria.dao;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.model.Perfil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PerfilDAO {

    public Perfil findByUsuarioId(int idUsuario) throws SQLException {
        String sql = "SELECT id, id_usuario, nombres, apellidos, documento_identidad, telefono, direccion, foto_url " +
                     "FROM perfil WHERE id_usuario = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Perfil p = new Perfil();
                    p.setId(rs.getInt("id"));
                    p.setIdUsuario(rs.getInt("id_usuario"));
                    p.setNombres(rs.getString("nombres"));
                    p.setApellidos(rs.getString("apellidos"));
                    p.setDocumentoIdentidad(rs.getString("documento_identidad"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setFotoUrl(rs.getString("foto_url"));
                    return p;
                }
            }
        }
        return null;
    }

    public boolean actualizar(Perfil p) throws SQLException {
        String sql = "UPDATE perfil SET nombres = ?, apellidos = ?, documento_identidad = ?, telefono = ?, direccion = ?, foto_url = ? " +
                     "WHERE id_usuario = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNombres());
            ps.setString(2, p.getApellidos());
            ps.setString(3, p.getDocumentoIdentidad());
            ps.setString(4, p.getTelefono());
            ps.setString(5, p.getDireccion());
            ps.setString(6, p.getFotoUrl());
            ps.setInt(7, p.getIdUsuario());
            return ps.executeUpdate() > 0;
        }
    }
}
