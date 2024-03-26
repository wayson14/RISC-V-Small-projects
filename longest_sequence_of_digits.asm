	.eqv	SYS_EXIT0, 10
	.eqv	SYS_PRTSTR, 4
	.eqv	SYS_READSTR, 8
	
	.eqv	BUFSIZE, 80
	
	.data
prompt:	.asciz	"Enter a string: "

buf:	.space	BUFSIZE
	.text

prologue:
	addi 	sp, sp, -4
	sw	s1, 0(sp) #saving value of an s1 register on the stack
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
	la	t0, buf #t0 holds an address 80-byte contents of a written buffer
	li	t2, '0' #t2 holds ascii representation of digit zero
	li	t3, '9' #t3 holds ascii representation of digit nine
	
	
	mv	t4, zero #holds an address of the first element of the longest digit sequence
	mv	t5, zero #holds length of a longest sequence
	
	mv	t6, zero #holds an address of the first element of an ongoing sequence
	mv	s1, zero #hold lenght of an ongoing sequence
	
findnum:
	
	lbu	t1, (t0) #loads one byte (8-bit-long) from t0 to t1 -> t1 holds checked char
	addi	t0, t0, 1
	beqz	t1, fin
	bltu	t1, t2, reset
	bgtu	t1, t3, reset
	bnez	s1, sequence_digit
	#here, if program has not branched yet it means, that ascii code is between this of digit 0 and this of digit 9

sequence_start:
	addi	t0, t0, -1
	mv	t6, t0
	addi 	t0, t0, 1
	
sequence_digit:
	addi	s1, s1, 1
	blt	s1, t5, findnum #compares sequence lengths
	
new_longest_sequence:
	mv	t5, s1
	mv	t4, t6
	j	findnum

reset:
	
	mv	t6, zero
	mv	s1, zero
	j	findnum

fin:
	beqz	t5, epilogue
	la	t0, buf
	
overwrite_buffer:
	lbu	t6, (t4)
	sb	t6, (t0)
	addi	t5, t5, -1 #for loop 
	addi	t4, t4, 1 #getting next number from the longest sequence
	addi	t0, t0, 1 #incrementing write-pointer
	bnez	t5, overwrite_buffer
	sb	zero, (t0) #zero is a null-termination character
	la	a0, buf
	li	a7, SYS_PRTSTR
	ecall

epilogue:
	lw	s1, 0(sp)
	addi	sp, sp, 4

	
	li	a7, SYS_EXIT0
	ecall
