
#here's a comment. they start with pound

/*
These ones work too

*/

.global _start 

.data
#global variable space

nums:
	.long 1 + 3
	.long 2 * 12
	.long 0x3 | 0x772
	.long 4
	.long 5

size:
	.long 5

sum:
.long 0

#.long 4 bytes ex .long 7
#.word 2 bytes .word 23
#.byte 1 byte .byte 'A'
#.float intial value. ex .float 35.79
#.string "some string"
#.space num_bytes. .space 20

hundred_array:
	.rept 100
		.long 5
	.endr


.text
#code goes here

_start: #code always starts at _start. main of assembly
	#ecx will be our i
	#eax will be our sum
	#ebx will be nums
	movl $0, %ecx #constants start with $. register names start with %
	movl $0, %eax
	movl $nums, %ebx #ebx is pointing to nums

#for(i =0; i < size; ++i)
	#sum += nums[i];

for_loop:
	#all comparisons are done against 0
	#i < size == i - size < 0

	#subl a, b == b -= a
	cmpl size, %ecx # i - size
	jge end_loop
	
	#sum += nums[i]
	addl (%ebx), %eax
	addl $4, %ebx #ebx += 1
	
	incl %ecx #i++
	jmp for_loop #go to the next iteration

end_loop:

	movl %eax, sum #sum = eax

done:
	movl %eax, %eax

	#a = b + c++
	#movl %ebx, %eax
	#addl %ecx, %eax
	#incl %ecx
	
	#a = b + ++c
	#incl %ecx
	#movl %ebx, %eax
	#addl %ecx, %eax
	
	






