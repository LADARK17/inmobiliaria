package com.inmobiliaria.model;

public class Caracteristica {
    private int id;
    private String nombre;
    private String icono;

    public Caracteristica() {}

    public Caracteristica(int id, String nombre, String icono) {
        this.id = id;
        this.nombre = nombre;
        this.icono = icono;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getIcono() { return icono; }
    public void setIcono(String icono) { this.icono = icono; }
}
