.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data

    msg  db 50 dup(0),0
    msg1 db	50 dup(0) 

.code
_main PROC
        mov  esi, OFFSET msg
        mov  edi, OFFSET msg1
        mov  ecx, SIZEOF msg
    L1:
        mov  al,[esi]
        cmp  al,'a'
        jl   nochange
        xor  al,00100000b
    nochange:
        mov  [edi],al           
        inc  esi                
        inc  edi
        loop L1
    

_main ENDP
start:
;     input
    push 50
    push offset msg
    call StdIn

;       try

    call _main
    push offset msg1
;       output
    call StdOut
    push    0
    call    ExitProcess     ; exit 
END start