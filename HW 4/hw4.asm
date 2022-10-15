############## Andrew Guo ##############
############## 113517303 #################
############## andguo ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_person
create_person:
  # start at base of node set + size of nodes * num curr nodes
  # $t0 = total_num_nodes
  # $t1 = size_of_node
  # $t2 = curr_num_nodes
  # $t3 = base addr of nodes
  # $t4 = offset based on $t1 and $t2
  # increment $t2
  # capacity v0 = -1
  # success node addr

  lw		$t0, 0($a0)		                                    # total_num_nodes
  lw		$t1, 8($a0)		                                    # size_of_node
  lw		$t2, 16($a0)		                                  # curr_num_of_nodes
  addi	$t3, $a0, 36			# $t3 = $a0 + 36                # base addr of nodes
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t4					# copy Lo to $t4                      # offset from base addr of nodes
  add		$t3, $t3, $t4		# $t3 = $t3 + $t4                 # addr first free node
  beq		$t0, $t2, create_personfail	                      # if $t0 == $t2 then create_personfail
  sw		$zero, 0($t3)		                                  # initialize node with zeros
  addi	$t2, $t2, 1			# $t2 = $t2 + 1                   # increment curr_num_of_nodes
  sw		$t2, 16($a0)		                                  # save new num of nodes
  move 	$v0, $t3		# $v0 = $t3                           # return node addr
  j		exitcreate_person				                            # jump to exitcreate_person
  
  create_personfail:
  li		$v0, -1		# $v0 = -1

  exitcreate_person:

  jr $ra

.globl is_person_exists
is_person_exists:
  # a0 = network addr, a1 = person addr
  # start at base of node set + size of nodes * num curr nodes
  # $t0 = total_num_nodes
  # $t1 = size_of_node
  # $t2 = curr_num_nodes
  # $t3 = base addr of nodes
  # $t4 = loop counter
  # loop (from 0 to curr_num_nodes)
  # if addr not same then + $t1 and loop
  # if addr same then success
  # if reach end and not same then fail
  # fail 0
  # success 1
  lw		$t0, 0($a0)		                                    # total_num_nodes
  lw		$t1, 8($a0)		                                    # size_of_node
  lw		$t2, 16($a0)		                                  # curr_num_of_nodes
  addi	$t3, $a0, 36			# $t3 = $a0 + 36                # base addr of nodes
  li		$t4, 0		# $t4 = 0                               # loop counter
  
  is_person_existsloop:
    beq		$t4, $t2, is_person_existsfail	                # if $t4 == $t2 then is_person_existsfail
    beq		$t3, $a1, is_person_existssuccess	              # if $t3 == $a1 then is_person_existssuccess
    add		$t3, $t3, $t1		# $t3 = $t2 + $t1               # increment node addr
    addi	$t4, $t4, 1			# $t4 = $t4 + 1                 # increment counter
    j		is_person_existsloop				# jump to is_person_existsloop
  
  is_person_existssuccess:
  li		$v0, 1		                                        # $v0 = 1
  j		exitis_person_exists				                        # jump to exitis_person_exists
 
  is_person_existsfail:
  li		$v0, 0		                                        # $v0 = 0
  
  exitis_person_exists:

  jr $ra

