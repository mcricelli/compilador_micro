# compilador_micro

Trabajo práctico 2 de SSL en el que se hace un compilador para el lenguaje Micro

# Pasos para compilar:

En `Windows:`
```
0 - Abrir una terminal en el directorio del proyecto.
1 - Ejecutar '/win_flex.exe compilador.l'.
2 - Ejecutar './win_bison.exe -ld compilador.y'.
3 - Ejecutar 'gcc -o exe compilador.tab.c lex.yy.c -o nombre_archivo_primer_paso'.
```
En `Ubuntu:`

Recordar instalar previamente flex y bison:

`sudo apt install flex`

`sudo apt install bison`

Y luego
```
0 - Abrir una terminal en el directorio del proyecto.
1 - Ejecutar '/flex compilador.l'.
2 - Ejecutar './bison -ld compilador.y'.
3 - Ejecutar 'gcc -o exe compilador.tab.c compilador.tab.h lex.yy.c -o nombre_archivo_primer_paso'.
```

# Pasos para ejecutar:

En `Windows:`
```
0 - Crear un archivo con el codigo en micro.
1 - Abrir una terminal en el directorio del proyecto.
2 - Ejecutar ./exe nombre_archivo_primer_paso
```
En `Ubuntu:`
```
0 - Crear un archivo con el codigo en micro.
1 - Abrir una terminal en el directorio del proyecto.
2 - Ejecutar ./nombre_archivo_primer_paso
```

# Notas sobre la sintaxis de Micro:

* Ejemplos de código en Micro:

* Ejemplo 1:
```
inicio
	identificador1 := 3;
	identificador2 := 20;
	resultado = identificador1 + (15 + identificador2);
fin
```
* Ejemplo 2:
```
inicio
	leer(identificador1,identificador2,identificador3); identificador4 := identificador1 + identificador2;
	escribir(identificador5,(identificador3+identificador4));
fin
```