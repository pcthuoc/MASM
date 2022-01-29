extrn WriteFile: proc
extrn ExitProcess: proc
extrn GetStdHandle: proc


.data?
    nByte   dd  ?
.data
    msg    db  'dm kho vlin ', 0

.code
main proc
    mov     rbp, rsp
    sub     rsp, 28h            ; reserve 40 bytes of Shadow space

    ; Get the handel for console display monitor I/O streams
    mov     rcx, -11            
    call    GetStdHandle         ;Returns handle in register RAX
    mov     [rbp - 8h], rax     ; Store the handel in memory stack'      


    mov     rcx, [rbp - 8h]     ; Pass the handel as first argument
    mov     rdx, offset msg
    mov     r8, sizeof msg
    mov     r9, offset nByte    ; return value storage location as the forth argument
    mov     [rsp - 20h], r12
    call    WriteFile

    mov     ecx, 0
    call    ExitProcess
main endp
end