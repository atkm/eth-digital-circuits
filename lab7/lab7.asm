#
# Calculate sum from A to B.
#
# Authors: 
#	X Y, Z Q 
#
#
# Put your sum S into register $t2

.text
main:
	# Set $t0 = A, $t1 = B+1.
  	addi $t0 $0 5
  	addi $t1 $0 7
  	add  $t1 $t1 1
  	# $t0 is the loop counter
  	
for: 	beq $t1	$t0 endfor
	add $t2 $t2 $t0
	add $t0 $t0 1 # increment
	j for
endfor:	