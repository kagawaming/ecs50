/*
This program is to do the mutiplication of matrices  a and b together,
and to return the result of it.
*/
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
push %ebx
push %esi
push %edi
/* c = malloc(num_rows * sizeof(int*));*/
movl num_rows_a(%ebp), %eax
shll $2, %eax
push %eax
call malloc
addl $1*wordsize, %esp
movl %eax, c(%ebp)

movl $0, %ecx
movl num_cols_b(%ebp), %ebx
shll $2, %ebx
push %ebx
/*
 for ( i = 0; i < num_rows_a; i++)
*/
outterloop:
cmpl num_rows_a(%ebp), %ecx
jge end_outterloop
movl %ecx, i(%ebp)
call malloc
movl c(%ebp), %edx
movl i(%ebp), %ecx
movl %eax, (%edx, %ecx, wordsize) /*c[i] = malloc(num_cols *sizeof(int));*/
movl %edx, %eax
movl $0, %edx
/*
for(j = 0; j < num_cols_b; j++){
*/
midloop:
cmpl num_cols_b(%ebp), %edx
jge end_midloop
movl $0, %edi
movl $0, %esi
/*for(k = 0; k < num_cols_a; k++){*/
innerloop:
cmpl num_cols_a(%ebp), %esi
jge end_innerloop
movl a(%ebp), %ebx
movl (%ebx, %ecx, wordsize), %ebx
movl (%ebx, %esi, wordsize), %ebx
movl %ebx, sum(%ebp) /*sum = a[i][k]*/
movl b(%ebp), %eax
movl (%eax, %esi, wordsize), %eax
movl (%eax, %edx, wordsize), %eax
movl %edx, j(%ebp)
mull sum(%ebp) /* edx:eax = sum * eax; sum = sum + b[k][j]* a[i][k]*/
addl %eax, %edi
movl j(%ebp), %edx
incl %esi/*k++*/
jmp innerloop

end_innerloop:
movl c(%ebp), %eax
movl (%eax, %ecx, wordsize), %ebx /*ebx = c[i]*/
movl %edi, (%ebx, %edx, wordsize)/*ebx = c[i][k] = total sum*/
incl %edx
jmp midloop

end_midloop:
incl %ecx/*j++*/
jmp outterloop

end_outterloop:
addl $1*wordsize, %esp/*i++*/
jmp epilogue

epilogue:
pop %esi
pop %ebx
pop %edi
movl %ebp, %esp
pop %ebp
ret
