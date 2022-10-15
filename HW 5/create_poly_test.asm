############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
.data
pairs: .word 5 5 9 2 0 -1
N: .word 2

.text
main:
	  la $a0, pairs
    lw $a1, N
  	jal create_polynomial
  	#write test code


exit:
	li $v0, 10
	syscall
.include "hw5.asm"
