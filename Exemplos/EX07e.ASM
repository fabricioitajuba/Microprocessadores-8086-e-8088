;----------------------------------------------
; EX07e.asm - Conversão de String DECIMAL para 
;             HEXADECIMAL
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

.model small
.stack 100h

.data
    ; String decimal terminada em '$' para facilitar (máximo 65535 para 16-bits)
    str_decimal db '12345', '$' 
    
    ; Buffer para armazenar o resultado hexadecimal convertido (4 dígitos + '$')
    str_hexa    db '0000', '$'
    
    msg1        db 'Decimal: $'
    msg2        db 0dh, 0ah, 'Hexadecimal: $'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- Exibe a string original ---
    mov ah, 09h
    lea dx, msg1
    int 21h
    lea dx, str_decimal
    int 21h

    ; =========================================================================
    ; PASSO 1: Converter String Decimal para Número Inteiro (em AX)
    ; =========================================================================
    lea si, str_decimal
    xor ax, ax          ; Limpa AX (acumulador do resultado)
    xor cx, cx          ; Limpa CX para usar CL como registrador temporário

conv_dec:
    mov cl, [si]        ; Carrega o caractere atual
    cmp cl, '$'         ; Verifica se chegou ao fim da string
    je  fim_conv_dec
    
    ; Converte o caractere ASCII ('0'-'9') para valor numérico (0-9)
    sub cl, '0'         
    
    ; Multiplica o valor atual acumulado por 10: AX = AX * 10
    mov bx, 10
    mul bx              ; DX:AX = AX * 10 (para números pequenos, fica só em AX)
    
    ; Adiciona o novo dígito: AX = AX + CL
    add ax, cx
    
    inc si              ; Avança para o próximo caractere
    jmp conv_dec

fim_conv_dec:
    ; Neste ponto, AX contém o número inteiro (Ex: 12345 ou 3039h)

    ; =========================================================================
    ; PASSO 2: Converter o Inteiro (AX) para String Hexadecimal
    ; =========================================================================
    ; Vamos isolar cada um dos 4 nibbles (4 bits) de AX, do menos para o mais significativo
    lea di, str_hexa
    add di, 3           ; Aponta para o último caractere do buffer (unidade hexa)
    
    mov cx, 4           ; Loop para os 4 dígitos hexadecimais (16 bits / 4)
    mov bx, ax          ; Move o valor para BX para não perder o original

conv_hex:
    mov ax, bx          ; Recupera o valor atualizado
    and ax, 000Fh       ; Isola os 4 bits menos significativos (nibble inferior)
    
    cmp al, 9
    jbe j_num
    add al, 7           ; Se for maior que 9, pula a lacuna do ASCII entre '9' e 'A' (ajuste de +7)
j_num:
    add al, '0'         ; Converte para o caractere ASCII correspondente ('0'-'9' ou 'A'-'F')
    
    mov [di], al        ; Salva o caractere no buffer
    dec di              ; Move o ponteiro do buffer para a esquerda
    
    ; Desloca BX 4 bits para a direita para processar o próximo nibble
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1           
    loop conv_hex

    ; --- Exibe a string hexadecimal resultante ---
    mov ah, 09h
    lea dx, msg2
    int 21h
    lea dx, str_hexa
    int 21h

    ; Finaliza o programa
    mov ax, 4c00h
    int 21h
main endp
end main
