;-----------------------------------------------------
; EX08.asm - Impressão de horas
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------
	.model small

	.stack 100h

	.data
	hora db 0
	minuto db 0
	segundo db 0

    unidade db 0
    dezena db 0

	.code
MAIN Proc

	;Inicializa o segmento de dados
	mov ax, @data
	mov ds, ax

	call get_time	;Obtem a hora
	call show_time	;Imprime a hora

	;Sai e retorna ao MSDOS
	mov al,00h
	mov ah,04ch
	int 21h 


;-----------------------------------------------------
; Obtenção das horas
;-----------------------------------------------------
get_time:
	mov ah,2ch
	int 21h 
	mov hora,ch
	mov minuto,cl
	mov segundo,dh
	ret

;-----------------------------------------------------
; mostra horas
;-----------------------------------------------------
show_time:
	mov al,hora
	call print_digitos
	mov al,':'
	call print_char
	mov al,minuto
	call print_digitos
	mov al,':'
	call print_char		
	mov al,segundo
	call print_digitos
	ret

;---------------------------------------------------
;Imprime os digitos
;al = valor
;---------------------------------------------------
print_digitos:
	call hexa2decimal
    
	mov dl,dezena
    add dl,'0'
    mov ah,02h
    int 21h

    mov dl,unidade
    add dl,'0'
    mov ah,02h
    int 21h	
	
	ret

;---------------------------------------------------
;hexa para decimal
;al = valor entre 00h a 63h
;---------------------------------------------------
hexa2decimal:
    xor ah,ah
    mov bl,10
    div bl
    mov unidade,ah
    mov dezena,al
    ret

;-----------------------------------------------------
;Imprime um caracter
;al=código ASCII do caracter
;-----------------------------------------------------
print_char:
	mov dl, al
	mov ah, 02h    ; Seleciona a função 02h Saída de caractere
	int 21h        ; Chama a interrupção 21h	
	ret

MAIN  	ENDP
END 	MAIN 