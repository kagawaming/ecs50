.global _start

.data

num1:
  .long 10
  .long 10

num2:
  .long 20
  .long 20

.text
_start:

  #eax will be the lower 32 bits
  #ecx will be the upper 32 bits
  #edx will be the upper 32 bits

  movl num1, %edx #store upper 32 bits in edx
  movl num2, %ecx #store upper 32 bits in ecx
  movl num1 + 4, %eax
  addl num2 + 4, %eax
  adc %ecx, %edx # add upper 32 bits with carry
  jmp done

done:
  movl %edx, %edx



