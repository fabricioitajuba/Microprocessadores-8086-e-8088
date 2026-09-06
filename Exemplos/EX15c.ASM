;----------------------------------------------
; EX15c.asm - Abrir um arquivo e fazer a leitura
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.model small

	.stack 100h

	.data
	nome db 'texto.txt',0
    
    handle dw ?				;Variável para guardar o identificador do arquivo

	buffer db 200 dup('$')	;Cria um buffer com 50 posições preenchidas pelo
							;caractere "$"

	msg1 db 'Erro ao abrir o arquivo!',CR,LF,'$'
	msg2 db 'Erro ao ler o arquivo!',CR,LF,'$'
	msg3 db 'Erro ao fechar o arquivo!',CR,LF,'$'

	.code
MAIN 	Proc

	;Inicializa o segmento de dados
	mov ax, @data
	mov ds, ax

	;Tenta abrir um arquivo para leitura
    mov al,0			;Modo de acesso: 0=Leitura|1=escrita|2=ambos
    lea dx,nome			;dx aponta para o nome do arquivo
    mov ah,3dh			;Abre arquivo existente
    int 21h	
	jc erro_abrir
	mov handle,AX		;Guarda o identificador do arquivo

	;Lê o conteúdo do arquivo
    mov bx,handle		; BX recebe o identificador do arquivo
    mov cx,199			; Quantidade máxima de bytes a ler (deixar 1 para o '$')
    lea dx,buffer		; DX aponta para o buffer
    mov ah,3fh			; Ler arquivo
    int 21h				; DX:AX agora contém o novo tamanho do arquivo
    jc erro_ler

	;==========================================
	;Mostra o conteúdo do arquivo
	lea dx,buffer
	call print_string
	;==========================================

	jmp fecha_arquivo

	;Erro ao abrir
erro_abrir:
	lea dx,msg1
	call print_string
	call sai_dos

	;Erro ao ler
erro_ler:
	lea dx,msg2
	call print_string

fecha_arquivo:
	;Fecha o arquivo
	mov bx,handle
	mov ah,3eh
	int 21h
	jc erro_fechar
	jmp sai_dos	

	;Erro ao fechar
erro_fechar:
	lea dx,msg3
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

