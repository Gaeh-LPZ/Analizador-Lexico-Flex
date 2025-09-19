%%
package lexer;

%class AnalizadorLexico     // Nombre de la clase resultante
%unicode                    // Trabajaremos con el formato unicode completo
%public                     // La clase generada sera publica
%final                      // La clase generada sera final y no se podra heredar
%line                      // Contador de linea
%column                    // Contador de columna
%type Token                 // regresa una clase de tipo "Token"
%standalone
%state COMENTARIO_BLOQUE

%{
    // Estructura para la tabla de símbolos
    public static class TablaSimbolos {
        String nombre;
        TablaSimbolos sig;
        
        public TablaSimbolos(String nombre) {
            this.nombre = nombre;
            this.sig = null;
        }
    }
    
    private TablaSimbolos tsimb = null;
    private PrintWriter tiraTokens = null;
    private PrintWriter errores = null;
    
    // Métodos para manejar la tabla de símbolos
    private void insertar(String nombre) {
        TablaSimbolos nuevo = new TablaSimbolos(nombre);
        nuevo.sig = tsimb;
        tsimb = nuevo;
    }
    
    private TablaSimbolos buscar(String nombre) {
        TablaSimbolos temp = tsimb;
        while (temp != null) {
            if (temp.nombre.equals(nombre)) {
                return temp;
            }
            temp = temp.sig;
        }
        return null;
    }
    
    private void imprimirTablaSimbolos() {
        System.out.println("\n=== TABLA DE SÍMBOLOS ===");
        TablaSimbolos temp = tsimb;
        int contador = 1;
        while (temp != null) {
            System.out.printf("%3d: %s\n", contador++, temp.nombre);
            temp = temp.sig;
        }
        if (contador == 1) {
            System.out.println("(vacía)");
        }
    }
    
    private void escribirTiraTokens(String token, String lexema) {
        if (tiraTokens != null) {
            tiraTokens.printf("%-10d%-30s%-20s\n", yyline + 1, lexema, token);
        }
    }
    
    private void escribirError(String descripcion) {
        if (errores != null) {
            errores.printf("Línea %-5d: %s\n", yyline + 1, descripcion);
        }
    }
    
    // Método inicializador para abrir archivos
    private void inicializarArchivos() throws IOException {
        tiraTokens = new PrintWriter(new FileWriter("tiraTokens.txt"));
        errores = new PrintWriter(new FileWriter("errores.txt"));
        
        // Encabezados
        System.out.printf("%-10s%-30s%-20s\n", "No. Línea", "Lexema", "Token");
        System.out.println("-".repeat(60));
        
        tiraTokens.printf("%-10s%-30s%-20s\n", "No. Línea", "Lexema", "Token");
        tiraTokens.println("-".repeat(60));
        
        errores.println("=== ERRORES LÉXICOS ===");
        errores.println("-".repeat(40));
    }
    
    // Método para cerrar archivos
    private void cerrarArchivos() {
        if (tiraTokens != null) {
            tiraTokens.close();
        }
        if (errores != null) {
            errores.close();
        }
    }
%}


/* ------ EXPRESIONES REGULARES ----- */
letra     =      [a-zA-Z]
digito    =      [0-9]
espacio   =      [ \t\n\r]
identificador =  {letra}({letra}|{digito})*
nint      =      {digito}+
nfloat    =      {digito}+(\.{digito}+)?
literal   =      \"(\\.|[^\\"])*\"
comentario =     "//".*
literalcaracter = '([^'\\]|\\.)'

%%

/* --------- Palabras Reservadas ------ */
"abstract"       { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "ABSTRACT");
                   escribirTiraTokens("ABSTRACT", yytext()); }
"assert"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "ASSERT");
                   escribirTiraTokens("ASSERT", yytext()); }
"boolean"        { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "BOOLEAN");
                   escribirTiraTokens("BOOLEAN", yytext()); }
"break"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "BREAK");
                   escribirTiraTokens("BREAK", yytext()); }
"byte"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "BYTE");
                   escribirTiraTokens("BYTE", yytext()); }
"case"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "CASE");
                   escribirTiraTokens("CASE", yytext()); }
