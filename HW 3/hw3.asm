######### Andrew Guo ##########
######### 113517303 ##########
######### andguo ##########

.text
.globl initialize
initialize:

  # open the file
  # reading the file
  # check if num rows num columns elements are in range
  # turn characters into integers

  # method initialize($a0 = addr filename, $a1 = addr buffer) -> int
  # open file read mode($a0 = addr filename, $a1 = 0 for reading, $a2 = 0, $v0 = 13) -> $v0 = file descriptor
  # read from file($a0 = file descriptor, $a1 = addr buffer, $a2 = num characters to read) -> $v0 = num characters read
  
  addi	$sp, $sp, -32			# $sp = $sp + -32   # allocating space in the stack
  sw		$s0, 0($sp)		                        # store original $s0
  sw		$s1, 4($sp)		                        # store original $s1
  sw		$s2, 8($sp)		                        # store original $s2
  sw		$s3, 12($sp)		                      # store original $s3
  sw		$s4, 16($sp)		                      # store original $s4
  sw		$s5, 20($sp)		                      # store original $s5
  sw		$s6, 24($sp)		                      # store original $s6
  sw		$s7, 28($sp)		                      # store original $s7
  
  move 	$s0, $a0		# $s0 = $a0               # $s0 = addr filename
  move 	$s1, $a1		# $s1 = $a1               # $s1 = addr buffer

  # open file read mode
  move 	$a0, $s0		# $a0 = $s0               # addr filename
  li		$a1, 0		# $a1 = 0                   # 0 for reading
  li		$a2, 0		# $a2 = 0
  li		$v0, 13		# $v0 = 13
  syscall
  li		$t0, 0		# $t0 = 0                   # loop counter
  blt		$v0, $zero, initializeerror	# if $v0 < $zero then initializeerror
  move 	$s2, $v0		# $s2 = $v0               # $s2 = file descriptor

  # save needed constants for loop
  li		$t0, '\r'		# $t0 = '\r'
  move 	$s3, $t0		# $s2 = $t0               # $s3 = '\r'
  li		$t0, '\n'		# $t0 = '\n'
  move 	$s4, $t0		# $s3 = $t0               # $s4 = '\n'
  li		$t0, '0'		# $t0 = '0'
  move 	$s5, $t0		# $s4 = $t0               # $s5 = '0'
  li		$t0, '1'		# $t0 = '1'
  move 	$s6, $t0		# $s5 = $t0               # $s6 = '1'
  li		$t0, '9'		# $t0 = '9'
  move 	$s7, $t0		# $s7 = $t0               # $s7 = '9'
  
  li		$t0, 0		# $t0 = 0                   # loop counter for both loops
  li		$t1, 0		# $t1 = 0                   # will hold num rows
  li		$t2, 0		# $t2 = 0                   # will hold num columns
  
  move 	$a1, $s1		# $a1 = $s1               # addr buffer
  li		$a2, 1		# $a2 = 1                   # read 1 character at a time
  
  initializereadloopfirsttwo:
    li		$t3, 1		# $t3 = 1
    bgt		$t0, $t3, exitinitializereadloopfirsttwo	# if $t0 > $t3 then exitinitializereadloopfirsttwo
    move 	$a0, $s2		# $a0 = $s2             # file descriptor
    li		$v0, 14		# $v0 = 14                # read from file
    syscall  
    blt		$v0, $zero, initializeerror	# if $v0 < $zero then initializeerror # when $v0 < 0 then an error occured
    lw		$t3, 0($a1)		                      # get word at buffer addr
    beq		$t3, $s3, initializereadloopfirsttwo	# if $t3 == $s3 then initializereadloopfirsttwo # when $t3 = '\r' then ignore rest and loop
    beq		$t3, $s4, initializereadloopfirsttwo	# if $t3 == $s4 then initializereadloopfirsttwo # when $t3 = '\n' then ignore rest and loop
    
    blt		$t3, $s6, initializeerror	# if $t3 < $s6 then initializeerror # error if rows and columns is less than 1
    bgt		$t3, $s7, initializeerror	# if $t3 > $s7 then initializeerror # error if rows and columns is greater than 9

    sub		$t3, $t3, $s5		# $t3 = $t3 - $s5   # change character into integer
    sw		$t3, 0($a1)		                      # save integer to addr buffer
    
    addi	$a1, $a1, 4			# $a1 = $a1 + 4     # addr of next word in buffer
    addi	$t0, $t0, 1			# $t0 = $t0 + 1     # increment counter
    j		initializereadloopfirsttwo				# jump to initializereadloopfirsttwo
    
  exitinitializereadloopfirsttwo:

  # save num rows and num columns to register
    move 	$t3, $s1		# $t3 = $s1             # addr buffer
    lw		$t4, 0($t3)		                      # load num rows
    move 	$t1, $t4		# $t1 = $t4             # save num rows
    lw		$t4, 4($t3)		                      # load num columns
    move 	$t2, $t4		# $t2 = $t4             # save num columns

  # find max counter length
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t3					# copy Lo to $t3          # rows * columns
  addi	$t3, $t3, 2			# $t3 = $t3 + 2       # row * columns + 2 = number of elements in buffer = total number of loops needed
  # $t0 = 2
  # $a1 = address for word 3
  # $a2 = 1

  initializereadlooparray:
    #bgt		$t0, $t3, exitinitializereadlooparray	# if $t0 > $t3 then exitinitializereadlooparray
    beq		$t0, $t3, exitinitializereadlooparray	# if $t0 == $t3 then exitinitializereadlooparray
    move 	$a0, $s2		# $a0 = $s2             # file descriptor
    li		$v0, 14		# $v0 = 14                # read from file
    syscall
    blt		$v0, $zero, initializeerror	# if $v0 < $zero then initializeerror # when $v0 < 0 then an error occured
    lw		$t4, 0($a1)		                      # get word at buffer addr
    beq		$t4, $s3, initializereadlooparray	# if $t4 == $s3 then initializereadlooparray # when $t4 = '\r' then ignore rest and loop
    beq		$t4, $s4, initializereadlooparray	# if $t4 == $s4 then initializereadlooparray # when $t4 = '\n' then ignore rest and loop
    blt		$t4, $s5, initializeerror	# if $t4 < $s5 then initializeerror # error if elements is less than 0
    bgt		$t4, $s7, initializeerror	# if $t4 > $s7 then initializeerror # error if elements is greater than 9

    sub		$t4, $t4, $s5		# $t4 = $t4 - $s5   # change character into integer
    sw		$t4, 0($a1)		                      # save integer to addr buffer
    addi	$a1, $a1, 4			# $a1 = $a1 + 4     # addr of next word in buffer
    addi	$t0, $t0, 1			# $t0 = $t0 + 1     # increment counter
    j		initializereadlooparray				# jump to initializereadlooparray

  exitinitializereadlooparray:
  li		$v0, 1		# $v0 = 1
  j		exitinitialize				# jump to exitinitialize
  
  initializeerror:
  li		$v0, -1		# $v0 = -1
  move 	$t5, $s1		# $t5 = $s1             # addr buffer
  li		$t6, 0		# $t6 = 0                 # error loop counter
  initializeerrorloop:
    sw		$zero, 0($t5)		# 
    bgt		$t6, $t0, exitinitialize	# if $t6 > $t0 then exitinitialize
    addi	$t6, $t6, 1			# $t6 = $t6 + 1
    addi	$t5, $t5, 4			# $t5 = $t5 + 4
    j		initializeerrorloop				# jump to initializeerrorloop

  exitinitialize:

  lw		$s0, 0($sp)		                        # restore original $s0
  lw		$s1, 4($sp)		                        # restore original $s1
  lw		$s2, 8($sp)		                        # restore original $s2
  lw		$s3, 12($sp)		                      # restore original $s3
  lw		$s4, 16($sp)		                      # restore original $s4
  lw		$s5, 20($sp)		                      # restore original $s5
  lw		$s6, 24($sp)		                      # restore original $s6
  lw		$s7, 28($sp)		                      # restore original $s7
  addi	$sp, $sp, 32			# $sp = $sp + 32    # deallocate space in the stack
  
 jr $ra

