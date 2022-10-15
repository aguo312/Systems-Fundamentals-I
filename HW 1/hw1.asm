################# Andrew Guo #################
################# andguo #################
################# 113517303 #################

################# DO NOT CHANGE THE DATA SECTION #################


.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "One of the arguments is invalid\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:
    li	$t1, 2	# $t1 = 2 
    bne	$a0, $t1, not_two_arguments # if $a0 != $t1 then not_two_arguments
    lw	$a0, arg1_addr	# get arg1
    li	$t1, 0	# string length counter
    li  $t2, 2  # desired length
    string_loop:
        lbu $t3 0($a1)
        addi $a1, $a1, 1
        addi $t1, $t1, 1
        beq $t3, $zero, exit_string_loop
        j check_string
        exit_check:
        j string_loop
    exit_string_loop:
        bne $t1, $t2, invalid_arg
    
    lb	$t1, 0($a0)
    
    choose_option:
        option_D:
            li $s0, 'D'
            bne $t1, $s0, option_F
            j	condition_D	# jump to condition_D    
        option_F:
            li $s0, 'F'
            bne $t1, $s0, option_L
            j	condition_F	# jump to condition_F
        option_L:
            li $s0, 'L'
            bne $t1, $s0, option_X
            j	condition_L	# jump to condtion_L
        option_X:
            li $s0, 'X'
            bne $t1, $s0, end
            j	condition_X	# jump to condition_X
    j		end				# jump to end
    

condition_D:
    li	$t4, 1		# $t4 = 1
    arg2_string_loop:
        lbu $t3 0($a1)
        beq $t3, $zero, exit_arg2_string_loop
        j arg2_check_string
        exit_arg2_check:
            addi $a1, $a1, 1
            addi	$t4, $t4, 1			# $t4 = $t4 + 1
            j arg2_string_loop

    exit_arg2_string_loop:
    li	$t5, 1		# $t5 = 1
    beq		$t4, $t5, invalid_arg	# if $t4 == $t5 then invalid_argument
    lw	$a1, arg2_addr		# get arg2
    li	$a0, 0		# a0 = 0
    li	$t4, 10		# $t4 = 10
    li	$t5, 0		# $t5 = 0 counter
    arg2_sum:
        lbu $t3 0($a1)
        beq $t3, $zero, exit_arg2_sum	# if $t3 == $zero then exit_arg2_sum
        beq		$t5, $zero, skip_first	# if $t5 == $zero then skip_first
        mult	$a0, $t4			# $a0 * $t4 = Hi and Lo registers
        mflo	$a0					# copy Lo to $a0
        
        skip_first:
            andi	$t3, $t3, 0x0F			# $t3 = $t3 & 0x0F
            add		$a0, $a0, $t3		# $a0 = $a0 + $t3
            addi	$a1, $a1, 1			# $a1 = $a1 + 1
            addi	$t5, $t5, 1			# $t5 = $t5 + 1
            j	arg2_sum				# jump to arg2_sum
        
    exit_arg2_sum:
        li		$v0, 1		# $v0 = 1
        syscall
        j		end				# jump to end
        
