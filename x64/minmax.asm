extrn   GetStdHandle: proc
extrn   ReadFile: proc
extrn   WriteFile: proc
extrn   ExitProcess: proc
extrn   GetProcessHeap: proc
extrn   HeapAlloc: proc
extrn   HeapFree: proc

.data
    sSize    db  'Nhap kich thuoc mang n: ', 0
    Arr      db  'Nhap n phan tu cua mang: ', 0
.data?
	string				db		1000 dup(?)
    array				db		100 dup(?)
    SizeArr             dd      100 dup(?)
    nSizeArr            dd  ?
    min                 dd  ?
    max                 dd  ?
    nByte				dd  ?
	STD_INPUT_HANDLE	dq	1 dup(?)
	STD_OUTPUT_HANDLE	dq	1 dup(?)

.code
main proc
	mov		rbp,rsp
	sub		rsp,48h

	mov     ecx, -10        ; STD_INPUT_HANDLE
    call    GetStdHandle
    mov     STD_INPUT_HANDLE,rax
    mov     ecx, -11
    call    GetStdHandle    ; STD_OUTPUT_HANDLE'
    mov     STD_OUTPUT_HANDLE,rax

    ;write string
    mov     rcx, STD_OUTPUT_HANDLE
    mov     rdx, offset sSize
    mov     r9, offset nByte
    mov     r8, sizeof sSize ; 
    call    WriteFile
    ;read size
    ReadSize:
	mov     rcx, STD_INPUT_HANDLE
    mov     rdx, offset SizeArr
    mov     r8,  256
    mov     r9, offset nByte
    mov     rbx, 0  
    call    ReadFile        ; get input 

    mov     rcx,offset SizeArr
    call    atoi
    cmp     rbx,0           ; check string empy 
    jz      ReadSize
    mov     nSizeArr,eax

    ;write string
    mov     rcx, STD_OUTPUT_HANDLE
    mov     rdx, offset Arr
    mov     r9, offset nByte
    mov     r8, sizeof Arr ; 
    call    WriteFile
    xor     r13,r13

    ;read arrr
    GetArr:
    	mov     rcx, STD_INPUT_HANDLE
        mov     rdx, offset string
        mov     r8,  1000
        mov     r9, offset nByte
        mov     rbx, 0   
        call    ReadFile        ; get input 
       
        mov     rcx,offset string
        mov     r12,offset array
    SaveValue:
        call    atoi
        cmp     rbx,0           ; check string empy 
        jz      GetArr
        mov     dword ptr [r12+r13*4],eax
        inc     r13
        cmp     nSizeArr,r13d
        jz      DoneRead
        cmp     byte ptr[rcx],0dh
        jz      GetArr
        jmp     SaveValue
    DoneRead:
        mov     rcx,offset array
        mov     edx,nSizeArr
        call    find
    ;print min
    mov     ecx, min
    call    itoa
    mov     r8w, 0a0dh         
    mov     word ptr [rax + rcx], r8w 
    add     rcx, 2              ; insert /r /n 
    mov     r8, rcx
    mov     rcx,  STD_OUTPUT_HANDLE
    mov     rdx, rax
    mov     r9, offset nByte
    call    WriteFile
    ;print min  max
    mov     ecx, max
    call    itoa
    mov     r8w, 0a0dh          
    mov     word ptr [rax + rcx], r8w  ; insert /r /n 
    add     rcx, 2            
    mov     r8, rcx
    mov     rcx,  STD_OUTPUT_HANDLE
    mov     rdx, rax
    mov     r9, offset nByte
    call    WriteFile

    mov     ecx, 0
    call    ExitProcess


main endp
find proc
    push    rbp
    mov     rbp,rsp
    sub     rsp,20h
    mov     eax,dword ptr[rcx]
    mov     [rbp-8],eax; min=eax
    mov     [rbp-0ch],eax;min=ebx
    add     rcx,4
    dec     rdx

    lap2:
        mov     eax,dword ptr[rcx]
    ;compare
        cmp     [rbp-8],eax     ; if min<eax =>> next
        jl      next1
        mov     [rbp-8],eax
    next1:
        cmp     [rbp-0ch],eax   ; if max>eax ==>> next
        jg      next2
        mov     [rbp-0ch],eax
    next2:
        add     rcx,4
        dec     rdx
        cmp     rdx,0
        jz      done
        jmp     lap2
    done:
        mov     eax,[rbp-8]
        mov     min,eax
        mov     eax,[rbp-0ch]
        mov     max,eax
        mov     rsp,rbp
        pop     rbp
        ret
    
find endp
atoi proc; convert string to int , rcx= string 
    push    rbp
    mov     rbp,rsp
    
    push    rdi
    push    rsi
    push    rdx
    mov     rdi,rcx
    mov     rbx,10
    xor     rax,rax
    lap0:           ; skip  value space and string empty
        xor     rdx,rdx
        mov     dl,byte ptr[rdi]
        cmp     dl,13
        jz      end1
        cmp     dl,20h
        jnz      lap1
        inc     rdi
        jmp     lap0
    end1:
        mov     rbx,0
        jmp     done
    lap1:
        xor     rdx,rdx
        mov     dl,byte ptr[rdi]        ; check endl
        cmp     dl,0dh
        jz      done
        inc     rdi                    
        cmp     byte ptr[rdi-1],20h     ; if string [i-1]!=" "  coutinue atoi 
        jnz     next
        cmp     byte ptr[rdi],20h       ; if string [i]==" "   loop until  0<<string[i] <=9
        jz      lap1
        jmp     done
    next:
        push    rdx
        imul    rbx
        pop     rdx
        sub     dl,30h
        add     rax,rdx
        jmp     lap1
    done:
        mov     rcx,rdi                 ; mov arr string
        pop     rdx
        pop     rdi
        pop     rsi
        mov     rsp,rbp
        pop     rbp
        ret     

atoi endp  
itoa proc   
    push    rbp    
    mov     rbp, rsp
    mov     r12,rcx         ; mov int =r12
    
    ; dynamic memory allocation
    sub     rsp, 20h            
    call    GetProcessHeap
    mov     rcx, rax            ; GetProcessHeap
    mov     rdx, 8              ; allocated memory  initialized to zero
    mov     r8, 11              ;  number of bytes  allocated
    call    HeapAlloc           
    add     rsp, 20h
    mov     rsi, rax            
    add     rsi, 9             
    mov     rax,r12            
    mov     r12, rsi            
    mov     r8d, 10
    
    lapx:
        xor     edx, edx
        div     r8d
        add     dl, 30h
        mov     [rsi], dl
        dec     rsi
        cmp     eax,0
        jz      done
        jmp     lapx

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
	

