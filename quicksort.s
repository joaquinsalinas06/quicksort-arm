.global _start
_start:
    MOV r0, #0x400

    MOV r1, #34
    STR r1, [r0], #4

    MOV r1, #7
    STR r1, [r0], #4

    MOV r1, #23
    STR r1, [r0], #4

    MOV r1, #32
    STR r1, [r0], #4

    MOV r1, #5
    STR r1, [r0], #4 

    MOV r1, #62
    STR r1, [r0], #4  

    MOV r0, #0x400 
    MOV r1, #6

    bl quicksort
	
	loop:
	b loop
	
quicksort:
    cmp r1, #1 //Caso base, donde la longitud del arreglo sea 1
    ble return

    mov r2, r1
    lsr r2, r2, #1 //El pivote se toma el elemento del medio, por lo que dividimos n/2
    ldr r3, [r0, r2, lsl #2] //Extraemos el valor del valor del pivote medio 

    mov r4, #0 //Definimos nuestro puntero al inicio del array
    sub r5, r1, #1 //Definimos nuestro puntero al final del array

dividir:
    ldr r6, [r0, r4, lsl #2] //Se accede al elemento que esta en la posicion más a la iquierda del subarreglo
    cmp r6, r3 //El valor es menor que el pivote? En tal caso, el elemento deberia estar en la izquierda del subarreglo
    blt izquierda

    ldr r7, [r0, r5, lsl #2] //Se accede al elemento que esta en la posicion más a la derecha del subarreglo
    cmp r7, r3 //El valor es mayor que el pivote? En tal caso, el elemento deberia estar en la derecha del subarreglo
    bgt derecha

    cmp r4, r5 //Vemos si es que los indices han chocado, es decir, si el puntero de la izquierda sobrepaso el de la derecha
    bge reorder //Si se da el caso, hay que reorganizar el mismo proceso, pero con el subarreglo izquierdo
    str r7, [r0, r4, lsl #2]
    str r6, [r0, r5, lsl #2]

    add r4, r4, #1
    sub r5, r5, #1
    b dividir

izquierda:
    add r4, r4, #1 //Se avanza el puntero 1, dado que sabemos que ese elemento si deberia estar en la izquierda del pivote
    b dividir

derecha:
    sub r5, r5, #1 //Se retrocede el puntero en 1, dado que sabemos que ese elemnto esta correctamente posicinado a la derecha
    b dividir

reorder:
    push {r0, r1, lr} //Se almacena la direccion, la longitud del ultimo subarreglo y la referencia a la llamada de la funcion
    mov r1, r5 // La longitud se define desde iniciar hasta donde ha llegado el puntero derecho, eso quiere decir, que la se arregla el subarreglo derecho
    bl quicksort
	//en este punto se retorna cuando hayamos llegado al return, y esto es cuando la longitud es 1, dado que el valor del puntero derecho tiene menos que recorrer

    pop {r0, r1, lr}
    add r0, r0, r4, lsl #2 
    sub r1, r1, r4    
    bl quicksort

return: //En caso el subarreglo sea de tamaño 1, entonces retornamos a la ultima llamada de la funcion 
    bx lr