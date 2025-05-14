#!/bin/bash

program_name=$1
run_after=${2:-false}

as --32 -g "src/$program_name".s -o "object_files/$program_name.o"
ld -m elf_i386 "object_files/$program_name.o" -o "executables/$program_name"

if [ "$run_after" = true ]; then
	./executables/"$program_name"
	echo $?
fi

