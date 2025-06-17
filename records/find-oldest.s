.include "linux.s"
.include "record-def.s"

.section .data
records_file_name:
	.ascii "records.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text

.globl _start
_start:
	.equ ST_INPUT_DESCRIPTOR, -4
	.equ ST_OUTPUT_DESCRIPTOR, -8
	#Copy the stack pointer to %ebp
	movl %esp, %ebp
	#Allocate space to hold the file descriptors
	subl $8, %esp
	#Open the file
	movl $SYS_OPEN, %eax
	movl $records_file_name, %ebx
	movl $0, %ecx #This says to open read-only
	movl $0666, %edx
	int $LINUX_SYSCALL
	#Save file descriptor
	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)
	#Even though it’s a constant, we are
	#saving the output file descriptor in
	#a local variable so that if we later
	#decide that it isn’t always going to
	#be STDOUT, we can change it easily.
	movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)
	# set current largest age to zero
	movl $0, %ecx
record_read_loop:
	pushl %ecx
	pushl ST_INPUT_DESCRIPTOR(%ebp)
	pushl $record_buffer
	call read_record
	addl $8, %esp

	popl %ecx

	#Returns the number of bytes read.
	#If it isn’t the same number we
	#requested, then it’s either an
	#end-of-file, or an error, so we’re
	#quitting
	cmpl $RECORD_SIZE, %eax
	jne finished_reading

	movl RECORD_AGE + record_buffer, %eax
	cmpl %ecx, %eax
	jg greater_age_found
	jmp record_read_loop
greater_age_found:
	movl %eax, %ecx
	jmp record_read_loop
finished_reading:
	movl $SYS_EXIT, %eax
	movl %ecx, %ebx
	int $LINUX_SYSCALL
