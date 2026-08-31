;-----------------------------------------------------
; EX10.asm - Compara 2 strings
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.model SMALL
	.stack 100H

	.data
    	; Definição das strings (Devem ter o mesmo tamanho para CMPSB)
    	str1	db 'hardware'
    	len1	equ $-str1	; Calcula o tamanho da string 1
    
    	str2	db 'hardware'
    	len2	equ $-str2	; Calcula o tamanho da string 2

    	; Mensagens de resultado
    	msg_eq	db 'As strings sao iguais!',CR,LF,'$'
    	msg_neq	db 'As strings sao diferentes!',CR,LF,'$'

	.code
MAIN 	PROC
    	; Inicializa o segmento de dados (DS)
    	mov ax,@data
    	mov ds,ax
    	mov es,ax          	; ES deve apontar para o mesmo segmento que DS para o CMPSB

    	; Passo 1: Verificar se os tamanhos são iguais
    	mov ax,len1
    	mov bx,len2
    	cmp ax,bx
    	jne diferentes      	; Se os tamanhos forem diferentes, pula para 'DIFERENTES'

    	; Passo 2: Configurar registradores para a comparação de string
    	lea si,str1	     	; SI aponta para o início da STR1
    	lea di,str2	    	; DI aponta para o início da STR2
    	mov cx,len1        	; CX recebe o número de caracteres a comparar
    
    	cld                 	; Limpa o Direction Flag (DF=0) para processar da esquerda para a direita

    	; Passo 3: Comparação byte a byte
    	repe cmpsb          	; Repete enquanto igual (ZF=1) e CX > 0
    	jne diferentes		; Se o último par testado não for igual, pula

    	; Se chegou aqui, as strings são iguais
    	lea dx,msg_eq
    	jmp exibir

diferentes:
    	lea dx,msg_neq

exibir:
    	; Função DOS para exibir string (AH = 09h)
    	mov ah,09h
    	int 21h

	;Sai e retorna ao MSDOS
   	mov ah, 4ch
   	int 21h

MAIN 	ENDP
END 	MAIN