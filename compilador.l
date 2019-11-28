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
operador_aditivo    [+-]
asignacion          :=
palabra_reservada   (leer|escribir|inicio|fin)
parent_izquierdo    \(
parent_derecho      \)
%%

inicio				return INICIO;
fin 				return FIN;
leer				return LEER;
escribir			return ESCRIBIR;
{identificador}		return IDENTIFICADOR;
{coma}				return COMA;
{punto_y_coma}		return PUNTO_Y_COMA;
{numero}			return CONSTANTE;
{asignacion}		return ASIGNACION;
{operador_aditivo}	return OPERADOR_ADITIVO;
{parent_izquierdo}	return PARENT_IZQUIERDO;
{parent_derecho}  	return PARENT_DERECHO;
{espacio}			/* se ignoran los espacios */;

%%
