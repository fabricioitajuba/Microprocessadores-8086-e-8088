;----------------------------------------------
; EX00.ASM - Segmento de código no arquivo .exe
; Autor: Eng. Fabrício Ribeiro
; masm EX00.asm;
; link EX00.obj;
;---------------------------------------------

pilha segment para stack 'stack'
	dw 128 dup(?)
pilha ends

dados segment para 'data'
	;Os dados vão aqui
dados ends

codigo segment para 'code'
	assume ss:pilha,cs:codigo,ds:dados,es:dados

;---------------------------------
; Programa principal
;---------------------------------
main proc far

	;Inicializa os segmentos de dados
	mov ax,dados
	mov ds,ax
	mov es,ax

	;Programa principal

	call func1
	call func2

	;Sai e retorna ao MSDOS
	mov ah, 04ch
	int 21h 

main endp

;---------------------------------
; Função 1
;---------------------------------
func1 proc near
	
	;Função 1
	
	ret
func1 endp

;---------------------------------
; Função 2
;---------------------------------
func2 	proc 	near
	
	;Função 2
	
	ret
func2 	endp

codigo	ends
end	main
