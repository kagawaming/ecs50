.global get_combs

.equ wordsize, 4


get_combs:

  # int* items, int k, int len
  # prologue

  push %ebp
  movl %esp, %ebp
  subl $5 * wordsize, %esp

  .equ items, 2 * wordsize
  .equ k, 3 * wordsize
  .equ len, 4 * wordsize
  .equ data, -1 * wordsize
  .equ i, -2 * wordsize
  .equ combs, -3 * wordsize
  .equ curIndex, -4 * wordsize
  .equ numCombs, -5 * wordsize

  push %ebx
  push %esi
  push %edi

  # malloc for int data[k]
  movl k(%ebp), %ebx
  shll $2, %ebx
  push %ebx
  call malloc
  addl $1 * wordsize, %esp # clear args
  movl %eax, data(%ebp)

  # int curIndex = 0
  movl $0, curIndex(%ebp)

  # int numCombs = num_combs(len, k)
  movl k(%ebp), %ebx
  movl len(%ebp), %edx
  push %ebx
  push %edx
  call num_combs
  addl $2 * wordsize, %esp # clear args from stack
  movl %eax, numCombs(%ebp) # numCombs = num_combs(len, k)


  # combs = malloc(numCombs * sizeof(int*))
  movl numCombs(%ebp), %ebx
  shll $2, %ebx # num_Combs * sizeof(int*)
  push %ebx
  call malloc
  addl $1 * wordsize, %esp # clear args
  movl %eax, combs(%ebp)

  #movl len(%ebp), %edx
  movl k(%ebp), %eax
  # mull %edx
  shll $2, %eax
  push %eax

  movl $0, %ebx

  row_malloc_loop:
    cmpl numCombs(%ebp), %ebx
    jge end_row_malloc_loop

    #push %ebx
    call malloc #malloc() #space allocated by malloc is in %eax

    movl combs(%ebp), %ecx
    movl %eax, (%ecx, %ebx, wordsize)
    movl %ecx, combs(%ebp)
    incl %ebx

    jmp row_malloc_loop

end_row_malloc_loop:

  addl $1*wordsize, %esp

  # findCombs(items, len, data, 0, k, 0, combs, curIndex)

  # curIndex

  movl curIndex(%ebp), %ecx
  push %ecx #curIndex

  # combs
  movl combs(%ebp), %ecx
  leal (%ecx), %ecx
  push %ecx

  # 0
  movl $0, %ecx # ecx = 0
  push %ecx
  # k
  movl k(%ebp), %ecx
  push %ecx

  # 0
  movl $0, %ecx # ecx = 0
  push %ecx

  # data
  movl data(%ebp), %ecx
  leal (%ecx), %ecx
  push %ecx

  # len
  movl len(%ebp), %ecx
  push %ecx

  # items
  movl items(%ebp), %ecx
  leal (%ecx), %ecx
  push %ecx

  call findCombs
  addl $8 * wordsize, %esp #clear the 8 arguments

  movl combs(%ebp), %eax #putting the answer into %eax

  pop %edi
  pop %esi
  pop %ebx

  movl %ebp, %esp
  pop %ebp
  ret


