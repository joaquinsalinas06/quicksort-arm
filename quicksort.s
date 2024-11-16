.global _start
_start:

	MOV R0, #0 // Direccion Base
    MOV R1, #0 // Tamaño del arreglo
    MOV R2, #0 // Pivote Medio
    MOV R3, #0 // Valor del Pivote Medio
    MOV R4, #0 // Puntero Izquierdo
    MOV R5, #0 // Puntero Derecho
    MOV R6, #0 // Valor del Puntero Izquierdo/Nuevo tamaño del arreglo
    MOV R7, #0 // Valor del Puntero Derecho
    MOV R8, #0 // Contador de Cambios
    MOV R9, #0 // Contador de Llamadas a Quicksort

	MOV LR, #0 //Se resetea el valor de LR
	MOV SP, #0 //Se resetea el valor de SP
	
    //Se cargan los datos requeridos a memoria, uno a uno segun el orden del ejemplo
    MOV R0, #0x400
    MOV R1, #34
    STR R1, [R0], #4
    MOV R1, #7
    STR R1, [R0], #4
    MOV R1, #23
    STR R1, [R0], #4
    MOV R1, #32
    STR R1, [R0], #4
    MOV R1, #5
    STR R1, [R0], #4
    MOV R1, #62
    STR R1, [R0], #4

    MOV R0, #0x400 //Dado que usamos post index, se resetea el valor de la memoria al original  
    MOV R1, #6 //Se define el tamaño del arreglo


    /*  //Se cargan los datos requeridos a memoria, uno a uno segun el orden del ejemplo
    MOV R0, #0x400
    MOV R1, #1
    STR R1, [R0], #4
    MOV R1, #2
    STR R1, [R0], #4
    MOV R1, #3
    STR R1, [R0], #4
    MOV R1, #4
    STR R1, [R0], #4
    MOV R1, #5
    STR R1, [R0], #4
    MOV R1, #6
    STR R1, [R0], #4
    MOV R1, #7
    STR R1, [R0], #4
    MOV R1, #8
    STR R1, [R0], #4
    MOV R1, #9
    STR R1, [R0], #4
    MOV R1, #10
    STR R1, [R0], #4
    MOV R1, #17
    STR R1, [R0], #4
    MOV R1, #19
    STR R1, [R0], #4
    MOV R1, #22
    STR R1, [R0], #4
    MOV R1, #25
    STR R1, [R0], #4
    MOV R1, #30
    STR R1, [R0], #4

    MOV R0, #0x400 //Dado que usamos post index, se resetea el valor de la memoria al original  
    MOV R1, #15 //Se define el tamaño del arreglo
 */

    /*   
//Se cargan los datos requeridos a memoria, uno a uno segun el orden del ejemplo
    MOV R0, #0x400
    MOV R1, #15
    STR R1, [R0], #4
    MOV R1, #8
    STR R1, [R0], #4
    MOV R1, #22
    STR R1, [R0], #4
    MOV R1, #3
    STR R1, [R0], #4
    MOV R1, #19
    STR R1, [R0], #4
    MOV R1, #27
    STR R1, [R0], #4
    MOV R1, #4
    STR R1, [R0], #4
    MOV R1, #33
    STR R1, [R0], #4
    MOV R1, #10
    STR R1, [R0], #4
    MOV R1, #5
    STR R1, [R0], #4
    MOV R1, #17
    STR R1, [R0], #4
    MOV R1, #25
    STR R1, [R0], #4
    MOV R1, #6
    STR R1, [R0], #4
    MOV R1, #9
    STR R1, [R0], #4
    MOV R1, #30
    STR R1, [R0], #4

    MOV R0, #0x400 //Dado que usamos post index, se resetea el valor de la memoria al original  
    MOV R1, #15 //Se define el tamaño del arreglo
*/
		  
BL quicksort

loop:
B loop              