"catch"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "CATCH");
                   escribirTiraTokens("CATCH", yytext()); }
"char"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "CHAR");
                   escribirTiraTokens("CHAR", yytext()); }
"class"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "CLASS");
                   escribirTiraTokens("CLASS", yytext()); }
"const"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "CONST");
                   escribirTiraTokens("CONST", yytext()); }
"continue"       { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "CONTINUE");
                   escribirTiraTokens("CONTINUE", yytext()); }
"default"        { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "DEFAULT");
                   escribirTiraTokens("DEFAULT", yytext()); }
"do"             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "DO");
                   escribirTiraTokens("DO", yytext()); }
"double"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "DOUBLE");
                   escribirTiraTokens("DOUBLE", yytext()); }
"else"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "ELSE");
                   escribirTiraTokens("ELSE", yytext()); }
"enum"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "ENUM");
                   escribirTiraTokens("ENUM", yytext()); }
"extends"        { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "EXTENDS");
                   escribirTiraTokens("EXTENDS", yytext()); }
"final"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "FINAL");
                   escribirTiraTokens("FINAL", yytext()); }
"finally"        { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "FINALLY");
                   escribirTiraTokens("FINALLY", yytext()); }
"float"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "FLOAT");
                   escribirTiraTokens("FLOAT", yytext()); }
"for"            { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "FOR");
                   escribirTiraTokens("FOR", yytext()); }
"goto"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "GOTO");
                   escribirTiraTokens("GOTO", yytext()); }
"if"             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "IF");
                   escribirTiraTokens("IF", yytext()); }
"implements"     { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "IMPLEMENTS");
                   escribirTiraTokens("IMPLEMENTS", yytext()); }
"import"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "IMPORT");
                   escribirTiraTokens("IMPORT", yytext()); }
"instanceof"     { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "INSTANCEOF");
                   escribirTiraTokens("INSTANCEOF", yytext()); }
"int"            { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "INT");
                   escribirTiraTokens("INT", yytext()); }
"interface"      { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "INTERFACE");
                   escribirTiraTokens("INTERFACE", yytext()); }
"long"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "LONG");
                   escribirTiraTokens("LONG", yytext()); }
"native"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "NATIVE");
                   escribirTiraTokens("NATIVE", yytext()); }
"new"            { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "NEW");
                   escribirTiraTokens("NEW", yytext()); }
"package"        { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "PACKAGE");
                   escribirTiraTokens("PACKAGE", yytext()); }
"private"        { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "PRIVATE");
                   escribirTiraTokens("PRIVATE", yytext()); }
"protected"      { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "PROTECTED");
                   escribirTiraTokens("PROTECTED", yytext()); }
"public"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "PUBLIC");
                   escribirTiraTokens("PUBLIC", yytext()); }
"return"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "RETURN");
                   escribirTiraTokens("RETURN", yytext()); }
"short"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "SHORT");
                   escribirTiraTokens("SHORT", yytext()); }
"static"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "STATIC");
                   escribirTiraTokens("STATIC", yytext()); }
"strictfp"       { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "STRICTFP");
                   escribirTiraTokens("STRICTFP", yytext()); }
"super"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "SUPER");
                   escribirTiraTokens("SUPER", yytext()); }
"switch"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "SWITCH");
                   escribirTiraTokens("SWITCH", yytext()); }
"synchronized"   { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "SYNCHRONIZED");
                   escribirTiraTokens("SYNCHRONIZED", yytext()); }
"this"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "THIS");
                   escribirTiraTokens("THIS", yytext()); }
"throw"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "THROW");
                   escribirTiraTokens("THROW", yytext()); }
"throws"         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "THROWS");
                   escribirTiraTokens("THROWS", yytext()); }
"transient"      { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "TRANSIENT");
                   escribirTiraTokens("TRANSIENT", yytext()); }
"try"            { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "TRY");
                   escribirTiraTokens("TRY", yytext()); }
"void"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "VOID");
                   escribirTiraTokens("VOID", yytext()); }
"volatile"       { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "VOLATILE");
                   escribirTiraTokens("VOLATILE", yytext()); }
"while"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "WHILE");
                   escribirTiraTokens("WHILE", yytext()); }

