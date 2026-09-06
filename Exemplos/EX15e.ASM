;----------------------------------------------------
; EX15e.asm - Faz toda a leitura de um arquivo texto
; Similar aos comandos 
; - type do windows 
; - cat do linux
; para usar:
; ex15e texto.txt
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------------

    .model small
    .stack 100h

    .data
    handle_arq dw 0                     ; Guardará o identificador do arquivo
    
    ; Mensagens de Erro
    msg_erro db "Erro ao abrir ou ler o arquivo!", 13, 10, '$'
    msg_vazio db 'Nenhum nome de arquivo foi digitado!', 13, 10, '$'

	nome_arquivo db 20 dup(0) ; Buffer para guardar o nome do arquivo
    ; Tamanho do bloco que leremos por vez (512 bytes)
    TAM_BLOCO equ 512
    buffer db TAM_BLOCO dup(0)          ; Buffer temporário para os dados

    .code
main proc

	; 1. Salvar o segmento do PSP (que está em DS) antes de apontar para .DATA
	mov ax,ds          ; AX agora guarda o segmento do PSP
    
	; 2. Inicializar o segmento de dados padrão (.DATA) em ES para usar o buffer
	mov bx,@data
	mov es,bx
    
	; 3. Acessar o tamanho dos parâmetros no offset 80h do PSP
	mov si,80h
	mov cl,[si]        ; CL recebe a quantidade de caracteres
	cmp cl,0           ; Se for 0, nenhum parâmetro foi passado
	je sem_parametros
    
	; 4. Copiar os parâmetros do PSP (DS:SI) para o nosso buffer (ES:DI)
	mov si,82h              ; Offset onde começam os parâmetros no PSP
	lea di,es:nome_arquivo  ; Destino no nosso segmento de dados
    
loop_copia:
	mov al,[si]        ; Lê caractere do PSP
	mov es:[di],al     ; Salva no nosso buffer
	inc si
	inc di
	dec cl
	jnz loop_copia

    ; Inicializa o segmento de dados
    mov ax,@data
    mov ds,ax

	; Substituir o caractere de Carriage Return 13h por 0 para finalizar a string no DOS
	lea di,nome_arquivo
corrige_fim:
	cmp byte ptr [di],13
	je finaliza_string
    cmp byte ptr [di],0
	je abre_arquivo     ; Se chegou no fim do buffer sem achar o 13
	inc di
	jmp corrige_fim
finaliza_string:
    mov byte ptr[di],0

abre_arquivo:
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
    lea dx,msg_erro
    call print_string
    jmp finalizar

sem_parametros:
	; Se não houver parâmetros, ajusta DS e avisa o usuário
	mov ax,@data
	mov ds,ax
    
	lea dx,msg_vazio
	call print_string
    jmp finalizar

print_string:
	mov ah,09h
	int 21h
    ret

main endp
end main
