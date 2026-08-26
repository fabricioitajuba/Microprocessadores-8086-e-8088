;-----------------------------------------------------
; EX03.asm - Leitura de uma tecla e impressão na tela
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------
	.model small

	.stack 100h
CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.data
	Message DB 'Pressione uma tecla ...',CR,LF,'$'

	.code
Char 	Proc

	;Imprime uma string
	mov ax, @data
	mov ds, ax
	mov dx, OFFSET Message
	mov ah,9h
	int 21h

	;Lê uma tecla com espera, retorna o valor em al
	mov ah, 07h
	int 21h

	;Imprime um caracter presente em al
	mov ah, 0Eh    ; Seleciona a função Teletype
	int 10h        ; Chama a interrupção de vídeo do BIOS

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h       

Char 	ENDP
END 	Char

