# Edit this file to write your tests. Change data section if needed.

.data
 plaintext: .asciiz "ENCRYPTION NOT DONE RIGHT IS UNSAFE"
 ciphertext: .asciiz "ABTQZDCLWB BWC PWBA QLKMC LF JBFESA"
 cipherkey: .asciiz ""


.text
main:
 la $a0, plaintext
 la $a1, ciphertext
 la $a2, cipherkey
 jal decipher_key_with_chosen_plaintext
term:
 li $v0, 10
 syscall


.include "hw2.asm"
