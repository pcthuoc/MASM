extrn   GetStdHandle: proc
extrn   ReadFile: proc
extrn   WriteFile: proc
extrn   ExitProcess: proc
extrn   GetProcessHeap: proc
extrn   HeapAlloc: proc
extrn   HeapFree: proc

.data
	input		db		'input:',10,13
	output		db		'output:',10,13
    endl		db		' ',10,13

.data?
	string		db		105	dup(?)
	substring	db		15	dup(?)
	number   	db		3   dup(?)
	array		db		105 dup(?)
	count		dd		?
	nByte		dd		?
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
    ;write string
    mov     rcx, STD_OUTPUT_HANDLE
    mov     rdx, offset input
    mov     r9, offset nByte
    mov     r8, sizeof input ; 
    call    WriteFile
    ;read string
	mov     rcx, STD_INPUT_HANDLE
    mov     rdx, offset string
    mov     r8,  105
    mov     r9, offset nByte
    mov     rbx, 0  
    call    ReadFile  
    ;read substring
	mov     rcx, STD_INPUT_HANDLE
    mov     rdx, offset substring
    mov     r8,  15
    mov     r9, offset nByte
    mov     rbx, 0  
    call    ReadFile 
    ; try 
    mov     rcx,offset string
    mov     rdx,offset substring
    mov     r8, offset array
    call    find
    ;write string
    mov     rcx, STD_OUTPUT_HANDLE
    mov     rdx, offset output
    mov     r9, offset nByte
    mov     r8, sizeof output ; 
    call    WriteFile
    ;check count = 0 end
    cmp     count,0
    jz      finish
    ; dynamic memory allocation; rsi will be saved string
    sub     rsp, 20h            
    call    GetProcessHeap
    mov     rcx, rax            ; GetProcessHeap
    mov     rdx, 8              ; allocated memory  initialized to zero
    mov     r8, 11              ;  number of bytes  allocated
    call    HeapAlloc           
    add     rsp, 20h
    mov     rsi, rax   
    add     rsi, 9 
    mov     [rbp-8],rsi             ; save rdi
    ; print count
    mov     ecx, count
    mov     rdx, [rbp-8]
    call    itoa
    mov     r12w, 0a0dh         
    mov     word ptr [rax + rcx], r12w 
    add     rcx, 2              ; insert /r /n 
    mov     r12, rcx
    mov     rcx,  STD_OUTPUT_HANDLE
    mov     rdx, rax
    mov     r9, offset nByte
    call    WriteFile
    ; print vt
    mov     rdi,offset array
    lapx:
        xor     rcx,rcx
        mov     ecx,dword ptr [rdi]
        mov     rdx, [rbp-8]
        call    itoa
        mov     r12w, 20h     
        mov     word ptr [rax + rcx], r12w
        add     rcx, 2             
        mov     r12, rcx
        mov     rcx,  STD_OUTPUT_HANDLE
        mov     rdx, rax
        mov     r9, offset nByte
        call    WriteFile
        add     rdi,4
        dec     count 
        cmp     count,0
        jz      finish
        jmp     lapx
    finish:
    mov     ecx, 0
    call    ExitProcess
main endp
find proc
    push    rbp
    mov     rbp,rsp

    mov     rdi,rcx     ;string
    mov     rsi,rdx     ;substring
    mov     rax,r8      ; array
    xor     rcx,rcx     ; count
    xor     rdx,rdx
    mov     r8,rdi                  ; save rdi
    lap0:
        mov     dl, byte ptr[rdi]       ; string[i]
        mov     dh, byte ptr[rsi]       ; substring[i]
        inc     rdi
        cmp     dl,0dh  
        jz      done
        cmp     dl,dh
        jz      check
        jmp     lap0
    check:
        dec     rdi
        xor     rbx,rbx
        compare:
            mov     dl, byte ptr[rdi+rbx]       ; string[i]
            mov     dh, byte ptr[rsi+rbx]       ; substring[i]
            cmp     dh,0dh
            jz      endcompare
            cmp     dl,dh
            jnz     endcheck
            inc     rbx
            jmp     compare
        endcompare:
            push    rdi
            sub     rdi,r8
            mov     dword ptr [rax+rcx*4],edi
            inc     rcx
            pop     rdi
        endcheck:   
            inc     rdi
            jmp     lap0
    done:
        mov     count,ecx    ; mov count 
        mov     rsp,rbp
        pop     rbp
        ret      
find endp
itoa proc   
    push    rbp    
    mov     rbp, rsp
         
    mov     rax,rcx         ; int = eax
    mov     rsi,rdx         ; adrr =rsi
    mov     r12,rsi         ; save rsi
    mov     r8d, 10
    
    lap1:
        xor     edx, edx
        div     r8d
        add     dl, 30h
        mov     byte ptr [rsi], dl
        dec     rsi
        cmp     eax,0
        jz      done
        jmp     lap1
    done:
        sub     r12, rsi         ; strlen
        mov     rcx, r12        ; adrr string
        inc     rsi
        mov     rax, rsi
        mov     rsp, rbp
        pop     rbp
        ret   
itoa endp
end