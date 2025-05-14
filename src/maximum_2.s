#TASK:
# Convert the maximum program given in the Section called Finding a Maximum
# Value in Chapter 3 so that it is a function which takes a pointer to several values
# and returns their maximum. Write a program that calls maximum with 3
# different lists, and returns the result of the last one as the program’s exit status
# code
.section .data
data_items_1: 
	.long 1,67,34,222,45,75,54,34,44,33,22,11,65,0
data_items_2: 
	.long 2,67,34,224,45,75,54,34,44,33,22,11,66,0
data_items_3: 
	.long 3,67,34,226,45,75,54,34,44,33,22,11,67,0
.section .text
.globl _start
_start:
	pushl $data_items_1
	call maximum
	addl $4, %esp
	pushl %ebx

	pushl $data_items_2
	call maximum
	addl $4, %esp
	pushl %ebx

	pushl $data_items_3
	call maximum
	addl $4, %esp
	pushl %ebx

	popl %ebx
	# %ebx is the status code for the exit system call
	# and it already has the maximum number
	movl $1, %eax
	int $0x80

#PURPOSE: This function takes a pointer to an data item, and finds the maximum value
#PARAMETERS: 
#	0: address of the begging of the data item
#REGISTERS USED:
#	%ecx: holds data item staring position address
#	%edi: holds cursor position
#	%eax: current data item
#	%ebx: current maximum value
.type maximum, @function
maximum:
	pushl %ebp # push old base pointer to stack
	movl %esp, %ebp # make a new base pointer from the stack pointer

	movl $0, %edi
	movl 8(%ebp), %ecx # moving first (and only) parameter to %ecx
	
	movl (%ecx,%edi,4), %eax # load the first byte of the data
	movl %eax, %ebx

start_function_loop:
	cmpl $0, %eax # check to see if we hit the end
	je end_maximum 

	incl %edi
	movl (%ecx,%edi,4), %eax
	cmpl %ebx, %eax
	jle start_function_loop 
	movl %eax, %ebx
	jmp start_function_loop 

end_maximum:
	movl %ebp, %esp #restore the stack pointer
	popl %ebp #restore the base pointer
	ret
