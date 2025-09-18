package lexer;

import java.io.BufferedWriter;
import java.io.IOException;

public class AnalizadorLexico {

    // Buscar un identificador en la tabla de símbolos
    public static TablaSimbolo buscar(TablaSimbolo tsimb, String nombre) {
        while (tsimb != null && !tsimb.nombre.equals(nombre)) {
            tsimb = tsimb.siguiente;
        }
        return tsimb; // devuelve null si no lo encuentra
    }

    // Insertar un nuevo identificador en la tabla (al inicio)
    public static TablaSimbolo insertar(TablaSimbolo tsimb, String nombre) {
        TablaSimbolo nuevo = new TablaSimbolo(nombre);
        nuevo.siguiente = tsimb;
        return nuevo; // devuelve la nueva cabeza de la lista
    }

    // Imprimir toda la tabla de símbolos
    public static void imprimir(TablaSimbolo tsimb) {
        System.out.println("\n\nTabla de símbolos:");
        while (tsimb != null) {
            System.out.println(tsimb.nombre);
            tsimb = tsimb.siguiente;
        }
    }

    // Escribir tokens en archivo
    public static void escribirTiraTokens(BufferedWriter tiraTokens, int numLinea, String lexema, String token) throws IOException {
        tiraTokens.write(String.format("%-10d%-20s%-10s%n", numLinea, lexema, token));
    }

    // Escribir errores en archivo
    public static void escribirError(BufferedWriter errores, int numLinea, String lexema) throws IOException {
        errores.write(String.format("%-10d%-20s%-10s%n", numLinea, "Error léxico", lexema));
    }
}
