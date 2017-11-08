.global knapsack

.equ wordsize, 4

max:
# prologue
maxprologue:
push %ebp
movl %esp, %ebp
jmp setup_stack

a_greater:
movl %ebp, %esp
pop %ebp
ret

cmpif:
cmpl %eax, %edx
jge b_greater
jmp a_greater

b_greater:
movl %edx, %eax
movl %ebp, %esp
pop %ebp
ret

setup_cmp:
movl a(%ebp), %eax
movl b(%ebp), %edx
jmp cmpif

setup_stack:
.equ a, 2 * wordsize
.equ b, 3 * wordsize
jmp setup_cmp

knapsack:

# prologue
prologue:
push %ebp
movl %esp, %ebp
subl $2 * wordsize, %esp
jmp setupstack

for_loop:
movl num_items(%ebp), %ecx
cmpl %ecx, %ebx #i - num_items
#i < num_items
jge end_for_loop
jmp for_loop_code

for_loop_if:
subl %eax, %edx #capacity - weights[i]
cmpl $0, %edx
jge ifFit  #if(capacity - weights[i] >= 0)
jmp endFit

setup_loop:
movl cur_value(%ebp), %ebx #ebx = cur_value
movl %ebx, best_value(%ebp) #best_value = cur_value
movl $0, %ebx#ebx = 0
#movl %ebx, i(%ebp) #ebx = i
movl num_items(%ebp), %ecx #ecx = num_items
jmp for_loop

setupstack:
.equ weights, 2 * wordsize
.equ values, 3 * wordsize
.equ num_items, 4 * wordsize
.equ capacity, 5 * wordsize
.equ cur_value, 6 * wordsize
.equ i, -1 * wordsize
.equ best_value, -2 * wordsize
jmp setup_push

capweight:
# capacity - weights[i]
movl capacity(%ebp), %esi
movl weights(%ebp), %edx
movl (%edx, %ebx, wordsize), %edx # edx has weights[i]
subl %edx, %esi # ecx has capacity - weights[i]
push %esi
jmp num_itemsi1

setup_push:
push %ebx
push %esi
push %edi
jmp setup_loop

postknap:
# max(best_value, knapsack(...))
push %eax
movl best_value(%ebp), %edx
push %edx
jmp callmax

curplusval:
movl cur_value(%ebp), %eax #eax = cur_value
movl values(%ebp), %edx #edx = values
movl (%edx, %ebx, wordsize), %edx # %ebx has values[i]
addl %edx, %eax # eax has cur_value + values[i]
push %eax
jmp capweight

for_loop_code:
movl capacity(%ebp), %edx #edx = capacity
movl weights(%ebp), %eax #eax = weights
movl (%eax, %ebx, wordsize), %eax #eax = weights[i]
jmp for_loop_if

endFit:
incl %ebx
#movl %ebx, i(%ebp)
jmp for_loop

end_for_loop:
jmp epilogue

ifFit:
jmp curplusval

postmax:
addl $2*wordsize, %esp #clear args
movl %eax, best_value(%ebp) #return of max into bestval
jmp endFit

callknap:
# knapsack(...)
call knapsack
addl $5*wordsize, %esp
jmp postknap

num_itemsi1:
# num_items - i - 1
movl num_items(%ebp), %edx
subl %ebx, %edx #edx has num_items - i
decl %edx # edx has num_items - i - 1
push %edx
jmp vali1

vali1:
# values + i + 1
movl values(%ebp), %esi
leal wordsize(%esi, %ebx, wordsize), %esi
push %esi
jmp weightsi

weightsi:
# weights +i + 1
movl weights(%ebp), %esi
leal wordsize(%esi, %ebx, wordsize), %esi
push %esi
jmp callknap

callmax:
call max
jmp postmax

epilogue:

movl best_value(%ebp), %eax

pop %edi
pop %esi
pop %ebx

movl %ebp, %esp
pop %ebp
ret
