;----------------------------------------------------
; EX15f.asm - Faz toda a leitura de um arquivo texto
; Esse programa é o EX15e.asm melhorado
; Similar aos comandos 
; - type do windows 
; - cat do linux
; # para compilar:
; masm ex15f.asm;
; link ex15f.objç
; exe2bin ex15f ex15f.com
; # para usar:
; ex15e texto.txt
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------------

CR equ 0dh
LR equ 0ah

;---------------------------------
; Programa principal .com
;---------------------------------
code segment
	assume cs:code, ds:code

	org 100h
inicio: jmp main

    ;Dados do programa
    handle_arq dw 0                     ; Guardará o identificador do arquivo
    
    ; Mensagens
    msg_erro db "Erro ao abrir ou ler o arquivo!", CR, LR, '$'
    msg_vazio db 'Nenhum nome de arquivo foi digitado!', CR, LR, '$'

    ; Tamanho do bloco que leremos por vez (512 bytes)
    TAM_BLOCO equ 512
    buffer db TAM_BLOCO dup(0)          ; Buffer temporário para os dados

main proc near
    ; ---------------------------------------------------------
    ; PASSO 0: Alterar o final do nome do arquivo para 00h
    ; ---------------------------------------------------------
    mov dx,82h		        ; DX aponta para o início do nome do arquivo
	mov di,82h 		        ;Aponta DI para início do nome do arquivo
	mov al,0dh 		        ;Procura por um retorno de carro (Carriage Return - CR) "0Dh"
	mov cx,0ch 		        ;Examina até 13 posições (82h-8E=13 posições)
	cld			            ;DF=0 (percorrer a memória para a frente) esquerda -> direita
	repne scasb 		    ;Procura o byte 0Dh no PSP
	jne sem_parametros      ;Se não foi digitado nenhum parâmetro
    mov byte ptr [di-1], 0	;Altera o fim do arquivo para 00h (antes 0dh)

    ; ---------------------------------------------------------
    ; PASSO 1: Abrir o Arquivo (Modo Leitura)
    ; ---------------------------------------------------------
    mov ah,3dh          ; Função DOS: Abrir arquivo
    mov al,0            ; Código de acesso: 0 = Apenas leitura
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
    int 21h             ; Retorna ao MS-DOS

erro_sistema:
    ; Exibe mensagem de erro genérica caso o arquivo não exista
    lea dx,msg_erro
    call print_string
    jmp finalizar

sem_parametros:
	; Se não houver parâmetros, ajusta DS e avisa o usuário  
	lea dx,msg_vazio
	call print_string
    jmp finalizar

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

code ends
	end inicio
