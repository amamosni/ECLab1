#Estructura de Computadores Laboratorio #1
#Autor: Amir Mosquera
.data
    msg_prompt_count:   .asciiz "�Cu�ntos n�meros desea comparar? (3-5): "
    msg_prompt_number:  .asciiz "Ingrese un n�mero: "
    msg_result_min:     .asciiz "El n�mero menor es: "
    newline:            .asciiz "\n"
    numbers:            .space 20  # Espacio para almacenar hasta 5 n�meros (4 bytes cada uno)
    buffer:             .space 10  # Buffer para leer la entrada del usuario

.text
    .globl main

main:
    # Pedir al usuario cu�ntos n�meros desea comparar
    li $v0, 4                      # C�digo de syscall para imprimir cadena
    la $a0, msg_prompt_count       # Cargar direcci�n del mensaje
    syscall

    # Leer la cantidad de n�meros
    li $v0, 5                      # C�digo de syscall para leer entero
    syscall
    move $t0, $v0                  # Guardar la cantidad en $t0

    # Validar que la cantidad est� entre 3 y 5
    blt $t0, 3, main               # Si es menor que 3, volver a preguntar
    bgt $t0, 5, main               # Si es mayor que 5, volver a preguntar

    # Inicializar contador y puntero para almacenar n�meros
    li $t1, 0                      # Contador de n�meros ingresados
    la $t2, numbers                # Puntero al arreglo de n�meros

input_loop:
    # Verificar si ya se ingresaron todos los n�meros
    bge $t1, $t0, find_min         # Si ya se ingresaron todos, salir del loop

    # Mostrar mensaje para ingresar un n�mero
    li $v0, 4                      # C�digo de syscall para imprimir cadena
    la $a0, msg_prompt_number      # Cargar direcci�n del mensaje
    syscall

    # Leer el n�mero
    li $v0, 5                      # C�digo de syscall para leer entero
    syscall
    sw $v0, 0($t2)                 # Guardar el n�mero en el arreglo
    addi $t2, $t2, 4               # Mover el puntero al siguiente espacio
    addi $t1, $t1, 1               # Incrementar el contador
    j input_loop                   # Repetir el loop

find_min:
    # Encontrar el n�mero menor
    la $t2, numbers                # Puntero al arreglo de n�meros
    lw $t3, 0($t2)                 # Cargar el primer n�mero como el menor
    li $t1, 1                      # Contador de n�meros comparados

min_loop:
    # Verificar si ya se compararon todos los n�meros
    bge $t1, $t0, print_min        # Si ya se compararon todos, salir del loop

    # Cargar el siguiente n�mero
    addi $t2, $t2, 4               # Mover el puntero al siguiente n�mero
    lw $t4, 0($t2)                 # Cargar el n�mero actual

    # Comparar con el n�mero menor actual
    blt $t4, $t3, update_min       # Si el n�mero actual es menor, actualizar
    j next_number                  # Si no, continuar

update_min:
    move $t3, $t4                  # Actualizar el n�mero menor

next_number:
    addi $t1, $t1, 1               # Incrementar el contador
    j min_loop                     # Repetir el loop

print_min:
    # Mostrar el mensaje del n�mero menor
    li $v0, 4                      # C�digo de syscall para imprimir cadena
    la $a0, msg_result_min         # Cargar direcci�n del mensaje
    syscall

    # Mostrar el n�mero menor
    li $v0, 1                      # C�digo de syscall para imprimir entero
    move $a0, $t3                  # Cargar el n�mero menor
    syscall

    # Mostrar un salto de l�nea
    li $v0, 4                      # C�digo de syscall para imprimir cadena
    la $a0, newline                # Cargar direcci�n del salto de l�nea
    syscall

    # Salir del programa
    li $v0, 10                     # C�digo de syscall para salir
    syscall