;----------------------------------------------
; somas.asm - Formas de somar um dado em uma
;             variável
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------
	.model small

	.stack 100h

	.data
	var db 0

	.code
MAIN 	PROC

	xor ax,ax

	mov al,30h
	add var,al
	mov al,07h
	add var,al

	;add byte ptr[var],30h	;valor imediado
	;mov al,07h		;valor
	;add [var],al		;direto

	;mov al,30h
	;add var,al
	;lea bx,var		
	;mov al,07h
	;mov bx,offset var
	;add byte ptr[bx],al	;registrador de ponteiro

	;add byte ptr[var],37h	;valor imediado

	mov al,var
	mov dl,al	;deverá mostra o caracter "7"

	;mov dl, 'A'    ; Caractere a ser exibido

	;Imprime um caracter
	mov ah, 02h    ; Seleciona a função 02h Saída de caractere
	int 21h        ; Chama a interrupção 21h

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h       

MAIN 	ENDP
END 	MAIN 

