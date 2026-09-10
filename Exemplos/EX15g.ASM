;----------------------------------------------
; EX15g.ASM - Gera um arquivo de "log"
; Autor: Eng. Fabrício Ribeiro
; masm EX15g.asm;
; link EX15g.obj;
; exe2bin EX15g EX15g.com
;---------------------------------------------

buffer_len equ 100
CR equ 0dh
LF equ 0ah

;---------------------------------
; Programa principal
;---------------------------------
;code_seg segment public
code segment
	assume cs:code, ds:code, es:code

	org 100h
inicio: jmp main

	nome db 'log.txt',0
	handle dw ?

	msg1 db 'Erro ao abrir o arquivo!',CR,LF,'$'
	msg2 db 'Erro ao criar o arquivo!',CR,LF,'$'
	msg3 db 'Erro ao fechar o arquivo!',CR,LF,'$'
	msg4 db 'Erro no ponteiro!',CR,LF,'$'
	msg5 db 'Erro ao inserir dados no arquivo!',CR,LF,'$'

	;Buffer para inserir dados
	buffer db buffer_len dup(0) ;Buffer para escrita no arquivo
	len dw 0					;Número de bytes no buffer

	texto db ' - Texto inserido no arquivo!','$'

main proc near

	;Tenta abrir o arquivo log.txt para escrita
    mov al,1
    lea dx,nome
    mov ah,3dh
    int 21h	
	jc erro_abrir
	mov handle,ax

insere_dados:

	;Posiciona o ponteiro do arquivo no final do arquivo
    mov al,02h
    mov bx,handle
    mov cx,0
    mov dx,0
    mov ah,42h
    int 21h
    jc erro_ponteiro

	;<<< ### Os dados que serão inseridos ### >>>
	call rst_buffer	;Reseta o buffer

	mov al,'1'
	call add_buffer	;Adiciona dado ao buffer
	mov al,'2'
	call add_buffer
	mov al,'3'
	call add_buffer
	mov al,'4'
	call add_buffer

	lea di,texto
	call str_buffer	;Adiciona uma string no vetor

	call end_buffer	;Finaliza o buffer

	;Grava os dados no final do arquivo
    mov bx,handle
    mov cx,len
    lea dx,buffer
	mov ah,40h
    int 21h
    jc erro_adicionar
	jmp fecha_arquivo

erro_adicionar:
	lea dx,msg1
	call print_string

	;Fecha o arquivo
fecha_arquivo:	
	mov bx,handle
	mov ah,3eh
	int 21h
	jc erro_fechar
	jmp sai_dos

	;Caso não exista, cria o arquivo log.txt
erro_abrir:
	lea dx,msg1
	call print_string

	lea dx,nome
	mov cx,0
	mov ah,3ch
	int 21h
	jc erro_criar
	mov handle,ax
	jmp insere_dados

erro_ponteiro:
	lea dx,msg4
	call print_string
	jmp fecha_arquivo

erro_fechar:
	lea dx,msg3
	call print_string
	jmp sai_dos

erro_criar:
	lea dx,msg2
	call print_string

sai_dos:
	;Sai e retorna ao MSDOS
	mov ah, 04ch
	int 21h

main endp

;----------------------------------------------
; print_string - Imprime uma string
; DX - endereço base da string
;----------------------------------------------
print_string proc near
	push ax
	mov ah,9h
	int 21h
	pop ax
	ret
print_string endp

;----------------------------------------------
; rst_buffer - Reseta o contador do buffer
;----------------------------------------------
rst_buffer proc near
	mov al,0
	mov si,al
	mov len,al
	ret
rst_buffer endp

;----------------------------------------------
; add_buffer - Adiciona dados ao buffer
; possui limitação de escrita no buffer
; al - dado a ser inserido
;----------------------------------------------
add_buffer proc near
	cmp si,buffer_len
	jb inc_buffer_end
	mov buffer[si],'$'
	jmp add_buffer_end
inc_buffer_end:
	mov buffer[si],al
	inc si
add_buffer_end:
	ret
add_buffer endp

;----------------------------------------------
; str_buffer - Adiciona string ao buffer
; DI - endereço base da string
;----------------------------------------------
str_buffer proc near
str_buffer_loop:
	mov al,[di]
	cmp al,'$'
	je str_buffer_end
	call add_buffer
	inc di
	jmp str_buffer_loop
str_buffer_end:	
	ret
str_buffer endp

;----------------------------------------------
; rst_buffer - Finaliaza o buffer
;----------------------------------------------
end_buffer proc near
	mov al,LF
	call add_buffer
	mov al,CR
	call add_buffer
	dec si
	mov len,si
	ret
end_buffer endp

code ends
	end inicio
