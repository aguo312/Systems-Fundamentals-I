############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
.data
pairs1: .word 33 3 12 4 9 2 3 1 0 -1
N1: .word 13

pairs2: .word 0 2 0 -1
N2: .word 13

.text
main:
#	  la $a0, pairs1
#    lw $a1, N1
#  	jal create_polynomial
#		move $s0, $v0

#		la $a0, pairs2
#    lw $a1, N2
#  	jal create_polynomial
#		move $s1, $v0

#		move $a0, $s0
#		move $a1, $s1
#		jal mult_polynomial
  	#write test code

	la $a0, pairs1
  	la $a1, pairs2
  	lw $a2, N1
  	lw $a3, N2
  	jal mult_test_func

exit:
	li $v0, 10
	syscall

.include "hw5.asm"