.globl is_person_name_exists
is_person_name_exists:
  #a0 = network addr, a1 = name addr
  # $t0 = size_of_node
  # $t1 = curr_num_nodes
  # $t2 = base addr of nodes
  # $t3 = name addr copy
  # $t4 = addr of current person
  # double loop (from 0 to curr num nodes)
  #   end loop if count = curr num nodes
  #   inner loop (from 0 to null)
  #     success if both reaches null
  #     next word if found different
  # $t5 = counter
  # $t6 = char of name
  # $t7 = char of nodename

  lw		$t0, 8($a0)		                                    # size_of_node
  lw		$t1, 16($a0)		                                  # curr_num_of_nodes
  addi	$t2, $a0, 36			# $t2 = $a0 + 36                # base addr of nodes
  li		$t5, 0		# $t5 = 0                               # loop counter

  is_person_name_existsouterloop:
    beq		$t5, $t1, is_person_name_existsfail	            # if $t5 == $t1 then is_person_name_existsfail
    move 	$t3, $a1		# $t3 = $a1                         # copy of name addr
    mult	$t0, $t5			# $t0 * $t5 = Hi and Lo registers 
    mflo	$t4					# copy Lo to $t4
    add		$t4, $t2, $t4		# $t4 = $t2 + $t4               # addr of current person
    
    is_person_name_existsinnerloop:
      lb		$t6, 0($t3)		                                # char of name
      lb		$t7, 0($t4)		                                # char of person
      bne		$t6, $t7, exitis_person_name_existsinnerloop	# if $t6 != $t7 then exitis_person_name_existsinnerloop
      beq		$t6, $zero, exitis_person_name_existsouterloop	# if $t6 == $zero then exitis_person_name_existsouterloop
      addi	$t3, $t3, 1			# $t3 = $t3 + 1               # addr of next char
      addi	$t4, $t4, 1			# $t4 = $t4 + 1               # addr of next char
      j		is_person_name_existsinnerloop				          # jump to is_person_name_existsinnerloop
      
    exitis_person_name_existsinnerloop:
    addi	$t5, $t5, 1			# $t5 = $t5 + 1                 # increment counter
    j		is_person_name_existsouterloop				            # jump to is_person_name_existsouterloop
    
  exitis_person_name_existsouterloop:
  mult	$t0, $t5			# $t0 * $t5 = Hi and Lo registers
  mflo	$t4					# copy Lo to $t4
  add		$t4, $t2, $t4		# $t4 = $t2 + $t4                 # addr of person with name
  li		$v0, 1		                                        # $v0 = 1
  move 	$v1, $t4		                                      # $v1 = $t4
  j		exitis_person_name_exists				                    # jump to exitis_person_name_exists

  is_person_name_existsfail:
  li		$v0, 0		# $v0 = 0

  exitis_person_name_exists:

  jr $ra

