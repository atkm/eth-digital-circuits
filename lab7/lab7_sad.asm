#
# Sum of Absolute Differences Algorithm
#
# Authors: 
#	X Y, Z Q 
#
#

.text


main:


# Initializing data in memory... 
# Store in $s0 the address of the first element in memory
	# lui sets the upper 16 bits of thte specified register
	# ori the lower ones
	# (to be precise, lui also sets the lower 16 bits to 0, ori ORs it with the given immediate)
	     lui     $s0, 0x0000 # Address of first element in the vector
	     ori     $s0, 0x0000
	     # 0x0000, ... , 0x0020 is for left_image.
	     addi   $t0, $0, 5	# left_image[0]	
	     sw      $t0, 0($s0)
	     addi   $t0, $0, 16	# left_image[1]		
	     sw      $t0, 4($s0)
	     # TODO1 (DONE): initilize the rest of the memory.
	     # This cannot be done in a for loop, because the pixel values are independent of the pixel index.
	     addi   $t0, $0, 7	# left_image[2]		
	     sw      $t0, 8($s0)
	     addi   $t0, $0, 1	# left_image[3]		
	     sw      $t0, 12($s0)
	     addi   $t0, $0, 1	# left_image[4]		
	     sw      $t0, 16($s0)
	     addi   $t0, $0, 13 # left_image[5]		
	     sw      $t0, 20($s0)
	     addi   $t0, $0, 2	# left_image[6]		
	     sw      $t0, 24($s0)
	     addi   $t0, $0, 8	# left_image[7]		
	     sw      $t0, 28($s0)
	     addi   $t0, $0, 10	# left_image[8]		
	     sw      $t0, 32($s0)
	     # 0x0024, ... , 0x0044 is for right_image.
	     addi   $t0, $0, 4	# right_image[0]		
	     sw      $t0, 36($s0)
	     addi   $t0, $0, 15	# right_image[1]		
	     sw      $t0, 40($s0)
	     addi   $t0, $0, 8	# right_image[2]		
	     sw      $t0, 44($s0)
	     addi   $t0, $0, 0	# right_image[3]		
	     sw      $t0, 48($s0)
	     addi   $t0, $0, 2	# right_image[4]		
	     sw      $t0, 52($s0)
	     addi   $t0, $0, 12	# right_image[5]		
	     sw      $t0, 56($s0)
	     addi   $t0, $0, 3	# right_image[6]		
	     sw      $t0, 60($s0)
	     addi   $t0, $0, 7	# right_image[7]		
	     sw      $t0, 64($s0)
	     addi   $t0, $0, 11	# right_image[8]		
	     sw      $t0, 68($s0)
	     # 0x0048, ... , 0x0068 is for sad_array.
	     
	# TODO4 (DONE): Loop over the elements of left_image and right_image
	
	addi $s1, $0, 0 # $s1 = i = 0
	addi $s2, $0, 9	# $s2 = image_size = 9
	addi $s3, $0, 0 # $s3 = address of the pixel

loop:

	# Check if we have traverse all the elements 
	# of the loop. If so, jump to end_loop:
	beq $s1,$s2,end_loop
	
	# ....
	
	
	# Load left_image{i} and put the value in the corresponding register (a0)
	# before doing the function call
	# ....
	lw $a0, ($s3)
	
	# Load right_image{i} and put the value in the corresponding register (a1)
	lw $a1, 36($s3) # the offset is 36 between left_image and right_image.
	# ....
	
	# Call abs_diff
	jal abs_diff
	# ....
	
	#Store the returned value in sad_array[i]
	sw $v0, 72($s3) # the offset is 72 between left_image and sad_array.
	# ....
	
	
	# Increment variable i and repeat loop:
	addi $s1,$s1,1
	addi $s3,$s3,4
	j loop
	# ...
	

	
end_loop:

	#TODO5: Call recursive_sum and store the result in $t2
	#Calculate the base address of sad_array (first argument
	#of the function call)and store in the corresponding register   
	addi $a0, $0, 0x0048 # sad array starts here
	# ...
	
	# Prepare the second argument of the function call: the size of the array
	addi $a1, $0, 9
	#..... 
	
	# Call to funtion
	jal recursive_sum
	# ....
	  
	
	#Store the returned value in $t2
	add $t2, $0, $v0
	# .....
	

end:	
	j	end	# Infinite loop at the end of the program. 




# TODO2 (DONE. use): Implement the abs_diff routine here, or use the one provided
# In general, abs(x) = (x ^ y) - y where y = x >> 31 (sign bit repeated for 32 bits)
abs_diff:
        sub $t1, $a0, $a1
        sra $t2,$t1,31   
        xor $t1,$t1,$t2   
        sub $v0,$t1,$t2    

        jr $ra


# TODO3 (DONE. use): Implement the recursive_sum routine here, or use the one provided
recursive_sum:    
        addi $sp, $sp, -8       # Adjust sp
        addi $t0, $a1, -1       # Compute size - 1
        sw   $t0, 0($sp)        # Save size - 1 to stack
        sw   $ra, 4($sp)        # Save return address
        bne  $a1, $zero, else   # size == 0 ?
        addi  $v0, $0, 0        # If size == 0, set return value to 0
        addi $sp, $sp, 8        # Adjust sp
        jr $ra                  # Return

else:     
        add  $a1, $t0, $0               #update the second argument
        jal   recursive_sum 
        lw    $t0, 0($sp)       # Restore size - 1 from stack
        sll  $t1, $t0, 2        # Multiply size by 4
        add   $t1, $t1, $a0     # Compute & arr[ size - 1 ]
        lw    $t2, 0($t1)       # t2 = arr[ size - 1 ]
        add   $v0, $v0, $t2     # retval = $v0 + arr[size - 1]
        lw    $ra, 4($sp)       # restore return address from stack         
        addi $sp, $sp, 8        # Adjust sp
        jr $ra                  # Return
