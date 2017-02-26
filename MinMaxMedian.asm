# Find minmaxmedian
	.data
nums: .word 92, 31, 92, 6, 54, 54, 62, 33, 8, 52
length: .word 10
min: .word 0
max: .word 0
median: .word 0
	.text
	
	# sort array
	la $s2, nums #loads base address of nums array
	la $t1, length #t1 holds address of length
	lw $t1, 0($t1) # n load array size into t1
	sub $s3, $s3, $s3 #initialize counter s3, a.k.a i
	addi $s4, $s4, 1 #initialize counter s4, a.k.a j
	
L1:	sub $t4, $s3, $t1 #for loop testing i<n
	bgtz $t4, L4 #if it's less than 0, s4 else L4 end
	la $s5, ($s2) #create copy of base memory
 	sub $t5, $t1, $s3 #t5 = n-i
L2:		sub $t6, $s4, $t5 #t6 = j < (n-i) or j-(n-j)
		bgtz $t6, L3 #if above is false then keep going, otherwise branch to L3
		lw $t7, 0($s5) #grab nums[i]
		lw $t8, 4($s5) #grab nums[i+1]
		sub $t9, $t8, $t7 # t9 = nums[i+1]-nums[i].
		bgtz $t9, increment #if t9 is greater than 0, then jump to increment, otherwise swap
		add $s1, $t8, $zero #save nums[i+1] in as a register
		sub $t8, $t8, $t8 #set nums[i+1] to 0
		add $t8, $t7, $zero #make t8 nums[i]
		sub $t7, $t7, $t7 #set nums[i] to 0
		add $t7, $s1, $zero #take on the value of old nums[i+1]
		sw $t7, 0($s5)
		sw $t8, 4($s5)
		addi $s5, $s5, 4 #increment address
		addi $s4, $s4, 1 #increment j by 1
		J L2
L3:	addi $s3, $s3, 1 #increment i by 1
	sub $s4, $s4, $s4
	addi $s4, $s4, 1
	J L1
		
increment:	addi $s5, $s5, 4
		addi $s4, $s4, 1
		J L2
		

#store min, max, median
L4:	#min
	la $t0, min
	lw $t2, 0($s2)
	sw $t2, 0($t0)

	#max
	la $t0, max
	lw $t2, 40($s2)
	sw $t2, 0($t0)

	#median
	la $t0, median
	lw $t2, 20($s2)
	sw $t2, 0($t0)

li $v0, 10
syscall
	
	