.data
firstRow: .word 0, 0, 0
secondRow: .word 0, 0, 0
thirdRow: .word 0, 0, 0
display: .space 1024
grid: .asciiz "\n 1 | 2 | 3 \n 4 | 5 | 6 \n 7 | 8 | 9"
player1_msg: .asciiz "\nTurno del jugador 1\n"
player2_msg: .asciiz "\nTurno del jugador 2\n"
instructions: .asciiz "¡Bienvenid@! \nDebes ingresar la casilla en la que deseas poner tu ficha cuando sea tu turno\n"
draw: .asciiz "¡Empate!"
player1Wins: .asciiz "¡Felicidades! El Jugador 1 gana."
player2Wins: .asciiz "¡Felicidades! El Jugador 2 gana."
newLine: .asciiz "\n"
espace: .asciiz " "
pointersArray: .word firstRow, secondRow, thirdRow

.text
main:
    # Inicializar contador de turnos
    li $s3, 0  # Turnos totales
    li $s6, 1  # Jugador O
    li $s7, 2  # Jugador X

    # Cargar array de punteros
    la $t8, pointersArray
    li $t4, 4  # Multiplicador de direcciones

    # Mostrar instrucciones y tablero inicial
    li $v0, 4
    la $a0, instructions
    syscall

    li $v0, 4
    la $a0, grid
    syscall

turnLoop:
    addi $a3, $a3, 1
    # Determinar jugador actual
    beq $s3, $zero, player1Move
    j player2Move

player1Move:
    # Mostrar mensaje del jugador O
    li $v0, 4
    la $a0, player1_msg
    syscall
    j playerInput

player2Move:
    # Mostrar mensaje del jugador X
    li $v0, 4
    la $a0, player2_msg
    syscall

playerInput:
    # Leer entrada del jugador
    li $v0, 5
    syscall
    move $t0, $v0

    # Validar entrada
    blt $t0, 1, playerInput
    bgt $t0, 9, playerInput

    # Obtener posición en memoria
    la $t8, pointersArray
    li $t3, 3
    ble $t0, $t3, setFila1

    addi $t3, $t3, 3
    ble $t0, $t3, setFila2

    addi $t3, $t3, 3
    ble $t0, $t3, setFila3

    j playerInput

setFila1:
    addi $t0, $t0, -1
    lw $t6, 0($t8)
    j calculateOffset

setFila2:
    addi $t0, $t0, -4
    lw $t6, 4($t8)
    j calculateOffset

setFila3:
    addi $t0, $t0, -7
    lw $t6, 8($t8)

calculateOffset:
    mul $s0, $t0, $t4
    add $s0, $s0, $t6

    # Verificar si la posición está vacía
    lw $s1, 0($s0)
    bne $zero, $s1, playerInput

    # Marcar posición con el jugador actual
    move $t1, $s6  # Jugador O
    beq $s3, $zero, markPosition
    move $t1, $s7  # Jugador X

markPosition:
    sw $t1, 0($s0)
    addi $s3, $s3, 1
    rem $s3, $s3, 2  # Cambiar turno

    # Mostrar tablero
    j printGrid

printGrid:
    li $t5, 3

printRows:
    lw $s2, 0($t8)
    li $t7, 3

printColumns:
    li $v0, 1
    lw $a0, ($s2)
    syscall

    li $v0, 4
    la $a0, espace
    syscall

    addi $s2, $s2, 4
    addi $t7, $t7, -1
    bgt $t7, $zero, printColumns

    li $v0, 4
    la $a0, newLine
    syscall

    addi $t8, $t8, 4
    addi $t5, $t5, -1
    bgt $t5, $zero, printRows

    addi $a2, $a2, 1
    
    # Verificar condición de victoria o empate
    j checkWin

checkWin:
    # Lógica para verificar filas, columnas y diagonales
    la $t8, pointersArray
    li $t9, 4

