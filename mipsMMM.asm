.data
nums: .word 92, 31, 92, 6, 54, 54, 62, 33, 8, 52
length: .word 10
min: .word 0
max: .word 0
median: .word 0
sort: .word 0:9
		.data
string1:	.asciiz   "\nNewRow\n"		# declaration for string variable, 
string2:	.asciiz   "\n"
string3:	.asciiz   "\ngoing to new A\n"
string4:	.asciiz   " "
						# .asciiz directive makes string null terminated
		.text
		
main: 
	
	la $s0, nums		#take address of the unsorted array
	la $a1, sort		#take address of the sorted array
	la $s2, sort
	li $s1, 10
	sll $s3, $s1,2
	add  $s2, $s2,$s3
	

	li $t0,1000 		#min defaults to 1000
	li $a2,0		#incrementer
L1:	sll $a3,$a2,2		#4 byte shift
	add $t2,$a3,$s0		#get address of next value
	lw $t1, ($t2)
	sub $t3, $t1,$t0
	
	li $v0, 1
	move $a0,$t0
	syscall	
	move $a0,$s6
	syscall
	li $v0,4
	la $a0,string2
	syscall
	
	bltz $t3, newMin
	addi $a2,$a2,1
	beq $a2,$s1,nextEle
	bgt $a2,$s1,end
	j L1
newMin:
	move $t0,$t1		#copy new min to cur min
	move $s6,$a2
	addi $a2,$a2,1		#increment inner for loop
	j L1

nextEle:
	sw $t0, ($a1)		#store the value
	li $t0, 1000		#reset the min
	addi $a1,$a1,4		#change sorted array base register
	j L1
	
	
end:
	li $v0,10
	syscall
