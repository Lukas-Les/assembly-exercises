.include "linux.s"  # Contains SYS_READ, STDIN, LINUX_SYSCALL, SYS_EXIT

.section .text
.globl read_std_in
# This function reads from STDIN and writes to a given buffer.
# It expects two parameters on the stack:
# 1. Count/Size of the buffer (pushed first by caller)
# 2. Address of the buffer (pushed second by caller, so it's closer to %ebp)
#
# Calling convention (cdecl like):
#   pushl buffer_size
#   pushl buffer_address
#   call read_std_in
#   addl $8, %esp      ; Caller cleans up stack
#
# Returns:
#   %eax: Number of bytes read, or a negative value on error.
read_std_in:
    pushl %ebp
    movl %esp, %ebp

    # Parameters are on the stack relative to %ebp:
    # %ebp+4  -> return address
    # %ebp+8  -> first parameter (buffer_address in our convention above)
    # %ebp+12 -> second parameter (buffer_size in our convention above)

    movl $SYS_READ, %eax
    movl $STDIN, %ebx       # File descriptor for stdin
    movl 8(%ebp), %ecx      # Parameter 1: Buffer address
    movl 12(%ebp), %edx     # Parameter 2: Count of bytes to read (buffer size)
    int $LINUX_SYSCALL      # eax will hold bytes read or error

    # The number of bytes read (or error) is already in %eax,
    # which is the standard way to return a value.

    movl %ebp, %esp         # Restore stack pointer
    popl %ebp               # Restore base pointer
    ret