.globl add_person_property
add_person_property:
  # a0 = network addr, a1 = person addr, a2 = prop_name addr, a3 = prop_val addr
  
  # save arguments
  addi	$sp, $sp, -20			# $sp = $sp + -20               # allocating space in stack
  sw		$a0, 0($sp)		                                    # save network addr in stack
  sw		$a1, 4($sp)		                                    # save person addr in stack
  sw		$a2, 8($sp)		                                    # save prop_name addr in stack
  sw		$a3, 12($sp)		                                  # save prop_val addr in stack
  sw		$ra, 16($sp)		                                  # save return addr
  
  # first case
  # $t0 = name_prop base addr
  # $t1 = copy of a2
  # loop each char (0 to null)
  # $t2 = char of name_prop
  # $t3 = char of prop_name
  addi	$t0, $a0, 24			# $t0 = $a0 + 24                # base addr of name_prop
  move 	$t1, $a2		# $t1 = $a2                           # copy of prop_name addr
  add_person_propertycase1loop:
    lb		$t2, 0($t0)		                                  # char of name_prop
    lb		$t3, 0($t1)		                                  # char of prop_name
    bne		$t2, $t3, add_person_propertyfail1	            # if $t2 != $t3 then add_person_propertyfail1
    beq		$t2, $zero, add_person_propertycase2	          # if $t2 == $zero then add_person_propertycase2
    addi	$t0, $t0, 1			# $t0 = $t0 + 1                 # increment name_prop addr
    addi	$t1, $t1, 1			# $t1 = $t1 + 1                 # increment prop_name addr
    j		add_person_propertycase1loop				              # jump to add_person_propertycase1loop

  add_person_propertycase2:
  # second case
  # function is_person_exists a0 = network addr, a1 = person addr
  lw		$a0, 0($sp)		                                    # load network addr in $a0
  lw		$a1, 4($sp)	                                    	# load person addr in $a1
  jal		is_person_exists				                          # jump to is_person_exists and save position to $ra
  beq		$v0, $zero, add_person_propertyfail2	            # if $v0 == $zero then add_person_propertyfail2
  
  # third case
  # $t0 = prop_val addr
  # $t1 = size_of_node
  # $t2 = loop counter
  # loop (from 0 to null)
  # if null then stop and count
  lw		$t0, 12($sp)		                                  # load prop_val addr to $t0
  lw		$t1, 0($sp)		                                    # load network addr to $t1
  lw		$t1, 8($t1)		                                    # size_of_node
  li		$t2, 0		# $t2 = 0                               # loop counter
  add_person_propertycase3loop:
    lb		$t3, 0($t0)		                                  # char of prop_val
    beq		$t3, $zero, exitadd_person_propertycase3loop	  # if $t3 == $zero then exitadd_person_propertycase3loop
    addi	$t0, $t0, 1			# $t0 = $t0 + 1                 # increment prop_val addr
    addi	$t2, $t2, 1			# $t2 = $t2 + 1                 # increment counter
    j		add_person_propertycase3loop		              		# jump to add_person_propertycase3loop
    
  exitadd_person_propertycase3loop:
  bge		$t2, $t1, add_person_propertyfail3	# if $t2 >= $t1 then add_person_propertyfail3
  
  # fourth case
  # function is_person_name_exists a0 = network addr, a1 = name addr
  lw		$a0, 0($sp)		                                    # load network addr in $a0
  lw		$a1, 12($sp)		                                  # load prop_val addr in $a1
  jal		is_person_name_exists				                      # jump to is_person_name_exists and save position to $ra
  bgt		$v0, $zero, add_person_propertyfail4	            # if $v0 > $zero then add_person_propertyfail4

  # success
  # $t0 = person addr
  # $t1 = prop_val addr
  # $t2 = prop_val char
  # loop from (0 to null)
  # exit after adding and $t2 is null
  lw		$t0, 4($sp)		                                    # load person addr to $t0
  lw		$t1, 12($sp)		                                  # load prop_val addr to $t1
  add_person_propertyloop:
    lb		$t2, 0($t1)		                                  # char of prop_val
    sb		$t2, 0($t0)		                                  # save char to person addr
    beq		$t2, $zero, exitadd_person_propertyloop	        # if $t2 == $zero then exitadd_person_propertyloop
    addi	$t0, $t0, 1			# $t0 = $t0 + 1                 # increment person addr
    addi	$t1, $t1, 1			# $t1 = $t1 + 1                 # increment prop_val addr
    j		add_person_propertyloop				                    # jump to add_person_propertyloop

  exitadd_person_propertyloop:
    li		$v0, 1		# $v0 = 1
    j		exitadd_person_property				# jump to exitadd_person_property
  
  # fail cases
  add_person_propertyfail1:
    li		$v0, 0		                                      # $v0 = 0
    j		exitadd_person_property				                    # jump to exitadd_person_property
    
  add_person_propertyfail2:
    li		$v0, -1		                                      # $v0 = -1
    j		exitadd_person_property				                    # jump to exitadd_person_property
    
  add_person_propertyfail3:
    li		$v0, -2		                                      # $v0 = -2
    j		exitadd_person_property				                    # jump to exitadd_person_property
    
  add_person_propertyfail4:
    li		$v0, -3		                                      # $v0 = -3

  exitadd_person_property:

  lw		$ra, 16($sp)		                                  # load return addr
  addi	$sp, $sp, 20			# $sp = $sp + 20                # deallocating space in stack
  
  jr $ra

.globl get_person
get_person:
  # a0 = network addr, a1 = name addr
  addi	$sp, $sp, -4			# $sp = $sp + -4                # allocating space in the stack
  sw		$ra, 0($sp)		                                    # save return addr in the stack
  jal		is_person_name_exists				# jump to is_person_name_exists and save position to $ra
  beq		$v0, $zero, exitget_person	# if $v0 == $zero then exitget_person
  move 	$v0, $v1		# $v0 = $v1
  exitget_person:
  lw		$ra, 0($sp)		                                    # load return addr
  addi	$sp, $sp, 4			# $sp = $sp + 4                   # deallocating space in the stack
  
  jr $ra

