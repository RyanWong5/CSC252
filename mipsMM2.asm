.data
#matrixA: .word 0,4,8,12,16,20,24,28,32,36,40,44
#matrixB: .word 0,4,8,12,16,20,24,28,32,36,40,44
#sizeA: .word 4,3
#sizeB: .word 3,4
#result: .word 0:16
matrixA: .word 1,2,3,4,5,6
matrixB: .word 5,6,7,8,9,10
sizeA: .word 3,2
sizeB: .word 2,3
result: .word 0:9


		.data
string1:	.asciiz   "\nNewRow\n"		# declaration for string variable, 
string2:	.asciiz   "\n"
string3:	.asciiz   "\ngoing to new A\n"
string4:	.asciiz   "\nvalueStored\n"
starto:		.asciiz   "\nstarto\n"
mult: 		.asciiz   " * "
space: 		.asciiz   " "
						# .asciiz directive makes string null terminated
		.text

main: 
	la $t0,sizeA
	la $t1,sizeB	
	lw $t0,($t0)
	lw $t1,4($t1)			
	mul $s0, $t1,$t0			#multiply mxn to get the resulting # of terms
	sll $s0,$s0,2				#sets $S0 to how many increments can be done before going out of bounds on matrixA /# of values x 4)
	
	la $s1,matrixA				#address of mA
	la $s2,matrixB				#address of mB
	la $s3,sizeA				#address of sizeA
	la $s4,sizeB				#address of sizeB
	la $s5,result				#address of the result
	add $s0,$s5,$s0
	
	lw $t1,($s3)				#first value of sizeA
	lw $t0,4($s4)				#first value of sizeB
	mul $s7,$t0,$t1				#mxn * nxm will have an m^2 ending size.
	sll $s7,$s7,2				#create upper limit of how many slots are in the result arrrayl

	
	
						#get the initial row in A to multiply by:
	lw $a2, 4($s3)				#Take the number of columns in A
	sll $a2, $a2,2				#convert from number to bytes
	lw $a3, 4($s4)				#take the number of columns in B
	lw $t0, ($s4)				#take the number of rows in B
	subi $t0,$t0,1
	sll $a3,$a3,2				#convert number to bytes
	move $k0,$a3
	mul $a3,$a3,$t0				#first term of B to be multiplied
	move $s6,$t0				#column counter
	move $t6,$s6
	li $v0,1
	add $t1,$zero,$s2
	li $t4,0
	lw $k1,4($s4)
	move $a0,$a2
#	syscall
	
	
	li $v0,4
	la $a0,starto
#	syscall
	li $v0,1
stayRowchangeColumn: 
	
	lw $t0,($s1)				#first term to be multiplied from A
	move $a0,$t0
#	syscall
	lw $t2,($t1)				#second term to be multiplied from B
	
	mul $t8, $t0,$t2			#t8 will represent the multiplication of the values
	add $t9,$t8,$t9				#t9 will hold the running sum
	
	addi $s1, $s1,4
	subi $t6,$t6,1				#decrement the number of iterations through a row
	bgez $t6, stayRowchangeColumn		#if we have risen through all the indices in a column, change column
	#nop					#placeholder until dependancies determined
	add $t1,$t1,$k0				#decrement place in B in which t1 is indexing
	
	li $v0,1 	
	move $a0,$t9
	syscall
	
	li $v0,4
	la $a0,space
	syscall
	li $v0,1 
	
	
	sw $t9,($s5)				#store and increment result
	addi $s5,$s5,4				#""
	beq $s5,$s0,end
	
	lw $t3,4($s3)
	sll $t3,$t3,2
	sub $s1,$s1,$t3				#resets the A matrix row counter to column 1
	
	addi $t4,$t4,4				#increments the column in matrix B
	la $t3,($s2)				#here
	add $t3,$s2,$t4
	move $t1,$t3	
	move $t6,$s6
	li $t9, 0				#resets t0 to 0
	
	bgt $t4,$a2, incRow			
	nop
	
	
	
	
	
	j stayRowchangeColumn
	nop
	
incRow:
	li $v0,4
	la $a0,string2				#newline
	syscall
	li $v0,1 
	
	lw $t5,4($s3)
	sll $t5,$t5,2
	add $s1,$t5,$s1
	li $t4,0
#	la $s2, matrixB
	la $t1, matrixB
	j stayRowchangeColumn
	
	


	

end:		
	li	$v0, 10		# system call code for exit = 10
	syscall			# Exit syscall
