#include <time.h>
#include <stdlib.h>
/*
A library to hijack a call to time() to generate spoofed system time.
HACKING TIME!

Compile-
gcc -shared -fPIC -Wall -m32 -o time.so time.c
or
gcc -shared -fPIC -Wall -o time.so time.c

ln -s time.so /usr/lib

export LD_PRELOAD=time.so
*/
time_t time(time_t *t){
	//EPOCH time stamp to simulate
	const char* s = getenv("SPOOFTIME");
	int spoof = atoi(s);
	return (time_t)(spoof);
}
