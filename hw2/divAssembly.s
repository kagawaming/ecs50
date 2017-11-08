.global _start

.data

dividend:
.space 4

divisor:
.space 4

quotient:
.long 0

remainder:
.space 4

i:
.long 0

temp_j:
.long 0

.text

_start:
/*#quotient=eax
#remainder=edx
i=cl*/

movl $0, %eax
movl dividend, %edx
movl $0, %ecx
movl divisor, %esi


first_loop:/*find out how many bit in the divisor*/
cmpl $33, %ecx
jge end_first_loop
shr %cl, %esi
cmpl $0, %esi
jz end_first_loop
movl divisor, %esi
incl %ecx
jmp first_loop
end_first_loop:
movl $32, %esi
subl %ecx, %esi
movl %esi, %ecx/*ecx = 32-j*/
movl divisor, %esi
second_loop:
cmpl $0, %ecx/*if the remainder = 0, the loop end*/
jl end_second_loop
cmpl $0, %edx
jz end_second_loop
shl %cl, %esi
cmpl %esi, %edx
jae function
continue:
movl divisor, %esi/*initial the esi with divisor for every loop*/
decl %ecx
jmp second_loop
function:/*//keep subtract the remainder by shifted divisor untill divisor >remiande*/
movl divisor, %esi
shl %cl, %esi
subl %esi, %edx
movl $1, %edi
shl %cl, %edi
or %edi, %eax
jmp continue
end_second_loop:
done:
movl %eax, %eax