.globl is_relation_exists
is_relation_exists:
  # a0 = network addr, a1 = person1 addr, a2 = person2 addr
  # $t0 = size_of_edge
  # $t1 = curr_num_of_edges
  # $t2 = edges addr
  # $t3 = loop counter
  # loop (from 0 to curr num of edges)
  # if both addr match then success
  # if both doesnt match then loop
  # escape loop if curr num of edges
  lw		$t0, 12($a0)		                                  # size_of_edge
  lw		$t1, 20($a0)		                                  # curr_num_of_edges
  lw		$t2, 0($a0)		                                    # total_num_nodes
  lw		$t3, 8($a0)		                                    # size_of_node
  mult	$t2, $t3			# $t2 * $t3 = Hi and Lo registers
  mflo	$t3					# copy Lo to $t3                      # nodes_capacity
  addi	$t2, $a0, 36			# $t2 = $a0 + 36                # nodes addr
  add		$t2, $t2, $t3		# $t2 = $t2 + $t3                 # edges addr
  li		$t3, 0		# $t3 = 0                               # loop counter
  
  is_relation_existsloop:
    beq		$t3, $t1, is_relation_existsfail	              # if $t3 == $t1 then is_relation_existsfail
    lw		$t4, 0($t2)		                                  # p1 addr
    lw		$t5, 4($t2)		                                  # p2 addr
    beq		$t4, $a1, is_relation_existsloopcheckp2	        # if $t4 == $a1 then is_relation_existsloopcheckp2
    beq		$t4, $a2, is_relation_existsloopcheckp1	        # if $t4 == $a2 then is_relation_existsloopcheckp1
    j		is_relation_existsloopnext				# jump to is_relation_existsloopnext
    
    is_relation_existsloopcheckp2:
      beq		$t5, $a2, is_relation_existssuccess	          # if $t5 == $a2 then is_relation_existssuccess
      j		is_relation_existsloopnext				              # jump to is_relation_existsloopnext
      
    is_relation_existsloopcheckp1:
      beq		$t5, $a1, is_relation_existssuccess	          # if $t5 == $a1 then is_relation_existssuccess
      j		is_relation_existsloopnext				              # jump to is_relation_existsloopnext
      
    is_relation_existsloopnext:
      add		$t2, $t2, $t0		# $t2 = $t2 + $t0             # increment edges
      addi	$t3, $t3, 1			# $t3 = $t3 + 1
      j		is_relation_existsloop				# jump to is_relation_existsloop
  
  is_relation_existssuccess:
  li		$v0, 1		                                        # $v0 = 1
  j		exitis_relation_exists				                      # jump to exitis_relation_exists

  is_relation_existsfail:
  li		$v0, 0		                                        # $v0 = 0
    
  exitis_relation_exists:

  jr $ra

