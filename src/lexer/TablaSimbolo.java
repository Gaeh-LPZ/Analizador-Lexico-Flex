package lexer;

public class TablaSimbolo {
    public String nombre;
    public TablaSimbolo siguiente;

    public TablaSimbolo(String nombre) {
        this.nombre = nombre;
        this.siguiente = null;
    }
}
