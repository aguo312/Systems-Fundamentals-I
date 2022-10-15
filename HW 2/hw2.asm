################# Andrew Guo #################
################# andguo #################
################# 113517303 #################

################# DO NOT CHANGE THE DATA SECTION #################

.text
.globl to_upper
to_upper:

    li		$t0, 'a'		# $t0 = 'a' value of a
    li		$t1, 'A'		# $t1 = 'A' value of A
    
    toupperloop:
        lb $t2, 0($a0)  # 
        beqz $t2, exittoupperloop
        blt		$t2, $t0, toupperloopincrement	# if $t2 < $t0 then toupperloopincrement
        sub		$t2, $t2, $t0		# $t2 = $t2 - $t0 subtract value of a
        add		$t2, $t2, $t1		# $t2 = $t2 + $t1 add value of A
        sb		$t2, 0($a0)		# 
        toupperloopincrement:
            addi	$a0, $a0, 1			# $a0 = $a0 + 1 increment
        j		toupperloop				# jump to toupperloop
        
    exittoupperloop:

 jr $ra

.globl remove
remove:

    blt		$a1, $zero, removefail	# if $a1 < $zero then removefail
    li		$t0, 0		# $t0 = 0   counter

    removeloop:
        lb		$t1, 0($a0)		# 
        lb		$t2, 1($a0)		# 
        beqz    $t1, exitremoveloop
        blt		$t0, $a1, removetonext	# if $t0 < $a1 then removetonext
        sb		$t2, 0($a0)		# 
        
        removetonext:
            addi	$t0, $t0, 1			# $t0 = $t0 + 1
            addi	$a0, $a0, 1			# $a0 = $a0 + 1
        
        j		removeloop				# jump to removeloop
        
    exitremoveloop:
    bgt		$a1, $t0, removefail	# if $a1 > $t0 then removefail
        li		$v0, 1		# $v0 = 1
        j		exitremove				# jump to exitremove
        
    removefail:
        li  $v0, -1
    
    exitremove:
    
 jr $ra

.globl getRandomInt
getRandomInt:

    ble		$a0, $zero, getRandomIntinvalidarg	# if $a0 <= $zero then getRandomIntinvalidarg
    move 	$a1, $a0		# $a1 = $a0
    li		$v0, 42		# $v0 = 42
    syscall

    move 	$v0, $a0		# $v0 = $a0
    li		$v1, 1		# $v1 = 1
    j		exitgetRandomInt				# jump to exitgetRandomInt

    getRandomIntinvalidarg:
        li		$v0, -1		# $v0 = -1
        li		$v1, 0		# $v1 = 0

    exitgetRandomInt:

 jr $ra

.globl cpyElems
cpyElems:

    li		$t0, 0		# $t0 = 0 counter

    cpyElemsloop:
        lb		$t1, 0($a0)		# 
        beq		$t0, $a1, copyElemscopy	# if $t0 == $a1 then copyElemscopy
        addi	$a0, $a0, 1			# $a0 = $a0 + 1
        addi	$t0, $t0, 1			# $t0 = $t0 + 1
        j		cpyElemsloop				# jump to cpyElemsloop
        
    copyElemscopy:
        sb		$t1, 0($a2)		# 
        addi	$a2, $a2, 1			# $a2 = $a2 + 1
        move 	$v0, $a2		# $v0 = $a2

 jr $ra

