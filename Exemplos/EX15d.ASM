;----------------------------------------------
; EX15d.asm - Faz toda a leitura de um arquivo
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------

    .model small
    .stack 100h

    .data
    ; O nome do arquivo deve terminar com um byte nulo (0), padrão ASCIZ
    nome_arquivo db "texto.txt", 0
    handle_arq dw 0                     ; Guardará o identificador do arquivo
    
    ; Mensagens de Erro
    msg_erro db "Erro ao abrir ou ler o arquivo!$"

    ; Tamanho do bloco que leremos por vez (512 bytes)
    TAM_BLOCO equ 512
    buffer db TAM_BLOCO dup(0)          ; Buffer temporário para os dados

    .code
main proc

    ; Inicializa o segmento de dados
    mov ax,@data
    mov ds,ax

    ; ---------------------------------------------------------
    ; PASSO 1: Abrir o Arquivo (Modo Leitura)
    ; ---------------------------------------------------------
    mov ah,3dh          ; Função DOS: Abrir arquivo
    mov al,0            ; Código de acesso: 0 = Apenas leitura
    lea dx,nome_arquivo
    int 21h
    jc erro_sistema     ; Se o Carry Flag (CF) for setado, houve erro (ex: arquivo não existe)
    mov handle_arq,ax   ; Se deu certo, AX traz o "Handle" (identificador) do arquivo

ler_loop:
    ; ---------------------------------------------------------
    ; PASSO 2: Ler um bloco do Arquivo
    ; ---------------------------------------------------------
    mov ah,3fh          ; Função DOS: Ler arquivo
    mov bx,handle_arq   ; Passa o handle do arquivo
    mov cx,TAM_BLOCO    ; Quantidade máxima de bytes a ler nesta rodada
    lea dx,buffer       ; Onde salvar os dados lidos
    int 21h
    jc erro_sistema     ; Se der erro na leitura, pula para a rotina de erro

    ; O DOS retorna em AX a quantidade de bytes REALMENTE lidos
    mov cx,ax           ; Move a quantidade lida para CX (usaremos no loop de exibição)
    cmp cx,0            ; Se AX/CX for igual a 0, significa Fim do Arquivo (EOF)
    je fim_leitura      ; Se chegou ao fim, sai do loop

    ; ---------------------------------------------------------
    ; PASSO 3: Processar/Exibir o bloco lido na tela
    ; ---------------------------------------------------------
    lea si,buffer       ; SI aponta para o início do buffer lido

exibir_bloco:
    mov dl,[si]         ; Coloca o caractere atual em DL
    mov ah,02h          ; Função DOS: Exibir caractere na tela
    int 21h
    inc si              ; Avança para o próximo caractere do buffer
    loop exibir_bloco   ; Decrementa CX e repete até exibir todos os bytes lidos

    jmp ler_loop        ; Volta para ler o próximo bloco do arquivo

fim_leitura:
    ; ---------------------------------------------------------
    ; PASSO 4: Fechar o Arquivo
    ; ---------------------------------------------------------
    mov ah,3eh          ; Função DOS: Fechar arquivo
    mov bx,handle_arq
    int 21h

finalizar:
    mov ah,4ch          ; Finaliza o programa de forma limpa
    int 21h

erro_sistema:
    ; Exibe mensagem de erro genérica caso o arquivo não exista
    mov ah,09h
    lea dx,msg_erro
    int 21h
    jmp finalizar

main endp
end main
