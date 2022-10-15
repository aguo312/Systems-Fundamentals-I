############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
.data
Person_prop: .asciiz "NAME"
Relation_prop: .asciiz "FRIEND"

Name1: .asciiz "Wasundhara"
Name2: .asciiz "Boka"
Name3: .asciiz "Kebla"

Network:
  .word 5   #total_nodes
  .word 10   #total_edges
  .word 12   #size_of_node
  .word 12  #size_of_edge
  .word 5   #curr_num_of_nodes
  .word 3   #curr_num_of_edges
  .asciiz "NAME"
  .asciiz "FRIEND"
   # set of nodes
  .byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
   # set of edges
  .word 0 0 0 0 0 0 0 0 0 0
.text
main:
	la $a0, Network
  	jal create_person
  	#move $s0, $v0		# return person

  	#write test code
  	la $a0, Network
  	addi	$a1, $a0, 36
  	la $a2, Person_prop
  	la $a3, Name3
  	jal add_person_property
  	
  	la $a0, Network
  	addi	$a1, $a0, 48
  	la $a2, Person_prop
  	la $a3, Name2
  	jal add_person_property
  	
  	la $a0, Network
  	addi	$a1, $a0, 84
  	la $a2, Person_prop
  	la $a3, Name1
  	jal add_person_property
  	
  	la $a0, Network
  	addi	$t0, $a0, 96
  	addi	$t1, $a0, 84
  	addi	$t2, $a0, 36
  	li	$t3, 1
  	sw	$t1, 0($t0)
  	sw	$t2, 4($t0)
  	sw	$t3, 8($t0)
  	addi	$t0, $a0, 108
  	addi	$t1, $a0, 48
  	addi	$t2, $a0, 36
  	li	$t3, 1
  	sw	$t1, 0($t0)
  	sw	$t2, 4($t0)
  	sw	$t3, 8($t0)
  	
  	la $a0, Network
  	la $a1, Name1
  	la $a2, Name2
  	jal is_friend_of_friend
  	
  	
exit:
	li $v0, 10
	syscall
.include "hw4.asm"
