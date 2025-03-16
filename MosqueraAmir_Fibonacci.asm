#Estructura de Computadores Laboratorio #1
#Autor: Amir Mosquera

.data
    mensaje_prompt_count:   .asciiz "Cuantos numeros de la serie Fibonacci desea generar? (minimo 1): "
    mensaje_series:         .asciiz "Serie Fibonacci: "
    mensaje_sum:            .asciiz "Suma de la serie: "
    comma:                  .asciiz ", "
    newline:                .asciiz "\n"
    buffer:                 .space 10  # Buffer para leer la entrada del usuario

.text
    .globl main

main:
    # Pedir al usuario Cuantos numeros de la serie Fibonacci desea generar
    li $v0, 4                      # Codigo de syscall para imprimir cadena
    la $a0, mensaje_prompt_count   # Cargar direccion del mensaje
    syscall

    # Leer la cantidad de numeros
    li $v0, 5                      # Codigo de syscall para leer entero
    syscall
    move $t0, $v0                  # Guardar la cantidad en $t0

    # Validar que la cantidad sea al menos 1
    blt $t0, 1, main               # Si es menor que 1, volver a preguntar

    # Inicializar variables para la serie Fibonacci
    li $t1, 0                      # Primer numero de Fibonacci (F(0) = 0)
    li $t2, 1                      # Segundo numero de Fibonacci (F(1) = 1)
    li $t3, 0                      # Contador de numeros generados
    li $t4, 0                      # Suma de la serie

    # Mostrar el mensaje de la serie
    li $v0, 4                      # Codigo de syscall para imprimir cadena
    la $a0, mensaje_series         # Cargar direccion del mensaje
    syscall

generate_series:
    # Verificar si ya se generaron todos los numeros
    bge $t3, $t0, print_sum        # Si ya se generaron todos, salir del loop

    # Mostrar el numero actual de la serie
    li $v0, 1                      # Codigo de syscall para imprimir entero
    move $a0, $t1                  # Cargar el numero actual
    syscall

    # Sumar el numero actual a la suma total
    add $t4, $t4, $t1              # Sumar el numero actual a $t4

    # Calcular el siguiente numero de Fibonacci
    add $t5, $t1, $t2              # $t5 = $t1 + $t2 (siguiente numero)
    move $t1, $t2                  # Actualizar $t1 al valor de $t2
    move $t2, $t5                  # Actualizar $t2 al valor de $t5

    # Incrementar el contador de numeros generados
    addi $t3, $t3, 1               # Incrementar el contador

    # Mostrar una coma si no es el ultimo numero
    blt $t3, $t0, print_comma      # Si no es el ultimo numero, mostrar coma
    j generate_series              # Repetir el loop

print_comma:
    # Mostrar una coma
    li $v0, 4                      # Codigo de syscall para imprimir cadena
    la $a0, comma                  # Cargar direccion de la coma
    syscall
    j generate_series              # Repetir el loop

print_sum:
    # Mostrar un salto de linea
    li $v0, 4                      # Codigo de syscall para imprimir cadena
    la $a0, newline                # Cargar direccion del salto de linea
    syscall

    # Mostrar el mensaje de la suma
    li $v0, 4                      # Codigo de syscall para imprimir cadena
    la $a0, mensaje_sum            # Cargar direccion del mensaje
    syscall

    # Mostrar la suma de la serie
    li $v0, 1                      # Codigo de syscall para imprimir entero
    move $a0, $t4                  # Cargar la suma
    syscall

    # Mostrar un salto de linea
    li $v0, 4                      # Codigo de syscall para imprimir cadena
    la $a0, newline                # Cargar direccion del salto de linea
    syscall

    # Salir del programa
    li $v0, 10                     # Codigo de syscall para salir
    syscall
