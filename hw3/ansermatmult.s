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

matMult:

push %ebp
movl %esp, %ebp
subl $5*wordsize, %esp
jmp setupstack

Cmalloc:
# C = malloc(num_rows * sizeof(int*));
movl num_rows_a(%ebp), %eax#get num rows
shll $2, %eax #num_rows * sizeof(int*)
push %eax #give malloc its argument
call malloc #call malloc
addl $1*wordsize, %esp #remove arguements froms tack
movl %eax, C(%ebp)
jmp row_loop_setup

row_col_loop_sum:
movl %ebx, sum(%ebp)#sum = a[i][k]
jmp row_col_loop_bkj

row_loop:
cmpl num_rows_a(%ebp), %ecx
jge end_row_loop
jmp savei

col_loop_code:
movl $0, %edi#sum = 0
movl $0, %esi#k = 0
jmp row_col_loop

savei:
movl %ecx, i(%ebp)
jmp row_loop_malloc

row_loop_malloc:
call malloc
jmp row_loop_save_malloc

row_loop_setup:
movl $0, %ecx
movl num_cols_b(%ebp), %ebx
shll $2, %ebx
push %ebx
jmp row_loop



col_loop_setup:
movl $0, %edx#j = 0
jmp col_loop

setuppush:
push %ebx #save ebx
push %esi #save esi
push %edi
jmp Cmalloc

end_row_col_loop_totalsum:
movl C(%ebp), %eax
movl (%eax, %ecx, wordsize), %ebx#ebx = c[i]
movl %edi, (%ebx, %edx, wordsize)#ebx = c[i][k] = total sum
jmp end_row_col_loop_incj

row_col_loop_code:
movl a(%ebp), %ebx#ebx has a
jmp row_col_loop_aik

col_loop:
cmpl num_cols_b(%ebp), %edx
jge end_col_loop
jmp col_loop_code


epilogue_pop:
pop %esi
pop %ebx
pop %edi
jmp epiloguecont


row_col_loop_totalsum:
addl %eax, %edi#add sum to total sum
jmp row_col_loop_restorej

row_col_loop_restorej:
movl j(%ebp), %edx #restore j
jmp row_col_loop_endcode

row_col_loop_endcode:
incl %esi#k++
jmp row_col_loop


end_row_col_loop:
jmp end_row_col_loop_totalsum

row_col_loop_bkj:
movl b(%ebp), %eax#eax has b
movl (%eax, %esi, wordsize), %eax#eax = b[k]
movl (%eax, %edx, wordsize), %eax#eax = b[k][j]
movl %edx, j(%ebp) #mull uses edx, so saves j
mull sum(%ebp)#edx:eax = sum * eax
jmp row_col_loop_totalsum


end_row_col_loop_incj:
incl %edx #j++
jmp col_loop

row_loop_save_malloc:
movl C(%ebp), %edx
movl i(%ebp), %ecx
movl %eax, (%edx, %ecx, wordsize)
movl %edx, %eax
jmp col_loop_setup

end_col_loop:
incl %ecx#i++
jmp row_loop

end_row_loop:
addl $1*wordsize, %esp
jmp epilogue

epilogue:
jmp epilogue_pop

setupstack:
.equ a, 2*wordsize
.equ num_rows_a, 3 *wordsize
.equ num_cols_a, 4 *wordsize
.equ b, 5 *wordsize
.equ num_rows_b, 6 *wordsize
.equ num_cols_b, 7 *wordsize
.equ C, -1 *wordsize
.equ i, -2 *wordsize
.equ j, -3 *wordsize
.equ k, -4 *wordsize
.equ sum, -5 *wordsize
jmp setuppush

row_col_loop:
cmpl num_cols_a(%ebp), %esi
jge end_row_col_loop
jmp row_col_loop_code

row_col_loop_aik:
movl (%ebx, %ecx, wordsize), %ebx#ebx = a[i]
movl (%ebx, %esi, wordsize), %ebx#ebx = a[i][k]
jmp row_col_loop_sum

epiloguecont:
movl %ebp, %esp
pop %ebp
ret
