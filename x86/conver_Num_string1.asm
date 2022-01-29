.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data	
	strcha	db 100 dup(?)
	strcon	db 10 dup(?)
	index	db 5 dup(?)
	result	db 100 dup(?)
	cnt		dd 0
	clen	dd 0
	bspace	db " ", 0

.code
main PROC
	push	100
	push	offset strcha
	call	StdIn

	push	10
	push	offset strcon
	call	StdIn

	push	offset strcon
	call	strlen
	mov		clen, eax
	push	0
	call	ExitProcess

main ENDP
strlen PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+08h]
	xor		esi, esi
	xor		eax, eax
		
	next_char:
		cmp		byte ptr [ecx+esi], 0
		jz		finished
		inc		esi
		jmp		next_char

	finished:
		mov		eax, esi
		pop		ebp
		ret		4

strlen ENDP

END main