.globl write_file
write_file:

  # method write_file($a0 = addr filename, $a1 = addr buffer) -> void
  # open file write mode($a0 = addr filename, $a1 = 1 for writing, $a2 = 0, $v0 = 13) -> $v0 = file descriptor
  # write to file($a0 = file descriptor, $a1 = addr buffer, $a2 = num char to write, $v0 = 15) -> $v0 = num characters written
  # close file ($a0 = file descriptor, $v0 = 16) -> void

  # save address of filename, address of buffer, file descriptor, num rows, num column
  addi	$sp, $sp, -20			# $sp = $sp + -20   # allocating space in stack
  sw		$s0, 0($sp)		                        # store original $s0
  sw		$s1, 4($sp)		                        # store original $s1
  sw		$s2, 8($sp)		                        # store original $s2
  sw		$s3, 12($sp)		                      # store original $s3
  sw		$s4, 16($sp)		                      # store original $s4
  
  move 	$s0, $a0		# $s0 = $a0               # $s0 = addr filename
  move 	$s1, $a1		# $s1 = $a1               # $s1 = addr buffer
  lw		$t0, 0($a1)		                        # load num rows
  move 	$s2, $t0		# $s2 = $t0               # $s2 = num rows
  lw		$t0, 4($a1)		                        # load num columns
  move 	$s3, $t0		# $s3 = $t0               # $s3 = num columns
  
  # open file writing mode
  move 	$a0, $s0		                          # $a0 = $s0 = addr filename
  li		$a1, 1		                            # $a1 = 1 = writing mode
  li		$a2, 0		                            # $a2 = 0
  li		$v0, 13		                            # $v0 = 13
  syscall
  move 	$s4, $v0		# $s4 = $v0               # $s4 = file descriptor

  # allocate space in stack to write character version of array
  mult	$s2, $s3			# $s2 * $s3 = Hi and Lo registers
  mflo	$t0					# copy Lo to $t0          # rows * columns
  li		$t2, 2		# $t2 = 2
  add		$t0, $t0, $t2		# $t0 = $t0 + $t2     # rows * columns + 2
  add		$t1, $s2, $t2		# $t1 = $s2 + $t2     # rows + 2
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t1					# copy Lo to $t1          # 2 * (rows + 2)
  add		$t0, $t0, $t1		# $t0 = $t0 + $t1     # (rows*columns+2)+(2*(rows+2))
  li		$t1, -4		# $t1 = -4
  mult	$t0, $t1			# $t0 * $t1 = Hi and Lo registers
  mflo	$t0					# copy Lo to $t0          # -4((rows*columns+2)+(2*(rows+2)))
  add		$sp, $sp, $t0		# $sp = $sp + $t0     # allocating space in stack
  
  move 	$t0, $sp		# $t0 = $sp               # base addr of stack for num rows
  li		$t1, '\r'		# $t1 = '\r'
  li		$t2, '\n'		# $t2 = '\n'
  addi	$t3, $s2, 2			# $t3 = $s2 + 2       # num rows + 2
  move 	$t4, $s1		# $t4 = $s1               # addr buffer (starting at num rows)

  li		$t5, 0		# $t5 = 0                   # num rows + 2 loop counter
  write_filerowloop:
    beq		$t5, $t3, exitwrite_filerowloop	# if $t5 == $t2 then exitwrite_filerowloop
    
    li		$t6, 0		# $t6 = 0                 # num columns loop counter
    write_filecolumnloop:
      beq		$t6, $s3, exitwrite_filecolumnloop	# if $t6 == $s3 then exitwrite_filecolumnloop
      
      lw		$t7, 0($t4)		                    # 0 at addr buffer (starting at num rows)
      li		$t8, '0'		# $t8 = '0'
      add		$t7, $t7, $t8		# $t7 = $t7 + $t8 # character of 0 at addr buffer (starting at num rows)
      sb		$t7, 0($t0)		                    # add character to stack

      addi	$t4, $t4, 4			# $t4 = $t4 + 4   # addr next word in buffer
      addi	$t6, $t6, 1			# $t6 = $t6 + 1   # increment column loop counter
      addi	$t0, $t0, 1			# $t0 = $t0 + 4   # addr next word in stack

      beq		$t5, $zero, exitwrite_filecolumnloop	# if $t5 == $zero then exitwrite_filecolumnloop
      li		$t7, 1		# $t7 = 1
      beq		$t5, $t7, exitwrite_filecolumnloop	# if $t5 == $t7 then exitwrite_filecolumnloop
      
      j		write_filecolumnloop				# jump to write_filecolumnloop

    exitwrite_filecolumnloop:

    sb		$t1, 0($t0)		                      # save new line when reach end of column
    addi	$t0, $t0, 1			# $t0 = $t0 + 4     # addr next word in stack
    sb		$t2, 0($t0)		                      # save new line when reach end of column
    addi	$t0, $t0, 1			# $t0 = $t0 + 8     # addr next word in stack
    addi	$t5, $t5, 1			# $t5 = $t5 + 1     # increment row loop counter
    j		write_filerowloop				# jump to write_filerowloop

  exitwrite_filerowloop:

  # need number of characters to write
  mult	$s2, $s3			# $s2 * $s3 = Hi and Lo registers
  mflo	$t0					# copy Lo to $t0          # rows * columns
  li		$t2, 2		# $t2 = 2
  add		$t0, $t0, $t2		# $t0 = $t0 + $t2     # rows * columns + 2
  add		$t1, $s2, $t2		# $t1 = $s2 + $t2     # rows + 2
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t1					# copy Lo to $t1          # 2 * (rows + 2)
  add		$t0, $t0, $t1		# $t0 = $t0 + $t1     # (rows*columns+2)+(2*(rows+2)), number of elements in the array

  # write to file
  move 	$a0, $s4		# $a0 = $s4               # $a0 = file descriptor
  move 	$a1, $sp		# $a1 = $sp               # $a1 = addr buffer of character array
  move 	$a2, $t0		# $a2 = $t0               # $a2 = num characters to write
  li		$v0, 15		# $v0 = 15
  syscall

  # close file
  #lw		$a0, 16($sp)		                      # $a0 = file descriptor
  move 	$a0, $s4		# $a0 = $s4               # $a0 =  file descriptor
  li		$v0, 16		                            # $v0 = 16
  syscall
  
  li		$t1, 4		# $t1 = 4
  mult	$t0, $t1			# $t0 * $t1 = Hi and Lo registers
  mflo	$t0					# copy Lo to $t0
  
  add		$sp, $sp, $t0		# $sp = $sp + $t0
  lw		$s0, 0($sp)		# 
  lw		$s1, 4($sp)		# 
  lw		$s2, 8($sp)		# 
  lw		$s3, 12($sp)		# 
  lw		$s4, 16($sp)		# 

  addi	$sp, $sp, 20			# $sp = $sp + 20
  
 jr $ra

