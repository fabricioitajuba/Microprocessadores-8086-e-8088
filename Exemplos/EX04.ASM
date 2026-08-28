;-----------------------------------------------------
; EX04.asm - Converte para ASCII o valor do byte em ah
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------
	.model small

	.stack 100h

	.data

	.code
HEXA 	Proc

	mov al,7Fh		;Irá mostra o byte 7fh
	call byte_hexa_print

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h 

;---------------------------------------------------
;Separa os nibbles para impressão
;---------------------------------------------------
byte_hexa_print:
	push ax
	mov cl,4
	sar al,cl
	call bin2ascii
	pop ax
	and al,0fh
	call bin2ascii
	mov al,'h'
	call print_char
	ret

;---------------------------------------------------
;Converte de binário para ASCII
;---------------------------------------------------
bin2ascii:
	cmp al,09h
	ja maior	;JMP se maior que 09h
	add al,'0'
	call print_char
	jmp bin2ascii_end
maior:	sub al,09h
	add al,40h
	call print_char
bin2ascii_end:
	ret   

;---------------------------------------------------
;Imprime um caracter presente em al
;---------------------------------------------------
print_char:
	mov dl, al
	mov ah, 02h    ; Seleciona a função 02h Saída de caractere
	int 21h        ; Chama a interrupção 21h	
	ret

HEXA  	ENDP
END 	HEXA 