condition_F:
    lw		$t0, arg2_addr		# 
    li		$t1, 0		# $t1 = 0, counter
    li		$t2, 8		# $t2 = 8, desired length
    #addi	$a0, $a0, 2			# $a0 = $a0 + 2
    
    f_arg2_loop:
        lbu $t3 0($t0)
        beq	$t3, $zero, exit_f_arg2_loop	# if $t3 == $zero then exit_f_arg2_loop
        j   f_arg2_check_string
        exit_f_arg2_check_string:
        addi	$t0, $t0, 1			# $t0 = $t0 + 1
        addi	$t1, $t1, 1			# $t1 = $t1 + 1
        j		f_arg2_loop			# jump to f_arg2_loop
        
    exit_f_arg2_loop:
        bne		$t1, $t2, invalid_arg	# if $t1 != $t2 then invalid_arg

    lw		$a0, arg2_addr		# maybe remove
    lw		$a1, 2($a0)		# maybe remove

    lw		$t0, arg2_addr		# 
    sub		$a2, $a2, $a2		# $a0 = $a0 - $a0
    
    f_construct_binary:
        lb		$t1, 0($t0)		# 
        beq		$t1, $zero, exit_f_construct_binary	# if $t1 == $zero then exit_f_construct_binary
        addi	$t0, $t0, 1			# $t0 = $t0 + 1
        li		$t2, 'A'		# $t2 = 'A'
        blt		$t1, $t2, f_is_number	# if $t1 < $t2 then f_is_number
        sub		$t1, $t1, $t2		# $t1 = $t1 - $t2
        addi	$t1, $t1, 10			# $t1 = $t1 + 10
        j		f_add_to_hex				# jump to f_add_to_hex
        
        f_is_number:
            li		$t2, '0'		# $t2 = '0'
            sub		$t1, $t1, $t2		# $t1 = $t1 - $t2
            j		f_add_to_hex				# jump to f_add_to_hex
        
        f_add_to_hex:
            sll		$a2, $a2, 4			# $a2 = $a2 << 4
            add		$a2, $a2, $t1		# $a2 = $a2 + $t1
            
        j		f_construct_binary				# jump to f_construct_binary    
        
    exit_f_construct_binary:
        li		$t1, 0x00000000		# $t1 = 0x00000000
        beq		$a2, $t1, zero_message	# if $a2 == $t1 then zero_message
        li		$t1, 0x80000000		# $t1 = 0x80000000
        beq		$a2, $t1, zero_message	# if $a2 == $t1 then zero_message
        li		$t1, 0xFF800000		# $t1 = 0xFF800000
        beq		$a2, $t1, inf_neg_message	# if $a2 == $t1 then inf_neg_message
        li		$t1, 0x7F800000		# $t1 = 0x7F800000
        beq		$a2, $t1, inf_pos_message	# if $a2 == $t1 then inf_pos_message
        li		$t1, 0x7F800001		# $t1 = 0x7F800001
        bge		$a2, $t1, check_nan_1	# if $a2 >= $t1 then check_nan_1
        exit_check_nan_1:
        li		$t1, 0xFF800001		# $t1 = 0xFF800001
        bge		$a2, $t1, check_nan_2	# if $a2 >= $t1 then check_nan_2
        exit_check_nan_2:
        j		exit_special_float_check				# jump to exit_special_float_check
        
        check_nan_1:
            li		$t1, 0x7FFFFFFF		# $t1 = 0x7FFFFFFF
            ble		$a2, $t1, nan_message	# if $a2 <= $t1 then nan_message
            j		exit_check_nan_1				# jump to exit_check_nan_1

        check_nan_2:
            li		$t1, 0xFFFFFFFF		# $t1 = 0xFFFFFFFF
            ble		$a2, $t1, nan_message	# if $a2 <= $t1 then nan_message
            j		exit_check_nan_2				# jump to exit_check_nan_2 
        
    exit_special_float_check:

    find_exponent:
        sll		$t1, $a2, 1			# $t1 = $a2 << 1
        
        srl		$t1, $t1, 24			# $t1 = $t1 >> 24
        li		$t2, 127		# $t2 = 127
        sub		$a0, $t1, $t2		# $a0 = $t1 - $t2, exponent
        
    construct_signed_mantissa:
        la		$t3, mantissa		#
        srl		$t1, $a2, 31			# $t1 = $a2 >> 31
        li		$t2, 1		# $t2 = 1
        bne		$t1, $t2, beginning_mantissa	# if $t1 != $t2 then beginning_mantissa

        li		$t2, '-'		# $t2 = '-'
        sb		$t2, 0($t3)		# 
        addi	$t3, $t3, 1			# $t3 = $t3 + 1

        beginning_mantissa:
            li		$t2, '1'		# $t2 = '1'
            sb		$t2, 0($t3)		# 
            addi	$t3, $t3, 1			# $t3 = $t3 + 1
            li		$t2, '.'		# $t2 = '.'
            sb		$t2, 0($t3)		# 
            addi	$t3, $t3, 1			# $t3 = $t3 + 1
        
        li		$t2, 0		# $t2 = 0, counter
        li		$t4, 23		# $t4 = 23, target
        sll		$t1, $a2, 9			# $t1 = $a2 << 9
        li		$t6, '0'		# $t6 = '0'
        
        loop_mantissa:
            srl		$t5, $t1, 31			# $t5 = $t1 >> 31
            sll		$t1, $t1, 1			# $t1 = $t1 << 1
            add		$t5, $t5, $t6		# $t5 = $t5 + $t6
            sb		$t5, 0($t3)		# 
            addi	$t3, $t3, 1			# $t3 = $t3 + 1
            addi	$t2, $t2, 1			# $t2 = $t2 + 1
            bne		$t2, $t4, loop_mantissa	# if $t2 != $t4 then loop_mantissa
        
        sb		$zero, 0($t3)		# 
    
    la		$a1, mantissa		#
    j	end	# jump to end
    
