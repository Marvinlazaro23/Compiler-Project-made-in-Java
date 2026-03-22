/* --------------------------------------------------------------------------
   Lexer.flex (modificado)
   - Identificadores ahora no pueden contener “ll” ni “rr” (en minúscula o mayúscula).
   -------------------------------------------------------------------------- */
package codigo;
import static codigo.Tokens.*;
%%
%class Lexer
%type Tokens

/* Macros originales para letras, dígitos, operadores, etc. */
L=[a-zA-Z_]+
D=[0-9]+
Operador=[*+/-]
Agrupacion=[( ) { } ,]
espacio=[ \t\r\n]+

%{
    public String lexeme;
%}
%%

/* 1) Ignorar espacios y tabs */
{espacio}               { /* nada: ignorar */ }
"//"(.)*                { /* ignorar comentario hasta fin de línea */ }

/* 2) Comillas y literales de cadena */
"\""                    { lexeme = yytext(); return Comillas; }
/* Cadena completa entre comillas: */
"\"" ({L}|{D}|{Operador}|{Agrupacion})* "\"" {
    lexeme = yytext();
    return Cadena;
}

/* 3) Tipos de datos */
(byte|int|char|long|float|double|string) {
    lexeme = yytext();
    /* Si quieres distinguir “int” como token separado Int, cámbialo: */
    if (yytext().equals("int")) {
        return Int;
    } else {
        return T_dato;
    }
}

/* 4) Palabras reservadas */
"INICIO"                { lexeme = yytext(); return INICIO; }
"FIN"                   { lexeme = yytext(); return FIN; }
"Var"                   { lexeme = yytext(); return Var; }
"LEER"                  { lexeme = yytext(); return LEER; }
"IMPRIMIR"              { lexeme = yytext(); return IMPRIMIR; }
"Repetir"               { lexeme = yytext(); return Repetir; }
"Hasta"                 { lexeme = yytext(); return Hasta; }
"Hacer"                 { lexeme = yytext(); return Hacer; }
"Fin_repetir"           { lexeme = yytext(); return Fin_repetir; }
"Mientras"              { lexeme = yytext(); return Mientras; }
"Fin_mientras"          { lexeme = yytext(); return Fin_mientras; }
"Si"                    { lexeme = yytext(); return Si; }
"Entonces"              { lexeme = yytext(); return Entonces; }
"Sino"                  { lexeme = yytext(); return Sino; }
"Fin_si"                { lexeme = yytext(); return Fin_si; }

/* 5) Constantes */
(true|false)            { lexeme = yytext(); return Op_booleano; }
"NULL"                  { lexeme = yytext(); return NULL; }
"PI"                    { lexeme = yytext(); return PI; }
"MAX_INT"               { lexeme = yytext(); return MAX_INT; }

/* 6) Operadores relacionales */
(">="|"<="|"=="|"!="|">"|"<") {
    lexeme = yytext();
    return Op_relacional;
}

/* 7) Incremento / decremento */
("++"|"--")             { lexeme = yytext(); return Op_incremento; }

/* 8) Fin de línea (cuenta líneas) */
"\n"                    { return Linea; }

/* 9) Asignación y operadores aritméticos básicos */
"="                     { lexeme = yytext(); return Igual; }
"+"                     { lexeme = yytext(); return Suma; }
"-"                     { lexeme = yytext(); return Resta; }
"*"                     { lexeme = yytext(); return Multiplicacion; }
"/"                     { lexeme = yytext(); return Division; }

/* 10) Paréntesis y llaves */
"("                     { lexeme = yytext(); return Parentesis_a; }
")"                     { lexeme = yytext(); return Parentesis_c; }
"{"                     { lexeme = yytext(); return Llave_a; }
"}"                     { lexeme = yytext(); return Llave_c; }

/* 11) Punto y coma */
";"                     { lexeme = yytext(); return P_coma; }

/* --------------------------------------------------------------------------
   12) IDENTIFICADOR (modificado para no permitir “ll” ni “rr”)
   - Patrón: {L}({L}|{D})* 
   - En la acción, comprobamos el lexema y devolvemos ERROR si existe
     “ll” o “rr” (en cualquier combinación de mayúsculas/minúsculas).
   -------------------------------------------------------------------------- */
{L}({L}|{D})*            {
    lexeme = yytext();
    String lower = lexeme.toLowerCase();

    // Si contiene “ll” o “rr” → ERROR léxico
    if (lower.contains("ll") || lower.contains("rr")) {
        return ERROR;
    }
    // Si todo está bien, devolvemos identificador
    return Identificador;
}

/* 13) Números enteros */
("(-"{D}+")")|{D}+       {
    lexeme = yytext();
    return Numero;
}

/* 14) Cualquier otro carácter no reconocido → ERROR léxico */
.                       {
    return ERROR;
}
