.include "linux.s"
.include "record-def.s"

.section .data
record1:
	.ascii "Fredrick\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "Bartlett\0"
	.rept 31 #Padding to 40 bytes
	.byte 0
	.endr
	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209 #Padding to 240 bytes
	.byte 0
	.endr
	.long 45
	.ascii "m\0"
	.rept 2
	.byte 0
	.endr

file_name:
	.ascii "records.dat\0"
.equ ST_FILE_DESCRIPTOR, -4
.equ RECORDS_TOTAL, 30
.section .text
.globl _start
_start:
	pushl %ebp
	#Copy the stack pointer to %ebp
	movl %esp, %ebp
	#Allocate space to hold the file descriptor
	subl $4, %esp
	#Open the file
	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
	movl $0101, %ecx #This says to create if it
	#doesn’t exist, and open for
	#writing
	movl $0666, %edx
	int $LINUX_SYSCALL
	#Store the file descriptor away
	movl %eax, ST_FILE_DESCRIPTOR(%ebp)
	#start the count
	movl $0, %ecx
start_write_loop:
	cmpl $RECORDS_TOTAL - 1, %ecx
	jge write_loop_exit
	# Save counter
	pushl %ecx
	#Write the first record
	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record1
	call write_record
	addl $8, %esp
	popl %ecx

	incl %ecx
	# Restore counter

	jmp start_write_loop
write_loop_exit:
#Close the file descriptor
movl $SYS_CLOSE, %eax
movl ST_FILE_DESCRIPTOR(%ebp), %ebx
int $LINUX_SYSCALL
#Exit the program
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