condition_L:
    li		$t0, 0		# $t0 = 0, sum
    li		$t1, 0		# $t1 = 0, hand counter
    li		$t2, 'M'		# $t2 = 'M', previous byte
    li		$t3, 12		# $t3 = 12, max_length
    
    lw		$a1, arg2_addr		# 
    
    l_arg2_loop:
        lb		$t4, 0($a1)		# 
        beq		$t4, $zero, exit_l_arg2_loop	# if $t4 == $zero then exit_l_arg2_loop
        bgt		$t1, $t3, exit_l_arg2_loop	# if $t1 > $t3 then exit_l_arg2_loop
        j		l_arg2_check_string				# jump to l_arg2_check_string
        exit_l_arg2_check_string:
        addi	$a1, $a1, 1			# $a1 = $a1 + 1
        addi	$t1, $t1, 1			# $t1 = $t1 + 1
        j		l_arg2_loop				# jump to l_arg2_loop
        
        
    exit_l_arg2_loop:
        bne		$t1, $t3, invalid_arg	# if $t1 != $t3 then invalid_arg
    
    lw		$a1, arg2_addr		# 
    li		$t1, 0		# $t1 = 0, counter
    li		$t5, 'A'		# $t5 = 'A'
    
    hand_loop:
        lb		$t4, 0($a1)		# 
        beq		$t1, $t3, exit_hand_loop	# if $t1 == $t3 then exit_hand_loop
        
        blt		$t4, $t5, l_is_number	# if $t4 < $t5 then l_is_number
        j		l_is_alpha				# jump to l_is_alpha
        
        l_is_number:
            blt		$t2, $t5, invalid_arg	# if $t2 < $t5 then invalid_arg
            move 	$t2, $t4		# $t2 = $t4
            j		prepare_next_loop				# jump to prepare_next_loop
            
            
        l_is_alpha:
            bgt		$t2, $t5, invalid_arg	# if $t2 > $t5 then invalid_arg
            li		$t6, 'M'		# $t6 = 'M'
            beq		$t4, $t6, l_m_card	# if $t4 == $t6 then l_m_card
            j		l_p_card				# jump to l_p_card
            
            l_m_card:
                li		$t6, '0'		# $t6 = '0'
                sub		$t2, $t2, $t6		# $t2 = $t2 - $t6
                add		$t0, $t0, $t2		# $t0 = $t0 + $t2
                j		prepare_next_loop				# jump to prepare_next_loop
                

            l_p_card:
                li		$t6, '0'		# $t6 = '0'
                sub		$t2, $t2, $t6		# $t2 = $t2 - $t6
                sub		$t0, $t0, $t2		# $t0 = $t0 - $t2
                j		prepare_next_loop				# jump to prepare_next_loop
                
        
        prepare_next_loop:
            addi	$a1, $a1, 1			# $a1 = $a1 + 1
            addi	$t1, $t1, 1			# $t1 = $t1 + 1
            move 	$t2, $t4		# $t2 = $t4, set current byte to previous
            j		hand_loop				# jump to hand_loop
            
            
    exit_hand_loop:
        move		$a0, $t0		# $a0 = $t0
        li		$v0, 1		# $v0 = 1
        syscall
        j		end				# jump to end
        
    j	end	# jump to end
    
