package com.inmobiliaria.model;

/**
 * Representa una imagen asociada a una propiedad (Relación 1:N).
 */
public class ImagenPropiedad {
    private int id;
    private int idPropiedad;
    private String urlImagen;
    private int orden;
    private boolean esPrincipal;
    private String descripcion;

    public ImagenPropiedad() {}

    public ImagenPropiedad(int id, int idPropiedad, String urlImagen, int orden, boolean esPrincipal, String descripcion) {
        this.id = id;
        this.idPropiedad = idPropiedad;
        this.urlImagen = urlImagen;
        this.orden = orden;
        this.esPrincipal = esPrincipal;
        this.descripcion = descripcion;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }
    public String getUrlImagen() { return urlImagen; }
    public void setUrlImagen(String urlImagen) { this.urlImagen = urlImagen; }
    public int getOrden() { return orden; }
    public void setOrden(int orden) { this.orden = orden; }
    public boolean isEsPrincipal() { return esPrincipal; }
    public void setEsPrincipal(boolean esPrincipal) { this.esPrincipal = esPrincipal; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}
