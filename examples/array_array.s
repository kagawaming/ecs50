
/*
	void mat_add(int** a, int** b, int** c,
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

arow2:
	.long 1
	.long 2 
	.long 3

a:
	.long arow1
	.long arow2
	
arow1:
	.long 1 
	.long 2 
	.long 3



b:
	.long brow1
	.long brow2
	
	brow1:
		.long 4
		.long 5
		.long 6
	brow2:
		.long 40
		.long 50
		.long 60

c:
	.long crow1
	.long crow2
	
	crow1:
		.space num_cols * 4
	crow2:
		.space num_cols * 4
	
i:
	.long 0

temp_j:
	.long 0
	
.text


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
			#*(*(c + i) + j) = *(*(a + i) + j) + *(*(b + i) + j)
			
			#ecx = a[i][j] 
			movl a(, %eax, wordsize), %ecx #ecx = a[i]
			movl (%ecx, %ebx, wordsize), %ecx #ecx = a[i][j]
			
			#edx = b[i][j]
			movl b(, %eax, wordsize), %edx #edx = b[i]
			movl (%edx, %ebx, wordsize), %edx
			addl %edx, %ecx
			
			#addl (%edx, %ebx, wordsize), %ecx
			
			#ecx = a[i][j] + b[i][j]
			
			#c[i][j] = a[i][j] + b[i][j];
			movl c(, %eax, wordsize), %edx # edx = c[i]
			movl %ecx, (%edx, %ebx, wordsize) 
			
			
			
			incl %ebx #++j
			jmp inner_loop #go to next iteration
		end_inner_loop:
		
		incl %eax #++i
		jmp outer_loop #go to next iteration
	end_outer_loop:
	
done:
	movl %eax, %eax
	
