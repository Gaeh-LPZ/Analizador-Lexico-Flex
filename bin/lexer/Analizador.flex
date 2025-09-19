package lexer;
import java.util.ArrayList;
import java.util.List;
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

    // Listas en memoria
    private Tabla tablaSimbolos = null;
    private List<Object[]> listaTokens = new ArrayList<>();
    private List<Object[]> listaErrores = new ArrayList<>();

    private boolean simboloExiste(String simbolo) {
        Tabla actual = tablaSimbolos;
        while (actual != null) {
            if (actual.nombre.equals(simbolo)) return true;
            actual = actual.siguiente;
        }
        return false;
    }

    private void agregarSimbolo(String simbolo) {
        if (!simboloExiste(simbolo)) {
            Tabla nuevo = new Tabla(simbolo);
            nuevo.siguiente = tablaSimbolos;
            tablaSimbolos = nuevo;
        }
    }

    private void escribirTiraTokens(String token, String lexema){
        listaTokens.add(new Object[]{token, lexema, yyline + 1, yycolumn + 1});
    }

    private void escribirSimbolos(String simbolo){
        agregarSimbolo(simbolo);
    }

    private void escribirError(String lexema){
        listaErrores.add(new Object[]{"Error Lexico", lexema, yyline + 1, yycolumn + 1});
    }

    // Recuperar listas
    public List<Object[]> getTokens() {
        return listaTokens;
    }

    public List<Object[]> getErrores() {
        return listaErrores;
    }

    public List<Object[]> getSimbolos() {
        List<Object[]> result = new ArrayList<>();
        Tabla actual = tablaSimbolos;
        while (actual != null) {
            result.add(new Object[]{actual.nombre});
            actual = actual.siguiente;
        }
        return result;
    }

    public void limpiarArchivos() {
        listaTokens.clear();
        listaErrores.clear();
        tablaSimbolos = null;
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
{ESPACIO}+ {/* Ignorar */ }
{COMENTARIO} {/* Ignorar */}
{NUEVALINEA} {/* Ignorar */ }

// ----- IDENTIFICADORES (SIMBOLOS) -----//
{IDENTIFICADOR} {
    escribirTiraTokens("IDENTIFICADOR", yytext());
    escribirSimbolos(yytext());
}

// ----- LITERALES Y NUMEROS -----//
{NUMERO_ENTERO} { escribirTiraTokens("NUMERO_ENTERO", yytext()); }
{NUMERO_FLOTANTE} { escribirTiraTokens("NUMERO_FLOTANTE", yytext()); }
{LITERAL} { escribirTiraTokens("LITERAL", yytext()); }

// ----- ERRORES ----- //
. { escribirError(yytext()); }
