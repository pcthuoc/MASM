.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
    string dw 16 dup (0)
    number dd 43
.code

start:
    mov     eax, number
    lea     edi,string
    call    to_string
    push  offset string 
    call StdOut
to_string PROC
    mov ebx,10
    mov ecx,0
    xor ecx,ecx
repeated:
    xor edx, edx
    div ebx
    push dx
    add cl,1
    or  eax,eax
    jnz repeated
load_digits:
    pop ax
    or al,00110000b
    stosb 
    loop load_digits
    mov byte ptr [edi],0
    ret
to_string ENDP
END start