.include "linux.s"
.section .bss
.equ BUFFER_SIZE, 200
.lcomm data_buffer, BUFFER_SIZE

.section .data
prompt_msg: .ascii "Enter text: "
prompt_len = . - prompt_msg
received_msg: .ascii "You entered: "
received_len = . - received_msg
newline: .ascii "\n"
newline_len = . - newline

.section .text
.globl _start
_start:
	# print a prompt
	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl $prompt_msg, %ecx
	movl $prompt_len, %edx
	int $LINUX_SYSCALL

	# push arguments
	pushl $BUFFER_SIZE
	pushl $data_buffer
	
	# call function
	call read_std_in

	# clean up stack
	addl $8, %esp

	# process result
	cmpl $0, %eax
	jle _exit

	# print "You entered: " message
	pushl %eax
	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl $received_msg, %ecx
	movl $received_len, %edx
	int $LINUX_SYSCALL
	popl %eax

	# print buffer
	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl $data_buffer, %ecx
	int $LINUX_SYSCALL

_exit:
	movl $SYS_EXIT, %eax
	xorl %ebx, %ebx
	int $LINUX_SYSCALL
