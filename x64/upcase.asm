extrn   GetStdHandle: proc
extrn   ReadFile: proc
extrn   WriteFile: proc
extrn   ExitProcess: proc

.data?
     string  db  256 dup(?)
     nByte   dd  ?
	STD_INPUT_HANDLE	dq	1 dup(?)
	STD_OUTPUT_HANDLE	dq	1 dup(?)
.code
main proc
    mov     rbp, rsp
    sub     rsp, 40h       

    mov     ecx, -10        ; STD_INPUT_HANDLE
    call    GetStdHandle
    mov     STD_INPUT_HANDLE,rax
    mov     ecx, -11
    call    GetStdHandle    ; STD_OUTPUT_HANDLE'
    mov     STD_OUTPUT_HANDLE,rax

    mov     rcx, STD_INPUT_HANDLE
    mov     rdx, offset string
    mov     r8,  256
    mov     r9, offset nByte
    mov     rbx, 0
    mov     [rsp - 20h], rbx    
    call    ReadFile        ; get input 
	
	mov		rcx,offset string
	call	upcase
    ;write string
    mov     rcx, STD_OUTPUT_HANDLE
    mov     rdx, offset string
    mov     r9, offset nByte
    mov     r8, rax ; 
    mov     [rsp - 20h], rbx
    call    WriteFile
    
    mov     ecx, 0
    call    ExitProcess
main endp
upcase proc
	push	rbp
	mov		rbp,rsp
	push	rdi
	push	rsi
	mov		rsi,rcx
	xor		r8,r8
	iter:
		mov		dl,byte ptr [rsi+r8]
		cmp		dl,0dh
		jz		done
		inc		r8
		cmp		dl,97
		jl		iter
		cmp		dl,122
		jg		iter
		dec		r8
		sub		dl,32
		mov		byte ptr [rsi+r8],dl
		inc		r8
		jmp		iter
	done:
		mov		rax,r8
		pop		rsi
		pop		rdi
		mov		rsp,rbp
		pop		rbp
		ret
upcase endp
end


