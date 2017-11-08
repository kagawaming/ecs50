.global _start
.data

dvalue:
.long 0

leni:
.long 0

lenj:
.long 0

string1:
.space 100
string2:
.space 100
array:
.rept 1000
.long 0
.endr

.text
strlen:
/*i=ecx,j=edx*/
push %edi
push %ecx
sub %ecx, %ecx
mov $-1,%ecx
sub %al, %al
cld
repne scasb
neg %ecx
sub $1, %ecx
mov %ecx, %eax
pop %ecx
pop %edi
ret

min1v2:
cmp %ebx, %eax
jge min1
ret
min1:
movl %ebx,%eax
ret

mineaxvd:
cmp dvalue,%eax
jge min2
ret
min2:
movl dvalue,%eax
ret

_start:

lea string1, %edi
call strlen
movl %eax, leni/*esi = string len 1, edi = string len 2*/
lea string2, %edi
call strlen
movl %eax, lenj

movl $0, %ecx
/*for (i=0;i<word1_len+1;i++){
  a[i][0]=i;
}
*/
first_loop:
cmpl %ecx, leni
jle end_first_loop
movl lenj, %eax
imull %ecx
movl %ecx, array(,%eax,4)
incl %ecx
jmp first_loop
end_first_loop:

movl $0, %ecx
/*  for (j=0;j<word2_len+1;j++){
    a[0][j]=j;
  }*/
second_loop:
cmpl %ecx, lenj
jle end_second_loop
movl %ecx, array(,%ecx,4)
incl %ecx
jmp second_loop
end_second_loop:
movl $1, %ecx
/*for (i=1;i<word1_len+1;i++){
  for (j=1;j<word2_len+1;j++){
    if(word1[i-1]== word2[j-1]){
      d=a[i-1][j-1];
    }
    else{
      d=a[i-1][j-1]+1;
    }
    a[i][j]=min(min(a[i-1][j]+1,a[i][j-1]+1),d);
  }
}
dist = a[i-1][j-1];*/
outerloop:
cmpl %ecx, leni
jle end_outerloop
movl $1, %edx
innerloop:
cmpl %edx, lenj
jle end_innerloop
movl leni, %esi
movl lenj, %edi
sub $1, %esi
sub $1, %edi
mov string1(,%esi,4),%esi
mov string2(,%edi,4),%edi
sub %esi, %edi
cmpl $0, %edi
jz test1
test2:
movl %ecx, %eax
sub $1, %eax
movl %edx, %ebx
sub $1, %ebx
imull lenj
add %ebx, %eax
movl array(,%eax,4),%eax
add $1, %eax
function:
movl %eax, dvalue
movl %ecx, %eax
sub $1, %eax
imull lenj
add %edx,%eax
movl array(,%eax,4),%eax
add $1, %eax
movl %eax, %ebx
movl %ecx, %eax
imull lenj
add %edx,%eax
sub $1, %eax
movl array(,%eax,4),%eax
add $1, %eax
call min1v2
call mineaxvd
movl %eax, %ebx
movl %ecx, %eax
imull lenj
add %edx,%eax
movl %ebx,array(,%eax,4)
incl %edx
jmp innerloop
test1:
movl %ecx, %eax
sub $1, %eax
movl %edx, %ebx
sub $1, %ebx
imull lenj
add %ebx, %eax
movl array(,%eax,4),%eax
jmp function
end_innerloop:
incl %ecx
jmp outerloop
end_outerloop:
movl %ecx, %eax
sub $1, %eax
movl %edx, %ebx
sub $1, %ebx
imull lenj
add %ebx, %eax
movl array(,%eax,4),%eax
done:
movl %eax, %eax
