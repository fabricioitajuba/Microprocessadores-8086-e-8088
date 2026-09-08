;----------------------------------------------
; EX00a.ASM - Segmento de código no arquivo .com
; Autor: Eng. Fabrício Ribeiro
; masm EX00.asm;
; link EX00.obj;
; exe2bin EX00 EX00.com
;---------------------------------------------

CR equ 0dh
LR equ 0ah

;---------------------------------
; Programa principal
;---------------------------------
;code_seg segment public
code segment
	assume cs:code, ds:code, es:code

	org 100h
inicio: jmp main

	;Os dados vem aqui
	nome db 8 dup(' ')
	idade db 2
	itens db 1, 2, 3

main proc near

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
func1 proc
	
	;Função 1
	
	ret
func1 endp

;---------------------------------
; Função 2
;---------------------------------
func2 proc
	
	;Função 2
	
	ret
func2 endp

code ends
	end inicio
