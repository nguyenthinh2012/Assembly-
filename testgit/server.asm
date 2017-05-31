global _start

struc sockaddr_in
    .sin_family resw 1
    .sin_port resw 1
    .sin_addr resd 1
    .sin_zero resq 1
endstruc
fm: equ 2
tcp: equ 0
type_soc: equ 1
%define hton(x) ((x & 0xFF000000) >> 24) | ((x & 0x00FF0000) >>  8) | ((x & 0x0000FF00) <<  8) | ((x & 0x000000FF) << 24)
%define htons(x) ((x >> 8) & 0xFF) | ((x & 0xFF) << 8)
_port equ 2002
INADDR_ANY equ 0
PORT equ htons(_port) 

section .data
fd: dq 0
my_sa istruc sockaddr_in
    at sockaddr_in.sin_family, dw fm
    at sockaddr_in.sin_port, dw PORT
    at sockaddr_in.sin_addr, dd 0x100007F
    at sockaddr_in.sin_zero, dq 0
iend
created: db "Created!"
cLen: equ $ - created
binded: db "Bind done"
bLen: equ $ - binded
blacklog: equ 128
listening: db "Listening"
lLen equ $ - listening
accepted: db "accepted"
aLen equ $ - accepted
error: db "error"
eLen equ $ - error
addL: dq 0
section	.text
_start:
.create:
	mov rax, 41
	mov rdi, 2
	mov rsi, 1
	mov rdx, 0
	syscall
	cmp eax, 0
	jb .create
	mov QWORD [addL], rdx
	mov QWORD [fd], rax
.bind:
	mov rax, 49
	mov rdi, [fd]
	mov rsi, my_sa
	mov rdx, 16
	syscall

.listen:
	mov rax, 50
	mov rdi, [fd]
	mov rsi, blacklog
	syscall
.accept:
	mov rax, 43
	mov rdi, [fd]
	mov rsi, my_sa
	mov rdx, 16
	syscall
	cmp rax, 0
	jl .accept
	mov rax,1 
	mov rdi, 1
	mov rsi, accepted
	mov rdx, aLen
	syscall
_exit: 
	mov eax, 1
	mov ebx, 0
	int 80h


