extrn   GetStdHandle: proc
extrn   ReadFile: proc
extrn   WriteFile: proc
extrn   ExitProcess: proc

.data?
     string  db  256 dup(?)
     nByte   dd  ?
.code
main proc
    mov     rbp, rsp
    sub     rsp, 40h       

    mov     ecx, -10        ; STD_INPUT_HANDLE
    call    GetStdHandle
    mov     [rbp-8],rax
    mov     ecx, -11
    call    GetStdHandle    ; STD_OUTPUT_HANDLE'
    mov     [rbp-10h],rax

    mov     rcx, [rbp-8]
    mov     rdx, offset string
    mov     r8,  256
    mov     r9, offset nByte
    mov     rbx, 0
    mov     [rsp - 20h], rbx    
    call    ReadFile        ; get input 

    ;write string
    mov     rcx, [rbp-10h]
    mov     rdx, offset string
    mov     r9, offset nByte
    mov     r8, sizeof string ; 
    mov     [rsp - 20h], rbx
    call    WriteFile
    
    mov     ecx, 0
    call    ExitProcess
main endp

end