.globl rotate_clkws_90
rotate_clkws_90:

  # Store original in stack, replace original with rotated
  # swap rows and columns
  # replacing the array

  # swapping num rows and num columns
  addi	$t0, $a0, 8			# $t0 = $a0 + 8       # 0, 0 of original array
  lw		$t1, 4($a0)		                        # num columns original
  lw		$t2, 0($a0)		                        # num rows original
  move 	$t3, $t1		# $t3 = $t1               # temp variable holding num column original
  sw		$t2, 4($a0)		                        # num rows original becomes num columns new
  sw		$t1, 0($a0)		                        # num columns original becomes num rows new

  # allocating space in the stack
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t4					# copy Lo to $t4          # number of elements in the array
  li		$t3, -4		# $t3 = -4                  # element size in bytes
  mult	$t4, $t3			# $t4 * $t3 = Hi and Lo registers
  mflo	$t5					# copy Lo to $t5          # bytes needed for entire array
  add		$sp, $sp, $t5		# $sp = $sp + $t5     # allocating space in the stack
  
  # loop through original array and add to stack
  move 	$t3, $sp		# $t3 = $sp               # base addr of the stack
  li		$t6, 0		# $t6 = 0                   # counter for loop
  # $t0 = base addr of 0, 0 of original array
  # $t4 = number of elements in the array
  
  rotate_storeoriginalarrayloop:
    beq		$t6, $t4, exitrotate_storeoriginalarrayloop	# if $t6 == $t4 then exitrotate_storeoriginalarrayloop  # exits when counter equals num elements in array
    lw		$t7, 0($t0)		                      # loads starting from 0, 0 of original array
    sw		$t7, 0($t3)		                      # stores into current base addr of the stack
    addi	$t0, $t0, 4			# $t0 = $t0 + 4     # move to next element in original array
    addi	$t3, $t3, 4			# $t3 = $t3 + 4     # move to next offset in stack
    addi	$t6, $t6, 1			# $t6 = $t6 + 1     # increment counter
    j		rotate_storeoriginalarrayloop				# jump to rotate_storeoriginalarrayloop
    
  exitrotate_storeoriginalarrayloop:

  # overwrite original array with new array
  # $t1 = number of columns original
  # $t2 = number of rows original
  addi	$t0, $a0, 8			# $t0 = $a0 + 8       # 0, 0 of original array
  li		$t3, 0		# $t3 = 0                   # column indicator for loop (starts at the first column)

  rotate_constructnewarrayouterloop:
    beq		$t3, $t1, exit_rotateconstructnewarrayouterloop	# if $t3 == $t1 then exit_rotateconstructnewarrayouterloop  # exits when reaches last column of array

    move 	$t4, $t2		# $t4 = $t2           # row indicator for loop (starts at the last row)
    rotate_constructnewarrayinnerloop:
      addi	$t4, $t4, -1			# $t4 = $t4 + -1  # move up to the previous row
      blt		$t4, $zero, exit_rotateconstructnewarrayinnerloop	# if $t4 < $zero then exit_rotateconstructnewarrayinnerloop # exists when finishes first row of array
      # need element at [last - 1, 0] then [last - 2, 0] to [0, 0]
      mult	$t4, $t1			# $t4 * $t1 = Hi and Lo registers
      mflo	$t5					# copy Lo to $t5      # row * num columns
      add		$t5, $t5, $t3		# $t5 = $t5 + $t3 # row * num columns + column
      li		$t6, 4		# $t6 = 4
      mult	$t5, $t6			# $t5 * $t6 = Hi and Lo registers
      mflo	$t5					# copy Lo to $t5      # 4 * (row * num columns + column) or offset
      add		$t5, $sp, $t5		# $t5 = $sp + $t5 # base addr of array[i][j]
      

      lw		$t6, 0($t5)		                    # value of array[i][j]
      sw		$t6, 0($t0)		                    # overwrite original[i][j] with new[i][j]

      addi	$t0, $t0, 4			# $t0 = $t0 + 4   # move to next base addr of original array
      
      j		rotate_constructnewarrayinnerloop				# jump to rotate_constructnewarrayinnerloop
      
    exit_rotateconstructnewarrayinnerloop:

    addi	$t3, $t3, 1			# $t3 = $t3 + 1     # move to the next column

    j		rotate_constructnewarrayouterloop				# jump to rotate_constructnewarrayouterloop

  exit_rotateconstructnewarrayouterloop:

  # deallocate the stack
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t1					# copy Lo to $t1
  li		$t2, 4		# $t2 = 4
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t1					# copy Lo to $t1
  add		$sp, $sp, $t1		# $sp = $sp + $t1
  
  # $a0 = base addr of rotated array
  # $a1 = base addr of filename

  # method write_file(filename addr, buffer addr)
  move 	$t0, $a0		# $t0 = $a0
  move 	$a0, $a1		# $a0 = $a1
  move 	$a1, $t0		# $a1 = $t0
  addi	$sp, $sp, -4			# $sp = $sp + -4
  sw		$ra, 0($sp)		# 
  jal		write_file				# jump to write_file and save position to $ra
  lw		$ra, 0($sp)		# 
  addi	$sp, $sp, 4			# $sp = $sp + 4
  move 	$t0, $a0		# $t0 = $a0
  move 	$a0, $a1		# $a0 = $a1
  move 	$a1, $t0		# $a1 = $t0
  
  jr $ra

