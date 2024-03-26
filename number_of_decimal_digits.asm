	.eqv	SYS_PRTSTR, 4
	.eqv	SYS_READSTR, 8
	.eqv	SYS_PRTUINT, 36
	.eqv	SYS_EXIT0, 10
	.eqv	BUFSIZE, 80
	
	.data
buf:	.space	BUFSIZE
prompt:	.asciz	"Enter a string: "

	.text
prologue:
	addi	sp, sp, -4
	sw	s1, 0(sp) #saving value to a stack
main:
	la	a0, prompt
	li	a7, SYS_PRTSTR
	ecall
	
	la	a0, buf
	li	a1, BUFSIZE
	li	a7, SYS_READSTR
	ecall
	
	la	t0, buf
	mv	t1, zero #number of number of digit-chains
	li	t2, '0'
	li	t3, '9'
	mv	t4, zero #processed char
	mv	t5, zero #previous char, examined when digit chain broken
	
not_digit:
	lbu	t5, -2(t0)
	bltu	t5, t2, process_char
	bgtu	t5, t3, process_char
	addi	t1, t1, 1
	
process_char:
	lbu	t4, 0(t0)
	addi	t0, t0, 1
	beqz	t4, fin
	bltu	t4, t2, not_digit
	bgtu	t4, t3, not_digit 
	j 	process_char
	
	
fin:
	mv	a0, t1
	li	a7, SYS_PRTUINT
	ecall

epilogue:
	lw	s1, 0(sp)
	addi	sp, sp, 4
	li	a7, SYS_EXIT0
	ecall


	