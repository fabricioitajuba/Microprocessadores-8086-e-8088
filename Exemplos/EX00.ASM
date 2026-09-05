;----------------------------------------------
; EX00.ASM - Modelo de programa bem estruturado
; Autor: Eng. Fabrício Ribeiro
; masm EX00.asm;
; link EX00.obj;
; exe2bin EX00 EX00.com
; obs: Para utiliar o comando exe2bin, o 
; code_seg tem que estar antes de data_seg
;---------------------------------------------
cgroup	group	code_seg, data_seg
	assume 	cs:cgroup, ds:cgroup

code_seg 	segment	public
	org 	100h 

;---------------------------------
; Programa principal
;---------------------------------
main 	proc 	near

	;Programa principal

	call func1
	call func2

	;Sai e retorna ao MSDOS
	mov ah, 04ch
	int 21h 

main 	endp

;---------------------------------
; Função 1
;---------------------------------
func1 	proc 	near
	
	;Função 1
	
	RET
func1 	endp

;---------------------------------
; Função 2
;---------------------------------
func2 	proc 	near
	
	;Função 2
	
	RET
func2 	endp

code_seg	ends

;---------------------------------
; Dados do programa
;---------------------------------
data_seg	segment public
	setor db 10h, 11h, 12h	
	dado1 db 0
	dado2 dw 0000
data_seg	ends

	end 	main
