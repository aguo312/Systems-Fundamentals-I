############## Andrew Guo ##############
############## 113517303 #################
############## andguo ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_term
create_term:

  addi	$sp, $sp, -8      # $sp = $sp + -8                      # allocating space in the stack  
  sw		$a0, 0($sp)		                                          # save coefficient to the stack
  sw		$a1, 4($sp)		                                          # save exponent to the stack
  beq		$a0, $zero, create_termfail	                            # if $a0 == $zero then create_termfail
  blt		$a1, $zero, create_termfail	                            # if $a1 < $zero then create_termfail
  
  li $a0, 12                                                    # amount
  li $v0, 9                                                     # sbrk
  syscall

  lw		$a0, 0($sp)		                                          # load coefficent from the stack
  lw		$a1, 4($sp)		                                          # load exponent from the stack
  sw		$a0, 0($v0)		                                          # save coefficent to the term coeff
  sw		$a1, 4($v0)		                                          # save exponent to the term exp
  sw		$zero, 8($v0)		                                        # save null to the term next_term
  
  j		exitcreate_term				                                    # jump to exitcreate_term

  create_termfail:
  li		$v0, -1		                                              # $v0 = -1

  exitcreate_term:
  addi	$sp, $sp, 8	    # $sp = $sp + 8                         # deallocating space in the stack
  
  jr $ra