.globl add_relation
add_relation:
  # a0 = network addr, a1 = person1 addr, a2 = person2 addr
  
  # save arguments
  addi	$sp, $sp, -16			# $sp = $sp + -16               # allocate space in the stack
  sw		$a0, 0($sp)		                                    # save network addr to the stack
  sw		$a1, 4($sp)		                                    # save person1 addr to the stack
  sw		$a2, 8($sp)		                                    # save person2 addr to the stack
  sw		$ra, 12($sp)		                                  # save return addr to the stack
  
  # first case
  # function is_person_exists a0 = network addr, a1 = person addr
  # if v0 = 0 then fail
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 4($sp)		                                    # load person1 addr to $a1
  jal		is_person_exists				                          # jump to is_person_exists and save position to $ra
  beq		$v0, $zero, add_relationfail1	                    # if $v0 == $zero then add_relationfail1
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 8($sp)		                                    # load person2 addr to $a1
  jal		is_person_exists				                          # jump to is_person_exists and save position to $ra
  beq		$v0, $zero, add_relationfail1	                    # if $v0 == $zero then add_relationfail1
  
  # second case
  # $t0 = total_num_edges
  # $t1 = curr_num_edges
  # if equal then fail2
  lw		$a0, 0($sp)		# 
  lw		$t0, 4($a0)		# 
  lw		$t1, 20($a0)		# 
  beq		$t0, $t1, add_relationfail2	# if $t0 == $t1 then add_relationfail2
  
  # third case
  # function is_relation_exists a0 = network addr, a1 = person1 addr, a2 = person2 addr
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 4($sp)		                                    # load person1 addr to $a1
  lw		$a2, 8($sp)		                                    # load person2 addr to $a2
  jal		is_relation_exists				                        # jump to is_relation_exists and save position to $ra
  bne		$v0, $zero, add_relationfail3	                    # if $v0 != $zero then add_relationfail3
  
  # fourth case
  lw		$a1, 4($sp)		                                    # load person1 addr to $a1
  lw		$a2, 8($sp)		                                    # load person2 addr to $a2
  beq		$a1, $a2, add_relationfail4	                      # if $a1 == $a2 then add_relationfail4
  
  # success
  # $t0 = total nodes
  # $t1 = size of nodes
  # $t2 = size of edge
  # $t3 = curr_num_of_edges
  # $t4 = addr of nodes
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 4($sp)		                                    # load person1 addr to $a1
  lw		$a2, 8($sp)		                                    # load person2 addr to $a2
  lw		$t0, 0($a0)		                                    # total_nodes
  lw		$t1, 8($a0)		                                    # size_of_nodes
  lw		$t2, 12($a0)		                                  # size_of_edges
  lw		$t3, 20($a0)		                                  # curr_num_of_edges
  addi	$t4, $a0, 36			# $t4 = $a0 + 36                # addr of nodes
  mult	$t0, $t1			# $t0 * $t1 = Hi and Lo registers
  mflo	$t5					# copy Lo to $t5                      # capacity of nodes
  add		$t4, $t4, $t5		# $t4 = $t4 + $t5                 # addr of edges
  mult	$t2, $t3			# $t2 * $t3 = Hi and Lo registers
  mflo	$t5					# copy Lo to $t5                      # size of used edges
  add		$t4, $t4, $t5		# $t4 = $t4 + $t5                 # addr of first free edge
  sw		$a1, 0($t4)		                                    # add person1 to edge
  sw		$a2, 4($t4)		                                    # add person2 to edge
  sw		$zero, 12($t4)		                                # initialize realtionship with 0
  addi	$t3, $t3, 1			# $t3 = $t3 + 1                   # increment curr_num_of_edges
  sw		$t3, 20($a0)		                                  # save new curr_num_of_edges
  li		$v0, 1		                                        # $v0 = 1
  j		exitadd_relation				                            # jump to exitadd_relation

  # fail cases
  add_relationfail1:
    li		$v0, 0		# $v0 = 0
    j		exitadd_relation				# jump to exitadd_relation
    
  add_relationfail2:
    li		$v0, -1		# $v0 = -1
    j		exitadd_relation				# jump to exitadd_relation
    
  add_relationfail3:
    li		$v0, -2		# $v0 = -2
    j		exitadd_relation				# jump to exitadd_relation
    
  add_relationfail4:
    li		$v0, -3		# $v0 = -3

  exitadd_relation:
  lw		$ra, 12($sp)		                                  # load return addr
  addi	$sp, $sp, 16			# $sp = $sp + 16                # deallocating space in the stack
  
  jr $ra

.globl add_relation_property
add_relation_property:
  # a0 = network addr, a1 = person1 addr, a2 = person2 addr, a3 = prop_name addr
  
  # save arguments
  addi	$sp, $sp, -20			# $sp = $sp + -20               # allocating space in the stack
  sw		$a0, 0($sp)		                                    # save network addr
  sw		$a1, 4($sp)		                                    # save person1 addr
  sw		$a2, 8($sp)		                                    # save person2 addr
  sw		$a3, 12($sp)		                                  # save prop_name addr
  sw		$ra, 16($sp)		                                  # save return addr

  # first case
  # function is_relation_exists a0 = network addr, a1 = person1 addr, a2 = person2 addr
  # if $v0 = 0 then fail1
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 4($sp)		                                    # load person1 addr to $a1
  lw		$a2, 8($sp)		                                    # load person2 addr to $a2
  jal		is_relation_exists				                        # jump to is_relation_exists and save position to $ra
  beq		$v0, $zero, add_relation_propertyfail1	          # if $v0 == $zero then add_relation_propertyfail1
  
  # second case
  # $t0 = frnd_prop addr
  # $t1 = prop_name addr
  # loop (from 0 to null)
  # if not same then fail4
  # if frnd_prop char is null then success
  lw		$a0, 0($sp)		                                    # load network addr
  addi	$t0, $a0, 29			# $t0 = $a0 + 29                # base addr of frnd_prop
  lw		$t1, 12($sp)		                                  # prop_name addr
  
  add_relation_propertycase2loop:
    lb		$t2, 0($t0)		                                  # char of frnd_prop
    lb		$t3, 0($t1)		                                  # char of prop_name
    bne		$t2, $t3, add_relation_propertyfail2	          # if $t2 != $t3 then add_relation_propertyfail2
    beq		$t2, $zero, add_relation_propertysuccess	      # if $t2 == $zero then add_relation_propertysuccess
    addi	$t0, $t0, 1			# $t0 = $t0 + 1                 # increment frnd_prop addr
    addi	$t1, $t1, 1			# $t1 = $t1 + 1                 # increment prop_name addr
    j		add_relation_propertycase2loop				            # jump to add_relation_propertycase2loop
    
  # success
  # function is_relation_exists2 a0 = network addr, a1 = person1 addr, a2 = person2 addr
  add_relation_propertysuccess:
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 4($sp)		                                    # load person1 addr to $a1
  lw		$a2, 8($sp)		                                    # load person2 addr to $a2
  jal		is_relation_exists2				                        # jump to is_relation_exists2 and save position to $ra
  li		$t0, 1		# $t0 = 1                               # friendship = 1
  sb		$t0, 8($v1)		                                    # save new friendship property
  li		$v0, 1		# $v0 = 1
  j		exitadd_relation_property				                    # jump to exitadd_relation_property

  # fail cases
  add_relation_propertyfail1:
  li		$v0, 0		# $v0 = 0
  j		exitadd_relation_property				# jump to exitadd_relation_property
  
  add_relation_propertyfail2:
  li		$v0, -1		# $v0 = -1
  j		exitadd_relation_property				# jump to exitadd_relation_property
  
  exitadd_relation_property:
  lw		$ra, 16($sp)		                                  # load return addr
  addi	$sp, $sp, 20			# $sp = $sp + 20                # deallocating space in the stack
  
  jr $ra

