;----------------------------------------------
; EX07d.asm - Conversão para decimal de 16 bits
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

	.model small

	.stack 100h

	.data

	.code
main 	proc

	;Inicializa o segmento de dados
	mov ax, @data
	mov ds, ax

	mov dx,0ffffh		;Carrega DX com FFFFh -> 65.535d
	call imp_decimal

	;Sai e retorna ao MSDOS
	mov al,00h
	mov ah,4ch
	int 21h       

;----------------------------------------------
; Imprime decimal de 16 bits
; Entrada: Registrador DX
;----------------------------------------------
imp_decimal:
        push ax
        push cx
        push dx
        push si
        mov ax,dx
        mov si,10		;Dividira por 10 usando SI
        xor cx,cx		;Contador digitos na pilha
nao_zero:
        xor dx,dx		;Zera palavra de N
        div si			;Calcula N/10 e (N mod 10)
        push dx			;Coloca um digito na pilha
        inc cx			;Mais um digito colocado
        or ax,ax		;N ja igual a 0?
        jne nao_zero		;Nao, continua
imp_dig_loop:
        pop dx			;Apanha os digitos em ordem contraria
        call imp_dig_hexa
        loop imp_dig_loop
        pop si
        pop dx
        pop cx
        pop ax
        ret

;----------------------------------------------
; Imprime dígito em hexadecimal
; Entrada: Registro dl
;----------------------------------------------
imp_dig_hexa:
	push dx			;Salva registradores usados
	cmp dl,10		;O nibble < 10?
	jae letra_hexa		;Nao converte para letra
	add dl,'0'		;Sim converte para digito
	jmp Short imp_digito	;Imprime este caractere
letra_hexa:
	add dl,'A'-10		;Converte para letra hexa
imp_digito:
	call imp_car		;Imprime letra na tela
	pop dx			;Restaura valor de DX
	ret

;----------------------------------------------
; Imprime caracter
; Entrada: Registro dl
;----------------------------------------------
imp_car:
	push ax
	mov ah,2		;Chamada para saida de caractere
	int 21h			;Sai caractere no registrador DL
	pop ax			;Recupera antigo valor de AX
	ret			;E retorna
    
main 	endp
end 	main

