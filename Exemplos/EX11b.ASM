;----------------------------------------------
; EX11b.asm - Procuta a primeira ocorrência de
; um caracter dentro de uma string
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

    .model small

    .stack

    .data
    string db 'TESTE DE CODIGO', 0 ; String na memória
    len equ $-string

    msg1 db 'Caracter encontrado! ',CR,LF,'$'
    msg2 db 'Caracter naun encontrado! ',CR,LF,'$'

    unidade db 0
    dezena db 0

    end_inicial dw 0
    end_final dw 0

    .code

main:
    mov ax,@data
    mov ds,ax           ; Inicializa o Extra Segment (DS)
    mov es,ax           ; Inicializa o Extra Segment (ES)
    
    lea di,string       ; ES:DI aponta para o início da string
    mov end_inicial,di  ; Guarda o endereço inicial da string
    mov al,'S'          ; Caractere que queremos procurar
    mov cx,len          ; Limite máximo de bytes para buscar (tamanho da string)
    
    cld                 ; DF = 0 (percorrer a memória para a frente) esquerda -> direita
    
    repne scasb         ; Repete a busca enquanto NÃO encontrar 'A' e CX > 0
    
    je encontrado       ; Caractere foi encontrado, DI possui a próxima posição

    lea dx,msg2
    call print_string
    jmp sai_dos

encontrado:
    mov end_final,di    ; Guarda o endereço inicial da string

    lea dx,msg1
    call print_string

    ;calcula a posição que o caracter se encontra na string
    mov bx,end_inicial
    mov ax,end_final
    sub ax,bx           
    sub ax,1            ;AX possui a posição do caracter encontrado

    ;Mostra em qual posição foi encontrado
    call hexa2decimal

    mov dl,dezena       ;Imprime dezena
    add dl,'0'
    call print_char

    mov dl,unidade      ;Imprime unidade
    add dl,'0'
    call print_char    

sai_dos:
	;Sai e retorna ao MSDOS
	mov al,00h
	mov ah,04ch
	int 21h       

;----------------------------------------------
; hexa2decinal - Converte de hexa/decimal
; AL - dado a ser convertido
;----------------------------------------------
hexa2decimal:
    xor ah,ah
    mov bl,10
    div bl
    mov unidade,ah
    mov dezena,al
    ret

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

;----------------------------------------------
; print_char - Imprime um caracter
; DL - caracter em ASCII
;----------------------------------------------
print_char:
	push ax
	mov ah,02h
	int 21h
	pop ax
	ret

end main
