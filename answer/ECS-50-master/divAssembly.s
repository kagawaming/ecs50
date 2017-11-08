.global _start

.equ wordsize, 4

.data

dividend:
	.long 23

divisor:
	.long 3
	
divcopy:
	.long 2
	
re:
	.long 0
	
quotient:
	.long 0

	
.text
_start:

# divcopy = dividend;
  movl dividend, %eax
  movl %eax, divcopy
  # quotient = quotient >> 31;
  movl quotient, %eax
  shrl $31, %eax
  movl %eax, quotient
  # dividend = dividend >> 31;
  
  movl dividend, %eax
  shrl $31, %eax
  movl %eax, dividend

  # for(int i = 0; i < 32; i++)
  # i is %eax
  movl $0, %eax
  outer_row_loop:
	cmpl $32, %eax
	jge end_outer_row_loop
  # {
    # if(((divcopy >> (31 - i)) & 0x1) == 1)
	# divcopy temp is %ebx
	movl divcopy, %ebx
	movl $31, %ecx
	subl %eax, %ecx #ecx is 31-i
	
	inner_row_loop:
		cmpl $0, %ecx
		jle end_inner_row_loop
		
		movl %ecx, re
		shrl $1, %ebx
		subl $1, %ecx
		
		jmp inner_row_loop
	end_inner_row_loop:
	
	andl $0x1, %ebx
	cmpl $1, %ebx
	jz if1
	continue1:
    # {
    # dividend = dividend | 0x1;
    # }//sets the first bit to 0 or 1 depending on what it is in the original num

	movl dividend, %edx
	cmpl divisor, %edx
	jge if2
	jl else1

	continue:
    # if (divisor <= dividend)
    #  
      # dividend = dividend - divisor;
      # quotient = quotient | 0x1;
    # }
	
    # else
    # {
      # quotient = quotient | 0x0;

    # }
    # quotient = quotient << 1;
    # dividend = dividend << 1;
    shll $1, quotient
    shll $1, dividend
  # }
  incl %eax
  jmp outer_row_loop
end_outer_row_loop:
  # quotient = quotient >> 1;
  # dividend = dividend >> 1;

shrl $1, quotient
shrl $1, dividend
  
  # re = dividend;
  movl dividend, %edx
  
  movl quotient, %eax
  
  jmp done
  
if1:     # dividend = dividend | 0x1;
	movl dividend, %edx
	orl $0x1, %edx
	movl %edx, dividend
	jmp continue1
	
if2:
    # dividend = dividend - divisor > 0;
	movl dividend, %ecx
	subl divisor, %ecx
	movl %ecx, dividend
    # quotient = quotient | 0x1;
	movl quotient, %ecx
	orl $0x1, %ecx
	movl %ecx, quotient
	jmp continue

else1:       # quotient = quotient | 0x0;
	movl quotient, %ecx
	orl $0x0, %ecx
	movl %ecx, quotient
	jmp continue
	

done:
  movl %ecx, %ecx
 
#  printf("%u / %u = %u R %u\n", divcopy, divisor, quotient, re);
#
#  return 0;
  
  