quicksort:
	ADD R9, R9, #1 //Contador para ver cuantas veces se llama a quicksort
    CMP R1, #1 //Vamos a estar modificando la longitud según sea el subarreglo con el que estemos trabajando
    BLE end

    MOV R2, R1 
    ASR R2, R2, #1 //Se calcula la mitad de todo el array
    LDR R3, [R0, R2, LSL #2] //El valor en la posicion de la mitad del array se carga en R3, donde R3 es el pivote

    MOV R4, R0 //Se define a R4 la direccion inicial
    ADD R5, R0, R1, LSL #2 //Se define R5 como la posicion Final del arreglo según l
	SUB R5, R5, #4
	MOV R8, #0 //Inicializamos el contador de cambios en 0

while_loop:

left_point:
    LDR R6, [R4] //Lo que sea que este al inicio del arreglo 
    CMP R6, R3 //Comparamos lo que estaba al inicio del arreglo
    BGE right_point      // Si R6 >= pivote, detenemos el movimiento del puntero
    ADD R4, R4, #4     // En caso no sea mayor o igual, eso quiere decir que el valor esta correctamente a la izquierda del pivote, asi que avanza hacia la derecha
    B left_point //Se llama asi mismo hasta que encuentre un valor mayor o igual que el pivote, en tal caso, se va a la branch right_point

right_point:
    LDR R7, [R5] // Se carga el valor en la ultima posicion del array
    CMP R7, R3 //Se compara este valor cargado con el del pivote
    BLE swap     // Si R7 <= pivote, detente
	SUB R5, R5, #4 // De la direccion base, dado que la calculamos con el size, le reducimos 1 espacio, ademas de cada espacio que tiene que moverse cada vez que el valor leido sea mayor que el pivote
    B right_point // Se llama a la branch de right_pointer hasta que encuentre un valor menor al pivote a la derecha del array

swap:
    CMP R4, R5 //Verifica si es que el puntero de la derecha esta más hacia la izquierda que el propio puntero de la izquierda
    BGE check_sorted //En caso si, se ha recorrido exitosamente esa parte del arreglo, por lo que vamos a dividir/partir el arreglo, pero siempre y cuando hayan habido cambios
    
    LDR R6, [R4] //En caso no pase esto, lo que hacemos es un intercambio de variables, del valor mayor al pivote a la izquierda de este, y del valor menor al pivote a la derecha de este, que determinamos con los punteros
    LDR R7, [R5]
    STR R7, [R4]
    STR R6, [R5]
    ADD R8, R8, #1 //Incrementamos el contador de cambios

    ADD R4, R4, #4 //Movemos el pivote izquierdo a la derecha
    SUB R5, R5, #4 //Movemos el pivote derecho a la izquierda
    B while_loop //Repetimos el proceso, hasta que el pivote de la derecha supere al de la izquierda

check_sorted:
    CMP R8, #0 //Verificamos si hubo cambios
    BNE divide //Si hubo cambios, procedemos a dividir
    B end //Si no hubo cambios, el subarreglo ya está ordenado

divide:
    SUB R6, R4, R0 //Guardamos la diferencia entre el inicio y la posicion final del puntero izquierdo
    ASR R6, R6, #2 //Dividimos entre 4 esta diferencia, obteniendo el tamaño entre el inicio y el puntero izquierdo
    CMP R6, #1
	BEQ push
	PUSH {R0, R6} //Guardamos en el stack tanto la posicion inicial como el tamaño, siendo asi que estamos guardando el subarreglo izquierd

	push:
    MOV R0, R4 //en la direccion R0, movemos el valor del puntero izquierdo
    SUB R1, R1, R6 // Se resta del tamaño total, el tamaño del subarreglo izquierdo, quedandonos asi con el subarreglo derecho
    B quicksort //Se llama a la funcion pero a partir del valor del subarreglo que estamos analizando

end:
    POP {R0, R1} //Se llega aqui cuando el valor del subarreglo actual es 1, en tal caso, recuperamos el valor del subarreglo derecho al que estabamos analizando
    CMP R1, #1 //Se comprueba que ese subarreglo derecho sea de un tamaño mayor a 1
    BLE return //Si es de tamaño 1, se termina el algoritmo
    B quicksort //En cualquier otro caso, se vuelve a llamar al algoritmo, pero tomando el subarray izquierdo

return:
    MOV PC, LR //Se usa el valor guardado en el LR, para regresar a donde se hizo la llamada
