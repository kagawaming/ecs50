
/*
	int rec_sum(int* nums, int len){
		if(len == 0){
			return 0;
		}else{
			return nums[0] + rec_sum(nums+1, len - 1);
		}
	}

*/


.global rec_sum

.equ wordsize, 4

.text 
rec_sum:
	push %ebp
	movl %esp, %ebp
	
	.equ nums, 2*wordsize #(%ebp)
	.equ len, 3*wordsize #(%ebp)
	
	if:
		cmpl $0, len(%ebp)
		jnz else
		movl $0, %eax
		jmp epilogue
	else:
		#return nums[0] + rec_sum(nums+1, len - 1);
		movl len(%ebp), %ecx
		decl %ecx
		push %ecx #len - 1
		movl nums(%ebp), %ecx
		leal wordsize(%ecx), %ecx 
		push %ecx #nums + 1
		call rec_sum
		addl $2*wordsize, %esp #clear args
		movl nums(%ebp), %ecx #ecx = nums
		addl (%ecx), %eax #nums[0] == *nums
	
	epilogue:
		movl %ebp, %esp
		pop %ebp
		ret
		
