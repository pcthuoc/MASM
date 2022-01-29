.386
.model flat,stdcall
option casemap:none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib


.data
	n_str	db	50 dup(?)
	x1		db	50 dup(?)

	sum_odd	 db  "0",0
	sum_even db  "0",0

	x		db	50 dup(?),0
	n		dd	0
	len 	dd  0
	nho		dd  0
	l_x		dd  0
	l_sum		dd  0
	space	db  "  "

	
.code
main proc
	push	30
	push	offset n_str
	call	StdIn

	push	offset n_str
	call	atoi
	mov		n,ebx

	

	@scan:
		
		push	30
		push	offset x
		call	StdIn
	
	

		push	offset x
		call	strlen
		mov		l_x,ebx

		push	l_x
		push	offset x
		call	check

		cmp		dl,0
		jz		@even
		
		push	offset x
		call	re_str

		push	offset sum_odd
		call	re_str

		push	offset x
		push	offset sum_odd
		call	sum_str




		jmp     @next@
	  @even:
		push	offset x
		call	re_str

		push	offset sum_even
		call	re_str

		push	offset x
		push	offset sum_even
		call	sum_str

	   @next@:
		dec		n
		cmp		n,0
		jz		@break
		jmp		@scan

	@break:

	push	offset sum_odd
	call	StdOut

	push	offset space
	call	StdOut

	push	offset sum_even
	call	StdOut





		




	push	0
	call	ExitProcess

main endp
check proc
	push	ebp
	mov		ebp,esp
	push	eax
	push	ebx
	push	ecx

	push	edi
	push	esi
	mov		eax,[ebp+08h]
	mov		edi,[ebp+0ch]
	sub		edi,1
	xor		edx,edx
	mov		dl,byte ptr [eax+edi]

	sub		dl,30h
	and		dl,1
		
		pop		esi
		pop		edi

		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		8
		



check endp

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
		mov		byte ptr [eax+esi],0
		mov		ebx,esi
		pop		ebp
		ret		4

strlen endp
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
END main



