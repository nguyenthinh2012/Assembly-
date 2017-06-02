global _start
struc sockaddr_in
    .sin_family resw 1
    .sin_port resw 1
    .sin_addr resd 1
    .sin_zero resq 1
endstruc
struc mess
	.me resw 1
endstruc
type_soc: equ 1
fm: equ 2
%define hton(x) ((x & 0xFF000000) >> 24) | ((x & 0x00FF0000) >>  8) | ((x & 0x0000FF00) <<  8) | ((x & 0x000000FF) << 24)
%define htons(x) ((x >> 8) & 0xFF) | ((x & 0xFF) << 8)
_port equ 2002
PORT equ htons(_port) 
section .data
my_sa istruc sockaddr_in
    at sockaddr_in.sin_family, dw 2
    at sockaddr_in.sin_port, dw 0x0645
    at sockaddr_in.sin_addr, dd 0x100007F
    at sockaddr_in.sin_zero, dq 0
iend
fd: dq 0
created: db "Created!"
cLen: equ $ - created
connected: db "Connected"
conLen equ $ - connected
mess1: times 100 db 0
len: dq 0
section .text
_start:
.create:
	mov rax, 41
	mov rdi, 2
	mov rsi, 1
	mov rdx, 0
	syscall
	mov QWORD [fd], rax
	cmp rax, 0	
	jl .create
	mov rax, 1
	mov rdi, 1
	mov rsi, created
	mov rdx, cLen
	syscall
.connect:
	mov rax, 42
	mov rdi, [fd]
	mov rsi, my_sa
	mov rdx, 16
	syscall
	cmp rax, 0
	jl .connect
.read: 
	mov rax, 0
	mov rdi, 0
	mov rsi, mess1
	mov rdx, 100
	syscall
	mov qword [len], rax
	xor qword [mess1], 0x421
.send:
	mov rax, 1
	mov rdi, [fd]
	mov rsi, mess1
	mov rdx, [len]
	syscall
.rec:
	mov rax, 0
	mov rdi,[fd]
	mov rsi, mess1
	mov rdx, 100
	syscall
	cmp rax, 0
	jl .rec
	mov QWORD [len], rax
.print:
	mov rax, 1
	mov rdi, 1
	mov rsi, mess1
	mov rdx, [len]
	syscall
_exit:
	mov rax, 60
	mov rbx, 0
	syscall
