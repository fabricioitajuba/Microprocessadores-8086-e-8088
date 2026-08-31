;-----------------------------------------------------
; EX09.asm - Mover uma string
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.model SMALL
	.stack 100H

	.data
    	StringA db 'Isso eh um teste!',CR,LF,'$'
    	len     equ $ - StringA

	.data?
    	StringB DB len dup(?)

	.code
MAIN 	PROC

    	mov ax,@data
    	mov ds,ax
    	mov es,ax

    	lea si, StringA		; SI aponta para o início da origem
    	lea di, StringB  	; DI aponta para o início do destino

	;move a string
    	mov cx,len
    	cld
    	rep movsb

	;Imprime a string movida
	mov dx, OFFSET StringB
	mov ah,9h
	int 21h

	;Sai e retorna ao MSDOS
   	mov ah, 4ch
   	int 21h

MAIN 	ENDP
END 	MAIN

