;----------------------------------------------
; EX17.asm - Usando funções externas
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	dosseg
	.model small

	.stack	;segmento de pilha (1k)

	.data
	Message DB 'Hello, World!',CR,LF,'$'

	.code
main:
	;Inicializa o segmento de dados
	mov ax,@data
	mov ds,ax

	;Imprime uma string
	mov dx,OFFSET Message	;ou lea dx,Message
	call print_string		;print "Hello, World!"

	;print "99d"
	mov al,63h
	call print_decimal_99
	mov al,'d'
	call print_char
	mov al,' '
	call print_char	

	;print "F7h"
	mov al,0F7h
	call print_hexadecimal
	mov al,'h'
	call print_char	
	mov al,' '
	call print_char

	;print "255d"
	mov al,0ffh
	call print_decimal_255
	mov al,'d'
	call print_char

	;Sai e retorna ao MSDOS
	mov al,00h
	mov ah,04ch
	int 21h       

include funcoes.inc

end main

