;----------------------------------------------
; EX11c.asm - Procuta a primeira ocorrência de
; um caracter dentro de uma string e altera por
; outro caracter
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

    .model small

    .stack

    .data
    string db 'Funcao - Seno',LF,CR,'$' ; String na memória
    len equ $-string

    msg1 db 'String antiga: ','$'
    msg2 db 'String alterada: ','$'

    .code

main:
    mov ax,@data
    mov ds,ax           ; Inicializa o Extra Segment (DS)
    mov es,ax           ; Inicializa o Extra Segment (ES)

    ;Mostra a string antiga
    lea dx,msg1
    call print_string
    lea dx,string
    call print_string    

    lea di,string       ; ES:DI aponta para o início da string
    mov al,'S'          ; Caractere que queremos procurar
    mov cx,len          ; Limite máximo de bytes para buscar (tamanho da string)
    
    cld                 ; DF = 0 (percorrer a memória para a frente) esquerda -> direita
    
    repne scasb         ; Repete a busca enquanto NÃO encontrar 'A' e CX > 0
    
    je encontrado       ; Caractere foi encontrado, DI possui a próxima posição

    jmp sai_dos

encontrado:
    ;DI possui o endereço do próximo caracter depois do caracter encontrado
    mov byte ptr[di-1],'C'   ;Altera o byte encontrado por "T"

    ;Mostra a string antiga
    lea dx,msg2
    call print_string
    lea dx,string
    call print_string    

sai_dos:
	;Sai e retorna ao MSDOS
	mov al,00h
	mov ah,04ch
	int 21h       

;----------------------------------------------
; print_string - Imprime uma string
; DX - endereço base da string
;----------------------------------------------
print_string:
	push ax
	mov ah,9h
	int 21h
	pop ax
	ret

end main
