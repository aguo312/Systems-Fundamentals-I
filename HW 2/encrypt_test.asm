# Edit this file to write your tests. Change data section if needed.

.data
 plaintext: .asciiz "I love Mips"
 cipherkey: .asciiz "QTOSIGZMWBXFHUDKNPJVCEALYR"
 ciphertext: .ascii ""


.text
main:
 la $a0, plaintext
 la $a1, cipherkey
 la $a2, ciphertext
 jal encrypt

term:
 li $v0, 10
 syscall


.include "hw2.asm"
