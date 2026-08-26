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
	mov ah, 0Eh    ; Seleciona a função Teletype
	mov al, 'A'    ; Caractere a ser exibido
	int 10h        ; Chama a interrupção de vídeo do BIOS

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h       

Char 	ENDP
END 	Char

