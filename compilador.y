%{
#include <stdio.h>
%}

%union{
    char* identificador;
    int dval;
}

%token  <dval> CONSTANTE 
%token  <identificador> IDENTIFICADOR
%token OPERADOR_ADITIVO ASIGNACION INICIO FIN LEER ESCRIBIR
%token  PARENT_IZQUIERDO	PARENT_DERECHO     PUNTO_Y_COMA COMA

%%

programa            : INICIO sentencias FIN { printf("\nCompilación exitosa.\n");};

sentencias          : sentencia sentencias { printf("\nSentencias->sent sents.\n");};
                    | sentencia { printf("\nSentencias->sent.\n");};

sentencia           : IDENTIFICADOR ASIGNACION expresion PUNTO_Y_COMA { printf("\nSentencia-> identificador asignacion expresion punto y coma.\n");};
                    | LEER PARENT_IZQUIERDO identificadores PARENT_DERECHO PUNTO_Y_COMA
                    | ESCRIBIR PARENT_IZQUIERDO expresiones PARENT_DERECHO PUNTO_Y_COMA

expresion           : primaria OPERADOR_ADITIVO expresion {printf("\nExpresion->primaria aditivo expresion.\n");}
                    | primaria {printf("\nExpresion->primaria.\n");}

identificador       : IDENTIFICADOR {printf("\nIdentificador->IDENTIFICADOR.\n");}

identificadores     : identificador identificadores {printf("\nIdentificadores->Identificadores.\n");}
                    | identificador {printf("\nIdentificadores->Identificador.\n");}

expresiones         : expresion expresiones {printf("\nExpresiones->Constante.\n");}
                    | expresion {printf("\nExpresiones->Constante.\n");}

primaria            : CONSTANTE {printf("\nPrimaria->Constante.\n");}
                    | IDENTIFICADOR  {printf("\nPrimaria->Identificador.\n");}
                    | PARENT_IZQUIERDO expresion PARENT_DERECHO {printf("\nPrimaria->Exp entre parentesis.\n");}


%%
extern FILE *yyin;

int yyerror(char *s) {
  printf("Error: no se reconoce la operación.\n");
}

int main(int argc, char* argv[]) {

    if (argc == 2)
    {
        FILE *source = fopen(argv[1], "r");
        
        if (!source) {
            printf("Imposible abrir el archivo %s.\n", argv[1]);
            return -1;
        }
        
        yyin = source;
    }

    yyparse();
    return 0;
}