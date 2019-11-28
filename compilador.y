%{
#include <stdio.h>
int yylex();
int yyerror(char *);
%}

%union{
    char* identificador;
    int iValue;
}

%token  <iValue> CONSTANTE 
%token  <identificador> IDENTIFICADOR
%token  OPERADOR_ADITIVO ASIGNACION INICIO FIN LEER ESCRIBIR
%token  PARENT_IZQUIERDO PARENT_DERECHO PUNTO_Y_COMA COMA
%start  programa

%%

programa            : INICIO sentencias FIN { printf("\nCompilación exitosa.\n");};

sentencias          : sentencia sentencias
                    | sentencia

sentencia           : IDENTIFICADOR ASIGNACION expresion PUNTO_Y_COMA 
                    | LEER PARENT_IZQUIERDO identificadores PARENT_DERECHO PUNTO_Y_COMA 
                    | ESCRIBIR PARENT_IZQUIERDO expresiones PARENT_DERECHO PUNTO_Y_COMA 

expresiones         : expresion COMA expresiones 
                    | expresion 

expresion           : primaria OPERADOR_ADITIVO expresion 
                    | primaria 

identificadores     : IDENTIFICADOR COMA identificadores 
                    | IDENTIFICADOR

primaria            : CONSTANTE 
                    | IDENTIFICADOR  
                    | PARENT_IZQUIERDO expresion PARENT_DERECHO 


%%
extern FILE *yyin;

int yyerror(char *s) {
  printf("Error: no se reconoce la operación.\n");
}

int main(int argc, char* argv[]) {

    int cantidadParametros = argc;
    FILE * archivoALeer = NULL;
    char* nombreArchivoALeer;

    switch(cantidadParametros){
        case 1: 
            yyin = stdin;
            break;
        case 2: 
            nombreArchivoALeer = argv[1];
            archivoALeer = fopen(nombreArchivoALeer, "r");
            
            if (!archivoALeer) {
                printf("Error al intentar abrir el archivo %s.\n", nombreArchivoALeer);
                return -1;
            }
            yyin = archivoALeer;
            break;
        default:
            printf("Error al iniciar programa. Demasiados argumentos\n");
    }

    yyparse();
    
    if(archivoALeer) {
        fclose(archivoALeer);
    }
        
    return 0;
}
