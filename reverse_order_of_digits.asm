	.eqv	SYS_READSTR, 8
	.eqv	SYS_PRTSTR, 4
	.eqv	SYS_EXIT0, 10
	.eqv	BUFSIZE, 100
	
	.data
prompt:	.asciz	"Enter a string: "
buf:	.space	BUFSIZE
digits:	.space	BUFSIZE

	.text
main:
	la	a0, prompt
	li	a7, SYS_PRTSTR
	ecall
	
	la	a0, buf
	li	a1, BUFSIZE
	li	a7, SYS_READSTR
	ecall

	la	t0, buf #pointer of read str
	la	t1, digits #pointer of stacked digits
	li	t3, '0'
	li	t4, '9'
	
	addi	t0, t0, -1
search:
	addi	t0, t0, 1
	lbu	t2, (t0)
	beqz	t2, load_buffer_before_search_reverse
	bltu	t2, t3, search
	bgtu	t2, t4, search

found_digit:
	sb	t2, 0(t1)
	addi	t1, t1, 1
	j	search
	
	
load_buffer_before_search_reverse:
	la	t0, buf
	addi	t0, t0, -1
search_reverse:
	addi	t0, t0, 1 #t0 must be preserved accross the whole loop
	lbu	t2, (t0)
	beqz	t2, print_string #end of string
	bltu	t2, t3, search_reverse
	bgtu	t2, t4, search_reverse

found_digit_reverse:
	lbu	t5, -1(t1)
	sb	t5, 0(t0)
	addi	t1, t1, -1
	j	search_reverse

	
	
print_string:
	la	a0, buf
	li	a7, SYS_PRTSTR
	ecall

fin:
	li	a7, SYS_EXIT0
	ecall
	
