global _start
struc sockaddr_in
    .sin_family resw 1
    .sin_port resw 1
    .sin_addr resd 1
    .sin_zero resq 1
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
    at sockaddr_in.sin_port, dw PORT
    at sockaddr_in.sin_addr, dd 0x100007F
    at sockaddr_in.sin_zero, dq 0
fd: dq 0
created: db "Created!"
cLen: equ $ - created
connected: db "Connected"
conLen equ $ - connected
section .text
_start:
.create:
	mov rax, 41
	mov rsi, 2
	mov rdi, 1
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
	mov rsi, [fd]
	mov rdi, my_sa
	mov rdx, 16
	syscall
