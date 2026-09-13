package com.inmobiliaria.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Usuario {
    private int id;
    private String correo;
    private String passwordHash;
    private String estado; // 'ACTIVO', 'INACTIVO', 'BLOQUEADO'
    private Integer idInmobiliaria;
    private LocalDateTime fechaRegistro;

    // Relaciones pedagógicas en POJO
    private Perfil perfil; // 1:1
    private List<Rol> roles = new ArrayList<>(); // N:M

    public Usuario() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public Integer getIdInmobiliaria() { return idInmobiliaria; }
    public void setIdInmobiliaria(Integer idInmobiliaria) { this.idInmobiliaria = idInmobiliaria; }
    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(LocalDateTime fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public Perfil getPerfil() { return perfil; }
    public void setPerfil(Perfil perfil) { this.perfil = perfil; }
    public List<Rol> getRoles() { return roles; }
    public void setRoles(List<Rol> roles) { this.roles = roles; }

    public boolean hasRol(String rolNombre) {
        if (roles == null || rolNombre == null) return false;
        for (Rol r : roles) {
            if (rolNombre.equalsIgnoreCase(r.getNombre())) {
                return true;
            }
        }
        return false;
    }
}
