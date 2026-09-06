;----------------------------------------------
; EX16.asm - Lendo os registros CS:IP dado ao
; programa
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

	.model small

	.stack 100h

	.data

	.code
MAIN 	PROC

    ;Pega o valor de CS
    mov ax,cs
    mov dx,ax
    ;Imprime o valor de CS
    mov al,dh
    call print_hexa
    mov al,dl
    call print_hexa  

    mov al,':'
    call print_char

    ;pega o valor de IP
    call pegar_ip
    mov dx,ax
    ;Imprime o valor de IP
    mov al,dh
    call print_hexa
    mov al,dl
    call print_hexa  

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h       

pegar_ip:
    pop ax
    push ax
    ret 

;----------------------------------------------
; print_hexa - Imprime o valor hexadecimal
; presente em AL
;----------------------------------------------
print_hexa:
    push ax
    push cx

    push ax
    mov cl,4
    ror al,cl 
    call corrige_hexa
    pop ax
    call corrige_hexa
    
    pop cx
    pop ax
    ret

corrige_hexa:
    and al,0fh
    add al,'0'
    cmp al,39h
    ja corrige_ascii
    call print_char
    ret
corrige_ascii:    
    add al,07h
    call print_char
    ret

;----------------------------------------------
; print_char - Imprime um caracter
;----------------------------------------------
print_char:
    push ax
    push dx

	mov dl,al
	mov ah,02h      ;Seleciona a função 02h Saída de caractere
	int 21h         ;Chama a interrupção 21h
    
    pop dx 
    pop ax   
    ret

MAIN 	ENDP
END 	MAIN