.globl create_polynomial
create_polynomial:

  addi	$sp, $sp, -16     # $sp = $sp + -16                     # allocating space in the stack
  sw		$a0, 0($sp)		                                          # save pairs to the stack
  sw		$a1, 4($sp)		                                          # save N to the stack
  sw		$ra, 8($sp)		                                          # save $ra to the stack
  
  lw		$a0, 0($sp)		                                          # load pairs addr
  jal		sort_array				                                      # jump to sort_array and save position to $ra
  sw		$v0, 0($sp)		                                          # save sorted pairs addr
  
  li		$t0, 0		# $t0 = 0                                     # size counter
  lw		$t1, 0($sp)		                                          # load sorted pairs addr
  create_polynomialsizeloop:
    lw		$t2, 0($t1)		                                        # coefficient
    lw		$t3, 4($t1)		                                        # exponent
    li		$t4, -1		# $t4 = -1
    
    blt		$t3, $t4, create_polynomialsizeloopnoincrement        # if $t3 < $t4 then create_polynomialsizeloopnoincrement
    beq		$t3, $t4, create_polynomialsizeloopendcheck         	# if $t3 == $t4 then create_polynomialsizeloopendcheck
    beq		$t2, $zero, create_polynomialsizeloopnoincrement    	# if $t2 == $zero then create_polynomialsizeloopnoincrement
    j		create_polynomialsizeloopnext				                    # jump to create_polynomialsizeloopnext

    create_polynomialsizeloopendcheck:
    beq		$t2, $zero, exitcreate_polynomialsizeloop	            # if $t2 == $zero then exitcreate_polynomialsizeloop
    j		create_polynomialsizeloopnoincrement            				# jump to create_polynomialsizeloopnoincrement
    
    create_polynomialsizeloopnext:
    addi	$t0, $t0, 1			# $t0 = $t0 + 1

    create_polynomialsizeloopnoincrement:
    addi	$t1, $t1, 8			# $t1 = $t1 + 8
    j		create_polynomialsizeloop				                        # jump to create_polynomialsizeloop
    
  exitcreate_polynomialsizeloop:

  bne		$t0, $zero, create_polynomialsizegreaterzero	          # if $t0 != $zero then create_polynomialsizegreaterzero
  li		$v0, 0		# $v0 = 0                                     # return null
  j		exitcreate_polynomial				                              # jump to exitcreate_polynomial
  
  create_polynomialsizegreaterzero:
  lw		$t1, 4($sp)		                                          # load N
  ble		$t1, $zero, create_polynomialnless0	                    # if $t1 <= $zero then create_polynomialnless0
  bgt		$t1, $t0, create_polynomialngreatersize	                # if $t1 > $t0 then create_polynomialngreatersize
  sw		$t1, 4($sp)		                                          # 
  j		create_polynomialloopprepare				                      # jump to create_polynomialloopprepare
  
  create_polynomialnless0:
  sw		$t0, 4($sp)		                                          # save size as N
  j		create_polynomialloopprepare				                      # jump to create_polynomialloopprepare

  create_polynomialngreatersize:
  sw		$t0, 4($sp)		                                          # save size as N
  j		create_polynomialloopprepare				                      # jump to create_polynomialloopprepare

  create_polynomialloopprepare:
  li $a0, 12                                                    # amount
  li $v0, 9                                                     # sbrk
  syscall    
  sw		$v0, 12($sp)		                                        # save empty term to the stack
  
  lw		$t0, 4($sp)		                                          # load N counter
  lw		$t1, 0($sp)		                                          # load sorted pairs addr
  lw		$t2, 12($sp)		                                        # load previous term addr
  
  create_polynomialloop:
    beq		$t0, $zero, exitcreate_polynomialloop	                # if $t0 == $zero then exitcreate_polynomialloop
    lw		$a0, 0($t1)		                                        # $a0 = coefficient
    lw		$a1, 4($t1)		                                        # $a1 = exponent
    addi	$sp, $sp, -12			# $sp = $sp + -12                   # allocate space in the stack
    sw		$t0, 0($sp)		                                        # save N counter to the stack
    sw		$t1, 4($sp)		                                        # save sorted pairs addr to the stack
    sw		$t2, 8($sp)		                                        # save previous term addr to the stack
    jal		create_term				                                    # jump to create_term and save position to $ra
    lw		$t0, 0($sp)		                                        # load N counter
    lw		$t1, 4($sp)		                                        # load sorted pairs addr
    lw		$t2, 8($sp)		                                        # load previous term addr
    addi	$sp, $sp, 12			# $sp = $sp + 12                    # deallocate space in the stack
    blt		$v0, $zero, create_polynomialloopnext	                # if $v0 < $zero then create_polynomialloopnext
    sw		$v0, 8($t2)		                                        # save term to next_term
    move 	$t2, $v0		# $t2 = $v0                               # term = previous term
    addi	$t0, $t0, -1			# $t0 = $t0 + -1                    # increment N counter
    
    create_polynomialloopnext:
    addi	$t1, $t1, 8			# $t1 = $t1 + 8                       # move to next pair
    j		create_polynomialloop				                            # jump to create_polynomialloop

  exitcreate_polynomialloop:

  lw		$t0, 12($sp)		                                        # load empty term
  lw		$t0, 8($t0)		                                          # head_term addr
  
  create_polynomialfixpolyloop:
    lw		$t1, 0($t0)		                                        # coefficient 1
    lw		$t2, 4($t0)		                                        # exponent 1
    lw		$t3, 8($t0)		                                        # next_term 1
    beq		$t3, $zero, exitcreate_polynomialfixpolyloop	        # if $t3 == $zero then exitcreate_polynomialfixpolyloop
    lw		$t4, 0($t3)		                                        # coefficient 2
    lw		$t5, 4($t3)		                                        # exponent 2
    lw		$t6, 8($t3)		                                        # next_term 2
    bne		$t2, $t5, create_polynomialfixpolyloopnext	          # if $t2 != $t5 then create_polynomialfixpolyloopnext
    bne		$t1, $t4, create_polynomialfixpolyloopadd	            # if $t1 != $t4 then create_polynomialfixpolyloopadd
    sw		$t6, 8($t0)		                                        # remove next term from polynomial
    beq		$t6, $zero, exitcreate_polynomialfixpolyloop	        # if $t6 == $zero then exitcreate_polynomialfixpolyloop
    j		create_polynomialfixpolyloop				                    # jump to create_polynomialfixpolyloop

    create_polynomialfixpolyloopadd:
    add		$t1, $t1, $t4		# $t1 = $t1 + $t4                     # add coefficients
    sw		$t1, 0($t0)		                                        # save new coefficient to current term
    sw		$t6, 8($t0)		                                        # remove next term from polynomial
    j		create_polynomialfixpolyloop				                    # jump to create_polynomialfixpolyloop
    
    create_polynomialfixpolyloopnext:
    move 	$t0, $t3		# $t0 = $t3                               # next_term
    j		create_polynomialfixpolyloop				                    # jump to create_polynomialfixpolyloop
  
  exitcreate_polynomialfixpolyloop:

  lw		$t0, 12($sp)		                                        # load empty term
  lw		$t0, 8($t0)		                                          # head_term addr
  
  create_polynomialfixpolyzeroloop:
    lw		$t1, 8($t0)		                                        # next_term 1
    beq		$t1, $zero, exitcreate_polynomialfixpolyzeroloop	    # if $t1 == $zero then exitcreate_polynomialfixpolyzeroloop
    lw		$t2, 0($t1)		                                        # coefficient 2
    lw		$t3, 8($t1)		                                        # next_term 2
    bne		$t2, $zero, create_polynomialfixpolyzeroloopnext	    # if $t2 != $zero then create_polynomialfixpolyzeroloopnext
    sw		$t3, 8($t0)		                                        # remove next term from polynomial
    beq		$t6, $zero, exitcreate_polynomialfixpolyzeroloop	    # if $t6 == $zero then exitcreate_polynomialfixpolyzeroloop
    j		create_polynomialfixpolyzeroloop				                # jump to create_polynomialfixpolyzeroloop
    
    create_polynomialfixpolyzeroloopnext:
    move 	$t0, $t1		# $t0 = $t1                               # next_term
    j		create_polynomialfixpolyzeroloop				                # jump to create_polynomialfixpolyzeroloop
    
  exitcreate_polynomialfixpolyzeroloop:

  li		$t0, 0		# $t0 = 0                                     # no_of_terms counter
  lw		$t1, 12($sp)		                                        # load empty term
  lw		$t1, 8($t1)		                                          # head_term addr
  
  create_polynomialcountpolytermsloop:
    addi	$t0, $t0, 1			# $t0 = $t0 + 1                       # increment counter
    lw		$t2, 8($t1)		                                        # next_term addr
    beq		$t2, $zero, exitcreate_polynomialcountpolytermsloop	  # if $t2 == $zero then exitcreate_polynomialcountpolytermsloop
    move 	$t1, $t2		# $t1 = $t2
    j		create_polynomialcountpolytermsloop				              # jump to create_polynomialcountpolytermsloop
    
  exitcreate_polynomialcountpolytermsloop:

  li $a0, 8                                                     # amount
  li $v0, 9                                                     # sbrk
  syscall
  sw		$t0, 4($v0)		                                          # save counter to no_of_terms
  lw		$t1, 12($sp)		                                        # load empty term
  lw		$t1, 8($t1)		                                          # head_term addr
  sw		$t1, 0($v0)		                                          # save head_term addr to head_term
    
  exitcreate_polynomial:
  lw		$ra, 8($sp)		                                          # load $ra
  addi	$sp, $sp, 16			                                      # $sp = $sp + 16

  jr $ra

