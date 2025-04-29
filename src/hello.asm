section .data
    hello: db 'Hello, World!', 0

section .text
    global _start

_start:
    ; Write hello to stdout
    mov eax, 4            ; System call for write
    mov ebx, 1            ; File descriptor 1 is stdout
    mov ecx, hello        ; Address of string to output
    mov edx, 13           ; Length of string
    int 0x80              ; Call kernel

    ; Exit program
    mov eax, 1            ; System call for exit
    mov ebx, 0            ; Exit code 0
    int 0x80              ; Call kernel
