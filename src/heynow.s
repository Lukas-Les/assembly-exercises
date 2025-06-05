.section .data
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

.equ LINUX_SYSCALL, 0x80

filename:
.ascii "heynow.txt\0"

content:
.ascii "whats up\0"

content_len:
.int . - content - 1

.section .text

.globl _start

_start:

# create or open file
movl $SYS_OPEN, %eax
movl $filename, %ebx
movl $01101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL
# returns a file descriptor to %eax
# push it to the stack
pushl %eax

# write to a file
movl $SYS_WRITE, %eax
# take file descriptor from the stack and put it to %ebx
movl (%esp), %ebx
movl $content, %ecx
movl content_len, %edx
int $LINUX_SYSCALL

# close file
movl $SYS_CLOSE, %eax
movl %esp, %ebx
int $LINUX_SYSCALL

# exit
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
