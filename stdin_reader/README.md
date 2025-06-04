This program reads stdin and writes to stdout
to run this:
as --32 read_stdin.s -o read_stdin.o
as --32 main.s -o main.o 
ld -m elf_i386 main.o read_std_in.o -o run 
./run
