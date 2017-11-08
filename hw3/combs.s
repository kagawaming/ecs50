.global get_combs
.equ wordsize, 4
.text
get_combs:
	#prologue
	push %ebp
	movl %esp, %ebp
	subl $4*wordsize, %esp

	# arguments
	.equ items, 	(2*wordsize)
	.equ k, 		(3*wordsize)
	.equ len, 		(4*wordsize)

	# locals
	.equ count,   (-1*wordsize)
	.equ temp,  	(-2*wordsize)
	.equ numOfCombs,  (-3*wordsize)
	.equ result, 	(-4*wordsize)


	# int count = 0;
	movl $0, count(%ebp)

	# int numOfCombs = num_combs(len, k);
	push k(%ebp)
	push len(%ebp)
	call num_combs
	addl $2*wordsize, %esp    # clear argument
	movl %eax, numOfCombs(%ebp) # save result

# int ** temp = malloc(sizeof(int *) * k);
	movl k(%ebp), %esi # esi = k
	shll $2, %esi
	push %esi
	call malloc
	addl $1*wordsize, %esp
	movl %eax, temp(%ebp)


# int ** result = malloc(sizeof(int *) * numOfCombs);
	movl numOfCombs(%ebp), %eax #eax = num_combs
	shll $2, %eax #eax = num_combs * 8
	push %eax
	call malloc
	addl $1*wordsize, %esp #clear argument
	# Save result
	movl %eax, result(%ebp)

# for (int i = 0; i < numOfCombs; i++)
	movl result(%ebp), %ebx
	movl $0, %esi # i = 0
	loop:
		movl k(%ebp), %eax
		shll $2, %eax
		push %eax
		call malloc
		movl k(%ebp), %edi
		movl %eax, (%ebx, %esi, wordsize) # result[i] = malloc(sizeof(int) * k);
		incl %esi
		cmp numOfCombs(%ebp), %esi
	jl loop
# comb(0, 0, len, k, count, temp, result, items);
	push items(%ebp)
	movl result(%ebp), %eax
	push %eax
	push temp(%ebp)
	leal count(%ebp) , %eax
	push %eax
	push k(%ebp)
	push len(%ebp)
	push $0
	push $0
	call comb
	addl $8*wordsize, %esp  #clear arguments

# epilogue
	movl result(%ebp), %eax 	# return saved value
	movl %ebp, %esp
	pop %ebp
	ret

comb:
	# prologue
	push %ebp
	movl %esp, %ebp
	subl $1*wordsize, %esp

	# arguments
	.equ num, 	(2*wordsize) #(%ebp)
	.equ choose, 	(3*wordsize) #(%ebp)
	.equ max, 	(4*wordsize) #(%ebp)
	.equ maxchoose, (5*wordsize) #(%ebp)
	.equ count,   (6*wordsize) #(%ebp)
	.equ new_temp, 	(7*wordsize) #(%ebp)
	.equ result, 	(8*wordsize) #(%ebp)
	.equ new_item, 	(9*wordsize) #(%ebp)

	# locals
	.equ i,  	(-1*wordsize) #(%ebp)

	# if (choose == maxchoose)
	movl maxchoose(%ebp), %esi
	cmpl choose(%ebp), %esi
	jnz continue #if false

# for (i = 0; i < maxchoose; i++)
	movl $0, i(%ebp)
	first_loop:
		movl i(%ebp), %esi
		cmpl maxchoose(%ebp), %esi
		jge end_first_loop

# result[*count][i] = new_temp[i]
# new_temp[i]
		movl new_temp(%ebp), %edx
		movl (%edx,%esi,wordsize), %edx #edx = new_temp[i]

# result[*count]
		movl count(%ebp), %edi
		movl (%edi), %edi # edi = *count
		movl result(%ebp), %eax # eax = **result
		movl (%eax, %edi, wordsize), %eax # result[*count]
		movl %edx, (%eax, %esi, wordsize)  # result[count][i] = new_temp[i]

		incl i(%ebp)
		jmp first_loop

	end_first_loop:
# (*count)++;
	movl count(%ebp), %edi
	movl (%edi), %edi	 	 # edi = *count
	incl %edi 	  		 # count++
	movl count(%ebp), %eax
	movl %edi, (%eax)
	jmp epilogue

	# for (i = num; i < max; i++)
	continue:
		movl num(%ebp), %esi
		movl %esi, i(%ebp) # i = num;
	second_loop:
		movl i(%ebp), %esi
		cmpl max(%ebp), %esi
		jge end_second_loop

		#new_temp[choose] = new_item[i];
		movl new_item(%ebp), %ebx
		movl (%ebx, %esi,wordsize), %edx # edx = new_item[i]
		movl new_temp(%ebp), %eax
		movl choose(%ebp), %edi
		movl %edx, (%eax,%edi,wordsize)

# comb(i + 1, choose + 1, max, maxchoose, count, new_temp, result, new_item);
# *new_item\
# push the argument in reverse order
		push new_item(%ebp)
		movl result(%ebp), %eax
		push %eax
		push new_temp(%ebp)
		push count(%ebp)
		push maxchoose(%ebp)
		push max(%ebp)
		movl choose(%ebp), %eax
		incl %eax
		push %eax
		movl i(%ebp), %esi
		incl %esi
		push %esi

		call comb
		addl $8*wordsize, %esp # clear arguments

		incl i(%ebp) #i++
		jmp second_loop
	end_second_loop:

	epilogue:
		movl result(%ebp), %eax
		movl %ebp, %esp
		pop %ebp
		ret
