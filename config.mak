prefix=/usr/local
exec_prefix=${prefix}
CONFDIR=${prefix}/var/lib/reaver

CC=gcc
CFLAGS_USER=-Wall -g -O2 -Wno-unused-but-set-variable
LDFLAGS=-lm -lpcap 

