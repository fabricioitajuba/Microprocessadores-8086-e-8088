;----------------------------------------------
; EX02.asm - Impressão de um caracter na tela
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------
	.model small

	.stack 100h

	.data

	.code
Char 	Proc

	;Imprime um caracter
	mov ah, 02h    ; Seleciona a função 02h Saída de caractere
	mov dl, 'A'    ; Caractere a ser exibido
	int 21h        ; Chama a interrupção 21h
	
	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h       

Char 	ENDP
END 	Char