.globl genKey
genKey:

    #genkey a0 = alphabet, a1 = key
    #getlengthofalphabet
    #getRandomInt a0 = bound
    #copyelems a0 = src, a1 = index, a2 = dest
    #remove a0 = plaintext, a1 = position

    li		$t2, 0		# $t2 = 0 counter
    move 	$t0, $a0		# $t0 = $a0
    
    genKeylengthloop:
        lb		$t1, 0($t0)		# 
        beqz    $t1, exitgenKeylengthloop
        addi	$t0, $t0, 1			# $t0 = $t0 + 1
        addi	$t2, $t2, 1			# $t2 = $t2 + 1
        j		genKeylengthloop				# jump to genKeylengthloop

    exitgenKeylengthloop:

    addi	$sp, $sp, -16			# $sp = $sp + -16
    sw		$a0, 0($sp)		# save alphabet
    sw		$a1, 4($sp)		# save key
    sw		$t2, 8($sp)		# save length of alphabet
    sw		$ra, 12($sp)	# save return address 
    lw		$a2, 4($sp)		# load dest base address
    
    genKeyloop:
        lw		$a0, 8($sp)		# load length of alphabet
        beqz    $a0, exitgenKeyloop
        jal		getRandomInt	# jump to getRandomInt and save position to $ra
        move 	$a1, $v0		# $s0 = $v0 move random generated int to index
        lw		$a0, 8($sp)		# load length of alphabet
        addi	$a0, $a0, -1	# $a0 = $a0 + -1
        sw		$a0, 8($sp)		# save decremented length
        lw		$a0, 0($sp)		# load src
        jal		cpyElems		# jump to cpyElems and save position to $ra
        lw		$a0, 0($sp)		# load plaintext
        jal		remove			# jump to remove and save position to $ra
        j		genKeyloop				# jump to genKeyloop

    exitgenKeyloop:
    
    sb		$zero, 0($a2)		# add null terminator to key
    lw		$a1, 4($sp)		# load key base address
    lw		$ra, 12($sp)		# 
    addi	$sp, $sp, 16			# $sp = $sp + 16
        

 jr $ra

.globl contains
contains:

    li		$t0, 0		# $t0 = 0 counter
    
    containsloop:
        lb		$t1, 0($a0)		# 
        beqz    $t1, containsfail
        beq		$t1, $a1, containssuccess	# if $t1 == $a1 then containssuccess
        addi	$a0, $a0, 1			# $a0 = $a0 + 1
        addi	$t0, $t0, 1			# $t0 = $t0 + 1
        j		containsloop				# jump to containsloop
        
    containssuccess:
        move 	$v0, $t0		# $v0 = $t0
        j		exitcontains				# jump to exitcontains

    containsfail:
        li		$v0, -1		# $v0 = -1

    exitcontains:

 jr $ra

.globl pair_exists
pair_exists:

    li		$t2, 'A'		# $t2 = 'A'
    li		$t3, 'Z'		# $t3 = 'Z'

    pair_existsloop:
        lb		$t0, 0($a2)		# take first character
        # check first character is uppercase letter
        blt		$t0, $t2, pair_existsfail	# if $t0 < $t2 then pair_existsfail
        bgt		$t0, $t3, pair_existsfail	# if $t0 > $t3 then pair_existsfail
        # check second character is uppercase letter
        lb		$t1, 1($a2)		# take second character
        blt		$t1, $t2, pair_existsfail	# if $t1 < $t2 then pair_existsfail
        bgt		$t1, $t3, pair_existsfail	# if $t1 > $t3 then pair_existsfail
        

        beqz    $t0, pair_existsfail    # if character 1 is null then fail
        beqz    $t1, pair_existsfail    # if character 2 is null then fail
        beq		$t0, $a0, pair_existsfirstmatch	# if $t0 == $a0 then pair_existsfirstmatch
        beq		$t0, $a1, pair_existssecondmatch	# if $t0 == $a1 then pair_existssecondmatch
        addi	$a2, $a2, 2			# $a2 = $a2 + 2
        j		pair_existsloop		# jump to pair_existsloop
        
    pair_existsfirstmatch:
        beq		$t1, $a1, pair_existssuccess	# if $t1 == $a1 then pair_existssuccess
        j		pair_existsfail				# jump to pair_existsfail
    
    pair_existssecondmatch:
        beq		$t1, $a0, pair_existssuccess	# if $t1 == $a0 then pair_existssuccess
        j		pair_existsfail				# jump to pair_existsfail
        
    pair_existssuccess:
        li		$v0, 1		# $v0 = 1
        j		exitpair_exists				# jump to exitpair_exists
        
    pair_existsfail:
        li		$v0, 0		# $v0 = 0
        
    exitpair_exists:

 jr $ra

