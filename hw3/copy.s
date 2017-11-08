# /*int** matMult(int **a, int num_rows_a, int num_cols_a,
# 				int** b, int num_rows_b, int num_cols_b);
#   int** c;
#   int i , j, k;
#   int sum;
#   sum=0;
#   c =  malloc(num_rows * sizeof(int*));
#   for ( i = 0; i < num_rows_a; i++)
#   {
#     c[i] = malloc(num_cols_b * sizeof(int));
#   }
#   for(i = 0; i < num_rows_a; i++){
#     for(j = 0; j < num_cols_b; j++){
#       for(k = 0; k < num_cols_a; j++){
#         sum += a[i][k] * b[k][j];
#       }
#       c[i][j] = sum;
#       sum = 0;
#     }
#   }
#   return c;
# }
# */
.global matMult

.equ wordsize, 4
.equ a, 2*wordsize
.equ num_rows_a, 3 *wordsize
.equ num_cols_a, 4 *wordsize
.equ b, 5 *wordsize
.equ num_rows_b, 6 *wordsize
.equ num_cols_b, 7 *wordsize
.equ c, -1 *wordsize
.equ i, -2 *wordsize
.equ j, -3 *wordsize
.equ k, -4 *wordsize
.equ sum, -5 *wordsize

matMult:

push %ebp
movl %esp, %ebp
subl $5*wordsize, %esp



push %ebx #save ebx
push %esi #save esi
push %edi
# c = malloc(num_rows * sizeof(int*));
movl num_rows_a(%ebp), %eax # get num rows
shll $2, %eax # num_rows * sizeof(int*)
push %eax # give malloc its argument
call malloc # call malloc
addl $1*wordsize, %esp # remove arguements froms tack
movl %eax, c(%ebp)

#   for ( i = 0; i < num_rows_a; i++)
#   {
#     c[i] = malloc(num_cols_b * sizeof(int));
#   }

movl $0, %ecx
movl num_cols_b(%ebp), %ebx
shll $2, %ebx
push %ebx

outterloop:
cmpl num_rows_a(%ebp), %ecx
jge end_outterloop

movl %ecx, i(%ebp)

call malloc

movl c(%ebp), %edx
movl i(%ebp), %ecx
movl %eax, (%edx, %ecx, wordsize) # c[i] = malloc(num_cols *sizeof(int));
movl %edx, %eax

movl $0, %edx # j = 0

midloop:
cmpl num_cols_b(%ebp), %edx
jge end_midloop

movl $0, %edi # sum = 0
movl $0, %esi # k = 0

innerloop:
cmpl num_cols_a(%ebp), %esi
jge end_innerloop

movl a(%ebp), %ebx # ebx has a

movl (%ebx, %ecx, wordsize), %ebx # ebx = a[i]
movl (%ebx, %esi, wordsize), %ebx # ebx = a[i][k]

movl %ebx, sum(%ebp)#sum = a[i][k]

movl b(%ebp), %eax # eax has b
movl (%eax, %esi, wordsize), %eax # eax = b[k]
movl (%eax, %edx, wordsize), %eax # eax = b[k][j]
movl %edx, j(%ebp)  # mull uses edx, so saves j
mull sum(%ebp)#edx:eax = sum * eax

addl %eax, %edi # add sum to total sum

movl j(%ebp), %edx # restore j

incl %esi # k++
jmp innerloop

end_innerloop:

movl c(%ebp), %eax
movl (%eax, %ecx, wordsize), %ebx#ebx = c[i]
movl %edi, (%ebx, %edx, wordsize)#ebx = c[i][k] = total sum

incl %edx # j++
jmp midloop

emd_midloop:
incl %ecx # i++
jmp outterloop

end_outterloop:
addl $1*wordsize, %esp
jmp epilogue

epilogue:
pop %esi
pop %ebx
pop %edi

movl %ebp, %esp
pop %ebp
ret
