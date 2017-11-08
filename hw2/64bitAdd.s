.global _start

.data

num1:
.space 4
.space 4

num2:
.space 4
.space 4

.text

_start:
  movl (num1),%edx/*move the upper 32 bits of num1 to edx*/
  movl (4+num1),%eax/*move the lowwer 32 bits of num1 to eax*/
  addl num2+4, %eax/*add the lowwer num2 and lowwer num1, and put the sum into eax*/
  jc ad_1/*if the lowwer sum is larger than 32 bits*/
  addl (num2),%edx/*add upper num2 and upper num1, and put the sum into edx*/
  jmp done
  ad_1:/*add one on upper sum*/
  addl $1,%edx
  addl (num2),%edx
done:
  movl %eax, %eax
