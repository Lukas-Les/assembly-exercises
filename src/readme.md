## run printf-example
as -g --32 printf-example.s -o printf-example.o
ld -m elf_i386 printf-example.o -o printf-example -lc
-dynamic-linker /lib/ld-linux.so.2
