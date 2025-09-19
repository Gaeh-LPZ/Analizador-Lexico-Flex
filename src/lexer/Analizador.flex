package lexer;
import java.io.FileWriter;
import java.io.IOException;

%%

%class Analizador
%public
%line
%column
%type void
%eofval{
    return;
%eofval}

%{
    public class Tabla{
        String nombre;
        Tabla siguiente;

        public Tabla(String nombre){
            this.nombre = nombre;
            this.siguiente = null;
        }
    }
    
    // Lista enlazada para almacenar símbolos únicos
    private Tabla tablaSimbolos = null;
    
    // Método para verificar si un símbolo ya existe
    private boolean simboloExiste(String simbolo) {
        Tabla actual = tablaSimbolos;
        while (actual != null) {
            if (actual.nombre.equals(simbolo)) {
                return true;
            }
            actual = actual.siguiente;
        }
        return false;
    }
    
    // Método para agregar un símbolo a la lista si no existe
    private void agregarSimbolo(String simbolo) {
        if (!simboloExiste(simbolo)) {
            Tabla nuevoSimbolo = new Tabla(simbolo);
            nuevoSimbolo.siguiente = tablaSimbolos;
            tablaSimbolos = nuevoSimbolo;
        }
    }

    private void escribirTiraTokens(String token, String lexema){
        try{
            FileWriter archivo = new FileWriter("tablaTokens.txt", true);
            archivo.write(String.format("%-15s %-20s Linea: %-5d Columna: %-5d\n", token, lexema, yyline + 1, yycolumn + 1));
            archivo.close();
        } catch (IOException e) {
            System.err.println("Error al escribir en la tabla de tokens: " + e.getMessage());
        }
    }

    private void escribirSimbolos(String simbolo){
        // Solo agregar a la lista si es nuevo
        agregarSimbolo(simbolo);
    }
    
    // Método para escribir todos los símbolos únicos al archivo
    public void escribirTablaSimbolos() {
        try {
            FileWriter archivo = new FileWriter("tablaSimbolos.txt", true);
            
            Tabla actual = tablaSimbolos;
            while (actual != null) {
                archivo.write(String.format("%-20s\n", actual.nombre));
                actual = actual.siguiente;
            }
            
            archivo.close();
        } catch (IOException e) {
            System.err.println("Error al escribir la tabla de símbolos: " + e.getMessage());
        }
    }

    private void escribirError(String lexema){
        try {
            FileWriter archivo = new FileWriter("tablaErrores.txt", true);
            archivo.write(String.format("Error Lexico: '%s' en linea %d, columna %d\n", lexema, yyline + 1, yycolumn + 1));
            archivo.close();
        } catch (IOException e) {
            System.err.println("Error al escribir en la tabla de errores: " + e.getMessage());
        }
    }

    public void limpiarArchivos() {
        try {
            // Limpiar tabla de tokens
            FileWriter archivo1 = new FileWriter("tablaTokens.txt", false);
            archivo1.write("=== TABLA DE TOKENS ===\n");
            archivo1.write(String.format("%-15s %-20s %-20s\n", "TOKEN", "LEXEMA", "POSICION"));
            archivo1.write("==================================================\n");
            archivo1.close();
            
            // Limpiar tabla de símbolos
            FileWriter archivo2 = new FileWriter("tablaSimbolos.txt", false);
            archivo2.write("=== TABLA DE SIMBOLOS ===\n");
            archivo2.write(String.format("%-20s\n", "SIMBOLO"));
            archivo2.write("====================\n");
            archivo2.close();
            
            // Limpiar tabla de errores
            FileWriter archivo3 = new FileWriter("tablaErrores.txt", false);
            archivo3.write("=== TABLA DE ERRORES ===\n");
            archivo3.close();
            
            // Limpiar la lista de símbolos en memoria
            tablaSimbolos = null;
            
        } catch (IOException e) {
            System.err.println("Error al limpiar archivos: " + e.getMessage());
        }
    }
%}

// ---- EXPRESIONES REGULARES ---- //
LETRA = [a-zA-Z]
DIGITO = [0-9]
ESPACIO = [ \t\r]
NUEVALINEA = \n
IDENTIFICADOR = {LETRA}({LETRA}|{DIGITO})*
NUMERO_ENTERO = {DIGITO}+
NUMERO_FLOTANTE = {DIGITO}+(\.{DIGITO}+)?
LITERAL = \"([^\\\"]|\\.)*\"
COMENTARIO = "//".*

