;----------------------------------------------
; EX15.asm - Criar um arquivo
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.model small

	.stack 100h

	.data
	nome db 'texto.txt',0
	
	msg1 DB 'Erro ao criar o arquivo!',CR,LF,'$'
	msg2 DB 'Erro ao fechar o arquivo!',CR,LF,'$'

    ; Variável para guardar o identificador do arquivo
    handle dw ?

	.code
MAIN 	Proc

	;Inicializa o segmento de dados
	mov ax, @data
	mov ds, ax

	;Cria um arquivo
	lea dx,nome		;Aponta para o nome do arquivo
	mov cx,0		;Atributo normal (sem oculto ou somente leitura)
	mov ah,3ch		;Função para criar um arquivo
	int 21h			;Chama a interrupção 21h

	jc erro_criar
	mov handle,ax

	;Aqui ocorre a manipulação
	;do arquivo

	;Fecha o arquivo
	mov bx,handle
	mov ah,3eh
	int 21h
	jc erro_fechar
	jmp sai_dos	

	;Erro ao criar
erro_criar:
	lea dx,msg1
	call print_string
	jmp sai_dos

	;Erro ao fechar
erro_fechar:
	lea dx,msg2
	call print_string

sai_dos:
	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 04ch
	int 21h       

print_string:
	mov ah,9h
	int 21h
	ret

MAIN 	ENDP
END 	MAIN

