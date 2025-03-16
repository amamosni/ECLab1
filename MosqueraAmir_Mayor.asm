#Estructura de Computadores Laboratorio #1
#Autor: Amir Mosquera
.data
    msg_prompt_count:   .asciiz "¿Cuántos números desea comparar? (3-5): "
    msg_prompt_number:  .asciiz "Ingrese un número: "
    msg_result_max:         .asciiz "El número mayor es: "
    newline:            .asciiz "\n"
    numbers:            .space 20  # Espacio para almacenar hasta 5 números (4 bytes cada uno)
    buffer:             .space 10  # Buffer para leer la entrada del usuario

.text
    .globl main

main:
    # Pedir al usuario cuántos números desea comparar
    li $v0, 4                      # Código de syscall para imprimir cadena
    la $a0, msg_prompt_count       # Cargar dirección del mensaje
    syscall

    # Leer la cantidad de números
    li $v0, 5                      # Código de syscall para leer entero
    syscall
    move $t0, $v0                  # Guardar la cantidad en $t0

    # Validar que la cantidad esté entre 3 y 5
    blt $t0, 3, main               # Si es menor que 3, volver a preguntar
    bgt $t0, 5, main               # Si es mayor que 5, volver a preguntar

    # Inicializar contador y puntero para almacenar números
    li $t1, 0                      # Contador de números ingresados
    la $t2, numbers                # Puntero al arreglo de números

input_loop:
    # Verificar si ya se ingresaron todos los números
    bge $t1, $t0, find_max         # Si ya se ingresaron todos, salir del loop

    # Mostrar mensaje para ingresar un número
    li $v0, 4                      # Código de syscall para imprimir cadena
    la $a0, msg_prompt_number      # Cargar dirección del mensaje
    syscall

    # Leer el número
    li $v0, 5                      # Código de syscall para leer entero
    syscall
    sw $v0, 0($t2)                 # Guardar el número en el arreglo
    addi $t2, $t2, 4               # Mover el puntero al siguiente espacio
    addi $t1, $t1, 1               # Incrementar el contador
    j input_loop                   # Repetir el loop

find_max:
    # Encontrar el número mayor
    la $t2, numbers                # Puntero al arreglo de números
    lw $t3, 0($t2)                 # Cargar el primer número como el mayor
    li $t1, 1                      # Contador de números comparados

max_loop:
    # Verificar si ya se compararon todos los números
    bge $t1, $t0, print_result     # Si ya se compararon todos, salir del loop

    # Cargar el siguiente número
    addi $t2, $t2, 4               # Mover el puntero al siguiente número
    lw $t4, 0($t2)                 # Cargar el número actual

    # Comparar con el número mayor actual
    bgt $t4, $t3, update_max       # Si el número actual es mayor, actualizar
    j next_number                  # Si no, continuar

update_max:
    move $t3, $t4                  # Actualizar el número mayor

next_number:
    addi $t1, $t1, 1               # Incrementar el contador
    j max_loop                     # Repetir el loop

print_result:
    # Mostrar el mensaje del resultado
    li $v0, 4                      # Código de syscall para imprimir cadena
    la $a0, msg_result_max             # Cargar dirección del mensaje
    syscall

    # Mostrar el número mayor
    li $v0, 1                      # Código de syscall para imprimir entero
    move $a0, $t3                  # Cargar el número mayor
    syscall

    # Mostrar un salto de línea
    li $v0, 4                      # Código de syscall para imprimir cadena
    la $a0, newline                # Cargar dirección del salto de línea
    syscall

    # Salir del programa
    li $v0, 10                     # Código de syscall para salir
    syscall