%%

// ----- OPERADORES DE ASIGNACION -----//
"+=" { escribirTiraTokens("ASIG_SUMA", yytext()); }

"-=" { escribirTiraTokens("ASIG_RESTA", yytext()); }

"/=" { escribirTiraTokens("ASIG_DIV", yytext()); }

"*=" { escribirTiraTokens("ASIG_MULT", yytext()); }

"++" { escribirTiraTokens("INCREMENTO", yytext()); }

"--" { escribirTiraTokens("DECREMENTO", yytext()); }

// ----- PALABRAS RESERVADAS -----//
"int" { escribirTiraTokens("INT", yytext()); }

"public" { escribirTiraTokens("PUBLIC", yytext()); }

"class" { escribirTiraTokens("CLASS", yytext()); }

"static" { escribirTiraTokens("STATIC", yytext()); }

"if" { escribirTiraTokens("IF", yytext()); }

"for" { escribirTiraTokens("FOR", yytext()); }

"while" { escribirTiraTokens("WHILE", yytext()); }

"boolean" { escribirTiraTokens("BOOLEAN", yytext()); }

"float" { escribirTiraTokens("FLOAT", yytext()); }

"main" { escribirTiraTokens("MAIN", yytext()); }

"System" { escribirTiraTokens("SYSTEM", yytext()); }

"out" { escribirTiraTokens("OUT", yytext()); }

"println" { escribirTiraTokens("PRINTLN", yytext()); }

"String" { escribirTiraTokens("STRING", yytext()); }

"void" { escribirTiraTokens("VOID", yytext()); }

"do" { escribirTiraTokens("DO", yytext()); }

"else" { escribirTiraTokens("ELSE", yytext()); }

// ----- DELIMITADORES -----//
"{" { escribirTiraTokens("LLAVE_IZQ", yytext()); }

"}" { escribirTiraTokens("LLAVE_DER", yytext()); }

";" { escribirTiraTokens("PUNTO_COMA", yytext()); }

"." { escribirTiraTokens("PUNTO", yytext()); }

"[" { escribirTiraTokens("CORCHETE_IZQ", yytext()); }

"]" { escribirTiraTokens("CORCHETE_DER", yytext()); }

"(" { escribirTiraTokens("PARENTESIS_IZQ", yytext()); }

")" { escribirTiraTokens("PARENTESIS_DER", yytext()); }

// ----- OPERADORES ARITMETICOS -----//
"+" { escribirTiraTokens("SUMA", yytext()); }

"-" { escribirTiraTokens("RESTA", yytext()); }

"/" { escribirTiraTokens("DIVISION", yytext()); }

"%" { escribirTiraTokens("MODULO", yytext()); }

"*" { escribirTiraTokens("MULTIPLICACION", yytext()); }

"=" { escribirTiraTokens("ASIGNACION", yytext()); }

// ----- OPERADORES LOGICOS -----//
"&&" { escribirTiraTokens("AND", yytext()); }

"||" { escribirTiraTokens("OR", yytext()); }

"!" { escribirTiraTokens("NOT", yytext()); }

// ----- ESPACIOS Y COMENTARIOS ------ //
{ESPACIO}+ {/* No retornamos ninguna cadena */}

{COMENTARIO} {/* Ignoramos los comentarios */}

{NUEVALINEA} {/* Ignoramos las lineas nuevas */}

// ----- IDENTIFICADORES (SIMBOLOS) -----//
{IDENTIFICADOR} {
    escribirTiraTokens("IDENTIFICADOR", yytext());
    escribirSimbolos(yytext());
}

// ----- LITERALES Y NUMEROS -----//
{NUMERO_ENTERO} {
    escribirTiraTokens("NUMERO_ENTERO", yytext());
}

{NUMERO_FLOTANTE} {
    escribirTiraTokens("NUMERO_FLOTANTE", yytext());
}

{LITERAL} {
    escribirTiraTokens("LITERAL", yytext());
}

// ----- ERRORES ----- //
. {
    escribirError(yytext());
}
