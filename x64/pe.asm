extrn GetStdHandle   :PROC
extrn CreateFileA    :PROC
extrn SetFilePointer :PROC
extrn GetFileSizeEx  :PROC
extrn ReadFile       :PROC
extrn WriteFile      :PROC
extrn GetConsoleMode :PROC
extrn SetConsoleMode :PROC
extrn ExitProcess    :PROC
extrn GetProcessHeap :PROC
extrn HeapAlloc      :PROC
extrn HeapFree       :PROC
extrn HeapDestroy    :PROC

.data?
	lpFileName	    db	512 dup(?)
    hexStr		    db  22  dup(?)
	lpFileSize	    dq	?
	lpFileData  	dq	?
	hStdIn          dq  ?
    hStdOut         dq  ?
	hFile			dq	?
    nByte           dd  ?	


	
.code
main proc
    mov	  rbp, rsp
    sub	  rsp, 68h	
    
	;get stdio handles
    mov     rcx, -10			; STD_INPUT_HANDLE
    call    GetStdHandle
    mov     hStdIn, rax			; handle input
    mov     rcx, -11			; STD_OUTPUT_HANDLE
    call    GetStdHandle
    mov     hStdOut, rax		; handle output
    xor     r14, r14

	;input file name
	mov		rcx, hStdOut
	mov		rdx,offset sFileName
	mov		r8, sizeof sFileName
	mov		r9, offset nByte
	mov		[rsp+20h],r14
	call	WriteFile
	mov		rcx,hStdIn
	mov		rdx, offset lpFileName
	mov		r8,256
	mov		r9, offset nByte
	mov		[rsp+20h],r14
	call	ReadFile
	; delete		/r/n
	mov		eax,nByte
	sub		eax,2
	mov		rdx, offset lpFileName
	add		rdx, rax
	mov		word ptr[rdx],0
	; open and read file
	mov		rcx,offset lpFileName
	mov		rdx,80000000h					; GENERIC_READ
	mov		r8,1							; FILE_SHARE_READ
	mov		r9,0							; lpSecurityAttributes
	mov     qword ptr [rsp + 20h], 3		; OPEN_EXISTING
	mov     qword ptr [rsp + 28h], 80h		; FILE_ATTRIBUTE_NORMAL
    mov     qword ptr [rsp + 30h], 0		; NULL
	call	CreateFileA
	cmp		rax,-1
	jz		open_failed
	mov		hFile,rax						; save handle

	;  get file size, alloc a buffer[filesize] to read file
	mov		rcx, hFile
	mov		rdx, offset lpFileSize
	call	GetFileSizeEx					; GetFileSizeEx(hFile, &lpFileSize)
	call	GetProcessHeap					; handle heap
	mov		rcx, rax
	mov		rdx, 8
	mov		r8, lpFileSize
	call	HeapAlloc		
	mov		lpFileData, rax
	mov		rcx,hFile
	mov		rdx, lpFileData
	mov		r8, lpFileSize
	mov		r9, offset nByte
	mov     [rsp + 20h], r14
    call    ReadFile
	; check file pe
	mov		rdi, lpFileData
	mov		[rbp-10h],rdi			; save rdi
	movzx	rcx, word ptr[rdi]
	cmp		rcx,5A4DH
	;jnz		isNotPE
    mov     [rbp - 8], rcx          ; save  e_magic
	;IMAGE DOS HEADER
    mov     rdx, offset sDosHeader
    mov     r8, sizeof sDosHeader
	call	write
	
		; e_magic
		mov		rdx,offset sE_magic
		mov		r8,sizeof sE_magic
		call	write
		mov		rcx,[rbp - 8]
		mov		rdx,offset hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		;e_lfanew
		mov		rdx,offset se_lfanew
		mov		r8,sizeof se_lfanew
		call	write
		mov		ecx, dword ptr [rdi+3ch]
		mov		rdx,offset hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
	;IMAGE NT HEADER
	mov		rdx,offset sNtHeader
	mov		r8,sizeof sNtHeader
	call	write
	mov		ecx, dword ptr [rdi+3ch]
	add		rdi,rcx
	mov		[rbp-10h],rdi				; save new rdi
		;Singature
		mov		rdx,offset sSignature
		mov		r8,sizeof sSignature
		call	write
		mov		rdi,[rbp-10h]
		mov		ecx, dword ptr [rdi]
		mov		rdx,offset hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
	add		rdi,4
	mov		[rbp-10h],rdi		; update rdi
	;IMAGE FILE HEADER
	mov		rdx, offset	 sFileHeader
	mov		r8, sizeof  sFileHeader
	call	write
		; numberofsections
		mov		rdx, offset	 sNumberOfSections
		mov		r8, sizeof  sNumberOfSections
		call	write
		movzx	rcx,word ptr [rdi+2]
		mov     [rbp - 18h], rcx
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		;sizeofoptionalheader
		mov		rdx, offset	 sSizeOfOptionalHeader
		mov		r8, sizeof  sSizeOfOptionalHeader
		call	write	
		movzx	rcx,word ptr [rdi+10h]
		mov     [rbp - 20h], rcx
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; sCharacteristics
		mov		rdx, offset	  sCharacteristics
		mov		r8, sizeof   sCharacteristics
		call	write	
		movzx	rcx,word ptr [rdi+12h]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
	add		rdi,14h
	mov		[rbp-10h],rdi		; update rdi	
    ;IMAGE OPTIONAL HEADER
	mov		rdx,offset  sOptionalHeader
	mov		r8, sizeof  sOptionalHeader
	call	write		
		; AddressOfEntryPoint	
		mov		rdx, offset	  sAddressOfEntryPoint
		mov		r8, sizeof   sAddressOfEntryPoint
		call	write	
		mov 	ecx,dword ptr [rdi+10h]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; ImageBase
		mov		rdx, offset	  sImageBase
		mov		r8, sizeof	sImageBase
		call	write	
			; check image  pe32 or pe32+
			mov		r13,1ch
			movzx	rcx,word ptr [rdi]
			cmp		rcx,10bh
			jz		imagebase_pe3
			sub		r13,4
			mov     rcx, qword ptr [rdi + r13]
			add		r13,8
			jmp		continue

			imagebase_pe3:
				    mov     r12, 1			; save value pe32
					mov     ecx, dword ptr [rdi + r13]
					add		r13,4
		continue:
			mov		rdx, offset	hexStr
			call	atoi_hexstr
			mov     word ptr [rsi + rax], 0d0ah
			add     rax,2
			mov		rdx,rsi
			mov		r8,rax
			call	write
		; SectionAlignment
		mov		rdx, offset	  sSectionAlignment
		mov		r8, sizeof	sSectionAlignment
		call	write
		mov 	ecx,dword ptr [rdi+r13]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; FileAlignment
		add		r13,4
		mov		rdx, offset	  sFileAlignment
		mov		r8, sizeof	sFileAlignment
		call	write
		mov 	ecx,dword ptr [rdi+r13]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write

		add     r13, 14h                ;  value SizeOfImage
		; sizeoffimage
		mov		rdx, offset	  sSizeOfImage
		mov		r8, sizeof	sSizeOfImage
		call	write
		mov 	ecx,dword ptr [rdi+r13]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write

		add		r13,0ch
		; Subsystem
		mov		rdx, offset	  sSubsystem
		mov		r8, sizeof	sSubsystem
		call	write
		movzx   rcx,word ptr [rdi+r13]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
	; rdi= point data directory
    mov     rcx, [rbp - 20h]           ; SizeOfOptionalHeader
	mov		[rbp-10h],rdi
    sub     rcx, 80h                   
    add     rdi, rcx                    ; rdx = adrr DataDirectory

	;IMAGE DATA DIRECTORY:
	mov		rdx, offset	  sDataDirectory
	mov		r8, sizeof	sDataDirectory
	call	write
		; Export Directory RVA
		mov		rdx,offset sExportRVA
		mov		r8, sizeof sExportRVA
		call	write
		xor		rcx,rcx 
		mov     ecx,dword ptr [rdi]
		mov     [rbp - 28h],rcx			; save 	wExport Directory RVA
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		 ; Export Directory size
		mov		rdx,offset sExportSize
		mov		r8, sizeof sExportSize
		call	write
		mov     ecx,dword ptr [rdi+4]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; Import  Directory RVA
		mov		rdx,offset sImportRVA
		mov		r8, sizeof sImportRVA
		call	write
		mov     ecx,dword ptr [rdi+8]
		mov     [rbp - 30h],rcx			; save 	import Directory RVA
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; Import Directory Size
		mov		rdx,offset sImportSize
		mov		r8, sizeof sImportSize
		call	write
		mov     ecx,dword ptr [rdi+0ch]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; Relocation Directory RVA
		mov     rdx, offset sRelocationRVA
		mov     r8, sizeof sRelocationRVA
		call    write
		mov     ecx, dword ptr [rdi + 28h]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; Relocation Directory Size
		mov     rdx, offset sRelocationSize
		mov     r8, sizeof sRelocationSize
		call    write
		mov     ecx, dword ptr [rdi + 2ch]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write

		; Debug Directory RVA
		mov     rdx, offset sDebugRVA
		mov     r8, sizeof sDebugRVA
		call    write
		mov     ecx, dword ptr [rdi + 30h]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write

		; Debug Directory Size
		mov     rdx, offset sDebugSize
		mov     r8, sizeof sDebugSize
		call    write
		mov     ecx, dword ptr [rdi + 34h]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; TLS Directory RVA
		mov     rdx, offset sTLSRVA
		mov     r8, sizeof sTLSRVA
		call    write
		mov     ecx, dword ptr [rdi + 48h]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write

		; TLS Directory Size
		mov     rdx, offset sTLSSize
		mov     r8, sizeof sTLSSize
		call    write
		mov     ecx, dword ptr [rdi + 4ch]
		mov		rdx, offset	hexStr
		call	atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write

	mov		rdi,[rbp-10h]		
	add		rdi,[rbp-20h]
	mov		[rbp-10h],rdi		; update rdi
	;IMAGE SECTION HEADER
	mov		rdx,offset sSectionHeader
	mov		r8,sizeof sSectionHeader
	call	write
	mov     rdx, offset sName
	mov     r8, sizeof sName
	call    write

	mov		r13,0
    next1:
	mov		[rbp-10h],rdi		; update rdi
    cmp     r13, [rbp - 18h]            ; cmp with NumberOfSections
    jz      export_directory
	mov     rdx, offset space
	mov     r8, sizeof space
	call    write
		; Name
		mov     rax, qword ptr [rdi]
		mov     rdi, offset hexStr
		stosq
		mov     rax,8
		mov     rsi, offset hexStr
		mov     word ptr [rsi + rax], 0909h
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write
		;Virtual Address   
	   	mov		rdi,[rbp-10h]  
		mov     ecx, dword ptr [rdi + 0ch]
		mov     rdx, offset hexStr
		call    atoi_hexstr
		mov     dword ptr [rsi + rax],  090909h
		add     rax,3
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; Raw ddress
		mov     ecx, dword ptr [rdi + 14h]
		mov     rdx, offset hexStr
		call    atoi_hexstr
		mov     dword ptr [rsi + rax],  090909h
		add     rax,3
		mov		rdx,rsi
		mov		r8,rax
		call	write
		; Characteristics
		mov     ecx, dword ptr [rdi + 24h]
		mov     rdx, offset hexStr
		call    atoi_hexstr
		mov     word ptr [rsi + rax], 0d0ah
		add     rax,2
		mov		rdx,rsi
		mov		r8,rax
		call	write

	add     rdi, 28h
	inc     r13
	jmp     next1

	export_directory:
  

			open_failed:
	isNotPE:
    mov     rdx, offset mIsNotPE
    mov     r8, sizeof mIsNotPE
    call    write	
	jmp		exit
	exit:
    xor     rcx, rcx
    call    ExitProcess

