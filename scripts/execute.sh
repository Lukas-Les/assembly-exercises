#!/bin/bash

program_name=$1

as "src/$program_name".s -o "object_files/$program_name.o"
ld "object_files/$program_name.o" -o "executables/$program_name"
./executables/"$program_name"
