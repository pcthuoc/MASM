extrn WriteFile: proc
extrn ReadFile: proc
extrn ExitProcess: proc
extrn GetStdHandle: proc
extrn GetProcessHeap: proc
extrn HeapAlloc: proc
.data
    sSize    db  'Nhap kich thuoc mang n: ', 0
    Arr      db  'Nhap n phan tu cua mang: ', 0
    MinArr   db  'Min: ', 0
    MaxArr   db  'Max: ', 0
.data?
	string				db		1000 dup(?)
    array				db		100 dup(?)
    SizeArr             dd      100 dup(?)
    nSizeArr            dd  ?
    min                 dd  30
    max                 dd  ?
    nByte				dd  ?
	STD_INPUT_HANDLE	dq	1 dup(?)
	STD_OUTPUT_HANDLE	dq	1 dup(?)

.code
main proc
	mov		rbp,rsp
	sub		rsp,40h

	mov     ecx, -10        ; STD_INPUT_HANDLE
    call    GetStdHandle
    mov     STD_INPUT_HANDLE,rax
    mov     ecx, -11
    call    GetStdHandle    ; STD_OUTPUT_HANDLE'
    mov     STD_OUTPUT_HANDLE,rax

    mov     ecx, 2345
    call    itoa
    mov     r8w, 0a0dh          ; little-endian
    mov     word ptr [rax + rcx], r8w 
    add     rcx, 2              ; insert /r /n 
    mov     r8, rcx
    mov     rcx,  STD_OUTPUT_HANDLE
    mov     rdx, rax
    mov     r9, offset nByte
    call    WriteFile

    mov     ecx, 2345
    call    itoa
    mov     r8w, 0a0dh          ; little-endian
    mov     word ptr [rax + rcx], r8w 
    add     rcx, 2              ; appended /r /n 
    mov     r8, rcx
    mov     rcx,  STD_OUTPUT_HANDLE
    mov     rdx, rax
    mov     r9, offset nByte
    call    WriteFile
    mov     ecx, 0
    call    ExitProcess


main endp 
itoa proc   ; int to ascii, return strlen in rcx, pointer in rax
    push    rbp    
    mov     rbp, rsp
    push    rcx
    
    ; dynamic memory allocation
    sub     rsp, 20h            ; shadow space 
    call    GetProcessHeap
    mov     rcx, rax
    mov     rdx, 8
    mov     r8, 11
    call    HeapAlloc           ; HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, 10) 
    add     rsp, 20h
    mov     rdi, rax            
    add     rdi, 9              ; rdi = *(str + 9)
    pop     rax                 ; pop int to rax
    mov     r10, rdi            ; save rdi
    mov     r8d, 10
    
    lapx:
    xor     edx, edx
    div     r8d
    or      dl, 30h
    mov     [rdi], dl
    dec     rdi
    test    eax, eax
    jz      done
    jmp     lapx

    done:
    sub     r10, rdi
    mov     rcx, r10
    inc     rdi
    mov     rax, rdi
    mov     rsp, rbp
    pop     rbp
    ret   
itoa endp
end
	

