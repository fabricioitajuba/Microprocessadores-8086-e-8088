.data
    resultado db '0', '0', '0', '$'
.code
;----------------------------------------------
; print_char - Imprime um caracter
; AL = código ASCII do caracter
;----------------------------------------------
print_char proc near
    push ax
    push dx
	mov dl,al
	mov ah,02h      ;Seleciona a função 02h Saída de caractere
	int 21h         ;Chama a interrupção 21h    
    pop dx 
    pop ax   
    ret
print_char endp

;----------------------------------------------
; print_string - Imprime uma string
; DX - endereço base da string
;----------------------------------------------
print_string proc near
	push ax
	mov ah,9h
	int 21h
	pop ax
	ret
print_string endp

;----------------------------------------------
; print_decimal_99 - Converte um número até 63h 
; em decimal e mostra na tela.
; AL - recebe o valor até 63h
;----------------------------------------------
print_decimal_99 proc near
    push ax
    push bx
    xor ah,ah
    mov bl,10
    div bl
    push ax
    ;mov unidade,ah
    add ah,'0'
    mov al,ah
    call print_char
    pop ax
    ;mov dezena,al
    add al,'0'
    call print_char    
    pop bx
    pop ax
    ret
print_decimal_99 endp

;----------------------------------------------
; print_decimal_255 - Converte um número até ffh
; em decimal e mostra na tela.
; AL - recebe o valor até ffh
;----------------------------------------------
print_decimal_255 proc near
    push ax
    push bx
    push dx
    push si
    
    mov ah,0
    lea si,resultado
    add si,2
converte_loop:
    mov bl,10
    div bl
    add ah,'0'  
    mov [si],ah   
    dec si
    mov ah,0
    cmp al,0
    jne converte_loop

    ;mostra_resultado
    lea dx,resultado
    call print_string

    pop si
    pop dx
    pop bx
    pop ax
    ret
print_decimal_255 endp

;----------------------------------------------
; print_hexa - Imprime o valor hexadecimal
; presente em AL
;----------------------------------------------
print_hexadecimal proc near
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
print_hexadecimal endp