.globl is_friend_of_friend
is_friend_of_friend:
  # a0 = network addr, a1 = name1 addr, a2 = name2 addr

  # save arguments
  addi	$sp, $sp, -24			# $sp = $sp + -24               # allocating space in the stack
  sw		$a0, 0($sp)		                                    # save network addr to the stack
  sw		$a1, 4($sp)		                                    # save name1 addr to the stack
  sw		$a2, 8($sp)		                                    # save name2 addr to the stack
  sw		$ra, 12($sp)		                                  # save return addr to the stack
  
  # name not exist fail
  # function is_person_name_exists a0 = network addr, a1 = name addr
  # if $v0 = 0 then name exist fail
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 4($sp)		                                    # load name1 addr to $a1
  jal		is_person_name_exists				                      # jump to is_person_name_exists and save position to $ra
  beq		$v0, $zero, is_friend_of_friendexistsfail	        # if $v0 == $zero then is_friend_of_friendexistsfail
  sw		$v1, 16($sp)		                                  # save addr of person with name1
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 8($sp)		                                    # load name2 addr to $a1
  jal		is_person_name_exists				                      # jump to is_person_name_exists and save position to $ra
  beq		$v0, $zero, is_friend_of_friendexistsfail	        # if $v0 == $zero then is_friend_of_friendexistsfail
  sw		$v1, 20($sp)		                                  # save addr of person with name2
  
  # are friends fail
  # function is_relation_exists2 a0 = network addr, a1 = person1addr, a2 = person2 addr
  # friend value = 1 then not friend of friend fail
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 16($sp)		                                  # load person1 addr to $a1
  lw		$a2, 20($sp)		                                  # load person2 addr to $a2
  jal		is_relation_exists2				                        # jump to is_relation_exists2 and save position to $ra
  beq		$v1, $zero, is_friend_of_friendloopsetup	        # if $v1 == $zero then is_friend_of_friendloopsetup
  lw		$t0, 8($v1)		                                    # load friendship value
  beq		$v0, $t0, is_friend_of_friendnotfail	            # if $v0 == $t0 then is_friend_of_friendnotfail
  
  # find friends of person1
  # check if friend of person1 is friend of person2
  # loop (from 0 to curr_num_of_edges)
  # exit if counter = curr_num_of_edges
  # $t0 = total_num_nodes
  # $t1 = size_of_node
  # $t2 = size of edge
  # $t3 = curr_num_edge
  # $t4 = addr_of_nodes
  is_friend_of_friendloopsetup:
  lw		$a0, 0($sp)		                                    # load network addr to $a0
  lw		$a1, 16($sp)		                                  # load person1 addr to $a1
  lw		$a2, 20($sp)		                                  # load person2 addr to $a2
  lw		$t0, 0($a0)		                                    # total_nodes
  lw		$t1, 8($a0)		                                    # size_of_nodes
  lw		$t2, 12($a0)		                                  # size_of_edges
  lw		$t3, 20($a0)		                                  # curr_num_of_edges
  addi	$t4, $a0, 36			# $t4 = $a0 + 36                # addr of nodes
  mult	$t0, $t1			# $t0 * $t1 = Hi and Lo registers
  mflo	$t5					# copy Lo to $t5                      # capacity of nodes
  add		$t4, $t4, $t5		# $t4 = $t4 + $t5                 # addr of edges

  # find friends loop
  # $t0 = addr of edges
  # $t1 = size_of_edges
  # $t2 = curr_num_of_edges
  # $t3 = loop counter
  # loop (from 0 to curr_num_of_edges)
  # if counter = curr then fail
  move 	$t0, $t4		# $t0 = $t4                           # addr of edges
  move 	$t1, $t2		# $t1 = $t2                           # size_of_edges
  move 	$t2, $t3		# $t2 = $t3                           # curr_num_of_edges
  move 	$t3, $a1		# $t3 = $a1                           # person1 addr
  move 	$t4, $a2		# $t4 = $a2                           # person2 addr
  li		$t5, 0		# $t3 = 0                               # loop counter
  is_friend_of_friendloop:
    beq		$t5, $t2, is_friend_of_friendnotfail	          # if $t5 == $t2 then is_friend_of_friendnotfail
    lw		$t6, 0($t0)		                                  # load p1 in relation
    beq		$t3, $t6, is_friend_of_friendloopp1	            # if $t3 == $t6 then is_friend_of_friendloopp1
    lw		$t6, 4($t0)		                                  # load p2 in relation
    beq		$t3, $t6, is_friend_of_friendloopp2	            # if $t3 == $t6 then is_friend_of_friendloopp2
    j		is_friend_of_friendloopnext				                # jump to is_friend_of_friendloopnext
    
    is_friend_of_friendloopp1:
    lw		$t7, 8($t0)		                                  # load friendship value in relation
    li		$t8, 1		# $t8 = 1
    lw		$t9, 4($t0)		                                  # load p2 in relation
    beq		$t7, $t8, is_friend_of_friendloopfound	        # if $t7 == $t8 then is_friend_of_friendloopfound
    j		is_friend_of_friendloopnext				                # jump to is_friend_of_friendloopnext
    
    is_friend_of_friendloopp2:
    lw		$t7, 8($t0)		                                  # load friendship value in relation
    li		$t8, 1		# $t8 = 1
    lw		$t9, 0($t0)		                                  # load p1 in relation
    beq		$t7, $t8, is_friend_of_friendloopfound	        # if $t7 == $t8 then is_friend_of_friendloopfound
    j		is_friend_of_friendloopnext				                # jump to is_friend_of_friendloopnext
    
    is_friend_of_friendloopfound:
    lw		$a0, 0($sp)		                                  # load network addr
    addi	$sp, $sp, -28			# $sp = $sp + -28             # allocating space in the stack
    sw		$t0, 0($sp)		                                  # save addr of edges
    sw		$t1, 4($sp)		                                  # save size_of_edges
    sw		$t2, 8($sp)		                                  # save curr_num_of_edges
    sw		$t3, 12($sp)		                                # save person1 addr
    sw		$t4, 16($sp)		                                # save person2 addr
    sw		$t5, 20($sp)		                                # save loop counter
    sw		$ra, 24($sp)		                                # save return addr
    lw		$a1, 16($sp)		                                # load person2 addr
    move 	$a2, $t9		# $a2 = $t9                         # load found friend
    jal		is_relation_exists2				                      # jump to is_relation_exists2 and save position to $ra
    lw		$t0, 0($sp)		                                  # load addr of edges
    lw		$t1, 4($sp)		                                  # load size_of_edges
    lw		$t2, 8($sp)		                                  # load curr_num_of_edges
    lw		$t3, 12($sp)		                                # load person1 addr
    lw		$t4, 16($sp)		                                # load person2 addr
    lw		$t5, 20($sp)		                                # load loop counter
    lw		$ra, 24($sp)		                                # load return addr
    addi	$sp, $sp, 28			# $sp = $sp + 28              # deallocating space in stack
    beq		$v0, $zero, is_friend_of_friendloopnext	        # if $v0 == $zero then is_friend_of_friendloopnext
    lw		$t6, 8($v1)		                                  # load friendship value
    beq		$v0, $t6, is_friend_of_friendsuccess	# if $v0 == $t6 then is_friend_of_friendsuccess

    is_friend_of_friendloopnext:
    add		$t0, $t0, $t1		# $t0 = $t0 + $t1
    addi	$t5, $t5, 1			# $t5 = $t5 + 1
    j		is_friend_of_friendloop				# jump to is_friend_of_friendloop

  is_friend_of_friendsuccess:
  li		$v0, 1		# $v0 = 1
  j		exitis_friend_of_friend				# jump to exitis_friend_of_friend

  is_friend_of_friendexistsfail:
  li		$v0, -1		# $v0 = -1
  j		exitis_friend_of_friend				# jump to exitis_friend_of_friend
  
  is_friend_of_friendnotfail:
  li		$v0, 0		# $v0 = 0
  j		exitis_friend_of_friend				# jump to exitis_friend_of_friend
  
  exitis_friend_of_friend:
  lw		$ra, 12($sp)		                                  # load return addr
  addi	$sp, $sp, 24			# $sp = $sp + 16                # deallocating space in the stack

  jr $ra