.globl rotate_clkws_180
rotate_clkws_180:

  # method rotate_clkws_90(buffer, filename)
  addi	$sp, $sp, -12			# $sp = $sp + -12
  sw		$a0, 0($sp)		# 
  sw		$a1, 4($sp)		# 
  sw		$ra, 8($sp)		# 
  jal		rotate_clkws_90				# jump to rotate_clkws_90 and save position to $ra
  lw		$a0, 0($sp)		# 
  lw		$a1, 4($sp)		# 
  lw		$ra, 8($sp)		# 
  jal		rotate_clkws_90				# jump to rotate_clkws_90 and save position to $ra
  lw		$a0, 0($sp)		# 
  lw		$a1, 4($sp)		# 
  lw		$ra, 8($sp)		# 
  addi	$sp, $sp, 12			# $sp = $sp + 12
  

  jr $ra

.globl rotate_clkws_270
rotate_clkws_270:

  addi	$sp, $sp, -12			# $sp = $sp + -12
  sw		$a0, 0($sp)		# 
  sw		$a1, 4($sp)		# 
  sw		$ra, 8($sp)		# 
  jal		rotate_clkws_90				# jump to rotate_clkws_90 and save position to $ra
  lw		$a0, 0($sp)		# 
  lw		$a1, 4($sp)		# 
  lw		$ra, 8($sp)		# 
  jal		rotate_clkws_90				# jump to rotate_clkws_90 and save position to $ra
  lw		$a0, 0($sp)		# 
  lw		$a1, 4($sp)		# 
  lw		$ra, 8($sp)		# 
  jal		rotate_clkws_90				# jump to rotate_clkws_90 and save position to $ra
  lw		$a0, 0($sp)		# 
  lw		$a1, 4($sp)		# 
  lw		$ra, 8($sp)		# 
  addi	$sp, $sp, 12			# $sp = $sp + 12

  jr $ra