// Valores literales especiales
"true"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "TRUE");
                   escribirTiraTokens("TRUE", yytext()); }
"false"          { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "FALSE");
                   escribirTiraTokens("FALSE", yytext()); }
"null"           { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "NULL");
                   escribirTiraTokens("NULL", yytext()); }

// === OPERADORES ===
// Operadores aritméticos
"+"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_SUMA");
                   escribirTiraTokens("OP_SUMA", yytext()); }
"-"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_RESTA");
                   escribirTiraTokens("OP_RESTA", yytext()); }
"*"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_MULT");
                   escribirTiraTokens("OP_MULT", yytext()); }
"/"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_DIV");
                   escribirTiraTokens("OP_DIV", yytext()); }
"%"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_MOD");
                   escribirTiraTokens("OP_MOD", yytext()); }
"++"             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_INCR");
                   escribirTiraTokens("OP_INCR", yytext()); }
"--"             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_DECR");
                   escribirTiraTokens("OP_DECR", yytext()); }

// Operadores de asignación
"="              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_ASIG");
                   escribirTiraTokens("OP_ASIG", yytext()); }
"+="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_ASIG_SUMA");
                   escribirTiraTokens("OP_ASIG_SUMA", yytext()); }
"-="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_ASIG_RESTA");
                   escribirTiraTokens("OP_ASIG_RESTA", yytext()); }
"*="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_ASIG_MULT");
                   escribirTiraTokens("OP_ASIG_MULT", yytext()); }
"/="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_ASIG_DIV");
                   escribirTiraTokens("OP_ASIG_DIV", yytext()); }
"%="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_ASIG_MOD");
                   escribirTiraTokens("OP_ASIG_MOD", yytext()); }

// Operadores relacionales
"=="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_IGUAL");
                   escribirTiraTokens("OP_IGUAL", yytext()); }
"!="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_DIF");
                   escribirTiraTokens("OP_DIF", yytext()); }
"<"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_MENOR");
                   escribirTiraTokens("OP_MENOR", yytext()); }
">"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_MAYOR");
                   escribirTiraTokens("OP_MAYOR", yytext()); }
"<="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_MENOR_IGUAL");
                   escribirTiraTokens("OP_MENOR_IGUAL", yytext()); }
">="             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_MAYOR_IGUAL");
                   escribirTiraTokens("OP_MAYOR_IGUAL", yytext()); }

// Operadores lógicos
"&&"             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_AND");
                   escribirTiraTokens("OP_AND", yytext()); }
"||"             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_OR");
                   escribirTiraTokens("OP_OR", yytext()); }
"!"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_NOT");
                   escribirTiraTokens("OP_NOT", yytext()); }

// Operadores de bits
"&"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_BIT_AND");
                   escribirTiraTokens("OP_BIT_AND", yytext()); }
"|"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_BIT_OR");
                   escribirTiraTokens("OP_BIT_OR", yytext()); }
"^"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_BIT_XOR");
                   escribirTiraTokens("OP_BIT_XOR", yytext()); }
"~"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_BIT_NOT");
                   escribirTiraTokens("OP_BIT_NOT", yytext()); }
"<<"             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_SHIFT_IZQ");
                   escribirTiraTokens("OP_SHIFT_IZQ", yytext()); }
">>"             { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_SHIFT_DER");
                   escribirTiraTokens("OP_SHIFT_DER", yytext()); }
">>>"            { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_SHIFT_DER_ZERO");
                   escribirTiraTokens("OP_SHIFT_DER_ZERO", yytext()); }

// Operador ternario
"?"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "OP_TERNARIO");
                   escribirTiraTokens("OP_TERNARIO", yytext()); }
":"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "DOS_PUNTOS");
                   escribirTiraTokens("DOS_PUNTOS", yytext()); }

// === SÍMBOLOS DE PUNTUACIÓN ===
"("              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "PAR_IZQ");
                   escribirTiraTokens("PAR_IZQ", yytext()); }
")"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "PAR_DER");
                   escribirTiraTokens("PAR_DER", yytext()); }
"{"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "LLAVE_IZQ");
                   escribirTiraTokens("LLAVE_IZQ", yytext()); }
