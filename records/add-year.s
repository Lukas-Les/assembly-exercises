.include "linux.s"
.include "record-def.s"

.section .data
input_file_name:
	.ascii "records.dat\0"
output_file_name: 
	.ascii "testout.dat\0"
error_msg:
	.ascii "Error\0"
len_error_msg = . - error_msg

.section .bss
.lcomm record_buffer, RECORD_SIZE

#Stack offsets local variables
.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8

.section .text
.globl _start
_start:
	# Copy stack pointer to make room for the variables
	movl %esp, %ebp
	subl $8, %esp
	# Open file for reading
	movl $SYS_OPEN, %eax
	movl $input_file_name, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	# check if return code is a negative number - it means error
	cmpl $0, %eax
	js error_handler
	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

	# Open file for writing
	movl $SYS_OPEN, %eax
	movl $output_file_name, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL

	cmpl $0, %eax
	js error_handler

	movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

loop_begin:
	pushl ST_INPUT_DESCRIPTOR(%ebp)
	pushl $record_buffer
	call read_record
	addl $8, %esp
	# Returns number of bytes read.
	# If it isn't the same number we
	# requested, then it's either an 
	# end-of-file, or an error, so we're
	# quitting.	
	cmpl $RECORD_SIZE, %eax
	jne exit

	# Increment the age
	incl record_buffer + RECORD_AGE

	# Write the record out
	pushl ST_OUTPUT_DESCRIPTOR(%ebp)
	pushl $record_buffer
	call write_record
	addl $8, %esp
	jmp loop_begin

exit:
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
exit_with_err:
	movl $SYS_EXIT, %eax
	movl $1, %ebx
	int $LINUX_SYSCALL
error_handler:
	movl $SYS_WRITE, %eax
	movl $2, %ebx
	movl $error_msg, %ecx
	movl $len_error_msg, %edx
	int $LINUX_SYSCALL
	jmp exit_with_err

