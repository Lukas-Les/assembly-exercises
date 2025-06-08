### run write records:

as --32 write-records.s -o write-records.o
as --32 write-record.s -o write-record.o
ld -m elf_i386 write-records.o write-record.o -o write-records
./write-records


### run read records

as --32 read-record.s -o read-record.o
as --32 count-chars.s -o count-chars.o
as --32 write-newline.s -o write-newline.o
as --32 read-records.s -o read-records.o
ld -m elf_i386 read-record.o count-chars.o write-newline.o read-records.o -o read-records
./read-records 


### run add-year
as --32 add-year.s -o add-year.o
ld -m elf_i386 add-year.o read-record.o write-record.o -o add-year
./add-year


### run write-records-loop
as --32 write-records-loop.s -o write-records-loop.o
ld -m elf_i386 write-record.o write-records-loop.o -o write-records-loop