.globl mirror
mirror:

  # $a0 = buffer addr, $a1 = filename addr

  addi	$t0, $a0, 8			# $t0 = $a0 + 8       # 0, 0 of original
  lw		$t1, 0($a0)		                        # num rows original
  lw		$t2, 4($a0)		                        # num columns original

  # allocating space in the stack
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t4					# copy Lo to $t4          # number of elements in the array
  li		$t3, -4		# $t3 = -4                  # element size in bytes
  mult	$t4, $t3			# $t4 * $t3 = Hi and Lo registers
  mflo	$t5					# copy Lo to $t5          # bytes needed for entire array
  add		$sp, $sp, $t5		# $sp = $sp + $t5     # allocating space in the stack

  # loop through original array and add to stack
  move 	$t3, $sp		# $t3 = $sp               # base addr of the stack
  li		$t6, 0		# $t6 = 0                   # counter for loop
  # $t0 = base addr of 0, 0 of original array
  # $t4 = number of elements in the array

  mirror_storeoriginalarrayloop:
    beq		$t6, $t4, exitmirror_storeoriginalarrayloop	# if $t6 == $t4 then exitmirror_storeoriginalarrayloop  # exits when counter equals num elements in array
    lw		$t7, 0($t0)		                      # loads starting from 0, 0 of original array
    sw		$t7, 0($t3)		                      # stores into current base addr of the stack
    addi	$t0, $t0, 4			# $t0 = $t0 + 4     # move to next element in original array
    addi	$t3, $t3, 4			# $t3 = $t3 + 4     # move to next offset in stack
    addi	$t6, $t6, 1			# $t6 = $t6 + 1     # increment counter
    j		mirror_storeoriginalarrayloop				# jump to mirror_storeoriginalarrayloop
    
  exitmirror_storeoriginalarrayloop:

  # overwrite original array with new array
  # $t1 = number of rows original
  # $t2 = number of columns original
  addi	$t0, $a0, 8			# $t0 = $a0 + 8       # 0, 0 of original array
  li		$t3, 0		# $t3 = 0                   # row indicator for loop (starts at the first row)

  mirror_constructnewarrayouterloop:
    beq		$t3, $t1, exit_mirrorconstructnewarrayouterloop	# if $t3 == $t1 then exit_mirrorconstructnewarrayouterloop  # exits when reaches last row of array

    move 	$t4, $t2		# $t4 = $t2           # column indicator for loop (starts at the last column)
    mirror_constructnewarrayinnerloop:
      addi	$t4, $t4, -1			# $t4 = $t4 + -1  # move back to the previous column
      blt		$t4, $zero, exit_mirrorconstructnewarrayinnerloop	# if $t4 < $zero then exit_mirrorconstructnewarrayinnerloop # exists when finishes first row of array
      # need element at [0, last - 1] then [0, last - 2] to [0, 0]
      mult	$t3, $t2			# $t4 * $t2 = Hi and Lo registers
      mflo	$t5					# copy Lo to $t5      # row * num columns
      add		$t5, $t5, $t4		# $t5 = $t5 + $t4 # row * num columns + column
      li		$t6, 4		# $t6 = 4
      mult	$t5, $t6			# $t5 * $t6 = Hi and Lo registers
      mflo	$t5					# copy Lo to $t5      # 4 * (row * num columns + column) or offset
      add		$t5, $sp, $t5		# $t5 = $sp + $t5 # base addr of array[i][j]
      

      lw		$t6, 0($t5)		                    # value of array[i][j]
      sw		$t6, 0($t0)		                    # overwrite original[i][j] with new[i][j]

      addi	$t0, $t0, 4			# $t0 = $t0 + 4   # move to next base addr of original array
      
      j		mirror_constructnewarrayinnerloop				# jump to mirror_constructnewarrayinnerloop
      
    exit_mirrorconstructnewarrayinnerloop:

    addi	$t3, $t3, 1			# $t3 = $t3 + 1     # move to the next row

    j		mirror_constructnewarrayouterloop				# jump to mirror_constructnewarrayouterloop

  exit_mirrorconstructnewarrayouterloop:

  # deallocate the stack
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t1					# copy Lo to $t1
  li		$t2, 4		# $t2 = 4
  mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
  mflo	$t1					# copy Lo to $t1
  add		$sp, $sp, $t1		# $sp = $sp + $t1
  
  # $a0 = base addr of mirrored array
  # $a1 = base addr of filename

  # method write_file(filename addr, buffer addr)
  move 	$t0, $a0		# $t0 = $a0
  move 	$a0, $a1		# $a0 = $a1
  move 	$a1, $t0		# $a1 = $t0
  addi	$sp, $sp, -4			# $sp = $sp + -4
  sw		$ra, 0($sp)		# 
  jal		write_file				# jump to write_file and save position to $ra
  lw		$ra, 0($sp)		# 
  addi	$sp, $sp, 4			# $sp = $sp + 4

  move 	$t0, $a0		# $t0 = $a0
  move 	$a0, $a1		# $a0 = $a1
  move 	$a1, $t0		# $a1 = $t0

  jr $ra

