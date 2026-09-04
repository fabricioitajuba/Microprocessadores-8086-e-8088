;Ex12a - Entrada de parâmetros
; Este exemplo mostra os parâmetros digitados após a execussão do
; programa. Exemplo:
;
; ex12 a <ENTER>
; Parametro digitado: a
;
; ex12 b <ENTER>
; Parametro digitado: b
;
; ex12 c <ENTER>
; Parametro digitado: c

	.model small
	.stack 100h

	.data
	msg_info db 'Parametro digitado: ', '$'
	par db ?

	.code
main 	proc
  
	mov bx,@data
	mov es,bx

	mov si,82h		;80h - número de caracteres, 81h espaço, 82h parametro
	lea di,es:par	;aponta di para a variável "par"

	mov al,[si]		;lê o valor do parâmetro apontado por si
	mov es:[di],al  ;guarda na variável "par" apontada por di

	;Inicia o segmento de dados
	mov ax,@data
	mov ds,ax

	;Mostra a mensgem de "Parametro digitado: "
	mov ah,09h
	lea dx,msg_info
	int 21h

	;Mostra qual foi o parâmetro digitado
	mov dl,par
	mov ah,02h
	int 21h

	; Finaliza o programa retornando ao DOS
	mov ax,4C00h
	int 21h
	
main 	endp
end 	main

