# merge sort
#java implementation for reference - https://www.cs.cmu.edu/~adamchik/15-121/lectures/Sorting%20Algorithms/code/MergeSort.java
.data
nums: .word 10, 9, 8, 7
sorted: .word 0:4
length: .word 4
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

end:
li $v0, 10
syscall
mergeSort: #(left, right)
		#load from stack
		lw $t0, 4($sp) #t0 = left
		lw $t1, 8($sp) #t1 = right
		lw $t3, 12($sp) #t3 = center
		
		sub $t2, $t0, $t1
		#addi $t2, $t2, 1 #to stop at 0th index
		beqz $t2, endMS #if left - right < 0 then $t2 and keep going, otherwise end
		
		add $t3, $t0, $t1 #t3 = center
		srl $t3, $t3, 1 #t3 = center = (left+right)/2
		sw $t3, 12($sp) #storing center into stack
		
		#mergeSort (left, center) - left hand side
		addi $sp, $sp, -16 # move $sp back another 16
		sw $t0, 4($sp) #left into sp offset 4
		sw $t3, 8($sp) #center into sp offset 8 right because we evaluate center as right in recursion
		
		jal mergeSort
		sw $ra, 0($sp)
		
		#mergeSort(center+1, right) - right hand side of array
		# move $sp back another 16
		addi $sp, $sp, 16 #pop
		lw $t1, 8($sp) #right
		lw $t4, 12($sp) #center
		
		addi $sp, $sp, -16
		addi $t4, $t4, 1 #center+1
		sw $t4, 4($sp)
		sw $t1, 8($sp)
		
		jal mergeSort
		sw $ra, 0($sp)
		
		#merge param(left, right, rightEnd) (left, center+1, right)
		addi $sp, $sp, 16
		lw $t5, 12($sp) #load center
		addi $t5, $t5, 1 #center + 1
		lw $t0, 4($sp) #left
		lw $t1, 8($sp) #rightEnd
		sw $t5, 12($sp) #right, center for consistency
		
		jal merge
		#sw $ra, 0($sp)
		nop
		
		#end of mergeSort method	
		lw $ra, 0($sp) #get return address
		jr $ra #jump back
		nop
	
endMS: #load address to jump back
	lw $ra, 0($sp)
	jr $ra
	nop
	
merge: #param (left, right, rightEnd)
	lw $t0, 4($sp) #t0 = left
	lw $t1, 8($sp) #t1 = rightEnd
	lw $t2, 12($sp) #t2 = center, or right
	subi $t3, $t2, 1 #t3 = leftEnd = right - 1
	add $t4, $t0, $zero #t4 = k
	sub $t5, $t1, $t0
	addi $t5, $t5, 1 #num = rightEnd - left + 1
	
	firstWhile:	#while(left <= leftEnd && right <= rightEnd)
		 	sub $t6, $t0, $t3 #t6 = left - leftEnd
			bgtz $t6, secondWhile
			nop
			sub $t7, $t2, $t1 #t7 = right - rightEnd
			bgtz $t7, secondWhile
			nop
				sll $t8, $t0, 2 #t8 = left * 4 to get offset amount 
				sll $t9, $t2, 2 #t9 = right * 4 to get offset amount
				add $t8, $t8, $s0 #offset copy of base array by left amount
				add $t9, $t9, $s0 #offset copy of base array by right
				lw $s2, 0($t8) #a[left]
				lw $s3, 0($t9) #a[right]
				sub $s4, $s2, $s3 #if(a[left].compareTo(a[right]) <= 0)
				bgtz $s4, else
				nop
					sll $s5, $t4, 2 #4*k to get offset amount
					sw $s2, sorted($s5)
					addi $t0, $t0, 1 #increment left by 1
					addi $t4, $t4, 1 #k++
				else: 
					sll $s5, $t4, 2 #4*k to get offset amount
					sw $s3, sorted($s5)
					addi $t2, $t2, 1 #increment right by 1
					addi $t4, $t4, 1 #k++
				J firstWhile
				nop
			
	secondWhile: #copy rest of left half
			sub $t6, $t0, $t3
			bgtz $t6, thirdWhile
			nop
				sll $t7, $t0, 2 #left offset by 4
				add $t7, $t7, $s0
				lw $t7, 0($t7) #a[left]
				
				sll $t8, $t4, 2 #copy of k offset by 4
				sw $t7, sorted($t8)
				
				addi $t0, $t0, 1 #increment left by 1
				addi $t4, $t4, 1 #increment k by 1
				J secondWhile
				nop
	thirdWhile: #copy rest of right half
			sub $t6, $t2, $t1
			bgtz $t6, copyArray
			nop
				sll $t7, $t1, 2 #right offset by 4
				add $t7, $t7, $s0
				lw $t7, 0($t7) #a[right]
				
				sll $t8, $t4, 2
				sw $t7, sorted($t8) #store tmp[k] = a[right]
				
				addi $t2, $t2, 1 #increment right by 1
				addi $t4, $t4, 1 #increment k by 1
	
	copyArray: #a[] = tmp[]
			li $t6, 0
		loop:	sub $s2, $t6, $t5
			beqz $s2, endMerge
			sll $t7, $t1, 2 #rightEnd offset by 4, will be shared with a[] and tmp[]
			la $t8, sorted
			add $t8, $t8, $t7 #rightEnd of tmp[]
			add $t9, $s0, $t7 #rightEnd of a[]
			lw $t8, 0($t8) #tmp[rightEnd]
			sw $t8, 0($t9) #a[rightEnd] = tmp[rightEnd]
			addi $t6, $t6, 1
			addi $t1, $t1, -1
			J loop
			nop

	endMerge: #need to jump back to address after finished
		lw $ra, 0($sp)
		#pop here?
		#addi $sp, $sp, 16
		jr $ra
		nop

la $a0, msg
li $v0, 4
syscall
li $v0, 10
syscall