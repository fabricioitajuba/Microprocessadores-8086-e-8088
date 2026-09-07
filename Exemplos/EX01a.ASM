;----------------------------------------------
; EX01a.asm - Impressão de uma string na tela
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
	call print_string

	;Sai e retorna ao MSDOS
	mov al,00h
	mov ah,04ch
	int 21h       

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

end main

