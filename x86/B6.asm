.386
.model flat,stdcall
option casemap:none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib


.data
	
	string1 db	100 dup(?)



	
.code
    

main proc
	push	100
	push	offset string1
	call StdIn

	
	push	offset string1
	call	re_str

	push	offset	string1
	call	StdOut

	push	0
	call	ExitProcess

main endp
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


		

END main



