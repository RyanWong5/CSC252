# merge sort
#java implementation for reference - https://www.cs.cmu.edu/~adamchik/15-121/lectures/Sorting%20Algorithms/code/MergeSort.java
.data
nums: .word 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
sorted: .word 0:10
length: .word 10
msg: .asciiz "Split Finished"
.text

la $s0, nums #base address of nums array a
la $s1, length 
lw $s1, 0($s1) # n number of nums

#call mergeSort(0, a.length-1)
addi $sp, $sp, -16 #($ra, left, right, center)
addi $a1, $a1, 0
sub $a2, $s1, 1 #a.length-1

#push into sp
sw $a1, 4($sp)
sw $a2, 8($sp)

jal mergeSort #step into mergeSort
sw $ra, 0($sp)

mergeSort: #(left, right)
		#load from stack
		lw $t0, 4($sp) #t0 = left
		lw $t1, 8($sp) #t1 = right
		lw $t3, 12($sp) #t3 = center
		
		sub $t2, $t0, $t1
		beqz $t2, end #if left - right < 0 then $t2 and keep going, otherwise end
		
		add $t3, $t0, $t1 #t3 = center
		srl $t3, $t3, 1 #t3 = center = (left+right)/2
		sw $t3, 12($sp) #storing center into stack
		
		#mergeSort (left, center) - left hand side
		# move $sp back another 16
		addi $sp, $sp, -16
		sw $t0, 4($sp) #left into sp offset 4
		sw $t3, 8($sp) #center into sp offset 8 right
		
		jal mergeSort
		sw $ra, 0($sp)
		
		#mergeSort(center+1, right) - right hand side of array
		# move $sp back another 16
		lw $t4, 12($sp)
		addi $sp, $sp, -16
		addi $t4, $t4, 1 #center+1
		sw $t4, 4($sp)
		sw $t1, 8($sp)
		
		jal mergeSort
		sw $ra, 0($sp)
		
		#merge(left, center+1, right)
		
	lw $ra, 0($sp) #get return address
	addi $sp, $sp, 16 #pop
	jr $ra #jump back
	

merge:

# create a 3rd offset to store local variable Center

end: 
la $a0, msg
li $v0, 4
syscall
li $v0, 10
syscall