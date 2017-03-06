# algorithm used: https://en.wikipedia.org/wiki/Binary_search_algorithm
.data			#creating array
length: .word 10
nums: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
target: .word 11
		
		.data
string1:	.asciiz   "\nPrint newline\n"		# declaration for string variable, 
string2:	.asciiz   "\nTarget not found\n" 		#number not in array
string3:	.asciiz   "\nTarget found at: "		#Number found at
						# .asciiz directive makes string null terminated
		.text
	
main:		
		li $v0,1		#set the syscall to print ints
		la $t4,nums 		#load address of nums into t5
		la $t9, target
		lw $t9, ($t9)
#		li $t9, 10		#target val is 11
		move $a0,$t9 		#testing to see if 11 was properly added
		#syscall
		
for:		lw $t3, length		#take in the size of the array
		add $t1, $zero,$zero	#lower bound index 0
		subi $t2, $t3,1		#upper bounded n-1
		
loopS:		bgt $t1,$t2,L1		#if Lower>Upper value is not in the array
		add $t5,$t1,$t2		# Sum (upper+lower)
		srl $t6,$t5,1		#divide by 2 - b/c its in ints it will automatically take the floor
		sll $t7,$t6,2		#multiply by 4 to get bytes address
		add $t5,$t4,$t7		#t6 now has the address of the midpoint
		lw $t8,($t5)		#load t8 with value in t6
		move $a0,$t6
#		syscall
		sub $t3,$t9,$t8
		bgtz $t3,searchUp	#difference is >0 ie, 9-5 >0 thus search up
		bltz $t3,searchDown	#difference is <0 ie 3-5<0 thus search down
		beqz $t3,L2		#if difference ==0 # has been found
		
		
	
		
searchUp:	addi $t1,$t6,1		#lower bound=midpoint+1
		j loopS
searchDown:	subi $t2,$t6,1		#upper bound=midpoint-1
		j loopS






L1:		li	$v0, 4			# load appropriate system call code into register $v0;
		la	$a0, string2		# jumps here if # not found
		syscall
		j end				#jumps to end skipping L2
L2:		li	$v0, 4			# load appropriate system call code into register $v0;
		la 	$a0, string3		# jumps here if # found
		syscall				# call operating system to perform print operation
		li 	$v0,1
		move	$a0,$t8
		syscall
#		addi $t9,$t9,1			#add +1 to target
#		j for				#for loop?
end:		li	$v0, 10		# system call code for exit = 10
		syscall			# Exit syscall
