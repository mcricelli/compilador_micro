%{
#include "compilador.tab.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
%}
%option noyywrap

espacio             [ \t\n]+
digito              [0-9]
numero              {digito}+
punto_y_coma        ;
coma                ,
letra               [a-zA-Z]
identificador       {letra}({digito}|{letra}){0,31}
operador_aditivo    [+-]
asignacion          :=
palabra_reservada   (leer|escribir|inicio|fin
parent_izquierdo    (
parent_derecho      )
%%

inicio				return INICIO;
fin 				return FIN;
leer				return LEER;
escribir			return ESCRIBIR;
{identificador}		{yylval.identificador = strdup(yytext);return IDENTIFICADOR;}
{coma}				return COMA;
{punto_y_coma}		return PUNTO_Y_COMA;
{numero}			{yylval.identificador = strdup(yytext);return CONSTANTE;}
{asignacion}		return ASIGNACION;
{operador_aditivo}	{yylval.identificador = strdup(yytext);return OPERADOR_ADITIVO;}
"("	                {yylval.identificador = strdup(yytext);return PARENT_IZQUIERDO;}
")"	            	{yylval.identificador = strdup(yytext);return PARENT_DERECHO;}
{espacio}			/* se ignoran los espacios */;

%%
