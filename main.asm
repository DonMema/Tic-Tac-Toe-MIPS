.data

firstRow: .space 12
secondRow: .space 12
thirdRow: .space 12
display: .space 1024
grid: .asciiz "\n 1 | 2 | 3 \n 4 | 5 | 6 \n 7 | 8 | 9"
player1_msg: .asciiz "\nTurno del jugador O\n"
player2_msg: .asciiz "\nTurno del jugador X\n"
instructions: .asciiz "¡Bienvenid@! \nDebes ingresar la casilla en la que deseas poner tu ficha cuando sea tu turno"
newLine: .asciiz "\n"
espace: .asciiz " "
pointersArray: .word firstRow, secondRow, thirdRow

.text
main:

#Carga el contador de turnos
li $s3, 0

#Carga la direccion de memoria del array de punteros
la $t8, pointersArray

#Multiplo de las direcciones en los numeros enteros
li $t4, 4

#Se imprimen las instrucciones del juego, y el tablero
li $v0, 4

la $a0, instructions

syscall

li $v0, 4

la $a0, grid

syscall

#Se comienza con la funcion para el movimiento del jugador 1
player1Move:

li $v0, 4

la $a0, player1_msg

syscall

#Se recibe la posicion del tablero, en la que se quiere ingresar la O
li $v0, 5

syscall

#La entrada recibida, se mueve al registro temporal
move $t0, $v0

#Se obtiene el valor de la posicion seleccionada
findArrayPosition:
li $t3, 3
ble $t0, $t3, setFila1

addi $t3, $t3, 3
ble $t0, $t3, setFila2

addi $t3, $t3, 3
ble $t0, $t3, setFila3

#Si la posicion ingresada no corresponde a una existente, se solicita nuevamente
j player1Move

setFila1:
addi $t0, $t0, -1

la $t8, pointersArray

#Asigna a $t6, la direccion de memoria del array 1
lw $t6, 0($t8)

move $t1, $t6

#Se guarda en $a0, la posicion de memoria a la que se tiene que ir
mul $s0, $t0, $t4

add $s0, $s0, $t1

j checkEmpty

setFila2:
addi $t0, $t0, -4

la $t8, pointersArray

#Asigna a $t6, la direccion de memoria del array 2
lw $t6, 4($t8)

move $t1, $t6

#Se guarda en $a0, la posicion de memoria a la que se tiene que ir
mul $s0, $t0, $t4

add $s0, $s0, $t1

j checkEmpty

setFila3:
addi $t0, $t0, -7

la $t8, pointersArray

#Asigna a $t6, la direccion de memoria del array 3
lw $t6, 8($t8)

move $t1, $t6

#Se guarda en $a0, la posicion de memoria a la que se tiene que ir
mul $s0, $t0, $t4

add $s0, $s0, $t1

j checkEmpty

#Se evalua si la posicion seleccionada, esta vacia
checkEmpty:
lw $s1, 0($s0)

beq $zero, $s1, player1Input

j player1Move

player1Input:
li $s1, 1
sw $s1, 0($s0)

j printGrid

#Se comienza con la funcion para el movimiento del jugador 1
player2Move:

li $v0, 4

la $a0, player2_msg

syscall

#Se recibe la posicion del tablero, en la que se quiere ingresar la O
li $v0, 5

syscall

#La entrada recibida, se mueve al registro temporal
move $t0, $v0

#Se obtiene el valor de la posicion seleccionada
findArrayPosition2:
li $t3, 3
ble $t0, $t3, setFila12

addi $t3, $t3, 3
ble $t0, $t3, setFila22

addi $t3, $t3, 3
ble $t0, $t3, setFila32

#Si la posicion ingresada no corresponde a una existente, se solicita nuevamente
j player2Move

setFila12:
addi $t0, $t0, -1

la $t8, pointersArray

lw $t6, 0($t8)

move $t1, $t6

#Se guarda en $a0, la posicion de memoria a la que se tiene que ir
mul $s0, $t0, $t4

add $s0, $s0, $t1

j checkEmpty2

setFila22:
addi $t0, $t0, -4

la $t8, pointersArray

lw $t6, 4($t8)

move $t1, $t6

#Se guarda en $a0, la posicion de memoria a la que se tiene que ir
mul $s0, $t0, $t4

add $s0, $s0, $t1

j checkEmpty2

setFila32:
addi $t0, $t0, -7

la $t8, pointersArray

lw $t6, 8($t8)

move $t1, $t6

#Se guarda en $a0, la posicion de memoria a la que se tiene que ir
mul $s0, $t0, $t4

add $s0, $s0, $t1

j checkEmpty2

#Se evalua si la posicion seleccionada, esta vacia
checkEmpty2:
lw $s1, 0($s0)

beq $zero, $s1, player2Input

j player2Move

player2Input:
li $s1, 2
sw $s1, 0($s0)

j printGrid

printGrid:
la $t8, pointersArray
li $t5, 3

repeat1:
lw $s2, 0($t8)
li $t7, 3

repeat2:
li $v0, 1

lw $a0, ($s2)

syscall

li $v0, 4

la $a0, espace

syscall

addi $s2, $s2, 4

addi $t7, $t7, -1

bgt $t7, $zero, repeat2

li $v0, 4

la $a0, newLine

syscall

addi $t8, $t8, 4

addi $t5, $t5, -1

bgt $t5, $zero, repeat1

li $s6, 1

li $s7, 2

li $s4, 5

li $s5, 9

continue:
#Cambia de jugador 1 a jugador 2
beq $s1, $s6, player2Move

#Cambia de jugador 2 a jugador 1
beq $s1, $s7, player1Move
