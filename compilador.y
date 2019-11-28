%{
#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
int yylex();
int yyerror(char *);

typedef struct Nodo
{
    char nombre[33];
    int valor;
    struct Nodo* siguiente;
} Nodo;

typedef struct Lista
{
    Nodo* cabeza;
} Lista;

Nodo* crearNodo(char *nombre, int valor);

void agregarNodo(Lista *lista, Nodo* nodo);

int estaEnLista(Lista *lista, char *nombreBuscado, int* valor);

int obtenerValor(Lista *lista, char *nombreBuscado);

Lista* crearLista();

void limpiarLista(Lista* lista);

void llenarListaCon(Lista *listaALlenar,Lista *listaACopiar);

void mostrar(Lista *lista);

Lista* diccionario;
Lista* listaIdentificadores;
Lista* listaExpresiones;

%}

%union{
    char* identificador;
    int iValue;
}

%token  <iValue> CONSTANTE PARENT_IZQUIERDO PARENT_DERECHO PUNTO_Y_COMA COMA
%token  <identificador> IDENTIFICADOR ASIGNACION INICIO FIN LEER ESCRIBIR

%left  SUMA RESTA

%type <identificador> sentencia identificadores
%type <iValue> primaria expresion expresiones

%start  programa

%%

programa            : INICIO sentencias FIN { printf("\nCompilación exitosa.\n");};

sentencias          : sentencia sentencias
                    | sentencia;

sentencia           : IDENTIFICADOR ASIGNACION expresion PUNTO_Y_COMA {agregarNodo(diccionario, crearNodo($1, $3));}
                    | LEER PARENT_IZQUIERDO identificadores PARENT_DERECHO PUNTO_Y_COMA {llenarListaCon(diccionario,listaIdentificadores);}
                    | ESCRIBIR PARENT_IZQUIERDO expresiones PARENT_DERECHO PUNTO_Y_COMA {mostrar(listaExpresiones);};

expresiones         : expresion {agregarNodo(listaExpresiones, crearNodo("", $1));} COMA expresiones 
                    | expresion {agregarNodo(listaExpresiones, crearNodo("", $1));};

expresion           : primaria SUMA expresion {$$ = $1 + $3;}
                    | primaria RESTA expresion {$$ = $1 - $3;}
                    | primaria {$$ = $1;};

identificadores     : IDENTIFICADOR {agregarNodo(listaIdentificadores, crearNodo($1, 0));} COMA identificadores 
                    | IDENTIFICADOR {agregarNodo(listaIdentificadores, crearNodo($1, 0));};

primaria            : CONSTANTE {$$ = $1;}
                    | IDENTIFICADOR {
                            int valor; 
                            if(estaEnLista(diccionario,$1,&valor)){
                                $$ = valor;
                            }
                        }
                    | PARENT_IZQUIERDO expresion PARENT_DERECHO  {$$ = $2;};


%%
extern FILE *yyin;

int yyerror(char *s) {
  printf("Error: no se reconoce la operación.\n");
}

int main(int argc, char* argv[]) {

    int cantidadParametros = argc;
    FILE * archivoALeer = NULL;
    char* nombreArchivoALeer;
    diccionario = crearLista();
    listaIdentificadores = crearLista();
    listaExpresiones = crearLista();

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

// Funciones de manejo de listas
Lista* crearLista()
{
    Lista* lista = (Lista*)malloc(sizeof(Lista));
    lista->cabeza = NULL;
    return lista;
}

Nodo* crearNodo(char *nombre, int valor)
{
    Nodo* nodo = (Nodo*) malloc(sizeof(Nodo));
    strncpy(nodo->nombre, nombre, sizeof(nodo->nombre));
    nodo->valor = valor;
    nodo->siguiente = NULL;
    return nodo;
}

void agregarNodo(Lista *lista, Nodo* nodo)
{
    if (lista->cabeza == NULL)
    {
        lista->cabeza = nodo;
    }
    else
    {
        Nodo* aux = lista->cabeza;
        while (aux->siguiente)
        {
            aux = aux->siguiente;
        }
        aux->siguiente = nodo;
    }
}

int estaEnLista(Lista *lista, char *nombreBuscado, int* valor)
{
    Nodo* aux = lista->cabeza;
    if (aux == NULL)
    {
        return 0;
    }
    else
    {
        while (aux != NULL)
        {
            if (strcmp(aux->nombre, nombreBuscado) == 0)
            {
                *valor = aux->valor;
                return 1;
            }
            else
                aux = aux->siguiente;
        }
        return 0;
    }
}

int obtenerValor(Lista *lista, char *nombreBuscado)
{
    Nodo* aux = lista->cabeza;
    if (aux == NULL)
    {
        return 0;
    }
    else
    {
        while (aux != NULL)
        {
            if (strcmp(aux->nombre, nombreBuscado) == 0)
            {
                return aux->valor;
            }
            else
                aux = aux->siguiente;
        }
        return -1;
    }
}

void limpiarLista(Lista* lista)
{
    Nodo* aux = lista->cabeza;
    lista->cabeza = NULL;
    
    while (aux != NULL)
    {
        Nodo* sig = aux->siguiente;
        free(aux);
        aux = sig;
    }

}

void llenarListaCon(Lista *listaALlenar,Lista *listaACopiar) {

    int valorAGuardar;
    Nodo* aux = listaACopiar->cabeza;
    while (aux != NULL) {
        printf("Ingrese el valor para el identificador %s : ",aux->nombre);
        scanf("%d",&valorAGuardar);
        agregarNodo(listaALlenar, crearNodo(aux->nombre, valorAGuardar));
        aux = aux->siguiente;
    }
    limpiarLista(listaACopiar);
}

void mostrar(Lista *lista) {

    Nodo* aux = lista->cabeza;
    
    while (aux != NULL)
    {
        printf("%d\n", aux->valor);
        aux = aux->siguiente;
    }
    limpiarLista(lista);
}