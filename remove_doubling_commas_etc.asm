	.eqv	SYS_PRTSTR, 4
	.eqv	SYS_READSTR, 8
	.eqv	SYS_EXIT0, 10
	.eqv	BUFSIZE, 80
	
	.data
buf:	.space	BUFSIZE
prompt:	.asciz	"Enter a string: "

	.text
main:
	la	a0, prompt
	li	a7, SYS_PRTSTR
	ecall

	la	a0, buf
	li	a1, BUFSIZE
	li	a7, SYS_READSTR
	ecall
	
	li	t0, ' ' #char to remove
	li	t1, ',' #char to remove
	li	t2, ';' #char to remove
	
	la	t3, buf #load pointer
	mv	t4, t3 #write pointer
	mv	t5, zero #previous char - used for comparison
	mv	t6, zero #ongoing char
	

	
check_char:
	lbu	t6, (t3)
	beqz	t6, fin
	beq	t6, t0, check_if_doubles #checks if char is one of banned chars
	beq	t6, t1, check_if_doubles #checks if char is one of banned chars
	beq	t6, t2, check_if_doubles #checks if char is one of banned chars
	sb	t6, (t4)
	addi	t3, t3, 1
	addi	t4, t4, 1
	j 	check_char
	
non_single_occurence:
	addi	t3, t3, 1
	
check_if_doubles:
	lbu	t5, 1(t3)
	beq	t5, t6, non_single_occurence
	sb	t6, (t4)
	addi	t3, t3, 1 #steps into next letter
	addi	t4, t4, 1
	j	check_char
	
fin:	
	sb	zero, 0(t4)
	la	a0, buf
	li	a7, SYS_PRTSTR
	ecall
	
	li	a7, SYS_EXIT0
	ecall
	
	

	
	
	
	
