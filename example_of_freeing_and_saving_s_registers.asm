	.eqv	SYS_PRTSTR, 4
	.eqv	SYS_READSTR, 8
	.eqv	SYS_EXIT0, 10
	.eqv	BUFSIZE, 12
	.eqv	SP_OFFSET, 12
	
	.data
buf:	.space	BUFSIZE
prompt:	.asciz	"Enter a string: "

	.text
prologue:
	addi	sp, sp, -SP_OFFSET
	sw	s1, 0(sp)
	sw	s2, 4(sp)
	sw	s3, 8(sp)

main:
	la	a0, prompt
	li	a7, SYS_PRTSTR
	ecall
	
	la	a0, buf
	li	a1, BUFSIZE
	li	a7, SYS_READSTR
	ecall
	
	la	t0, buf
	lw	s1, 0(t0)
	lw	s2, 4(t0)
	lw	s3, 8(t0)
	
	sw	s1, 0(t0)
	sw	s2, 4(t0)
	sw	s3, 8(t0)
	
	
epilogue:
	lw	s3, -8(sp)
	lw	s2, -4(sp)
	lw	s1, 0(sp)
	addi	sp, sp, SP_OFFSET
	
	li	a7, SYS_EXIT0
	ecall
		