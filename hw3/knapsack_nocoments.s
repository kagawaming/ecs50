.global knapsack

max_stack:
.equ wordsize, 4
.equ a, 2 * wordsize
.equ b, 3 * wordsize

knap_stack:
.equ weights, 2 * wordsize
.equ values, 3 * wordsize
.equ num_items, 4 * wordsize
.equ capacity, 5 * wordsize
.equ cur_value, 6 * wordsize
.equ i, -1 * wordsize
.equ best_value, -2 * wordsize

max:

max_prologue:
push %ebp
movl %esp, %ebp

movl a(%ebp), %eax
movl b(%ebp), %ecx

cmpl %eax, %ecx
jge b_is_greater

movl %ebp, %esp
pop %ebp
ret

b_is_greater:
movl %ecx, %eax
movl %ebp, %esp
pop %ebp
ret

knapsack:

prologue:
push %ebp
movl %esp, %ebp
subl $2 * wordsize, %esp
push %ebx
push %esi
push %edi

movl cur_value(%ebp), %ebx
movl %ebx, best_value(%ebp)
movl $0, %ebx
movl %ebx, i(%ebp)
movl num_items(%ebp), %edx

knap_loop:
movl num_items(%ebp), %edx
cmpl %edx, %ebx
jge end_knap_loop

movl capacity(%ebp), %ecx
movl weights(%ebp), %eax
movl (%eax, %ebx, wordsize), %eax

subl %eax, %ecx
cmpl $0, %ecx
jge capacity_enough
jmp next

capacity_enough:

movl cur_value(%ebp), %eax
movl values(%ebp), %ecx
movl (%ecx, %ebx, wordsize), %ecx
addl %ecx, %eax
push %eax

movl capacity(%ebp), %esi
movl weights(%ebp), %ecx
movl (%ecx, %ebx, wordsize), %ecx
subl %ecx, %esi
push %esi

movl num_items(%ebp), %ecx
subl %ebx, %ecx
decl %ecx
push %ecx

movl values(%ebp), %esi
leal wordsize(%esi, %ebx, wordsize), %esi
push %esi

movl weights(%ebp), %esi
leal wordsize(%esi, %ebx, wordsize), %esi
push %esi

call knapsack
addl $5*wordsize, %esp

push %eax
movl best_value(%ebp), %ecx
push %ecx

call max

addl $2*wordsize, %esp
movl %eax, best_value(%ebp)

next:
incl %ebx
movl %ebx, i(%ebp)
jmp knap_loop

end_knap_loop:

epilogue:

movl best_value(%ebp), %eax
pop %edi
pop %esi
pop %ebx
movl %ebp, %esp
pop %ebp
ret