.globl add_polynomial
add_polynomial:
  
  addi	$sp, $sp, -16			# $sp = $sp + -16                     # allocate space in the stack
  sw		$a0, 0($sp)		                                          # save poly 1
  sw		$a1, 4($sp)		                                          # save poly 2
  sw		$ra, 8($sp)		                                          # save $ra

  beq		$a0, $zero, add_polynomiala0zero	                      # if $a0 == $zero then add_polynomiala0zero
  beq		$a1, $zero, add_polynomiala1zero	                      # if $a1 == $zero then add_polynomiala1zero
  
  li $a0, 12                                                    # amount
  li $v0, 9                                                     # sbrk
  syscall    
  sw		$v0, 12($sp)		                                        # save empty term to the stack

  lw		$t0, 0($sp)		                                          # load poly 1
  lw		$t0, 0($t0)		                                          # load head_term of poly 1
  lw		$t1, 4($sp)		                                          # load poly 2
  lw		$t1, 0($t1)		                                          # load head_term of poly 2
  lw		$t2, 12($sp)		                                        # load empty term
  
  # if one of them is 0 then append the rest of the other
  add_polynomialloop:
    lw		$t3, 4($t0)		                                        # exponent 1
    lw		$t4, 8($t0)		                                        # next_term 1
    #beq		$t4, $zero, exit_addpolynomialloop	                  # if $t4 == $zero then exit_addpolynomialloop
    lw		$t5, 4($t1)		                                        # exponent 2
    lw		$t6, 8($t1)		                                        # next_term 2
    # if t3 is greater than t5
    #   increment t0
    # if t5 is greater than t3
    #   increment t1
    # if t3 is equal to $t5
    #   increment both
    bgt		$t3, $t5, add_polynomialloope1greater	                # if $t3 > $t5 then add_polynomialloope1greater
    bgt		$t5, $t3, add_polynomialloope2greater	                # if $t5 > $t3 then add_polynomialloope2greater
    beq		$t3, $t5, add_polynomialloopbothequal	                # if $t3 == $t5 then add_polynomialloopbothequal

    add_polynomialloope1greater:
    sw		$t0, 8($t2)		                                        # next_term = term 1
    move 	$t2, $t0		# $t2 = $t0                               # previous term = term 1
    move 	$t0, $t4		# $t0 = $t4                               # term 1 = next_term 1
    j		add_polynomialloopiszerocheck				                    # jump to add_polynomialloopiszerocheck

    add_polynomialloope2greater:
    sw		$t1, 8($t2)		                                        # next_term = term 2
    move 	$t2, $t1		# $t2 = $t1                               # previous term = term 2
    move 	$t1, $t6		# $t1 = $t6                               # term 2 = next_term 2
    j		add_polynomialloopiszerocheck				                    # jump to add_polynomialloopiszerocheck

    add_polynomialloopbothequal:
    lw		$t7, 0($t0)		                                        # coefficient 1
    lw		$t8, 0($t1)		                                        # coefficient 2
    add		$t7, $t7, $t8		# $t7 = $t7 + $t8                     # coefficient 1 + coefficent 2
    beq		$t7, $zero, add_polynomialloopbothequalnext	          # if $t7 == $zero then add_polynomialloopbothequalnext
    sw		$t7, 0($t0)		                                        # coefficient 1 = c1 + c2
    sw		$t0, 8($t2)		                                        # next_term = new term 1
    move 	$t2, $t0		# $t2 = $t0                               # previous_term = new term 1

    add_polynomialloopbothequalnext:
    move 	$t0, $t4		# $t0 = $t4                               # term 1 = next_term 1
    move 	$t1, $t6		# $t1 = $t6                               # term 2 = next_term 2
    
    add_polynomialloopiszerocheck:
    beq		$t0, $zero, add_polynomialiszerocheckt1	              # if $t0 == $zero then add_polynomialiszerocheckt1
    beq		$t1, $zero, add_polynomialiszerocheckt2	              # if $t1 == $zero then add_polynomialiszerocheckt2
    j		add_polynomialloop				                              # jump to add_polynomialloop

    add_polynomialiszerocheckt1:
    sw		$t1, 8($t2)		                                        # next_term = term 2
    j		exit_addpolynomialloop				                          # jump to exit_addpolynomialloop
    
    add_polynomialiszerocheckt2:
    sw		$t0, 8($t2)		                                        # next_term = term 1
    j		exit_addpolynomialloop				                          # jump to exit_addpolynomialloop

  exit_addpolynomialloop:

  # find polynomial count
  li		$t0, 0		# $t0 = 0                                     # no_of_terms counter
  lw		$t1, 12($sp)		                                        # load empty term
  lw		$t1, 8($t1)		                                          # head_term addr
  
  add_polynomialcountpolytermsloop:
    beq		$t1, $zero, exitadd_polynomialcountpolytermsloop	    # if $t1 == $zero then exitadd_polynomialcountpolytermsloop
    addi	$t0, $t0, 1			# $t0 = $t0 + 1                       # increment counter
    lw		$t2, 8($t1)		                                        # next_term addr
    beq		$t2, $zero, exitadd_polynomialcountpolytermsloop	    # if $t2 == $zero then exitadd_polynomialcountpolytermsloop
    move 	$t1, $t2		# $t1 = $t2
    j		add_polynomialcountpolytermsloop				                # jump to add_polynomialcountpolytermsloop
    
  exitadd_polynomialcountpolytermsloop:

  beq		$t0, $zero, add_polynomialbothzero            	        # if $t0 == $zero then add_polynomialbothzero
  
  li $a0, 8                                                     # amount
  li $v0, 9                                                     # sbrk
  syscall
  sw		$t0, 4($v0)		                                          # save counter to no_of_terms
  lw		$t1, 12($sp)		                                        # load empty term
  lw		$t1, 8($t1)		                                          # head_term addr
  sw		$t1, 0($v0)		                                          # save head_term addr to head_term
  j		exitadd_polynomial				                                # jump to exitadd_polynomial

  add_polynomiala0zero:
  beq		$a1, $zero, add_polynomialbothzero	                    # if $a1 == $zero then add_polynomialbothzero
  j		add_polynomialreturna1				                            # jump to add_polynomialreturna1
  
  add_polynomiala1zero:
  beq		$a0, $zero, add_polynomialbothzero	                    # if $a0 == $zero then add_polynomialbothzero
  j		add_polynomialreturna0				                            # jump to add_polynomialreturna0

  add_polynomialreturna0:
  move 	$v0, $a0		# $v0 = $a0                                 # return $a0
  j		exitadd_polynomial				                                # jump to exitadd_polynomial
  
  add_polynomialreturna1:
  move 	$v0, $a1		# $v0 = $a1                                 # return $a1
  j		exitadd_polynomial				                                # jump to exitadd_polynomial
  
  add_polynomialbothzero:
  li		$v0, 0		# $v0 = 0                                     # return null
  j		exitadd_polynomial				                                # jump to exitadd_polynomial
  
  exitadd_polynomial:
  lw		$ra, 8($sp)		                                          # load $ra
  addi	$sp, $sp, 16			                                      # $sp = $sp + 16

  jr $ra

