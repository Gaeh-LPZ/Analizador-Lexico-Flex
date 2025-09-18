package lexer;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException; class Main {

    public static void main(String[] args) {
        TablaSimbolo tsimb = null; // Tabla de símbolos vacía

        try {
            BufferedReader yyin = new BufferedReader(new FileReader("prueba2.c"));
            BufferedWriter tiraTokens = new BufferedWriter(new FileWriter("tiraTokens.txt"));
            BufferedWriter errores = new BufferedWriter(new FileWriter("errores.txt"));

            System.out.printf("%-10s%-20s%-10s%n", "No linea", "Lexema", "Token");
            tiraTokens.write(String.format("%-10s%-20s%-10s%n", "No linea", "Lexema", "Token"));
            errores.write(String.format("%-10s%-20s%n", "No linea", "Descripcion"));

            String linea;
            int numLinea = 1;

            // Simulación simple de lexer: separa palabras por espacio
            while ((linea = yyin.readLine()) != null) {
                String[] lexemas = linea.split("\\s+");
                for (String lexema : lexemas) {
                    // Todo lo que no sea número se considera identificador
                    if (!lexema.matches("\\d+")) {
                        if (AnalizadorLexico.buscar(tsimb, lexema) == null) {
                            tsimb = AnalizadorLexico.insertar(tsimb, lexema);
                        }
                        AnalizadorLexico.escribirTiraTokens(tiraTokens, numLinea, lexema, "IDENTIFICADOR");
                    } else {
                        AnalizadorLexico.escribirTiraTokens(tiraTokens, numLinea, lexema, "NUMERO");
                    }
                }
                numLinea++;
            }

            // Al final imprime la tabla de símbolos
            AnalizadorLexico.imprimir(tsimb);

            yyin.close();
            tiraTokens.close();
            errores.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
