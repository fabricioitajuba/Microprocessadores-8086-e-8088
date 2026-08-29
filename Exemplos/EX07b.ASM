;-----------------------------------------------------
; EX07b.asm - Conversão de hexadecimal para decimal 
;             00d - 99d -> 00h - 63h
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

    .model small
    .stack 100H

    .data
    unidade db ?
    dezena db ?

    .CODE
MAIN PROC
    
    ; Inicializa o segmento de dados
    mov ax,@data
    mov ds,ax

    ;mov al,63h
    mov al,32h
    call hexa2decimal

    mov dl,dezena
    add dl,'0'
    mov ah,02h
    int 21h

    mov dl,unidade
    add dl,'0'
    mov ah,02h
    int 21h

    ;Retorna ao MSDOS
    mov ah,4ch
    int 21h

hexa2decimal:
    mov dl,0                ;Zera
    mov unidade,dl          ;as posições
    mov dezena,dl           ;unidade e dezena
hexa2decimal_loop:    
    cmp al,0
    je hexa2decimal_fim
    inc BYTE PTR[unidade]
    mov ah, unidade
    cmp ah, 9
    ja hexa2decimal_maior   ;Salta se maior que 9
    dec al
    jmp hexa2decimal_loop
hexa2decimal_maior:    
    inc BYTE PTR[dezena]
    mov dl,0
    mov unidade,dl
    dec al
    jmp hexa2decimal_loop    
hexa2decimal_fim:
    ret

MAIN ENDP
END MAIN
