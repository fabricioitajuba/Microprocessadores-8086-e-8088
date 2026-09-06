;-----------------------------------------------------
; EX11a.asm - Concatena 2 strings
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------
    .model small
    .stack 100h

    .data
    ; Definição das strings originais terminadas em '$'
    string1  db "Ola ", "$"
    string2  db "Mundo!", "$"
    
    ; Buffer que receberá a união das duas strings (reservando 50 bytes)
    string_final db 50 dup('$')

    .code
main proc
    ; Inicializa o segmento de dados (DS e ES)
    mov ax,@data
    mov ds,ax
    mov es,ax      ; ES é necessário para instruções de string como MOVSB

    ; ---------------------------------------------------------
    ; PASSO 1: Copiar a primeira string para o 'string_final'
    ; ---------------------------------------------------------
    lea si, string1 ; SI aponta para a origem (string1)
    lea di, string_final ; DI aponta para o destino

copia_str1:
    mov al,[si]    ; Carrega o caractere atual de string1
    cmp al,'$'     ; Chegou ao fim da string1?
    je fim_str1     ; Se sim, sai do loop sem copiar o '$'
    mov [di],al    ; Copia o caractere para o destino
    inc si          ; Avança na origem
    inc di          ; Avança no destino
    jmp copia_str1

fim_str1:
    ; Neste ponto, DI já está apontando exatamente para onde 
    ; deve começar a gravação da segunda string.

    ; ---------------------------------------------------------
    ; PASSO 2: Copiar a segunda string logo em seguida
    ; ---------------------------------------------------------
    lea si, string2 ; SI agora aponta para a origem (string2)

copia_str2:
    mov al,[si]    ; Carrega o caractere atual de string2
    cmp al,'$'     ; Chegou ao fim da string2?
    je fim_str2     ; Se sim, encerra a cópia
    mov [di],al    ; Copia o caractere para o destino
    inc si
    inc di
    jmp copia_str2

fim_str2:
    ; Adiciona o terminador '$' no final da string concatenada
    mov byte ptr [di],'$'

    ; ---------------------------------------------------------
    ; PASSO 3: Exibir o resultado final na tela
    ; ---------------------------------------------------------
    lea dx,string_final
    mov ah,09h     ; Função do DOS para exibir string
    int 21h         ; Chama a interrupção do DOS

    ; Finalizar o programa de forma limpa
    mov ah,4ch
    int 21h

main endp
end main
