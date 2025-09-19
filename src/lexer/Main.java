package com.lexer;

import java.io.FileReader;
import java.io.IOException;
import java.io.StringReader;

public class Main {
    
    public static void main(String[] args) {
        try {
            // Crear instancia del analizador
            Analizador lexer;
            
            // Decidir si leer desde archivo o desde String
            if (args.length > 0) {
                // Leer desde archivo
                System.out.println("Analizando archivo: " + args[0]);
                FileReader archivo = new FileReader(args[0]);
                lexer = new Analizador(archivo);
            } else {
                // Código de ejemplo para probar
                String codigoEjemplo = """
                    public class MiClase {
                        int numero = 42;
                        float decimal = 3.14;
                        boolean activo = true;
                        String mensaje = "Hola mundo";
                        
                        public static void main() {
                            if (activo) {
                                for (int i = 0; i < 10; i++) {
                                    // Este es un comentario
                                    System.out.println(mensaje);
                                }
                            }
                        }
                    }
                    """;
                
                System.out.println("Analizando código de ejemplo:");
                System.out.println("================================");
                System.out.println(codigoEjemplo);
                System.out.println("================================");
                
                StringReader stringReader = new StringReader(codigoEjemplo);
                lexer = new Analizador(stringReader);
            }
            
            // Limpiar archivos antes de empezar
            lexer.limpiarArchivos();
            
            System.out.println("Iniciando análisis léxico...");
            System.out.println("Generando archivos: tablaTokens.txt, tablaSimbolos.txt y tablaErrores.txt");
            
            // Procesar todos los tokens
            try {
                lexer.yylex(); // Como yylex() es void, procesa todo el archivo de una vez
                
                // Escribir la tabla de símbolos únicos al final
                lexer.escribirTablaSimbolos();
                
                System.out.println("Análisis completado exitosamente.");
            } catch (Exception e) {
                System.err.println("Error durante el análisis: " + e.getMessage());
                e.printStackTrace();
            }
            
            System.out.println("\n=== ANÁLISIS TERMINADO ===");
            System.out.println("Revisa los archivos generados:");
            System.out.println("- tablaTokens.txt: Todos los tokens encontrados");
            System.out.println("- tablaSimbolos.txt: Variables e identificadores");
            System.out.println("- tablaErrores.txt: Errores léxicos");
            
        } catch (IOException e) {
            System.err.println("Error al leer el archivo: " + e.getMessage());
            System.out.println("\nUso:");
            System.out.println("  java com.lexer.Main [archivo.txt]");
            System.out.println("  java com.lexer.Main (para usar código de ejemplo)");
        }
    }
}