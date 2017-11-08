.global _start

.equ longsize, 4
.equ wordsize, 2


.data

string1:
	.space 100

len1:
	.long 0

string2:
  .space 100

len2:
	.long 0

i:
  .long 1

j:
	.long 12

k:
  .space 4

l:
  .long 2

char1:
  .space 1


curDist:
  .space 404

oldDist:
  .space 404

.text
_start:

movl $0, %eax
jmp while_not_end

cont_outer_loop:
        movl $0, %edi
        movl %eax, curDist(,%edi,longsize) #curDist[0] = i;
        movl $1, %ebx #j = 1
		jmp inner_loop

eaxlen2_cont:
incl %ebx
movl $0, %eax
jmp fill_stuff


secondIncl:
  incl %esi
  incl %ebx
  movl %esi , curDist(, %ebx, longsize)#if oldDist[j-1] is the lowest
  incl %ebx
  jmp inner_loop


while_not_end:
  cmpb $0, string1(%eax)
  jz end_while
  jmp while_not_end1

end_while1:
  movl %eax, len1
  movl $0, %eax
  jmp end_while1_cont

end_while:
  jmp end_while1

while_not_end1:
  incl %eax
  jmp while_not_end

setupouter_cont:
        cmpl %edx, %eax #i < word1_len + 1
        jge end_outer_loop
		jmp cont_outer_loop

end_while1_cont:
  jmp while_no_end

    end_outer_loop:
    movl len2, %ebx
    movl oldDist(, %ebx, longsize), %eax #dist = oldDist[word2_len]
    jmp done

end_inner_loop:

        jmp swap
        jmp outer_loop


while_no_end:
  cmpb $0, string2(%eax)
  jz end_while2
  incl %eax
  jmp while_no_end


eaxlen2:
  movl %eax, len2
  movl len2, %ebx
  jmp eaxlen2_cont

end_while2:
  jmp eaxlen2

curDistoldDist:
  movl %eax, curDist(, %eax, longsize)
  movl %eax, oldDist(, %eax, longsize)
  jmp curDistoldDist_cont

  fill_stuff:
    cmpl %ebx, %eax
    jge done_stuff
    jmp curDistoldDist


  curDistoldDist_cont:
    incl %eax
    jmp fill_stuff

moveinner:
  movb string1(,%eax,), %cl
  movb %cl, char1
  movb string2(,%ebx,), %ch
  jmp inclinner


setupinner:
  movl len2, %edi
  incl %edi
  jmp compareinner

setupouter:
   movl len1 , %edx
   incl %edx
   jmp setupouter_cont

done_stuff:
movl $1, %eax #i = 1;
jmp outer_loop

outer_loop:

		jmp setupouter















inner_loop:
            jmp setupinner



compareinner:
            cmpl %edi, %ebx #j < word2_len + 1
            jge end_inner_loop
            jmp continueinner

continueinner:
  jmp declex

declex:
  decl %eax
  decl %ebx
  jmp moveinner






inclinner:
            incl %eax
            incl %ebx
			jmp endinner



endinner:
            cmpb char1, %ch #if(word1[i - 1] == word2[j - 1]) FIXME
            jz equal #if it checks through the above statement
            jne elsestatement #if it checks through the above statement


swapmove:
  movl %eax, i
  movl %ebx, j
  movl $0, %eax
  jmp swap_loop

swap:
  jmp swapmove




  swap_loop:
    jmp swap_loop_setup

swap_loop_compare:
    cmpl %edi, %eax
    jge end_swap_loop
    jmp swap_loop_cont

swap_loop_cont:
    movl %eax, k
	jmp swap_loop_movls


	swap_loop_movls:
    movl oldDist(, %eax, longsize), %esi
	jmp swap_loop_movls_curDist

swap_loop_movls_curDist:
    movl curDist(, %eax, longsize), %edi
	jmp swap_loop_movls_edi

swap_loop_movls_edi:
    movl %edi, oldDist(, %eax, longsize)
	jmp swap_loop_movls_esi

swap_loop_movls_esi:
    movl %esi, curDist(, %eax, longsize)
	jmp swap_loop_incl_eax

swap_loop_incl_eax:
    incl %eax
    jmp swap_loop

  end_swap_loop:
  movl i, %eax
  movl j, %ebx
  incl %eax

  jmp outer_loop

equal:
  jmp equalp1

  equalp1:
  decl %ebx
  movl oldDist(,%ebx,longsize), %esi
  jmp equalp2

equalp2:
  incl %ebx
  movl %esi , curDist(,%ebx,longsize)
  incl %ebx
  jmp inner_loop
  #curDist[j] = oldDist[j - 1] + 1

secondMinIfSetup:
  decl %ebx
  movl curDist(, %ebx , longsize), %esi
  jmp secondMinIfComp

firstMinIf2:
  cmpl oldDist(, %ebx, longsize) , %esi  #oldDist[j] < oldDist[j - 1])
  jg firstMinIfAddition #if oldDist[j] is the lowest

  decl %ebx
  movl oldDist(, %ebx, longsize), %esi
  incl %esi
  incl %ebx

  movl %esi, curDist(, %ebx, longsize)#if oldDist[j-1] is the lowest
  incl %ebx
  jmp inner_loop

elsestatement: #else statement
  movl oldDist(, %ebx, longsize), %esi
  decl %ebx
  cmpl %esi , curDist(, %ebx, longsize)
  incl %ebx
  jge firstMinIf  #oldDist[j] < curDist[j-1]
  jl secondMinIf  #curDist[j-1] < oldDist[j]

secondMinIncl:
  incl %esi
  incl %ebx
  movl %esi, curDist(, %ebx, longsize)
  incl %ebx
  jmp inner_loop

swap_loop_setup:
      movl len1, %edi
    incl %edi
	jmp swap_loop_compare


firstMinIf: #oldDist[j] < curDist[j-1]
  jmp firstMinIf1

  firstMinIf1:
  decl %ebx
  movl oldDist(, %ebx , longsize), %esi
  incl %ebx
  jmp firstMinIf2



firstMinIfAddition: #if oldDist[j] is the lowest
  movl oldDist(, %ebx, longsize), %esi
  incl %esi
  movl %esi, curDist(, %ebx, longsize)
  incl %ebx
  jmp inner_loop
  #curDist[j] = oldDist[j] + 1

secondMinIf: #if curDist[j-1] < oldDist[j]
  jmp secondMinIfSetup




secondMinIfComp:
  cmpl %esi , oldDist(, %ebx  , longsize) #curDist[j-1] < oldDist[j-1]
  incl %ebx
  jg secondMinIfAddition #if curDist[j-1] is the lowest
  jmp secondMinIfCont


secondMinIfCont:
  decl %ebx
  movl oldDist(, %ebx, longsize), %esi
  jmp secondIncl


secondMinIfAddition: #if curDist[j-1] is the lowest
  decl %ebx
  movl curDist(, %ebx, longsize), %esi
  jmp secondMinIncl



done:
  movl %eax, %eax