condition_X:
    lw	$a0, arg2_addr	# get arg2
    li	$t1, 0	# string length counter
    li  $t2, 10 # maximum length
    li	$t5, 1	# $t5 = 1 counter for first digit
    li	$t6, 2	# $t6 = 2 counter for second digit
    li	$t7, 3	# $t7 = 3 minumum length
    
    j	check_hex	# jump to check_hex, checks length of arg2
    exit_check_hex:
    blt		$t1, $t7, invalid_arg	# if $t1 < $t7 then invalid_arg, condition for less length than 3
    bgt		$t1, $t2, invalid_arg	# if $t1 > $t2 then invalid_arg, condition for more length than 10

    lw		$t0, arg2_addr		# 
    addi	$t0, $t0, 2			# $t0 = $t0 + 2, Skips 0x
    sub		$a0, $a0, $a0		# $a0 = $a0 - $a0
    

    construct_binary:
        
        lb		$t2, 0($t0)		# 

        beq		$t2, $zero, exit_construct_binary	# if $t2 == $zero then exit_construct_binary
        addi	$t0, $t0, 1			# $t0 = $t0 + 1, increment

        li		$t3, 'A'		# $t3 = '0'
        blt		$t2, $t3, is_number	# if $t2 < $t3 then is_number
        
        sub		$t2, $t2, $t3		# $t2 = $t2 - $t3
        addi	$t2, $t2, 10			# $t2 = $t2 + 10
        
        j		add_to_hex				# jump to add_to_hex
        

        is_number:
            li		$t3, '0'		# $t3 = '0'
            sub	$t2, $t2, $t3			# $t2 = $t2 - $t3
            j		add_to_hex				# jump to add_to_hex
            
        add_to_hex:
            sll		$a0, $a0, 4			# $a0 = $a0 << 4
            add		$a0, $a0, $t2		# $a0 = $a0 + $t2
            
        j		construct_binary				# jump to construct_binary
        
    exit_construct_binary:
        li		$v0, 1		# $v0 = 1
        syscall
        j		end				# jump to end

    j	end	# jump to end
    
check_string:
    caseD:
        li $s0, 'D'
        bne $t3, $s0, caseF
        j	exit_check  # jump to exit_check
    caseF:
        li $s0, 'F'
        bne $t3, $s0, caseL
        j	exit_check  # jump to exit_check
    caseL:
        li $s0, 'L'
        bne $t3, $s0, caseX
        j	exit_check  # jump to exit_check
    caseX:
        li $s0, 'X'
        bne $t3, $s0, invalid_arg
        j	exit_check  # jump to exit_check
    
arg2_check_string:
    li $s0, '0'
    blt		$t3, $s0, invalid_arg	# if $t3 < $s0 then invalid_arg
    li $s0, '9'
    bge		$t3, $s0, is_nine	# if $t3 >= $s0 then is_nine
    j		exit_arg2_check				# jump to exit_arg2_check
    
    is_nine:
        bne		$t3, $s0, invalid_arg	# if $t3 != $s0 then invalid_arg
        j		exit_arg2_check				# jump to exit_arg2_check
            
