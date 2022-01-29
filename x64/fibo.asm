extrn   GetStdHandle: proc
extrn   ReadFile: proc
extrn   WriteFile: proc
extrn   ExitProcess: proc
extrn   GetProcessHeap: proc
extrn   HeapAlloc: proc
extrn   HeapFree: proc

.data
    sSize       db      'Nhap  n: ', 0

    y 			db		'1',98 dup('0')
    x 			db		    99 dup('0')
    n1          db      '0 '
    n2          db      '0 1 '
    nho         dd      0
.data?
	string				db		100 dup(?)
    number				db		100 dup(?)
    nSize               dd  ?
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
        mov     rdx, offset string
        mov     r8,  256
        mov     r9, offset nByte
        mov     rbx, 0  
        call    ReadFile        ; get input 

        mov     rcx,offset string
        call    atoi
        cmp     rbx,0           ; check string empy 
        jz      ReadSize
        mov     r12,rax
    ; check n=0
        cmp     r12,0
        jnz     next0
        jmp     finish
    next0:
    ; check n=1
        cmp     r12,1
        jnz     next1
    mov     rcx, STD_OUTPUT_HANDLE
    mov     rdx, offset n1
    mov     r9, offset nByte
    mov     r8, sizeof n1 ; 
    call    WriteFile
    jmp     finish
    next1:
    ;check n=2
    mov     rcx, STD_OUTPUT_HANDLE
    mov     rdx, offset n2
    mov     r9, offset nByte
    mov     r8, sizeof n2 ; 
    call    WriteFile
    
    sub     r12,2
    test    r12,r12
    jz      finish
    lap0:
            mov     rcx,offset x
            mov     rdx,offset y
            mov     r8,offset number
            call    sum


            mov     r8, rcx
            mov     rcx,  STD_OUTPUT_HANDLE
            mov     rdx,  rax
            mov     r9, offset nByte
            call    WriteFile

            dec     r12
            cmp     r12,0
            jz      finish
            jmp     lap0




    finish:
    mov     ecx, 0
    call    ExitProcess


main endp
sum  proc
    push    rbp
    mov     rbp,rsp
    mov     rax,rcx ; x
    mov     rbx,rdx ;y
    mov     rsi,r8
    add     rsi,60
    mov     byte ptr [rsi],20h
    dec     rsi
    xor     rdi,rdi

    calc:
        xor     rdx,rdx
        mov     dl,byte ptr [rbx+rdi]
        mov     dh,byte ptr [rax+rdi]

        mov     byte ptr [rax+rdi],dl
        sub     dl,30h
        sub     dh,30h
        add     dl,dh
        add     edx,nho
        mov     nho,0
        cmp     dl,0
        jz      donex
        cmp     dl,10
        jc      not_mind
        mov     nho,1
        sub     dl,10
        not_mind:
            add     dl,30h
            mov     byte ptr [rsi],dl
            mov     byte ptr [rbx+rdi],dl
            dec     rsi
        inc     rdi
        jmp     calc
     donex:
        mov     rcx,rdi
        inc     rcx
        inc     rsi
        mov     rax, rsi
        mov     rsp, rbp
        pop     rbp
        ret 
sum  endp
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

end
	

