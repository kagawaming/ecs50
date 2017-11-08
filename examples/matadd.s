
/*int** matsum(int** a, int** b, int num_rows, int num_cols);
{
	int** c = malloc(num_rows * sizeof(int*));
	for(int i = 0; i < num_rows; ++i){
		c[i] = malloc(num_cols *sizeof(int));
		for(j = 0; j < num_cols; ++j){
			c[i][j] = a[i][j] + b[i][j]
		}
	}
	return c;
}
*/

.global matsum
.equ wordsize, 4

.text

matsum:
	#esp + 16: num_cols
	#esp + 12: num_rows
	#esp + 8: b
	#esp + 4: a
	#esp: ret addr
	
	#prologue
	push %ebp
	movl %esp, %ebp
	
	#args:
	.equ a, 2*wordsize  #(%ebp)
	.equ b, 3*wordsize #(%ebp)
	.equ num_rows, 4*wordsize #(%ebp)
	.equ num_cols, 5*wordsize #(%ebp)
	
	#make space for locals
	subl $3 *wordsize, %esp
	#locals
	.equ i, -1*wordsize #(%ebp)
	.equ j, -2*wordsize #(%ebp)
	.equ c, -3*wordsize #(%ebp)
	#eax is c
	push %ebx
	push %esi
	
	#c = malloc(num_rows * sizeof(int*));
	movl num_rows(%ebp), %eax #eax = num_rows
	shll $2, %eax # eax = num_rows * sizeof(int*)
	push %eax
	call malloc
	addl $1*wordsize, %esp #remove arg from stack
	
	#ecx is i
	movl $0 , %ecx #i = 0
	
	#for(int i = 0; i < num_rows; ++i){
	outer_loop:
		#i < num_rows
		#i - num_rows < 0
		#neg: i - num_rows >=0
		cmpl num_rows(%ebp), %ecx
		jge end_outer_loop
		
		#c[i] = malloc(num_cols *sizeof(int));
		movl num_cols(%ebp), %ebx #ebx = num_cols
		shll $2, %ebx #ebx = num_cols *sizeof(int)
		push %ebx #prepped call to malloc
		movl %eax, c(%ebp) #save c
		movl %ecx, i(%ebp) #save i
		call malloc
		addl $1*wordsize, %esp #clear arg to malloc
		
		movl i(%ebp), %ecx #restore i
		movl c(%ebp), %ebx #ebx = c
		movl %eax, (%ebx, %ecx, wordsize) #c[i] = malloc(num_cols *sizeof(int));
		
		#for(j = 0; j < num_cols; ++j){
		#edx is j
		movl $0, %edx
		inner_for_loop:
			cmpl num_cols(%ebp), %edx
			jge end_inner_for_loop
		
			#c[i][j] = a[i][j] + b[i][j]
			#esi = a[i][j]
			movl a(%ebp), %esi
			movl (%esi, %ecx, wordsize), %esi
			movl (%esi, %edx, wordsize), %esi
			
			#c[i][j] = a[i][j];
			movl %esi, (%eax, %edx, wordsize)
			
			#esi = b[i][j]
			movl b(%ebp), %esi
			movl (%esi, %ecx, wordsize), %esi
			movl (%esi, %edx, wordsize), %esi
		
			#c[i][j] = a[i][j];
			addl %esi, (%eax, %edx, wordsize)
		
		incl %edx
		jmp inner_for_loop
		end_inner_for_loop:
		
		movl c(%ebp), %eax
		incl %ecx
		jmp outer_loop
	end_outer_loop:
	
	
	epilogue:
		pop %esi
		pop %ebx
		movl %ebp, %esp
		pop %ebp
		ret
	
	
