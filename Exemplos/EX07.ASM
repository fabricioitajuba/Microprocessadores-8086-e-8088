;-----------------------------------------------------
; EX07.asm - Conversão de hexadecimal para decimal e
;            impressão na tela 
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

    .model small
    .stack 100H

    .data
    valor_hex db 0FFh     
    resultado db '0', '0', '0', '$'    
    mensagem db 'O valor em decimal eh: $'

    .CODE
MAIN PROC
    
    ; Inicializa o segmento de dados
    mov ax,@data
    mov ds,ax

    mov al,valor_hex
    mov ah,0

    ; Ponteiro para o final do buffer de resultado (armazenando de trás para frente)
    lea si, resultado
    add si,2

converte_loop:
    mov bl,10
    div bl
    add ah,'0'  
    mov [si],ah   
    dec si
    mov ah,0
    cmp al,0
    jne converte_loop
    
    ;mostra_resultado
    mov ah,09h
    lea dx,mensagem
    int 21h

    mov ah,09h
    lea dx, resultado
    int 21h

    ;Retorna ao MSDOS
    mov ah,4ch
    int 21h

MAIN ENDP
END MAIN
