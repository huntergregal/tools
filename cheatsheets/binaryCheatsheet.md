
## Binary CheatSheet
* Install gdb-peda
```
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit
```
* gdb + peda usefull commands
```
info file //entry point address and moar; useful if the .exe is stripped (file bad.exe) to find entrypoint
file binary.exe //select file to debug
run //runs selected file in debugger
run < payload.txt //use a file's contents as an argument to the binary
continue //continue to next break point or input/end of program
step //steps INTO next instruction; this means is will follow "call" instructions
next //Move to next instruction; will NOT follow "call" instructions

break main //break main function
break *main+0x8 //break main function at offset

x *0xffffff //check address value
x $ebp //check register value & address
x $ebp+0x7 //check register + offset value & address
telescope 25 //view 25 lines of the stack, addresses and values

pattern create 64 //create pattern of 64 byptes
pattern offset AAAAA //find offset

set follow-fork-mode child //next line...
catch fork //Debug forked processes

EXTRA:
[Enter] will run last command used in gdb
Most commands can be shortened by using their first letter only
```
* Generate overflow payload in binary
```
perl -e 'print "A"x32 . "\xef\xfe\xad\xde"' > payload //load into binary as argument using gdb: run < payload

OR

python -c 'print "A"*32 + "\xef\xfe\xad\xde"' > payload
```
* Run x32 binaries on x64 OS (debian-based linux)
	* Note: This will make your system a multiarch system; If any packages are not found, remove those ones from the install command
```
dpkg --add-architecture i386
apt-get update
apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 libx32gcc-4.8-dev libc6-dev-i386
```
* Disable ASLR protection
```
echo 0 > /proc/sys/kernel/randomize_va_space
```
* GCC compile options:
```
-z execstack //allows stack execution
-fno-stack-protector //removes smash protections
-g //enables debug symbols
-m32 //compile for x32
-o //output file

gcc -z -fno-stack-protector -m32 code.c -o binary.exe
```