findCombs:
#(int* items, int len, int data[], int index, int k, int i, int** combs, int curIndex)
  # prologue
  push %ebp
  movl %esp, %ebp
  subl $1*wordsize, %esp

  .equ items, 2 * wordsize
  .equ len, 3 * wordsize
  .equ data, 4 * wordsize
  .equ index, 5 * wordsize
  .equ k, 6 * wordsize
  .equ i, 7 * wordsize
  .equ combs, 8 * wordsize
  .equ curIndex, 9 * wordsize
  .equ j, -1 * wordsize

  push %ebx
  push %esi
  push %edi

  #%eax is curIndex
  #if (index == k)
  movl index(%ebp), %ebx #ebx is index
  movl k(%ebp), %edi #edi is k
  cmpl %ebx, %edi #k - index
  jnz if # if (index != k)

  #int j;
  #forloop initialization
  movl $0, %ebx #j = 0 is ebx
  #for (j = 0; j < k; j++)
  for_loop:

    cmpl %edi, %ebx # edi is k, ebx is j
    jge end_for
    movl curIndex(%ebp), %esi
    # combs[*curIndex][j] = data[j];
    movl data(%ebp), %ecx # ecx is data
    movl combs(%ebp), %eax # eax is combs
    movl %eax, %edx
    movl (%ecx, %ebx, wordsize), %ecx # ecx is data[j]
    movl (%eax, %esi, wordsize), %eax # eax is combs[*curIndex]
    movl %ecx, (%eax, %ebx, wordsize) # combs[*curIndex][j] = data[j]
    #movl %edx, combs(%ebp)

    incl %ebx # j++;
    jmp for_loop

  end_for:

    #*curIndex = *curIndex + 1;
    movl curIndex(%ebp), %esi
    incl %esi
    movl %esi, %eax

    pop %edi
    pop %esi
    pop %ebx

    movl %ebp, %esp
    pop %ebp
    #return;
    ret

  # if (index != k)
  if:

    movl len(%ebp), %ecx
    movl i(%ebp), %edx
    cmpl %ecx, %edx # if len <= i
    jge end_if

    # data[index] = items[i]
    movl data(%ebp), %edx # edx is data
    movl index(%ebp), %edi # edi is index
    movl items(%ebp), %ecx # ecx is items
    movl i(%ebp), %ebx # ebx is i
    movl (%ecx, %ebx, wordsize), %ecx # ecx is items[i]
    movl %ecx, (%edx, %edi, wordsize) # data[index] = items[i]
    movl %edx, data(%ebp)

# IT WONT SAVE DATA[index] the second loop for some reason :(

    # findCombs(items, len, data, index + 1, k, i + 1, combs, curIndex);
	# curIndex
    movl curIndex(%ebp), %ecx
    leal (%ecx), %ecx
    push %ecx #push! 1
	# combs
    movl combs(%ebp), %ecx
    leal (%ecx), %ecx
    push %ecx #push! 2
	# i + 1
    movl i(%ebp), %eax # i (but don't want to change i)
    incl %eax
    push %eax #push! 3 (i + 1)
	# k
    movl k(%ebp), %ecx
    push %ecx #push! 4 (k)
	# index + 1
    movl index(%ebp), %eax
    incl %eax
    push %eax  #push! 5 (index + 1)
	# data
    movl data(%ebp), %ecx
    leal (%ecx), %ecx
    push %ecx #push! 6
	# len
    movl len(%ebp), %ecx
    push %ecx #push! 7
	# items
    movl items(%ebp), %ecx
    leal (%ecx), %ecx
    push %ecx #push! 8
    call findCombs
    addl $8 *wordsize, %esp
    movl %eax, curIndex(%ebp)


    # findCombs(items, len, data, index, k, i + 1, combs, curIndex);
	# curIndex
    movl curIndex(%ebp), %ecx
    leal (%ecx), %ecx
    push %ecx
	# combs
    movl combs(%ebp), %ecx
    leal (%ecx), %ecx
    push %ecx
	# i + 1
    movl i(%ebp), %eax
    incl %eax
    push %eax # i + 1
    # k
	  movl k(%ebp), %ecx
    push %ecx
    # index
  	movl index(%ebp), %eax
    push %eax  # index
    # data
	  movl data(%ebp), %ecx
    leal (%ecx), %ecx
    push %ecx
    # len
	  movl len(%ebp), %ecx
    push %ecx
    # items
	  movl items(%ebp), %ecx
    leal (%ecx), %ecx
    push %ecx
    call findCombs
    addl $8 *wordsize, %esp
    movl %eax, curIndex(%ebp)

    movl curIndex(%ebp), %eax

    pop %edi
    pop %esi
    pop %ebx

    movl %ebp, %esp
    pop %ebp
    # return;
    ret

end_if:

    movl curIndex(%ebp), %eax

    pop %edi
    pop %esi
    pop %ebx

    movl %ebp, %esp
    pop %ebp
    ret
