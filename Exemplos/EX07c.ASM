;-----------------------------------------------------
; EX07c.asm - Conversão de hexadecimal para decimal 
;             00d - 99d -> 00h - 63h
              Maneira mais simples!
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

    .model small
    .stack 100H

    .data
    unidade db 0
    dezena db 0

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
    xor ah,ah
    mov bl,10
    div bl
    mov unidade,ah
    mov dezena,al
    ret

MAIN ENDP
END MAIN