.globl encrypt
encrypt:

    #a0 = plaintext, a1 = cipherkey, a2 = ciphertext
    #toupper a0 = s
    #
    #contains a0 = s, a1 = ch
    #cpyElems a0 = src, a1 = index, a2 = dest
    addi	$sp, $sp, -16			# $sp = $sp + -12
    sw		$a0, 0($sp)		# save plaintext
    sw		$a1, 4($sp)		# save cipherkey
    sw		$a2, 8($sp)		# save ciphertext
    sw		$ra, 12($sp)	# save return address

    jal		to_upper				# jump to to_upper and save position to $ra
    lw		$a0, 0($sp)		# 
    
    encryptcheckexists:
        lb		$t0, 0($a0)		# 
        beqz    $t0, encryptloop
        li		$t1, ' '		# $t1 = ' '
        beq		$t0, $t1, encryptskipletterchecks	# if $t0 == $t1 then encryptskipletterchecks
         
        li		$t1, 'A'		# $t1 = 'A'
        blt		$t0, $t1, encryptfail	# if $t0 < $t1 then encryptfail
        li		$t1, 'Z'		# $t1 = 'Z'
        bgt		$t0, $t1, encryptfail	# if $t0 > $t1 then encryptfail
        
        encryptskipletterchecks:
            addi	$a0, $a0, 1			# $a0 = $a0 + 1
            
        j		encryptcheckexists				# jump to encryptcheckexists

    encryptloop:
        lw		$a0, 0($sp)		# 
        lb		$t0, 0($a0)		# 
        #beqz    #exitloop
        beqz    $t0, exitencrpytloop
        #beq space to addspace and skip
        li		$t1, ' '		# $t1 = ' '
        beq		$t0, $t1, encryptspace	# if $t0 == $t1 then encryptspace
        
        move 	$a1, $t0		# $a1 = $t0 move character to ch
        lw		$a0, 4($sp)		# load cipherkey into s
        jal		contains				# jump to contains and save position to $ra
        #blt 0 fail
        blt		$v0, $zero, encryptfail	# if $v0 < $zero then encryptfail
        
        #if v0 is even then +1 else -1 move to t0
        move 	$t2, $v0		# $t2 = $v0
        li		$t3, 1		# $t3 = 1
        #andi	$t3, $t2, $t3			# $t3 = $t2 & $t3
        and		$t3, $t2, $t3		# $t3 = $t2 & $t3
        
        bne		$t3, $zero, encryptisodd	# if $t3 != $zero then encryptisodd
        addi	$t0, $t2, 1			# $t0 = $t2 + 1
        j		encryptcopy				# jump to encryptcopy

        encryptspace:
            sb		$t1, 0($a2)		# save space character
            addi	$a2, $a2, 1			# $a2 = $a2 + 1
            j		encryptloopincrement				# jump to encryptloopincrement

        encryptisodd:
            addi	$t0, $t2, -1			# $t0 = $t2 + -1

        encryptcopy:
            lw		$a0, 4($sp)		# load cipherkey into src
            move 	$a1, $t0		# $a1 = $t0 move index of cipher pair to index
            jal		cpyElems				# jump to cpyElems and save position to $ra
        
        encryptloopincrement:
            lw		$a0, 0($sp)		# load plaintext
            addi	$a0, $a0, 1			# $a0 = $a0 + 1
            sw		$a0, 0($sp)		# save new plaintext address
        
        j		encryptloop				# jump to encryptloop
        
    exitencrpytloop:
        li		$v0, 1		# $v0 = 1
        j		exitencrypt				# jump to exitencrypt

    encryptfail:
        li		$v0, 0		# $v0 = 0
    
    exitencrypt:
        sb		$zero, 0($a2)		# 
        lw		$a2, 8($sp)		# 
        lw		$ra, 12($sp)		# 
        addi	$sp, $sp, 16			# $sp = $sp + 16

 jr $ra

