;----------------------------------------------
; EX15b.asm - Abrir um arquivo e insere
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.model small

	.stack 100h

	.data
	nome db 'texto.txt',0

	msg1 db 'Erro ao abrir o arquivo!',CR,LF,'$'
	msg2 db 'Erro ao mover o ponteiro!',CR,LF,'$'
	msg3 db 'Erro ao adicionar texto!',CR,LF,'$'
	msg4 db 'Erro ao fechar o arquivo!',CR,LF,'$'

	texto db 'Texto inserido no arquivo!',CR,LF
	len equ $-texto ;Calcula o tamanho do arquivo

    ; Variável para guardar o identificador do arquivo
    handle dw ?

	.code
MAIN 	Proc

	;Inicializa o segmento de dados
	mov ax, @data
	mov ds, ax

	;Tenta abrir um arquivo para escrita
    mov al,1			;Modo de acesso: 0=Leitura|1=escrita
    lea dx,nome
    mov ah,3dh			;Abre arquivo existente
    int 21h	
	jc erro_abrir
	mov handle,ax		;Salva o handle do arquivo

	;Inserindo texto
insere_texto:
    mov al,02h			; 02h = Mover relativo ao FINAL do arquivo
    mov bx,handle
    mov cx,0			; Deslocamento (bytes mais significativos)
    mov dx,0			; Deslocamento (bytes menos significativos)
    mov ah,42h			; Nove o ponteiro para o final do arquivo
    int 21h				; DX:AX agora contém o novo tamanho do arquivo
    jc erro_ponteiro

    ; 3. GRAVAR O NOVO TEXTO NO FINAL (Função 40h)
    mov bx,handle
    mov cx,len			; Quantidade de bytes para adicionar
    lea dx,texto		; Endereço do novo texto
	mov ah,40h			; Insere dados
    int 21h
    jc erro_adicionar

	jmp fecha_arquivo


	;Erro ao abrir
erro_abrir:
	lea dx,msg1
	call print_string
	jmp sai_dos

	;erro ao mover o ponteiro
erro_ponteiro:
	lea dx,msg2
	call print_string	
	jmp fecha_arquivo

erro_adicionar:
	lea dx,msg3
	call print_string
	jmp fecha_arquivo

	;Erro ao fechar
erro_fechar:
	lea dx,msg4
	call print_string
	jmp sai_dos

fecha_arquivo:
	;Fecha o arquivo
	mov bx,handle
	mov ah,3eh
	int 21h
	jc erro_fechar

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

