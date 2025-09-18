%%
package lexer;

%class AnalizadorLexico     // Nombre de la clase resultante
%unicode                    // Trabajaremos con el formato unicode completo
%public                     // La clase generada sera publica
%final                      // La clase generada sera final y no se podra heredar
%linea                      // Contador de linea
%columna                    // Contador de columna
%type Token                 // regresa una clase de tipo "Token"

/* ------ EXPRESIONES REGULARES ----- */
letra     =      [a-zA-Z]
digito    =      [0-9]
espacio   =      [ \t\n\r]
identificador =  {letra}({letra}|{digito})*
nint      =      {digito}+
nfloat    =      {digito}+(\.{digito}+)?
literal   =      \"(\\.|[^\\"])*\"