;----------------------------------------------
; EX01.asm - Impressão de uma string na tela
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------
	.model small

	.stack 100h
CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.data
	Message DB 'Hello, World!',CR,LF,'$'

	.code
Hello 	Proc

	;Imprime uma string
	mov ax, @data
	mov ds, ax
	mov dx, OFFSET Message
	mov ah,9h
	int 21h

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h       

Hello 	ENDP
END 	Hello

