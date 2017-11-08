
.global _start

.data

a:
	.long 65
b:
	.long 10

operator:
	.byte '+

.text

_start:
	#result will be edx
	#eax will be a
	#ebx will be b
	
	movl  a, %eax #eax =a 
	movl b, %ebx #ebx = b
	
	#if(operator == '+')
		#result = a + b
	#else if(operator == '-')
		#result = a - b

add_case:
	cmpb $'+ , operator #operator == '+' == operator - '+'== 0
	jnz sub_case
	movl %eax, %edx
	addl %ebx, %edx
	jmp end_else_if
	
sub_case:
	cmpb $'- , operator #operator == '-' == operator - '-'== 0
	jnz and_case
	movl %eax, %edx
	subl %ebx, %edx
	jmp end_else_if

and_case:
	cmpb $'& , operator #operator == '&' == operator - '&'== 0
	jnz or_case
	movl %eax, %edx
	andl %ebx, %edx
	jmp end_else_if

or_case:
	cmpb $'| , operator #operator == '|' == operator - '|'== 0
	jnz end_else_if
	movl %eax, %edx
	orl %ebx, %edx

end_else_if:

done:
	movl %eax, %eax
	
	

