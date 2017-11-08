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
movl b(%ebp), %edx

cmpl %eax, %edx
jge b_is_greater

movl %ebp, %esp
pop %ebp
ret

b_is_greater:
movl %edx, %eax
movl %ebp, %esp
pop %ebp
ret

knapsack:

# prologue
prologue:
push %ebp
movl %esp, %ebp
subl $2 * wordsize, %esp

push %ebx
push %esi
push %edi

movl cur_value(%ebp), %ebx # ebx = cur_value
movl %ebx, best_value(%ebp) # best_value = cur_value
movl $0, %ebx # ebx = 0
movl %ebx, i(%ebp) # ebx = i
movl num_items(%ebp), %ecx # ecx = num_items

knap_loop: # for_loop:
movl num_items(%ebp), %ecx
cmpl %ecx, %ebx # i - num_items
# i < num_items
jge end_knap_loop

movl capacity(%ebp), %edx # edx = capacity
movl weights(%ebp), %eax # eax = weights
movl (%eax, %ebx, wordsize), %eax # eax = weights[i]

subl %eax, %edx # capacity - weights[i]
cmpl $0, %edx
jge capacity_enough  # if(capacity - weights[i] >= 0)
jmp next

capacity_enough:

movl cur_value(%ebp), %eax # eax = cur_value
movl values(%ebp), %edx # edx = values
movl (%edx, %ebx, wordsize), %edx # %ebx has values[i]
addl %edx, %eax # eax has cur_value + values[i]
push %eax

# capacity - weights[i]
movl capacity(%ebp), %esi
movl weights(%ebp), %edx
movl (%edx, %ebx, wordsize), %edx # edx has weights[i]
subl %edx, %esi # ecx has capacity - weights[i]
push %esi

# num_items - i - 1
movl num_items(%ebp), %edx
subl %ebx, %edx # edx has num_items - i
decl %edx # edx has num_items - i - 1
push %edx

# values + i + 1
movl values(%ebp), %esi
leal wordsize(%esi, %ebx, wordsize), %esi
push %esi

# weights +i + 1
movl weights(%ebp), %esi
leal wordsize(%esi, %ebx, wordsize), %esi
push %esi

# knapsack(...)
call knapsack
addl $5*wordsize, %esp

# max(best_value, knapsack(...))
push %eax
movl best_value(%ebp), %edx
push %edx

call max

addl $2*wordsize, %esp # clear args
movl %eax, best_value(%ebp) # return of max into bestval

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
