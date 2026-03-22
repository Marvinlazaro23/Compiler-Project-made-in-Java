package codigo;
import java_cup.runtime.*;
%%
%public
%class LexerCup
%type java_cup.runtime.Symbol
%cup
%full
%line
%column
%char

L=[a-zA-Z_]           /* Identificador debe empezar con letra ASCII */
D=[0-9]+
Operador=[*+/-]
Agrupacion=[( ) { } ,]
espacio=[ \t\r\n]+
%{
    private Symbol symbol(int type, Object value){
        return new Symbol(type, yyline, yycolumn, value);
    }
    private Symbol symbol(int type){
        return new Symbol(type, yyline, yycolumn);
    }
%}
%%

{espacio} {/*Ignore*/}
"//"(.)* {/*Ignore*/}

/* Comillas */
"\""                            { return new Symbol(sym.Comillas, yychar, yyline, yytext()); }
"\""({L}|{D}|{Operador}|{Agrupacion})*"\"" { return new Symbol(sym.Cadena, yychar, yyline, yytext()); }

/* Tipos de datos */
( byte | char | long | float | double | string ) { return new Symbol(sym.T_dato, yychar, yyline, yytext()); }
("int")                                 { return new Symbol(sym.Int, yychar, yyline, yytext()); }

/* Palabras reservadas */
INICIO                                { return new Symbol(sym.INICIO, yychar, yyline, yytext()); }
FIN                                   { return new Symbol(sym.FIN, yychar, yyline, yytext()); }
Var                                   { return new Symbol(sym.Var, yychar, yyline, yytext()); }
LEER                                  { return new Symbol(sym.LEER, yychar, yyline, yytext()); }
IMPRIMIR                              { return new Symbol(sym.IMPRIMIR, yychar, yyline, yytext()); }
Repetir                               { return new Symbol(sym.Repetir, yychar, yyline, yytext()); }
Hasta                                 { return new Symbol(sym.Hasta, yychar, yyline, yytext()); }
Hacer                                 { return new Symbol(sym.Hacer, yychar, yyline, yytext()); }
Fin_repetir                           { return new Symbol(sym.Fin_repetir, yychar, yyline, yytext()); }
Mientras                              { return new Symbol(sym.Mientras, yychar, yyline, yytext()); }
Fin_mientras                          { return new Symbol(sym.Fin_mientras, yychar, yyline, yytext()); }
Si                                    { return new Symbol(sym.Si, yychar, yyline, yytext()); }
Entonces                              { return new Symbol(sym.Entonces, yychar, yyline, yytext()); }
Sino                                  { return new Symbol(sym.Sino, yychar, yyline, yytext()); }
Fin_si                                { return new Symbol(sym.Fin_si, yychar, yyline, yytext()); }

/* Constantes */
( true | false )                      { return new Symbol(sym.Op_booleano, yychar, yyline, yytext()); }
NULL                                  { return new Symbol(sym.NULL, yychar, yyline, yytext()); }
PI                                    { return new Symbol(sym.PI, yychar, yyline, yytext()); }
MAX_INT                               { return new Symbol(sym.MAX_INT, yychar, yyline, yytext()); }

/* Operadores relacionales */
( ">" | "<" | "==" | "!=" | ">=" | "<=" ) { return new Symbol(sym.Op_relacional, yychar, yyline, yytext()); }

/* Incremento / decremento */
( "++" | "--" )                    { return new Symbol(sym.Op_incremento, yychar, yyline, yytext()); }

/* Asignacion y aritmeticos */
"="                                  { return new Symbol(sym.Igual, yychar, yyline, yytext()); }
"+"                                  { return new Symbol(sym.Suma, yychar, yyline, yytext()); }
"-"                                  { return new Symbol(sym.Resta, yychar, yyline, yytext()); }
"*"                                  { return new Symbol(sym.Multiplicacion, yychar, yyline, yytext()); }
"/"                                  { return new Symbol(sym.Division, yychar, yyline, yytext()); }

/* Parentesis y llaves */
"("                                  { return new Symbol(sym.Parentesis_a, yychar, yyline, yytext()); }
")"                                  { return new Symbol(sym.Parentesis_c, yychar, yyline, yytext()); }
"{"                                  { return new Symbol(sym.Llave_a, yychar, yyline, yytext()); }
"}"                                  { return new Symbol(sym.Llave_c, yychar, yyline, yytext()); }

/* Punto y coma */
";"                                  { return new Symbol(sym.P_coma, yychar, yyline, yytext()); }

/* --------------------------------------------------------------------------
   Regla de Identificador con restriccion de “ll” y “rr”
   - {L}({L}|{D})* : empieza con letra ASCII luego letras o digitos
   - En la accion, convertimos el lexema a minusculas y si contiene "ll" o "rr",
     retornamos ERROR en lugar de Identificador.
   -------------------------------------------------------------------------- */
{L}({L}|{D})*  {
    String lex = yytext();
    String lower = lex.toLowerCase();

    if (lower.contains("ll") || lower.contains("rr")) {
        return new Symbol(sym.ERROR, yychar, yyline, lex);
    }
    return new Symbol(sym.Identificador, yychar, yyline, lex);
}

/* Numeros enteros (con o sin signo) */
("-"{D}+) | {D}+                     { return new Symbol(sym.Numero, yychar, yyline, yytext()); }

/* Cualquier otro caracter no reconocido => ERROR */
.                                { return new Symbol(sym.ERROR, yychar, yyline, yytext()); }
