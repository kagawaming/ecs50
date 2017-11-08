
/*
	void mat_add(int a[][3], int b[][3], int c[][3],
	int num_rows, int num_cols){
		for(i = 0; i < num_rows; ++i){
			for(j = 0; j < num_cols; ++j){
				c[i][j] = a[i][j] + b[i][j];
			}
	}

*/

.global _start

.equ num_cols, 3
.equ num_rows, 2
.equ wordsize, 4 #there are 4 bytes in a word on a 32 bit machine

.data

a:
	.rept num_rows * num_cols
		.long 10
	.endr

b:
	.long 1
	.long 2
	.long 3
	.long 4
	.long 5
	.long 6

c:
	.space num_rows *num_cols * wordsize
	
i:
	.long 0

temp_j:
	.long 0
	
.text

twoD21D: #(int i, int j, int num_cols)
	#ecx is i
	#edx is j
	#1D index will be in eax

	#i * num_cols + j
	
	#signed multiplication: imull src	
	#unsigned multiplication: mull src
	#edx:eax = src * eax
	movl %edx, temp_j #save j becuase it will be overwritten by mult instruction
	movl $num_cols, %eax
	imull %ecx #eax = i * num_cols
	movl temp_j, %edx #restore edx to j
	addl %edx, %eax #eax = i * num_cols + j
ret #go back to where you were called
	
	
_start:
	#eax will be i
	#ebx will be j
	
	#for(i = 0; i < num_rows; ++i)
	movl $0, %eax # i = 0
	
	outer_loop:
		#i < num_rows
		#i - num_rows < 0
		#negation: i - num_rows >= 0
		cmpl $num_rows, %eax
		jge end_outer_loop
		
		#for(j = 0; j < num_cols; ++j)
		movl $0, %ebx #j = 0
		
		inner_loop:
			#j < num_cols
			#j - num_cols < 0
			#neg: j - num_cols >= 0
			cmpl $num_cols, %ebx
			jge end_inner_loop
			
			#c[i][j] = a[i][j] + b[i][j];
			#*(c + i *num_cols + j) = *(a + i *num_cols + j) + 
			#													*(b + i *num_cols + j)
			
			#calculate i *num_cols + j
			movl %eax, %ecx
			movl %ebx, %edx
			movl %eax, i
			call twoD21D
			
			#eax = i *num_cols + j
			
			#c[i][j] = a[i][j] + b[i][j];
			movl a(, %eax, wordsize), %esi #esi = a[i][j]
			addl b(, %eax, wordsize), %esi #esi = a[i][j] + b[i][j]
			movl %esi, c(, %eax, wordsize) #c = a[i][j] + b[i][j]
			
			movl i, %eax #restore eax to being i
			
			
			incl %ebx #++j
			jmp inner_loop #go to next iteration
		end_inner_loop:
		
		incl %eax #++i
		jmp outer_loop #go to next iteration
	end_outer_loop:
	
done:
	movl %eax, %eax
	