.globl duplicate
duplicate:

  # START WITH ROW 2 CHECK FOR EQUALITY IN ROW 1
  addi	$t0, $a0, 8			# $t0 = $a0 + 8       # 0, 0 of the array
  lw		$t1, 0($a0)		                        # num rows
  lw		$t2, 4($a0)		                        # num columns
  #$t3 = 1                                    # row 1 (iterate till num rows in outer loop)
  #$t4 = 0                                    # row 0 (iterate till $t3 in inner loop)
  #$t5 = 0                                    # column 0 (iterate till num columns in column loop)

  li		$t3, 1		# $t3 = 1                   # row count (starts at 1 till num rows in outer loop)
  duplicateouterrowloop:
    beq		$t3, $t1, exitduplicateouterrowloop	# if $t3 == $t1 then exitduplicateouterrowloop

    li		$t4, 0		# $t4 = 0                 # row count (starts at 0 till $t3 row count in inner loop)
    duplicateinnerrowloop:
      beq		$t4, $t3, exitduplicateinnerrowloop	# if $t4 == $t3 then exitduplicateinnerrowloop
      
      li		$t5, 0		# $t5 = 0               # column count (starts at 0 till num collumns in column loop)
      duplicatecolumnloop:
        beq		$t5, $t2, duplicateexist	# if $t5 == $t2 then duplicateexist
        
        mult	$t3, $t2			# $t3 * $t2 = Hi and Lo registers
        mflo	$t6					# copy Lo to $t6    # row count * num columns
        mult	$t4, $t2			# $t4 * $t2 = Hi and Lo registers
        mflo	$t7					# copy Lo to $t7    # row count2 * num columns
        add		$t6, $t6, $t5		# $t6 = $t6 + $t5 # row count * num columns + column count
        add		$t7, $t7, $t5		# $t7 = $t7 + $t5 # row count2 * num columns + column count
        li		$t8, 4		# $t8 = 4             # element size in bytes
        mult	$t6, $t8			# $t6 * $t8 = Hi and Lo registers
        mflo	$t6					# copy Lo to $t6    # size(row * num columns + column)
        mult	$t7, $t8			# $t7 * $t8 = Hi and Lo registers
        mflo	$t7					# copy Lo to $t7    # size(row2 * num columns + column)
        add		$t6, $t6, $t0		# $t6 = $t6 + $t0 # base addr of arr[row][column]
        add		$t7, $t7, $t0		# $t7 = $t7 + $t0 # base addr of arr[row2][column]
        lw		$t6, 0($t6)		                  # value of arr[row][column]
        lw		$t7, 0($t7)	                  	# value of arr[row][column]
        bne		$t6, $t7, exitduplicatecolumnloop	# if $t6 != $t7 then exitduplicatecolumnloop
        addi	$t5, $t5, 1			# $t5 = $t5 + 1
        j		duplicatecolumnloop				# jump to duplicatecolumnloop

      exitduplicatecolumnloop:
      addi	$t4, $t4, 1			# $t5 = $t5 + 1
      j		duplicateinnerrowloop				# jump to duplicateinnerrowloop
      
    exitduplicateinnerrowloop:
    addi	$t3, $t3, 1			# $t3 = $t3 + 1
    j		duplicateouterrowloop				# jump to duplicateouterrowloop

  exitduplicateouterrowloop:
  # no duplicates found
  li		$v0, -1		# $v0 = -1
  li		$v1, 0		# $v1 = 0
  j		exitduplicate				# jump to exitduplicate

  duplicateexist:
  # duplicate found
  li		$v0, 1		# $v0 = 1
  addi	$v1, $t3, 1			# $v1 = $t5 + 1

  exitduplicate:

 jr $ra
