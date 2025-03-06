#
#	Name:	Beauchamp, Joshua
#	Homework:	2
#	Due:	4-22-24
#	Course:	cs-2640-02-sp24
#
#	Description:
#		The homework program is designed to use a procedure called "printf"
#		to output numbers, strings, and a percent sign. However, if an unknown
#		%code is entered, the output stops and the same character that is not a
#		%code is outputted after a question mark, signifying the program does not
#		understand how to output the format of the string



	.data
title:	.asciiz	"printf by J. Beauchamp"
format:	.asciiz	"Numbers are %d %d %d. Check for percent %%. String is %s. Unknown is %j. Checks if the string stops outputting"
string:	.asciiz	"Hello World"
before:	.asciiz	"String format output before printf: "
after:	.asciiz	"String format output after printf: "
digit1:	.word	4
digit2:	.word	26
digit3:	.word	100

	.text
main:	
	# Outputs title
	la	$a0, title
	li	$v0, 4
	syscall
	jal	printnl
	jal	printnl

	# Outputs the string format before it is changed via printf
	la	$a0, before
	li	$v0, 4
	syscall
	jal	printnl

	la	$a0, format
	li	$v0, 4
	syscall
	jal	printnl
	jal	printnl

	# Outputs the string format after printf
	la	$a0, after
	li	$v0, 4
	syscall
	jal	printnl

	# Passes test parameters on the stack
	addiu	$sp, $sp, -16
	lw	$t0, digit1	# First parameter stored in second byte: Integer
	sw	$t0, 0($sp)
	lw	$t0, digit2	# Second parameter stored in third byte: Integer
	sw	$t0, 4($sp)
	lw	$t0, digit3	# Third paramteter stored in fourth byte: Integer
	sw	$t0, 8($sp)
	la	$t0, string	# Fourth parameter stored in first byte: String
	sw	$t0, 12($sp)

	# Calls "printf" procedure
	la	$a0, format	# String format as paramater
	jal	printf

	# Returns stack back to normal
	addiu	$sp, $sp, 16

	# Prints newline and exits program
	jal	printnl
	li	$v0, 10
	syscall


	# Assume string format in $a0
	# Assume paramters are on the stack
	# Outputs the string until completion or until unknow %code encountered
printf:	
	# Save format onto stack
	addiu	$sp, $sp, -4
	sw	$a0, ($sp)

	# Sets stack pointer to first parameter
	addiu	$t1, $sp, 4

	# Stores the string format into t0 so we can use 
	# t2 to iterate through each character
	move	$t0, $a0
	lb	$t2, ($t0)

	# Loops through the string format until we reach the end
while:	
	lb	$t2, ($t0)	# First character of format in t2
	beqz	$t2, endw		# Ends loop if the current character is '/0'

	# If the current character is '%', starts switch cases
	bne	$t2, '%', else	

	# Increments to next character after '%'
	add	$t0, $t0, 1
	lb	$t2, ($t0)

	# Switch cases
	# Checks which case corresponds to the character in the format string after '%'
case1:	
	bne	$t2, '%', case2	# case "%"
	li	$a0, '%'
	li	$v0, 11
	syscall
	b	stop

case2:
	bne	$t2, 'd', case3	# case "d"
	lw	$a0, ($t1)
	li	$v0, 1
	syscall
	
	addiu	$t1, $t1, 4
	b	stop

case3:
	bne	$t2, 's', default	# case "s"
	lw	$a0, ($t1)
	li	$v0, 4
	syscall

	addiu	$t1, $t1, 4
	b	stop

default:	
	li	$a0, '?'		# case "unknown"
	li	$v0, 11
	syscall
	move	$a0, $t2
	syscall

	b	endw
stop:
	# End of switch cases


	b	endif
	# Else, the character must not be '%', so it is outputted
else:
	move	$a0, $t2
	li	$v0, 11
	syscall

endif:

	# Increments to next character in format
	add	$t0, $t0, 1
	b	while
endw:
	# Pops $a0 out of stack to restore stack
	lw	$a0, ($sp)
	addiu	$sp, $sp, 4

	jr	$ra

	# Prints a newline character
printnl:	
	li	$a0, '\n'
	li	$v0, 11
	syscall
	jr	$ra