checkCols:
    li $a1, 0
    li $a2, 3
    
    #Carga la primera columna
    lw $t2, 0($t8) 
    lw $t5, 4($t8)
    lw $t7, 8($t8)
    colsLoop:
	lw $s1, 0($t2)
    	beq $s1, $zero, skipCol
    	
    	lw $s4, 0($t5)
    	beq $s4, $zero, skipCol
    
    	lw $s5, 0($t7)
    	beq $s5, $zero, skipCol
    
    	#Verificamos que los elementos de la columna sean iguales
    	beq $s1, $s4, colMatch
    	
    	#Salto en caso de que la columna contenga un 0
    	skipCol:
    	
    	#Añade un 1 al contador (que llega a 3)
    	addi $a1, $a1, 1
    	
    	#Avanzamos a la columa siguiente
    	add $t2, $t2, $t9
    	add $t5, $t5, $t9
    	add $t7, $t7, $t9
    	
    	#Se establece una condición para volver al ciclo
    	bne $a1, $a2, colsLoop
    	
    	j checkRows

colMatch:
    beq $s4, $s5, winCondition
    addi $a1, $a1, 1
    addi $t9, $t9, 4
    bne $a1, $a2, colsLoop

checkRows:
    la $t8, pointersArray
    li $a1, 0
    li $a2, 3
    rowsLoop:
    	lw $t2, 0($t8) #Carga el primer espacio de la fila 1
    	lw $t5, 4($t2)
    	beq $t5, $zero, skipRow
    	lw $t7, 8($t2)
    	beq $t7, $zero, skipRow
    	lw $t2, 0($t2)
    	beq $t2, $zero, skipRow
    	
    	move $t0, $t2
    	
    	#Verificamos en el primer espacio de la fila 1, sea igual al de la fila 2
    	beq $t2, $t5, rowMatch
    	
    	#Salto en caso de que la columna contenga un 0
    	skipRow:
    	
    	#Añade un 1 al contador (que llega a 3)
    	addi $a1, $a1, 1
    	#Avanzamos 4 espacios en la fila
    	addi $t8, $t8, 4
    	#Se establece una condición para volver al ciclo
    	bne $a1, $a2, rowsLoop
    	
    	j checkDiag1
    	
rowMatch:
    beq $t5, $t7, winCondition
    addi $a1, $a1, 1
    addi $t8, $t8, 4
    bne $a1, $a2, rowsLoop

checkDiag1:
    la $t8, pointersArray
    
    lw $t2, 0($t8)
    lw $t2, 0($t2)
    beq $t2, $zero, checkDiag2
    
    lw $t5, 4($t8)
    addi $t5, $t5, 4
    lw $t5, 0($t5)
    beq $t5, $zero, checkDiag2

    lw $t7, 8($t8)
    addi $t7, $t7, 8
    lw $t7, 0($t7)
    beq $t7, $zero, checkDiag2
    
    move $t0, $t2
    
    #Verificamos en el primer espacio de la fila 1, sea igual al de la fila 2
    beq $t2, $t5, diag1Match
    	
    j checkDiag2

diag1Match:
    beq $t5, $t7, winCondition

checkDiag2:
    la $t8, pointersArray
    
    lw $t2, 0($t8)
    addi $t2, $t2, 8
    lw $t2, 0($t2)
    beq $t2, $zero, checkDraw
    
    lw $t5, 4($t8)
    addi $t5, $t5, 4
    lw $t5, 0($t5)
    beq $t5, $zero, checkDraw
    
    lw $t7, 8($t8)
    lw $t7, 0($t7)
    beq $t7, $zero, checkDraw
    
    move $t0, $t2
    
    #Verificamos en el primer espacio de la fila 1, sea igual al de la fila 2
    beq $t2, $t5, diag2Match
    	
    j checkDraw

diag2Match:
    beq $t5, $t7, winCondition

checkDraw:
    li $a1, 9
    bne $a3, $a1, turnLoop
    
    # Lógica para empate
    li $v0, 4
    la $a0, draw
    syscall
    j endGame

winCondition:
    beq $t0, $s7, winPlayer2
    li $v0, 4
    la $a0, player1Wins
    syscall
    j endGame
    
    winPlayer2:
    li $v0, 4
    la $a0, player2Wins
    syscall
    j endGame

endGame:
    li $v0, 10
    syscall
