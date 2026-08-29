;-----------------------------------------------------
; EX06.asm - Leitura de uma string e impressão na tela
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

CR	equ	0dh	;ASCII carriage return
LF	equ	0ah	;ASCII line feed

	.model small

	.stack 100h

	.data
    	len	db 50  		;Tamanho do buffer 50 char+return
        act_len db ?   		;Tamanho atual
        buffer	db 50 DUP('$') 	;Buffer, 50 posições inicializadas com "$"

	msg1  	db 'Digite uma string: $'
	msg2	db CR, LF,'$'
    
	.code
String	Proc

	;Inicializa o segmento de dados
	mov ax, @data
	mov ds, ax

	;Escreve uma string
	lea dx, msg1
	mov ah, 09h
	int 21h

	;Lê uma string
	lea dx, len
	mov ah, 0ah
	int 21h

	;Escreve uma string (pula linha)
	lea dx, msg2
	mov ah, 09h
	int 21h

	;escreve a nova string
	lea dx, buffer
	mov ah, 09h
	int 21h

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 4ch
	int 21h 
    
String 	ENDP
END 	String