check_hex:
    lbu $t3 0($a0)
    
    beq		$t3, $zero, exit_check_hex	# if $t3 == $zero then exit_check_hex
    
    addi $a0, $a0, 1
    addi $t1, $t1, 1

    beq		$t1, $t5, check_first	# if $t1 == $t5 then check_first
    exit_check_first:
    beq		$t1, $t6, check_second	# if $t1 == $t6 then check_second

    li		$t4, '0'		# $t4 = '0'
    blt		$t3, $t4, invalid_arg	# if $t3 < $t4 then invalid_arg
    li		$t4, 'F'		# $t4 = 'F'
    bgt		$t3, $t4, invalid_arg	# if $t3 > $t4 then invalid_arg
    li		$t4, '9'		# $t4 = '9'
    bgt		$t3, $t4, check_between	# if $t3 > $t4 then check_between
    
    j		check_hex				# jump to check_hex
    

    check_between:
        li		$t4, 'A'		# $t4 = 'A'
        blt		$t3, $t4, invalid_arg	# if $t3 < $t4 then invalid_arg
        
    
    exit_check_second:

    j	check_hex	# jump to check_hex
    

    check_first:
        li	$t4, '0'	# $t4 = 0
        bne		$t3, $t4, invalid_arg	# if $t3 != $t4 then invalid_arg
        j		exit_check_first				# jump to exit_check_first

    check_second:
        li		$t4, 'x'		# $t4 = 'x'
        bne		$t3, $t4, invalid_arg	# if $t3 != $t4 then invalid_arg
        j		exit_check_second				# jump to exit_check_second

f_arg2_check_string:
    li		$s0, '0'		# $s0 = '0'
    blt		$t3, $s0, invalid_arg	# if $t3 < $s0 then invalid_arg
    li      $s0, 'F'
    bgt		$t3, $s0, invalid_arg	# if $t3 > $s0 then invalid_arg
    li      $s0, '9'
    bgt		$t3, $s0, check_alpha	# if $t3 > $s0 then check_alpha
    j		exit_f_arg2_check_string				# jump to exit_f_arg2_check_string
    
    check_alpha:
        li		$s0, 'A'		# $s0 = '0'
        blt		$t3, $s0, invalid_arg	# if $t3 < $s0 then invalid_arg
    j		exit_f_arg2_check_string				# jump to exit_f_arg2_check_string
    
l_arg2_check_string:
    li		$s0, 'M'		# $s0 = 'M'
    beq		$t4, $s0, exit_l_arg2_check_string	# if $t4 == $s0 then exit_l_arg2_check_string
    li		$s0, 'P'		# $s0 = 'P'
    beq		$t4, $s0, exit_l_arg2_check_string	# if $t4 == $s0 then exit_l_arg2_check_string
    li		$s0, '0'		# $s0 = '0'
    blt		$t4, $s0, invalid_arg	# if $t4 < $s0 then invalid_arg
    li		$s0, '9'		# $s0 = '9'
    bgt		$t4, $s0, invalid_arg	# if $t4 > $s0 then invalid_arg
    j		exit_l_arg2_check_string				# jump to exit_l_arg2_check_string
    
    
not_two_arguments:
    la  $a0, args_err_msg
    li  $v0, 4
    syscall
    j end

invalid_arg:
    la  $a0, invalid_arg_msg
    li  $v0, 4
    syscall
    j end
    
zero_message:
    la		$a0, zero		# 
    li		$v0, 4		# $v0 = 4
    syscall
    j		end				# jump to end
    
inf_neg_message:
    la		$a0, inf_neg		# 
    li		$v0, 4		# $v0 = 4
    syscall
    j		end				# jump to end
    
inf_pos_message:
    la		$a0, inf_pos		# 
    li		$v0, 4		# $v0 = 4
    syscall
    j		end				# jump to end
    
nan_message:
    la		$a0, nan		# 
    li		$v0, 4		# $v0 = 4
    syscall
    j		end				# jump to end

end:
    li $v0, 10
    syscall
