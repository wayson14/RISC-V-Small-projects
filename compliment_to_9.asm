	.eqv	SYS_EXIT0, 10
	.eqv	SYS_PRTSTR, 4
	.eqv	SYS_READSTR, 8
	
	.eqv	BUFSIZE, 80
	
	.data
prompt:	.asciz	"Enter a string: "

buf:	.space	BUFSIZE
	
	.text
main:
	#text prompting
	la	a0, prompt
	li	a7, SYS_PRTSTR 
	ecall
	
	#text input
	la	a0, buf
	li	a1, BUFSIZE
	li	a7, SYS_READSTR
	ecall
	
	#writing values to registers
	la	t0, buf #t0 holds 80-byte contents of a written buffer
	li	t2, '0' #t2 holds ascii representation of digit zero
	li	t3, '9' #t3 holds ascii representation of digit nine
	#li	t4, 9 #t4 holds 0 constant
	
findnum:
	lbu	t1, (t0) #loads one byte (8-bit-long) from t0 to t1 -> t1 holds checked char
	addi	t0, t0, 1
	beqz	t1, fin
	bltu	t1, t2, findnum
	bgtu	t1, t3, findnum
	#here, if program has not branched yet it means, that ascii code is between this of digit 0 and this of digit 9
	
compliment_digit:
	sub	t1, t3, t1
	addi 	t1, t1, 48
	addi	t0, t0, -1 #decremetns pointer by one
	sb	t1, (t0) #tries to save complimented integer to the buffer
	addi	t0, t0, 1
	j	findnum
	
fin:
	la	a0, buf
	li	a7, SYS_PRTSTR
	ecall
	
	li	a7, SYS_EXIT0
	ecall