"}"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "LLAVE_DER");
                   escribirTiraTokens("LLAVE_DER", yytext()); }
"["              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "CORCH_IZQ");
                   escribirTiraTokens("CORCH_IZQ", yytext()); }
"]"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "CORCH_DER");
                   escribirTiraTokens("CORCH_DER", yytext()); }
";"              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "PUNTO_COMA");
                   escribirTiraTokens("PUNTO_COMA", yytext()); }
","              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "COMA");
                   escribirTiraTokens("COMA", yytext()); }
"."              { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "PUNTO");
                   escribirTiraTokens("PUNTO", yytext()); }

// === LITERALES E IDENTIFICADORES ===
{identificador}  { 
    System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "IDENTIFICADOR");
    escribirTiraTokens("IDENTIFICADOR", yytext());
    
    // Agregar a la tabla de símbolos si no existe
    TablaSimbolos temp = buscar(yytext());
    if (temp == null) {
        insertar(yytext());
    }
}

{nint}         { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "LIT_ENTERO");
                   escribirTiraTokens("LIT_ENTERO", yytext()); }

{nfloat}        { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "LIT_DECIMAL");
                   escribirTiraTokens("LIT_DECIMAL", yytext()); }

{literal}  { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "LIT_CADENA");
                   escribirTiraTokens("LIT_CADENA", yytext()); }

{literalcaracter} { System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "LIT_CARACTER");
                    escribirTiraTokens("LIT_CARACTER", yytext()); }

// === COMENTARIOS ===
{comentario}  { /* Ignorar comentarios de línea */ }

"/*"             { yybegin(COMENTARIO_BLOQUE); }

// === ESPACIOS EN BLANCO ===
{espacio}  { /* Ignorar espacios en blanco */ }

// === MANEJO DE ERRORES ===
.                { 
    System.out.printf("%-10d%-30s%-20s\n", yyline + 1, yytext(), "ERROR_LEXICO");
    escribirError("Símbolo no reconocido: '" + yytext() + "'");
}

// === ESTADO PARA COMENTARIOS DE BLOQUE ===
<COMENTARIO_BLOQUE> {
    "*/"         { yybegin(YYINITIAL); }
    [^*\n]+      { /* Ignorar contenido */ }
    "*"          { /* Ignorar asterisco */ }
    \n           { /* Ignorar salto de línea */ }
}

%%

// === MÉTODO PRINCIPAL ===
public static void main(String[] args) {
    if (args.length != 1) {
        System.err.println("Uso: java AnalizadorLexicoJava <archivo.java>");
        System.err.println("Ejemplo: java AnalizadorLexicoJava MiPrograma.java");
        System.exit(1);
    }
    
    File archivo = new File(args[0]);
    if (!archivo.exists()) {
        System.err.println("Error: El archivo '" + args[0] + "' no existe.");
        System.exit(1);
    }
    
    if (!archivo.canRead()) {
        System.err.println("Error: No se puede leer el archivo '" + args[0] + "'.");
        System.exit(1);
    }
    
    try {
        System.out.println("=== ANALIZADOR LÉXICO PARA JAVA ===");
        System.out.println("Archivo de entrada: " + args[0]);
        System.out.println("-".repeat(60));
        
        AnalizadorLexicoJava scanner = new AnalizadorLexicoJava(new FileReader(archivo));
        scanner.inicializarArchivos();
        
        // Ejecutar el análisis léxico
        while (!scanner.zzAtEOF) {
            scanner.yylex();
        }
        
        // Imprimir tabla de símbolos
        scanner.imprimirTablaSimbolos();
        
        // Cerrar archivos
        scanner.cerrarArchivos();
        
        System.out.println("\n=== ANÁLISIS COMPLETADO ===");
        System.out.println("Archivo de tokens generado: tiraTokens.txt");
        System.out.println("Archivo de errores generado: errores.txt");
        
    } catch (FileNotFoundException e) {
        System.err.println("Error: No se pudo encontrar el archivo: " + e.getMessage());
    } catch (IOException e) {
        System.err.println("Error de E/S: " + e.getMessage());
    } catch (Exception e) {
        System.err.println("Error inesperado: " + e.getMessage());
        e.printStackTrace();
    }
}