main endp
atoi_hexstr proc
	push	rbp
	mov		rbp,rsp
	sub		rsp,28h
	mov		rax,rcx				; number
	mov		rsi,rdx				; adrress
	mov		r8,16
	add		rsi,18
	mov		[rbp-08h],rsi
	xor		rcx,rcx
	div_loop:
		xor		rdx,rdx
		div		r8
		cmp		edx,0ah
		jl		convert_number
		add		edx,37h
		jmp		conver_alphabet
		convert_number:
			xor		edx,30h
		conver_alphabet:
			mov		byte ptr [rsi],dl
			dec		rsi
			test	rax,rax
			jz		done
			jmp		div_loop
	done:
		mov		rax,[rbp-08h]
		sub		rax,rsi
		inc		rsi

		mov		rsp,rbp
		pop		rbp
		ret
atoi_hexstr endp
write proc
	push	rbp
	mov		rbp, rsp
	push	rdi
	sub		rsp, 30h
	xor		r14, r14

	mov		rcx, hStdOut
    mov     r9, offset nByte
    mov     [rsp + 20h], r14        
    call    WriteFile	

	add		rsp, 30h
	pop		rdi
	pop		rbp
	ret

write endp
.data
	sFileName	            db	"Link PE file: ", 0
	space		            db	"	"
	sErrorOutput            db	"Can't open file",  0Ah, 0Dh, 0
	mIsNotPE				db	"Isn't PE File", 0Ah, 0Dh, 0
	mIsPE					db	"Is PE File", 0Ah, 0Dh, 0
    ; DOS Header
    sDosHeader              db  "[+] Dos Header", 0ah, 0dh
    sE_magic                db  "	e_magic							:"
    sE_lfanew               db  "	e_lfanew						:"
    ; PE header
    sNtHeader               db  0Ah, 0Dh,"[+] NT Header", 0ah, 0dh
    sSignature              db  "	Signature						:"
	; FILE  header			
	sFileHeader				db	0Ah, 0Dh,"	[-] File Header",0ah,0dh
    sNumberOfSections       db  "		NumberOfSections				:"
    sSizeOfOptionalHeader   db  "		SizeOfOptionalHeader				:"
    sCharacteristics        db  "		Characteristics					:"
    ; OPTIONAL_HEADER
	isPE32                  db  0
    sOptionalHeader         db  0Ah, 0Dh,"	[-] Optional Header", 0ah, 0dh
    sAddressOfEntryPoint    db  "		AddressOfEntryPoint				:"
    sImageBase              db  "		ImageBase					:"
    sSectionAlignment       db  "		SectionAlignment				:"
    sFileAlignment          db  "		FileAlignment					:"
    sSizeOfImage            db  "		SizeOfImage					:"
    sSubsystem              db  "		Subsystem					:"
    ; DATA_DIRECTORIES
    sDataDirectory          db  0Ah, 0Dh,"		[*] DataDirectory ", 0Ah, 0dh
    sExportRVA              db  "			Export Directory RVA			:"
    sExportSize             db  "			Export Directory size			:"
    sImportRVA              db  "			Import Directory RVA			:"
    sImportSize             db  "			Import Directory size			:"
    sRelocationRVA          db  "			Relocation Directory RVA		:"
    sRelocationSize         db  "			Relocation Directory size		:"
    sDebugRVA               db  "			Debug Directory RVA			:"
    sDebugSize              db  "			Debug Directory size			:"
    sTLSRVA                 db  "			TLS Directory RVA			:"
    sTLSSize                db  "			TLS Directory size			:"
    ; Section Table
    sSectionHeader          db  0ah, 0dh, "[+] Section Header: ", 0ah, 0dh, 0
    sName                   db  "	Name		Virtual Address		Raw Address		Characteristics", 0Ah, 0Dh

end
