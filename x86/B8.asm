.386
.model flat,stdcall
option casemap:none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib


.data
	x1		db	50 dup(?)
	x2		db	50 dup(?)
	x3		db	50 dup(?)
	luu		db	50 dup(?)
	indec	db	50 dup(?)
	sum		db  50 dup(?) 
	kq		dd	0
	len2	dd  0
	nho		dd  0
	space	db  "  "

	
.code
main proc
	push	30
	push	offset x1
	call	StdIn

	push	30
	push	offset x2
	call	StdIn
	
	push	offset x1
	call	re_str

	push	offset luu
	push	offset x2
	call	assign

	push	offset x2
	call	re_str

	push	offset x1
	push	offset x2
	call	sum_str

	push	offset x1
	push	offset luu
	call	assign

	push	offset x1
	call	StdOut

	push	offset space
	call	StdOut

	push	offset x2
	call	StdOut

	push	0
	call	ExitProcess

main endp
assign proc
	push	ebp
	mov		ebp,esp
	push	ecx
	mov		eax,[ebp+08h]
	mov		ebx,[ebp+0ch]
	xor		esi,esi

	@assign:
		mov		dl,	byte ptr [eax+esi]
		
		cmp		dl,0
		jz		finished1
		mov		byte ptr [ebx+esi],dl
		inc		esi
		jmp		@assign
	finished1:
		mov		byte ptr [ebx+esi],0
		pop		ecx
		pop		ebp
		ret		8
assign  endp
sum_str proc
	push	ebp
	mov		ebp,esp
	mov		eax,[ebp+08h];x2
	mov		ebx,[ebp+0ch];x1
	xor		edi,edi
	xor		esi,esi
	xor		ecx,ecx;nho
	push	69h
	@push_sum:
		xor		edx,edx
		mov		dl,byte ptr [eax+edi]

		cmp		dl,30h
		jns		continue1
		mov		dl,30h
	   continue1:

		mov		dh,byte ptr [ebx+edi]

		


		cmp		dh,30h
		jns		continue2
		mov		dh,30h
	   continue2:
		
		sub		dl,30h
		sub		dh,30h
		add		dl,dh
		add		dl,cl
		mov		ecx,0

		cmp		dl,0
		jz		@pop_sum



		cmp		dl,10
		jc		no_mind
		mov		ecx,1
		sub		dl,10
		no_mind:
			add		dl,30h
			push	edx
		inc		edi
		jmp		@push_sum

	@pop_sum:
		xor		edx,edx
		pop		edx
		cmp		dl,69h
		jz		break1
		mov		byte ptr [eax+esi],dl
		inc		esi
		jmp		@pop_sum

	break1:
		mov		byte ptr [eax+esi],0
		pop		ebp
		ret		8



sum_str endp
re_str proc
	push	ebp
	mov		ebp,esp
	mov		eax,[ebp+08h]
	xor		edi,edi
	xor		esi,esi

	push	69h	
	@push_re:
		xor		edx,edx
		mov		dl,byte ptr [eax+edi]
		cmp		dl,0
		jz		@pop_re
		push	edx
		inc		edi
		jmp		@push_re
	@pop_re:
		xor		edx,edx
		pop		edx
		cmp		dl,69h
		jz		break

		mov		byte ptr [eax+esi],dl
		inc		esi
		jmp		@pop_re
	break:
		mov		byte ptr [eax+esi],0
		pop		ebp
		ret		4
		
		
re_str endp


strlen proc
	push	ebp
	mov		ebp,esp
	mov		eax,[ebp+08h]
	xor		ebx,ebx
	xor		esi,esi

	count_char:
		cmp		byte ptr [eax+esi],0
		jz		finished
		inc		esi
		jmp		count_char
	finished:
		mov		ebx,esi
		pop		ebp
		ret		4

strlen endp
END main