is_relation_exists2:
  # a0 = network addr, a1 = person1 addr, a2 = person2 addr
  # $t0 = size_of_edge
  # $t1 = curr_num_of_edges
  # $t2 = edges addr
  # $t3 = loop counter
  # loop (from 0 to curr num of edges)
  # if both addr match then success
  # if both doesnt match then loop
  # escape loop if curr num of edges
  lw		$t0, 12($a0)		                                  # size_of_edge
  lw		$t1, 20($a0)		                                  # curr_num_of_edges
  lw		$t2, 0($a0)		                                    # total_num_nodes
  lw		$t3, 8($a0)		                                    # size_of_node
  mult	$t2, $t3			# $t2 * $t3 = Hi and Lo registers
  mflo	$t3					# copy Lo to $t3                      # nodes_capacity
  addi	$t2, $a0, 36			# $t2 = $a0 + 36                # nodes addr
  add		$t2, $t2, $t3		# $t2 = $t2 + $t3                 # edges addr
  li		$t3, 0		# $t3 = 0                               # loop counter
  
  is_relation_exists2loop:
    beq		$t3, $t1, is_relation_exists2fail	              # if $t3 == $t1 then is_relation_exists2fail
    lw		$t4, 0($t2)		                                  # p1 addr
    lw		$t5, 4($t2)		                                  # p2 addr
    beq		$t4, $a1, is_relation_exists2loopcheckp2	        # if $t4 == $a1 then is_relation_exists2loopcheckp2
    beq		$t4, $a2, is_relation_exists2loopcheckp1	        # if $t4 == $a2 then is_relation_exists2loopcheckp1
    j		is_relation_exists2loopnext				# jump to is_relation_exists2loopnext
    
    is_relation_exists2loopcheckp2:
      beq		$t5, $a2, is_relation_exists2success	          # if $t5 == $a2 then is_relation_exists2success
      j		is_relation_exists2loopnext				              # jump to is_relation_exists2loopnext
      
    is_relation_exists2loopcheckp1:
      beq		$t5, $a1, is_relation_exists2success	          # if $t5 == $a1 then is_relation_exists2success
      j		is_relation_exists2loopnext				              # jump to is_relation_exists2loopnext
      
    is_relation_exists2loopnext:
      add		$t2, $t2, $t0		# $t2 = $t2 + $t0             # increment edges
      addi	$t3, $t3, 1			# $t3 = $t3 + 1
      j		is_relation_exists2loop				# jump to is_relation_exists2loop
  
  is_relation_exists2success:
  li		$v0, 1		                                        # $v0 = 1
  move 	$v1, $t2		# $v1 = $t2                           # addr of the relation edge
  j		exitis_relation_exists2				                      # jump to exitis_relation_exists2

  is_relation_exists2fail:
  li		$v0, 0		                                        # $v0 = 0
  li		$v1, 0		                                        # $v1 = 0
    
  exitis_relation_exists2:

  jr $ra