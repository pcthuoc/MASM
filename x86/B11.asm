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
	msg1		db "X : ", 0
	msg2		db "Y : ", 0
	msg3		db "KEY : ",0 
	mode		db 3 dup(?)
	x			db 30 dup(?)
	y			db 30 dup(?)
	key			db 31 dup(?)
	msg			db "1. Cong", 0ah, "2. Tru", 0ah, "3. Nhan", 0ah, "4. Chia", 0
	n			dd 0
	int_x		dd 0
	int_y		dd 0
	sum			dd 0


.code
main PROC
	push	offset msg
	call	StdOut

	push	offset endl
	call	StdOut

	push	3
	push	offset mode
	call	StdIn
	push	offset mode
	call	atoi
	mov		n, eax					

	push	offset msg1
	call	StdOut


	push	30
	push	offset x
	call	StdIn
	push	offset x
	call	atoi
	mov		int_x, eax

	push	offset msg2
	call	StdOut


	push	30
	push	offset y
	call	StdIn
	push	offset y
	call	atoi
	mov		int_y, eax


	mov		edx, n
	cmp		edx, 1					
	jz		@add
	cmp		edx, 2
	jz		@sub
	cmp		edx, 3
	jz		@mul
	cmp		edx, 4
	jz		@div
	jmp		@break

	@add:

		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, int_x					
		mov		ebx, int_y					
		add		eax, ebx
		mov		sum, eax
		jmp		@break

	@sub:

		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, int_x					
		mov		ebx, int_y					
		sub		eax, ebx
		mov		sum, eax
		jmp		@break

	@mul:

		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, int_x					
		mov		ebx, int_y					
		mul		ebx
		mov		sum, eax
		jmp		@break

	@div:

		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, int_x					
		mov		ebx, int_y					
		div		ebx
		mov		sum, eax
		jmp		@break

	@break:	
		push	offset msg3
		call	StdOut
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