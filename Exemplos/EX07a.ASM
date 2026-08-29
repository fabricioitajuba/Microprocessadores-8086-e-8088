;-----------------------------------------------------
; EX07a.asm - Conversão de hexadecimal para decimal e
;            impressão na tela 
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

    .model small
    .stack 100H

    .data
    resultado db 0, 0, 0

    .CODE
MAIN PROC
    
    ; Inicializa o segmento de dados
    mov ax,@data
    mov ds,ax

    mov al,0ffh
    call hexa2decimal

    mov dl,resultado
    add dl,'0'
    mov ah,02h
    int 21h

    mov dl,resultado+1
    add dl,'0'
    mov ah,02h
    int 21h

    mov dl,resultado+2
    add dl,'0'
    mov ah,02h
    int 21h        

    ;Retorna ao MSDOS
    mov ah,4ch
    int 21h

;-----------------------------------------------------
;Converte de hexa para cecimal
;-----------------------------------------------------
hexa2decimal:
    mov ah,0
    lea si,resultado   ;Ponteiro para o final do buffer de resultado (armazenando de trás para frente)
    add si,2
converte_loop:
    mov bl,10
    div bl
    mov [si],ah   
    dec si
    mov ah,0
    cmp al,0
    jne converte_loop
    ret

MAIN ENDP
END MAIN
