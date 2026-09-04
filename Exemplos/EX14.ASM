;-----------------------------------------------------
; Ex14.asm - Soma de 2 números
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

CR	equ	0DH		;ASCII carriage return
LF	equ	0AH		;ASCII line feed
dig equ 10		;Número máximo de digitos
ndig equ 10		;Total de digitos

	.model small

	.stack 100h

	.data
	msg1 db CR,LF,'Entre com o valor 1: ','$'
	msg2 db 'Entre com o valor 2: ','$'
	msg3 db 'Resultado: ','$'
	crlf db CR,LF,'$'

    len db ndig  			;Tamanho do buffer 10 char+return
    len_used db ?   		;Tamanho ocupado pela string atual
    buffer db ndig DUP('0')	;Buffer, 10 posições inicializadas com 0

    vai1 db ndig DUP(0) 	;Buffer, 10 posições inicializadas com 0
    num1 db ndig DUP(0) 	;Buffer, 10 posições inicializadas com 0
    num2 db ndig DUP(0) 	;Buffer, 10 posições inicializadas com 0
    result db ndig DUP('0') ;Buffer, 10 posições inicializadas com "0"

	end_vai1 dw ?
	end_num1 dw ?			
	end_num2 dw ?
	end_result dw ?

	flag db 0
  
	.code
MAIN PROC

	;Inicializa o segmento de dados
	mov ax,@data
	mov ds,ax
	mov es,ax

;===============================================
;= Lendo o primeiro número
;===============================================

	;Imprime uma string
	lea dx,msg1
	call print_string

	;Lê uma string
	lea dx,len
	mov ah,0ah
	int 21h

	;Pula linha
	lea dx,crlf
	call print_string

	;Transfere os dados de buffer para num1
	mov ah,0

	lea si,buffer		;Carrega SI com o endereço de buffer
	mov al,[len_used]	;Carrega o conteúdo de len_used em al
	sub al,1
	add si,ax

	lea di,num1
	mov al,[ndig]
	sub al,1
	add di,ax

	xor cx,cx
	mov cl,[len_used]

transf1:
	mov al,[si]
	sub al,'0'		;Converte de ASCII para hexa
	mov [di],al
	dec si
	dec di
	loop transf1

;===============================================
;= Lendo o segundo número
;===============================================
	;Imprime uma string
	lea dx,msg2
	call print_string

	;Lê uma string
	lea dx,len
	mov ah,0ah
	int 21h

	;Pula linha
	lea dx,crlf
	call print_string

	;Transfere os dados de buffer para num2
	mov ah,0

	lea si,buffer
	mov al,[len_used]
	sub al,1
	add si,ax

	lea di,num2
	mov al,[ndig]
	sub al,1
	add di,ax

	xor cx,cx
	mov cl,[len_used]

transf2:
	mov al,[si]
	sub al,'0'		;Converte de ASCII para hexa
	mov [di],al
	dec si
	dec di
	loop transf2

;===============================================
;= Realiza a soma
;===============================================
	xor ax,ax
	xor cx,cx

	mov al,[ndig]		;Carrega o valor de ndig em al
	mov cl,al
	sub al,1

	lea si,vai1			;Carrega SI com o endereço de vai1
	add si,ax
	mov [end_vai1],si	;Guarda o endereço do primeiro dígito de vai1

	lea si,num1			;Carrega SI com o endereço de num1
	add si,ax
	mov [end_num1],si	;Guarda o endereço do primeiro dígito de num1

	lea si,num2			;Carrega SI com o endereço de num2
	add si,ax
	mov [end_num2],si	;Guarda o endereço do primeiro dígito de num2

	lea si,result		;Carrega SI com o endereço de result
	add si,ax
	mov [end_result],si	;Guarda o endereço do primeiro dígito de result
; ;---
soma:
 	mov si,[end_num1]
 	mov di,[end_num2]

 	mov al,[si]			;al recebe num1 -> al=num1
  	add al,[di]			;soma num1 em al -> num1+num2
 	mov di,[end_vai1]
	add al,[di]			;al=num1+num2+vai1 => resultado da soma
	dec di				;Endereço de va11 é decrementado
	mov [end_vai1],si	;e guardado

    xor ah,ah
    mov bl,10
    div bl

	add ah,'0'			;Converte o digito em ASCII

 	mov si,[end_result]
 	mov [si],ah
	mov di,[end_vai1]
 	mov [di],al

	dec si				;Decrementa o endereço result
	mov [end_result],si	;Guarda o valor

	mov si,[end_num1]
	dec si
	mov [end_num1],si

	mov di,[end_num2]
	dec di
	mov [end_num2],di

	loop soma

;===============================================
;= Mostra o resultado
;===============================================
	;Imprime uma string
	lea dx,msg3
	call print_string

	lea si,result
	xor cx,cx
	mov cl,ndig
mostra:
	mov dl,[si]

	mov al,flag
	cmp al,1
	je mostr_char

	cmp dl,'0'
	je sai_mostra
	mov al,1
	mov flag,al

	;Imprime um caracter
mostr_char:
	mov ah,02h
	int 21h

sai_mostra:
	inc si
	loop mostra

;===============================================
;= Sai e retorna ao MSDOS
;===============================================
	mov al, 00h
	mov ah, 4ch
	int 21h 

;===============================================
;= Mostra uma string
;===============================================
print_string:
    mov ah,9h
	int 21h
	ret

MAIN	ENDP
END 	MAIN
