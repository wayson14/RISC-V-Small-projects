	.eqv	SYS_PRTSTR, 4
	.eqv	SYS_READSTR, 8
	.eqv	SYS_READINT, 5
	.eqv	SYS_EXIT0, 10
	.eqv	BUFSIZE, 80
	
	.data
buf:	.space	BUFSIZE
#prompt:	.asciz	"Enter a string: "
	
	.text
	la	a0, buf
	li	a1, BUFSIZE
	li	a7, SYS_READSTR
	ecall
	
	li	a7, SYS_READINT
	ecall
	
	mv	t0, a0
	
	li	a7, SYS_READINT
	ecall
	
	bge	a0, t0, normal_order
swap: #t0 should hold the lesser value, t1 the greater one
	mv 	t1, t0
	mv	t0, a0
normal_order:
	mv 	t1, a0
	# now t1 holds the greater value, t0 holds the lesser value
	# t2 is an actual char, t3 is an address to overwrite, t4 is an index (int), t5 is an ongoing address in buffer
	li	t4, -1
	la	t5, buf
	mv 	t3, t5
	
loop_through_buffer:
	lbu	t2, (t5)
	addi	t5, t5, 1
	addi	t4, t4, 1
	beqz 	t2, add_leading_zero
	bgtu	t4, t0, loop_through_buffer #if index is between values to remove
	bltu	t4, t1, loop_through_buffer #if index is between values to remove
	sb	t2, (t3)
	addi	t3, t3, 1
	j	loop_through_buffer
	
add_leading_zero:
	sb	zero, (t3)
	
fin:
	la	a0, buf
	li	a7, SYS_PRTSTR
	ecall
	
	li	a7, SYS_EXIT0
	ecall
	
	
	


