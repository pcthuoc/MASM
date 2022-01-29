.386
.model flat,stdcall
option casemap:none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib


.data
	
	string1 db	100 dup(?)
    string2 db	10 dup(?)
	index	db  5 dup(?)
	result	db  100 dup(?)
	dem		dd	0
	len1	dd	0
	len2	dd	0

	
.code
    

main proc

	push    100
	push    offset string1	
	call    StdIn
    push    10
	push    offset string2
	call    StdIn


	push	offset string2
	call	strlen
	mov		len1,eax



	push	offset	string1
	push	offset	string2
	call	find_str
	
	push	offset result
	call	StdOut

    
	push    0
    call    ExitProcess   
    
main ENDP
find_str proc	
	push	ebp
	mov		ebp,esp	
	push	eax
	push	ebx
	mov		eax,[ebp+08h]
	mov		ebx,[ebp+0ch]
	xor		esi,esi
	
	find_char:
		xor		edx,edx
		xor		edi,edi
		mov		dl,byte ptr [ebx+esi]
		mov		dh,byte	ptr [eax+0h]
		cmp		dl,0
		jz		done_find
		cmp		dl,dh
		jz		cmp_inc
		inc		esi
		jmp		find_char
	cmp_inc:
		xor		edx,edx
		mov		dl,byte ptr [eax+edi]
		cmp		dl,0
		jz		pop_vt
		mov		dh,byte ptr	[ebx+esi]
		cmp		dh,dl
		jnz		find_char
		inc		edi
		inc		esi
		jmp		cmp_inc
	pop_vt:
		sub		esi,len1
		push	esi
		push	offset index
		call	itoa
		add		esi,len1
		push	offset index
		push	offset result
		push	dem
		call	cout
		jmp		find_char
	done_find:
		pop		eax
		pop		ebx
		pop		ebp
		ret		8

find_str endp

cout proc
	push	ebp
	mov		ebp,esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+10h]
	mov		ebx, [ebp+0Ch]
	mov		ecx, [ebp+08h]
	xor		edi, edi
	for_cout:
		xor		edx, edx
		mov		dl, byte ptr [eax+edi]
		cmp		dl, 0
		jz		done_cout
		mov		byte ptr [ebx+ecx], dl
		inc		edi
		inc		ecx
		jmp		for_cout

	done_cout:
		mov		byte ptr [ebx+ecx], 20h
		inc		ecx
		mov		byte ptr [ebx+ecx], 0
		mov		dem, ecx
		xor		edi, edi
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12
cout endp


strlen PROC
	push	ebp
	mov		ebp,esp
	mov		ecx,[ebp+08h]
	xor		esi,esi
	xor		eax,eax

	count_char:
		cmp	byte ptr [ecx+esi],0
		jz finished
		inc esi
		jmp count_char

	finished:
		mov eax,esi
		pop ebp
		ret 4
strlen	endp
itoa proc
	push	ebp
	mov		ebp,esp
	push	eax
	push	ebx
	mov		eax,[ebp+0ch]
	mov		ebx,[ebp+08h]
	mov		ecx,10
	xor		edi,edi
	push	69h

	convert:
		xor		edx,edx
		div		ecx
		or		edx,30h
		push	edx
		cmp		eax,0
		jz		luu
		jmp		convert
	luu:
		pop		edx
		cmp		dl,69h
		jz		break
		mov		byte ptr [ebx+edi],dl
		inc		edi
		jmp		luu
	break:
		mov	byte ptr [ebx+edi],0
		pop	eax
		pop	ebx
		pop	ebp
		ret	8
itoa endp



END main