.globl decipher_key_with_chosen_plaintext
decipher_key_with_chosen_plaintext:

    #a0 = plaintext, a1 = ciphertext, a2 = key
    #pairexists a0 = c1, a1 = c2, a2 = key
    #cpyElems a0 = src, a1 = index, a2 = dest

    addi	$sp, $sp, -16			# $sp = $sp + -16
    sw		$a0, 0($sp)		# save plaintext
    sw		$a1, 4($sp)		# save ciphertext
    sw		$a2, 8($sp)		# save key
    sw		$ra, 12($sp)		# save return address
    #sw		$s0, 16($sp)		# saved variable for current key address

    decipherloop:
        lw		$a0, 0($sp)		# 
        lw		$a1, 4($sp)		# 
        lb		$t0, 0($a0)		# 
        lb		$t1, 0($a1)		# 
        beqz    $t0, decipherfindkeyend
        li		$t2, ' '		# $t2 = ' '
        beq		$t0, $t2, deciphernext	# if $t0 == $t2 then deciphernext
        move 	$a0, $t0		# $a0 = $t0
        move 	$a1, $t1		# $a1 = $t1
        #sw		$a2, 16($sp)		# 
        lw		$a2, 8($sp)		# 
        #original address of a2
        jal		pair_exists_decipher				# jump to pair_exists_decipher and save position to $ra
        bne		$v0, $zero, deciphernext	# if $v0 != $zero then deciphernext

        #deciphercurrentkeyaddress:
        #    lb		$t0, 0($a2)		# 
        #    beqz    $t0, decipheraddtokey
        #    addi	$a2, $a2, 1			# $a2 = $a2 + 1
        #    j		deciphercurrentkeyaddress				# jump to deciphercurrentkeyaddress

        #decipheraddtokey:
            lw		$a0, 0($sp)		# 
            li		$a1, 0		# $a1 = 0
            #lw		$a2, 16($sp)		# 
            #current address of a2
            jal		cpyElems				# jump to cpyElems and save position to $ra
            lw		$a0, 4($sp)		# 
            li		$a1, 0		# $a1 = 0
            #current address of a2
            jal		cpyElems				# jump to cpyElems and save position to $ra
    
        deciphernext:
            lw		$a0, 0($sp)		# 
            addi	$a0, $a0, 1			# $a0 = $a0 + 1
            sw		$a0, 0($sp)		# 
            lw		$a1, 4($sp)		# 
            addi	$a1, $a1, 1			# $a1 = $a1 + 1
            sw		$a1, 4($sp)		# 
            
        j		decipherloop				# jump to decipherloop
        
    decipherfindkeyend:
        lb		$t0, 0($a2)		# 
        beqz    $t0, exitdecipher
        addi	$a2, $a2, 1			# $a2 = $a2 + 1
        j		decipherfindkeyend				# jump to decipherfindkeyend

    exitdecipher:
        sb		$zero, 0($a2)		# 
        lw		$a2, 8($sp)		# 
        lw		$ra, 12($sp)		# 
        addi	$sp, $sp, 16			# $sp = $sp + 16

 jr $ra

.globl pair_exists_decipher
pair_exists_decipher:

    li		$t2, 'A'		# $t2 = 'A'
    li		$t3, 'Z'		# $t3 = 'Z'

    pair_exists_decipherloop:
        lb		$t0, 0($a2)		# take first character
        # check first character is uppercase letter
        blt		$t0, $t2, pair_exists_decipherfail	# if $t0 < $t2 then pair_exists_decipherfail
        bgt		$t0, $t3, pair_exists_decipherfail	# if $t0 > $t3 then pair_exists_decipherfail
        # check second character is uppercase letter
        lb		$t1, 1($a2)		# take second character
        blt		$t1, $t2, pair_exists_decipherfail	# if $t1 < $t2 then pair_exists_decipherfail
        bgt		$t1, $t3, pair_exists_decipherfail	# if $t1 > $t3 then pair_exists_decipherfail
        

        beqz    $t0, pair_exists_decipherfail    # if character 1 is null then fail
        beqz    $t1, pair_exists_decipherfail    # if character 2 is null then fail
        beq		$t0, $a0, pair_exists_decipherfirstmatch	# if $t0 == $a0 then pair_exists_decipherfirstmatch
        exitpair_exists_decipherfirstmatch:
        beq		$t0, $a1, pair_exists_deciphersecondmatch	# if $t0 == $a1 then pair_exists_deciphersecondmatch
        exitpair_exists_deciphersecondmatch:
        addi	$a2, $a2, 2			# $a2 = $a2 + 2
        j		pair_exists_decipherloop		# jump to pair_exists_decipherloop
        
    pair_exists_decipherfirstmatch:
        beq		$t1, $a1, pair_exists_deciphersuccess	# if $t1 == $a1 then pair_exists_deciphersuccess
        j		exitpair_exists_decipherfirstmatch				# jump to exitpair_exists_decipherfirstmatch
    
    pair_exists_deciphersecondmatch:
        beq		$t1, $a0, pair_exists_deciphersuccess	# if $t1 == $a0 then pair_exists_deciphersuccess
        j		exitpair_exists_deciphersecondmatch				# jump to exitpair_exists_deciphersecondmatch
        
    pair_exists_deciphersuccess:
        li		$v0, 1		# $v0 = 1
        j		exitpair_exists_decipher				# jump to exitpair_exists_decipher
        
    pair_exists_decipherfail:
        li		$v0, 0		# $v0 = 0
        
    exitpair_exists_decipher:

 jr $ra