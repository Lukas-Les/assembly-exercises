#!/bin/bash

program_name=$1

as --32 "src/$program_name".s -o "object_files/$program_name.o"
ld -m elf_i386 "object_files/$program_name.o" -o "executables/$program_name"
./executables/"$program_name"
echo $?
