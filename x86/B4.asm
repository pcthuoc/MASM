.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	space		db 20, 0
	endl		db 0ah, 0dh, 0
	mode		db 3 dup(?)
	x			db 30 dup(?)
	y			db 30 dup(?)
	key			db 31 dup(?)
	n			dd 0
	int_x		dd 0
	int_y		dd 0
	sum			dd 0


.code
main PROC
				




	push	30
	push	offset x
	call	StdIn
	push	offset x
	call	atoi
	mov		int_x, eax




	push	30
	push	offset y
	call	StdIn
	push	offset y
	call	atoi
	mov		int_y, eax





		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, int_x					
		mov		ebx, int_y					
		add		eax, ebx
		mov		sum, eax

	

		push	sum
		push	offset key
		call	itoa
		push	offset key
		call	StdOut

		push	0
		call	ExitProcess

main ENDP

atoi PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ebp+08h]
	xor		esi, esi
	xor		eax, eax
	mov		ecx, 10

	@mul:
		xor		edx, edx
		mov		dl, byte ptr [ebx+esi]
		cmp		dl, 0
		jz		@done
		sub		dl, 30h
		add		eax, edx
		mul		ecx
		inc		esi
		jmp		@mul

	@done:
		div		ecx
		pop		ebx
		pop		ebp
		ret		4

atoi ENDP

itoa PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]
	mov		ebx, [ebp+08h]
	xor		esi, esi
	mov		ecx, 10
	push	0h

	@div:
		xor		edx, edx
		div		ecx
		or		edx, 30h
		push	edx
		cmp		eax, 0
		jz		@pop
		jmp		@div

	@pop:
		xor		edx, edx
		pop		edx
		cmp		dl, 0h
		jz		@done
		mov		byte ptr [ebx+esi], dl
		inc		esi
		jmp		@pop

	@done:
		mov		byte ptr [ebx+esi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP
END main