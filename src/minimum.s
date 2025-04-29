# PURPOSE: This program finds minimum value of data_items set.
#
# VALUES: These registers have the following purposes:
#	%edi - Holds the index of the data item being examined
#	%ebx - Lowest data item found
#	%eax - Current data item

.section .data
data_items: #These are the data items
	.long 3,67,34,222,45,75,54,34,44,33,22,11,66
data_size:
	.long 13

.section .text
.globl _start
_start:
	movl $0, %edi # move 0 into the index register
	movl data_items(,%edi,4), %eax # load the first byte of data
	movl %eax, %ebx
start_loop: # start loop
	cmpl data_size, %edi # check to see if we’ve hit the end
	je loop_exit
	incl %edi
	movl data_items(,%edi,4), %eax
	cmpl %eax, %ebx # compare values
	jle start_loop
	movl %eax, %ebx # move the value as the largest
	jmp start_loop
loop_exit:
	movl $1, %eax
	int $0x80

