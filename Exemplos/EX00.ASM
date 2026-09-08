;----------------------------------------------
; EX00.ASM - Segmento de código no arquivo .exe
; Autor: Eng. Fabrício Ribeiro
; masm EX00.asm;
; link EX00.obj;
;---------------------------------------------

dados segment
	;Os dados vão aqui
	nome db 8 dup(' ')
	idade db 2
	itens db 1, 2, 3
dados ends

codigo segment
	   assume cs:codigo, ss:pilha

;---------------------------------
; Programa principal
;---------------------------------
main proc far

	;Inicializa os segmentos de dados
	mov ax,dados
	mov ds,ax
	assume ds:dados

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

;---------------------------------
; Pilha ou stack
;---------------------------------
pilha segment para stack 'stack'
	dw 100 dup(?)
pilha ends

end	main
