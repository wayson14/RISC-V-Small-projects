	.eqv	SYS_EXIT0, 10
	.eqv 	SYS_PRTSTR, 4
	.eqv 	SYS_READSTR, 8
	.eqv 	SYS_PRTINTU, 33
	
	.data
hello: .asciz	"hello world!\n"

	.text
main:
	la 	a0, hello
	li	a7, SYS_PRTSTR
	ecall
	
		
	