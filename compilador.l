%{
#include "compilador.tab.h"
#include <stdlib.h>
#include <stdio.h>
%}
%option noyywrap

espacio             [ \t\n]+
digito              [0-9]
numero              {digito}+
punto_y_coma        ;
coma                ,
letra               [a-zA-Z]
identificador       {letra}({digito}|{letra}){0,31}
suma                \+
resta               -
asignacion          :=
palabra_reservada   (leer|escribir|inicio|fin)
parent_izquierdo    \(
parent_derecho      \)
%%

inicio				return INICIO;
fin 				return FIN;
leer				return LEER;
escribir			return ESCRIBIR;
{identificador}		{yylval.identificador = strdup(yytext);return IDENTIFICADOR;};
{coma}				{yylval.identificador = strdup(yytext);return COMA;};
{punto_y_coma}		{yylval.identificador = strdup(yytext);return PUNTO_Y_COMA;};
{numero}			{yylval.iValue = atoi(yytext);return CONSTANTE;};
{asignacion}		return ASIGNACION;
{parent_izquierdo}	{yylval.identificador = strdup(yytext);return PARENT_IZQUIERDO;};
{parent_derecho}  	{yylval.identificador = strdup(yytext);return PARENT_DERECHO;};
{suma}            	{yylval.identificador = strdup(yytext);return SUMA;};
{resta}            	{yylval.identificador = strdup(yytext);return RESTA;};
{espacio}			/* se ignoran los espacios */;

%%
