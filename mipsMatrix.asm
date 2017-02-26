.data
matrixA: .word 1,2,3,4,5,6
matrixB: .word 5,6,7,8,9,10
sizeA: .word 3,2
sizeB: .word 2,3
result: .word 0:9

		.data
string1:	.asciiz   "\nNewRow\n"		# declaration for string variable, 
string2:	.asciiz   "\n"
string3:	.asciiz   "\ngoing to new A\n"
string4:	.asciiz   " "
						# .asciiz directive makes string null terminated
		.text

main: 
	li $s0,24
	la $s1,matrixA
	la $s2,matrixB
	la $s3,sizeA
	la $s4,sizeB
	la $s5,result
	li $s7,36
	
	li $t9,0
	li $t8,4
set67:	
	li $t6,12
	li $t7,0
	li $t0,0
cycle: 
	add $a1,$s1, $t9	#gets the first address of A
	add $a2,$s1, $t8	#gets the second address of A
internal: 
	add $t3,$s2, $t7	#gets the first address of B
	add $t4,$s2, $t6	#gets the second address of B
	lw $t1,($a1)		#gets the values
	lw $t2,($a2)
	lw $t3,($t3)
	lw $t4,($t4)
	
	mul $t3,$t1,$t3		#dot products
	mul $t4,$t2,$t4
	add $t5,$t3,$t4
	
	li $v0,1		#prints the # and a space
	move $a0,$t5
	syscall
	li $v0,4
	la $a0,string4
	syscall
	
	add $s6,$s5,$t0		#storing result into result array
	sw $t5,($s6)
	addi $t0, $t0,4		#one value has been added to the result, thus increment the place in memory it will be accessing
	addi $t7,$t7,4		#adds 4 to increment the B matrix 
	addi $t6,$t6,4
	beq $t0,$s7,end
	beq $t6,$s0,set89
	j internal


set89:	
	li $v0,4
	la $a0,string2
	syscall
	#addi $t9,$t9,8
	#addi $t8,$t8,8
	addi $a1,$a1,8
	addi $a2,$a2,8
	bne $t8,$s0,reset67	#adds 8 to the A indices then resets 6&7 which reference the b matrice
reset67:
	li $t6,12
	li $t7,0
	j internal
	

end:		
	li	$v0, 10		# system call code for exit = 10
	syscall			# Exit syscall