.globl mult_polynomial
mult_polynomial:

  addi	$sp, $sp, -20			# $sp = $sp + -20                     # allocate space in the stack
  sw		$a0, 0($sp)		                                          # save poly 1
  sw		$a1, 4($sp)		                                          # save poly 2
  sw		$ra, 8($sp)		                                          # save $ra
  sw		$s0, 12($sp)		                                        # save $s0
  li		$s0, 0		# $s0 = 0                                     # reset $s0

  beq		$a0, $zero, mult_polynomialreturnzero	                  # if $a0 == $zero then mult_polynomialreturnzero
  beq		$a1, $zero, mult_polynomialreturnzero	                  # if $a1 == $zero then mult_polynomialreturnzero
  
  # heap 4
  # outer loop until poly 1 = 0
  #   information of term(n outer loop) in poly 1
  #   inner loop until poly 2 = 0
  #     information of term (n inner loop) in poly 2
  #     heap 8
  #     multiplied info
  #     link to outside heap 8
  #     loop
  #   create polynomial outside heap 8
  #   add polynomial s0 and v0 store in s0
  # loop

  lw		$t0, 0($sp)		                                          # load poly 1
  lw		$t0, 0($t0)		                                          # load poly 1 term addr
  mult_polynomialouterloop:
    beq		$t0, $zero, exitmult_polynomialouterloop	            # if $t0 == $zero then exitmult_polynomialouterloop
    
    li $a0, 4                                                     # amount
    li $v0, 9                                                     # sbrk
    syscall
    sw		$v0, 16($sp)		                                        # save empty term to the stack

    lw		$t2, 0($t0)		                                        # poly 1 term coefficient
    lw		$t3, 4($t0)		                                        # poly 1 term exponent
    
    lw		$t1, 4($sp)		                                        # load poly 2
    lw		$t1, 0($t1)		                                        # load poly 2 term addr
    mult_polynomialinnerloop:
      beq		$t1, $zero, exitmult_polynomialinnerloop	          # if $t1 == $zero then exitmult_polynomialinnerloop
      
      lw		$t4, 0($t1)		                                      # poly 2 term coefficient
      lw		$t5, 4($t1)	                                      	# poly 2 term exponent
      mult	$t2, $t4			# $t2 * $t4 = Hi and Lo registers
      mflo	$t6					# copy Lo to $t6                        # c1 * c2
      add		$t7, $t3, $t5		# $t7 = $t3 + $t5                   # e1 + e2

      li $a0, 8                                                 # amount
      li $v0, 9                                                 # sbrk
      syscall

      sw		$t6, 0($v0)		                                      # save c1 * c2
      sw		$t7, 4($v0)		                                      # save e1 + e2
      
      lw		$t8, 8($t1)		                                      # poly 2 term next_term
      move 	$t1, $t8		# $t1 = $t8                             # poly 2 term = next poly 2 term
      j		mult_polynomialinnerloop				                      # jump to mult_polynomialinnerloop

    exitmult_polynomialinnerloop:
    
    li $a0, 8                                                   # amount
    li $v0, 9                                                   # sbrk
    syscall
    li		$t6, 0		# $t6 = 0
    li		$t7, -1		# $t7 = -1
    sw		$t6, 0($v0)		                                        # save 0
    sw		$t7, 4($v0)		                                        # save -1

    lw		$a0, 16($sp)		                                      # load empty term
    #lw		$a0, 0($a0)		                                        # $a0 = array addr
    addi	$a0, $a0, 4			# $a0 = $a0 + 4                       # $a0 = array addr
    li		$a1, 0		                                            # $a1 = 0
    addi	$sp, $sp, -8			# $sp = $sp + -8                    # allocate space in the stack
    sw		$t0, 0($sp)		                                        # save $t0
    sw		$ra, 4($sp)		                                        # save $ra
    jal		create_polynomial				                              # jump to create_polynomial and save position to $ra
    lw		$t0, 0($sp)		                                        # load $t0
    lw		$ra, 4($sp)		                                        # load $ra
    
    move 	$a0, $s0		# $a0 = $s0                               # poly 1 = $s0
    move 	$a1, $v0		# $a1 = $v0                               # poly 2 = $v0
    sw		$t0, 0($sp)		                                        # save $t0
    sw		$ra, 4($sp)		                                        # save $ra
    jal		add_polynomial				                                # jump to add_polynomial and save position to $ra
    lw		$t0, 0($sp)		                                        # load $t0
    lw		$ra, 4($sp)		                                        # load $ra
    addi	$sp, $sp, 8			# $sp = $sp + 8                       # deallocate space in the stack
    
    move 	$s0, $v0		# $s0 = $v0                               # move sum to $s0
    
    lw		$t8, 8($t0)		                                        # poly 1 term next_term
    move 	$t0, $t8		# $t1 = $t8                               # poly 1 term = next poly 1 term
    j		mult_polynomialouterloop				                        # jump to mult_polynomialouterloop

  exitmult_polynomialouterloop:
  move 	$v0, $s0		# $v0 = $s0                                 # return $s0
  j		exitmult_polynomial				                                # jump to exitmult_polynomial
  

  mult_polynomialreturnzero:
  li		$v0, 0		# $v0 = 0                                     # return 0

  exitmult_polynomial:
  lw		$ra, 8($sp)		                                          # load $ra
  lw		$s0, 12($sp)		                                        # load $s0
  addi	$sp, $sp, 20			                                      # $sp = $sp + 20

  jr $ra

