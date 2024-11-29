data

firstRow: .space 12
secondRow: .space 12
thirdRow: .space 12
display: .space 1024
grid: .asciiz " 0 | 1 | 2 /n 3 | 4 | 5 /n 6 | 7 | 8"
player1_msg: .asciiz "Turno del jugador O"
player2_msg: .asciiz "Turno del jugador X"
instructions: .asciiz "¡Bienvenid@ /n Debes ingresar la casilla en la que deseas poner tu ficha cuando sea tu turno"


.text
main:
la $t1, firstRow
la $t4, secondRow
la $t9, thirdRow
li $v0, 5
la $v0, instructions
syscall

li $v0, 5
la $v0, grid
syscall

li $t0, 0

firstMove:
li $v0, 5
la $v0, player1_msg
syscall

li $v0, 4
syscall

beq $t0,$t1, firstMoveInput

notEqual:
addi $t0, $t0, 1
bne $t0,$t1, notEqual


firstMoveInput:
move $t1, $t2
