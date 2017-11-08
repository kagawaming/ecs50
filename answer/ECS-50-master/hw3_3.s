.global get_combs

.equ wordsize, 4


get_combs:

  #int* items, int k, int len
  # prologue

  push %ebp
  movl %esp, %ebp
  subl $5 * wordsize, %esp

  .equ items, 2 * wordsize
  .equ k, 3 * wordsize
  .equ len, 4 * wordsize
  .equ dat, -1 * wordsize
  .equ i, -2 * wordsize
  .equ combs, -3 * wordsize
  .equ curIndex, -4 * wordsize
  .equ numCombs, -5 * wordsize

  push %ebx
  push %esi
  push %edi

  #malloc for int dat[k]
  movl k(%ebp), %ebx
  shll $2, %ebx
  push %ebx
  call malloc
  addl $1 * wordsize, %esp # clear args
  movl %eax, dat(%ebp)

  # int curIndex = 0
  movl $0, curIndex(%ebp)

  # int numCombs = num_combs(len, k)
  movl k(%ebp), %ebx
  movl len(%ebp), %ecx
  push %ebx
  push %ecx
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

  #movl len(%ebp), %ecx
  movl k(%ebp), %eax
  # mull %ecx
  shll $2, %eax
  push %eax

  movl $0, %ebx

  row_malloc_loop:
    cmpl numCombs(%ebp), %ebx
    jge end_row_malloc_loop

    #push %ebx
    call malloc #malloc() #space allocated by malloc is in %eax

    movl combs(%ebp), %edx
    movl %eax, (%edx, %ebx, wordsize)
    movl %edx, combs(%ebp)
    incl %ebx

    jmp row_malloc_loop

end_row_malloc_loop:

  addl $1*wordsize, %esp

  #findCombs(items, len, dat, 0, k, 0, combs, curIndex)

  #curIndex

  movl curIndex(%ebp), %edx
  push %edx #curIndex

  #combs
  movl combs(%ebp), %edx
  leal (%edx), %edx
  push %edx

  #0
  movl $0, %edx # edx = 0
  push %edx
  #k
  movl k(%ebp), %edx
  push %edx

  #0
  movl $0, %edx # edx = 0
  push %edx

  #dat
  movl dat(%ebp), %edx
  leal (%edx), %edx
  push %edx

  #len
  movl len(%ebp), %edx
  push %edx

  #items
  movl items(%ebp), %edx
  leal (%edx), %edx
  push %edx

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
  .equ dat, 4 * wordsize
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
  jnz if_statement # if (index != k)

  #int j;
  #forloop initialization
  movl $0, %ebx #j = 0 is ebx
  #for (j = 0; j < k; j++)
  for_loop:

    cmpl %edi, %ebx # edi is k, ebx is j
    jge end_for
    movl curIndex(%ebp), %esi
    # combs[*curIndex][j] = dat[j];
    movl dat(%ebp), %edx # edx is dat
    movl combs(%ebp), %eax # eax is combs
    movl %eax, %ecx
    movl (%edx, %ebx, wordsize), %edx # edx is dat[j]
    movl (%eax, %esi, wordsize), %eax # eax is combs[*curIndex]
    movl %edx, (%eax, %ebx, wordsize) # combs[*curIndex][j] = dat[j]
    #movl %ecx, combs(%ebp)

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

  #if (index != k)
  if_statement:

    movl len(%ebp), %edx
    movl i(%ebp), %ecx
    cmpl %edx, %ecx # if len <= i
    jge end_if_statement

    #dat[index] = items[i]
    movl dat(%ebp), %ecx # ecx is dat
    movl index(%ebp), %edi # edi is index
    movl items(%ebp), %edx # edx is items
    movl i(%ebp), %ebx # ebx is i
    movl (%edx, %ebx, wordsize), %edx #edx is items[i]
    movl %edx, (%ecx, %edi, wordsize)# dat[index] = items[i]
    movl %ecx, dat(%ebp)

#IT WONT SAVE DAT[index] the second loop for some reason :(

    # findCombs(items, len, dat, index + 1, k, i + 1, combs, curIndex);
	#curIndex
    movl curIndex(%ebp), %edx
    leal (%edx), %edx
    push %edx #push! 1
	#combs
    movl combs(%ebp), %edx
    leal (%edx), %edx
    push %edx #push! 2
	#i + 1
    movl i(%ebp), %eax # i (but don't want to change i)
    incl %eax
    push %eax #push! 3 (i + 1)
	#k
    movl k(%ebp), %edx
    push %edx #push! 4 (k)
	#index + 1
    movl index(%ebp), %eax
    incl %eax
    push %eax  #push! 5 (index + 1)
	#dat
    movl dat(%ebp), %edx
    leal (%edx), %edx
    push %edx #push! 6
	#len
    movl len(%ebp), %edx
    push %edx #push! 7
	#items
    movl items(%ebp), %edx
    leal (%edx), %edx
    push %edx #push! 8
    call findCombs
    addl $8 *wordsize, %esp
    movl %eax, curIndex(%ebp)


    # findCombs(items, len, dat, index, k, i + 1, combs, curIndex);
	#curIndex
    movl curIndex(%ebp), %edx
    leal (%edx), %edx
    push %edx
	#combs
    movl combs(%ebp), %edx
    leal (%edx), %edx
    push %edx
	#i + 1
    movl i(%ebp), %eax
    incl %eax
    push %eax # i + 1
    #k
	  movl k(%ebp), %edx
    push %edx
    #index
  	movl index(%ebp), %eax
    push %eax  # index
    #dat
	  movl dat(%ebp), %edx
    leal (%edx), %edx
    push %edx
    #len
	  movl len(%ebp), %edx
    push %edx
    #items
	  movl items(%ebp), %edx
    leal (%edx), %edx
    push %edx
    call findCombs
    addl $8 *wordsize, %esp
    movl %eax, curIndex(%ebp)

    movl curIndex(%ebp), %eax

    pop %edi
    pop %esi
    pop %ebx

    movl %ebp, %esp
    pop %ebp
    #return;
    ret

end_if_statement:

    movl curIndex(%ebp), %eax

    pop %edi
    pop %esi
    pop %ebx

    movl %ebp, %esp
    pop %ebp
    #return;
    ret
