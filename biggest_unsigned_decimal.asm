	.eqv	SYS_READSTR, 8
	.eqv	SYS_PRTSTR, 4
	.eqv	SYS_PRTUINT, 36
	.eqv	SYS_EXIT0, 10
	.eqv	BUFSIZE, 16
	
	.data
prompt:	.asciz	"Enter a string: "
buf:	.space	BUFSIZE

	.text
prologue:
	addi	sp, sp, -4
	sw	s1, 0(sp) #saving value from a register on the stack
	
main:
	la	a0, prompt
	li	a7, SYS_PRTSTR
	ecall
	
	la	a0, buf
	li	a1, BUFSIZE
	li	a7, SYS_READSTR
	ecall
	
	la	t0, buf
	li	t2, '0'
	li	t3, '9'
	li	s1, 10 #base of decimal system
	mv	t5, zero #max uint
	
	
reset_digit_chain:
	li	t4, 1 #current digit
	mv	t6, zero #value of current uint
digit_search:
	addi	t0, t0, 1
	lbu	t1, -1(t0)
	beqz	t1, print_max_uint
	bltu	t1, t2, reset_digit_chain
	bgtu	t1, t3, reset_digit_chain
digit_found:
	mul 	t6, t6, s1 #multiply whole uint
	addi	t1, t1, -48
	add	t6, t6, t1
	mul	t4, t4, s1 #base*10
	bltu	t6, t5, digit_search #check if it's a new max
	mv	t5, t6
	j digit_search
	

print_max_uint:
	mv	a0, t5
	li	a7, SYS_PRTUINT
	ecall
	
epligoue:
	lw	s1, 0(sp)
	addi	sp, sp, 4
	
fin:
	li	a7, SYS_EXIT0
	ecall
