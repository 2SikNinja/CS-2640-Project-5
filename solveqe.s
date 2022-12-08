#	Name:	Nguyen, Peter
#	Project:	#5
#	Due:	12/08/2022
#	Course:	cs-2640-04-f22
#
#	Description:
#		Solves quadratic equation using user inputs and notifies if the roots are imaginary or if not a quadratic equation

	.data
intro:	.asciiz	"Quadratic Equation Solver v0.1 by P.Nguyen\n\n"
newLine:	.asciiz	"\n"
polynomPrint1:	.asciiz	" x^2 + "
polynomPrint2:	.asciiz	" x + "
equalPrint:	.asciiz	" = 0"
imaginary:	.asciiz	"Roots are imaginary."
notQuad:	.asciiz	"Not a quadratic equation."
x1:	.asciiz	"x1 = "
x2:	.asciiz	"x2 = "
aPrompt:	.asciiz	"Enter value for a? "
bPrompt:	.asciiz	"Enter value for b? "
cPrompt:	.asciiz	"Enter value for c? "
A:	.float	0.0
B:	.float	0.0
C:	.float	0.0

	.text
main:
	li	$v0, 4	# prints intro
	la	$a0, intro
	syscall

	la	$a0, aPrompt	# prints prompt for a
	syscall
	li	$v0, 6	# read float
	syscall
	s.s	$f0, A	# store into a

	li	$v0, 4	# prints prompt for b
	la	$a0, bPrompt
	syscall
	li	$v0, 6	# read float
	syscall
	s.s	$f0, B	# store into b

	li	$v0, 4	# prints prompt for c
	la	$a0, cPrompt
	syscall
	li	$v0, 6	# read float
	syscall
	s.s	$f0, C	# store into c

	li	$v0, 4	# print new line
	la	$a0, newLine
	syscall
	li	$v0, 2	# print A
	l.s	$f12, A
	syscall
	li	$v0, 4	# print "x^2 + "
	la	$a0, polynomPrint1
	syscall
	li	$v0, 2	# print B
	l.s	$f12, B
	syscall 
	li	$v0, 4	# print " x + "
	la	$a0, polynomPrint2
	syscall
	li	$v0, 2	# print C
	l.s	$f12, C
	syscall
	li	$v0, 4	# print " = 0"
	la	$a0, equalPrint
	syscall
	li	$v0, 4	# print new line twice
	la	$a0, newLine
	syscall
	syscall

	l.s	$f12, A	# quadeq(A,B,C)
	l.s	$f13, B
	l.s	$f14, C
	jal	quadeq

	beq	$v0,-1, caseImaginary
	beqz	$v0, caseNotQuad
	beq	$v0, 1, caseOneSolution
	beq	$v0, 2, caseTwoSolution


quadeq:
			# f12=A, f13=B, f14=C
	mov.s	$f21, $f12	# f21=A b/c will use f12 when calling sqrts
	addiu	$sp, $sp, -4	# push(ra)
	sw	$ra,($sp)

	li.s	$f20, 0.0	# if(A=0), do next if statement
	c.eq.s	$f21, $f20
	bc1f	endif1

	c.eq.s	$f13, $f20	# if(B=0)
	bc1f	else2
	li	$v0, 0	# return 0
	lw	$ra,($sp)	# pop ra
	addiu	$sp,$sp,4
	jr	$ra
else2:
	neg.s	$f0, $f14	# f0 = -C
	div.s	$f0, $f0, $f13	# f0 = -C/B
	li	$v0, 1
	lw	$ra,($sp)	# pop ra
	addiu	$sp,$sp,4
	jr	$ra	# return 1 in v0, -C/B in f0
endif1:
	mul.s	$f23,$f13,$f13	# f23 = B^2
	mul.s	$f22,$f21,$f14	# f22 = A*C
	li.s	$f21, 4.0
	mul.s	$f22,$f22,$f21	# f22 = 4AC
	sub.s	$f23,$f23,$f22	# f23 = B^2 - 4AC

	c.lt.s	$f23, $f20	# if(d<0)
	bc1f	else3
	li	$v0, -1
	lw	$ra,($sp)	# pop ra
	addiu	$sp,$sp,4
	jr	$ra	# return -1 in v0
else3:
	mov.s	$f12, $f23	# sqrts(b^2-4ac)
	jal	sqrts
	mov.s	$f24,$f0	# f24 = sqrt(b^2-4ac)

	neg.s	$f25, $f13	# f25 = -b
	
	li.s	$f26, 2.0
	mul.s	$f26,$f26,$f21	# f26 = 2a

	add.s	$f0,$f25,$f24	# f0 = -b + sqrt(b^2-4ac)
	div.s	$f0,$f0,$f26	# f0 = (-b + sqrt(b^2-4ac))/2a

	sub.s	$f1,$f25,$f24	# f1 = -b - sqrt(b^2-4ac)
	div.s	$f1,$f1,$f26	# f1 = (-b + sqrt(b^2-4ac))/2a

	li	$v0,2

	lw	$ra,($sp)	# pop ra
	addiu	$sp,$sp,4
	jr	$ra


caseImaginary:
	li	$v0,4	# print "Roots are imaginary"
	la	$a0,imaginary
	syscall
	b	endSwitch
caseNotQuad:
	li	$v0, 4	# print "Not a quadratic equation"
	la	$a0,notQuad
	syscall
	b	endSwitch
caseOneSolution:
	li	$v0, 4	# print "x1 = "
	la	$a0, x1
	syscall
	li	$v0, 2	# print root
	mov.s	$f12,$f0
	syscall
	li	$v0, 4	# print new line
	la	$a0, newLine
	syscall
	b	endSwitch
caseTwoSolution:
	li	$v0, 4	# print "x1 = "
	la	$a0, x1
	syscall
	li	$v0, 2	# print root
	mov.s	$f12,$f0
	syscall
	li	$v0, 4	# print new line
	la	$a0, newLine
	syscall
	la	$a0, x2	# print "x2 = "
	syscall
	li	$v0, 2	# print root 2
	mov.s	$f12,$f1
	syscall
endSwitch:
	li	$v0, 10	# exit
	syscall



# Babylonian square root (x) 
sqrts:
			# f12=x
	li.s	$f28,0.0000001	# f28 = err
	mov.s	$f0,$f12	# f0 = t 
	li.s	$f29,2.0	# f29 = 2
while1:
	div.s	$f30,$f12,$f0	# f30 = x/t
	sub.s	$f30,$f0,$f30	# f30 = t-x/t
	abs.s	$f30,$f30	# f30 = abs(t-x/t)
	mul.s	$f31,$f28,$f0	# f31 = err * t
	c.lt.s	$f31,$f30
	bc1f	endWhile1	# while ( abs(t-x/t) > error*t)
	div.s	$f30,$f12,$f0	# f30 = x/t
	add.s	$f30,$f30,$f0	# f30 = x/t + t
	div.s	$f0,$f30,$f29	# t = (x/2+t)/2
	b	while1
endWhile1:
	jr	$ra	# returns t


