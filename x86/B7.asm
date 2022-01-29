.386
.model flat,stdcall
option casemap:none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib


.data
	n_str	db	50 dup(?)
	x		db	'0',0
	y		db	'1',0
	x3		db	50 dup(?)
	luu		db	50 dup(?)
	arr		db	3000 dup(?)
	sum		db  50 dup(?) 
	kq		dd	0
	len2	dd  4
	nho		dd  0
	n		dd  0
	len		dd	0
	space	db  "  "

	
.code
main proc
	push	30
	push	offset n_str
	call	StdIn

	push	offset n_str
	call	atoi
	mov		n,ebx



	@lap:

		push	len
		push	offset y
		push	offset arr
		call	mem_cpy
	
		push	offset x
		call	re_str

		push	offset luu
		push	offset y
		call	assign

		push	offset y
		call	re_str

		push	offset x
		push	offset y
		call	sum_str

		push	offset x
		push	offset luu
		call	assign

		dec		n
		cmp		n,0
		jz		end1
		jmp		@lap


	end1:








		push	offset arr
		call	StdOut

		






	push	0
	call	ExitProcess

main endp

mem_cpy proc
	push	ebp
	mov		ebp,esp
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	edi
	push	esi
	mov		eax,[ebp+08h]; string_replace  
	mov		ebx,[ebp+0ch]; string_copy
	mov		edi,[ebp+10h];   len_replace
	xor		esi,esi		;   vt_copy
	
	@men_cpy:
		mov		dl,byte ptr [ebx+esi]
		cmp		dl,0
		jz		break

		mov		byte ptr [eax+edi],dl



		inc		edi
		inc		esi
		jmp		@men_cpy

	break:
		mov		byte ptr [eax+edi],20h
		inc		edi
		mov		len,edi
		mov		byte ptr [eax+edi],0
		pop		esi
		pop		edi
		pop		edx
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12
mem_cpy endp
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
atoi proc
	push	ebp
	mov		ebp,esp
	mov		ecx,[ebp+8h]
	xor		edi,edi
	mov		bl,10
	xor		eax,eax
	convert:
		xor		edx,edx
		mov		dl,[ecx+edi]
		cmp		dl,0
		jz		break1
		sub		dl,30h
		imul	bl
		add		eax,edx
		inc		edi
		jmp		convert
	break1:
		xor		ebx,ebx
		mov		ebx,eax
		pop		ebp
	ret		4

atoi endp

sum_str proc
	push	ebp
	mov		ebp,esp
	mov		eax,[ebp+08h];y
	mov		ebx,[ebp+0ch];x
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










