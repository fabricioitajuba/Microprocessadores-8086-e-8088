;-----------------------------------------------------
; EX05.asm - Leitura de uma tecla e impressão na tela
;            do byte ASCII correspondente a tecla.
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------
	.model small

	.stack 100h
CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.data
	msg1	db 	'Pressione uma tecla ... ',CR,LF,'$'

	.code
Char 	Proc

	mov dx, OFFSET msg1
	call print_string

	call le_tec

	call print_char

	push ax
	mov al,'-'
	call print_char
	pop ax

	call byte_hexa_print

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h       


;---------------------------------------------------
;Separa os nibbles para impressão
;---------------------------------------------------
byte_hexa_print:
	push ax
	mov cl,4
	sar al,cl
	call bin2ascii
	pop ax
	and al,0fh
	call bin2ascii
	mov al,'h'
	call print_char
	ret

;---------------------------------------------------
;Converte de binário para ASCII
;---------------------------------------------------
bin2ascii:
	cmp al,09h
	ja maior	;JMP se maior que 09h
	add al,'0'
	call print_char
	jmp bin2ascii_end
maior:	sub al,09h
	add al,40h
	call print_char
bin2ascii_end:
	ret

;---------------------------------------------------
; le_tec
; Aguarda até que uma tecla seja pressionada
; al = retorna com o byte em ASCII
;---------------------------------------------------
le_tec:	mov ah, 07h
	int 21h
	ret

;---------------------------------------------------
; print_char
; imprime na tela a tecla pressionada
; al = o valor em ASCII
;---------------------------------------------------
print_char:
	mov dl, al
	mov ah, 02h    ; Seleciona a função 02h Saída de caractere
	int 21h        ; Chama a interrupção 21h	
	ret

;---------------------------------------------------
; print_string
; Imprime uma string
; dx endereço da string
;---------------------------------------------------
print_string:
	mov ax, @data
	mov ds, ax
	mov ah,9h
	int 21h
	ret

Char 	ENDP
END 	Char