sort_array:
  li		$t0, 1		                                              # $t0 = 1

  lw		$t2, 0($a0)		                                          # coefficient 1
  lw		$t3, 4($a0)		                                          # exponent 1
  li		$t4, -1		                                              # $t4 = -1
  beq		$t3, $t4, sort_arrayfirstendcheck	                      # if $t3 == $t4 then sort_arrayfirstendcheck
  j		sort_arrayouterloop				                                # jump to sort_arrayouterloop
  
  sort_arrayfirstendcheck:
  li		$t4, 0		                                              # $t4 = 0
  beq		$t2, $t4, exitsort_arrayouterloop	                      # if $t2 == $t4 then exitsort_arrayouterloop

  sort_arrayouterloop:
    beq		$t0, $zero, exitsort_arrayouterloop	                  # if $t0 == $zero then exitsort_arrayouterloop
    li		$t0, 0		# $t0 = 0
    move 	$t1, $a0		                                          # $t1 = $a0
    
    sort_arrayinnerloop:
      lw		$t2, 0($t1)		                                      # coefficient 1
      lw		$t3, 4($t1)		                                      # exponent 1
      lw		$t4, 8($t1)		                                      # coefficient 2
      lw		$t5, 12($t1)		                                    # exponent 2
      li		$t6, -1		                                          # $t6 = -1
      beq		$t5, $t6, sort_arrayendcheck	                      # if $t5 == $t6 then sort_arrayendcheck
      j		sort_arrayaction				                              # jump to sort_arrayaction

      sort_arrayendcheck:
      li		$t6, 0		                                          # $t6 = 0
      beq		$t4, $t6, sort_arrayouterloop	                      # if $t4 == $t6 then sort_arrayouterloop
      
      sort_arrayaction:
      bge		$t3, $t5, sort_arraynext	                          # if $t3 >= $t5 then sort_arraynext

      sw		$t2, 8($t1)		                                      # new c1 = old c2
      sw		$t3, 12($t1)		                                    # new e1 = old e2
      sw		$t4, 0($t1)		                                      # new c2 = old c1
      sw		$t5, 4($t1)		                                      # new e2 = old e1      
      addi	$t0, $t0, 1			                                    # $t0 = $t0 + 1

      sort_arraynext:
      addi	$t1, $t1, 8			                                    # $t1 = $t1 + 8
      j		sort_arrayinnerloop				                            # jump to sort_arrayinnerloop

  exitsort_arrayouterloop:
  move 	$v0, $a0		# $v0 = $a0

  jr $ra
    
.globl add_test_func
add_test_func:

  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  move $s0, $a0
  move $s1, $a1
  move $s2, $a2
  move $s3, $a3
  move $a0, $s0
  move $a1, $s2
  jal create_polynomial
  move $s0, $v0
  move $a0, $s1
  move $a1, $s3
  jal create_polynomial
  move $s1, $v0
  move $a0, $s0
  move $a1, $s1
  jal add_polynomial
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

.globl mult_test_func
mult_test_func:

  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  move $s0, $a0
  move $s1, $a1
  move $s2, $a2
  move $s3, $a3
  move $a0, $s0
  move $a1, $s2
  jal create_polynomial
  move $s0, $v0
  move $a0, $s1
  move $a1, $s3
  jal create_polynomial
  move $s1, $v0
  move $a0, $s0
  move $a1, $s1
  jal mult_polynomial
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra