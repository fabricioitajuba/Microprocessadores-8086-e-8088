;----------------------------------------------------
; Proj03.asm - Manipula arquivo
; para compilar:
; $ NMAKE
; $ exe2bin proj03 proj03.com
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------------

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        INCLUDE CONST.INC

        ORG     100h

	;Carrega funções externas
        EXTRN   FILE_CREATE:NEAR
        EXTRN   FILE_INSERT:NEAR
        EXTRN   FILE_APPEND:NEAR
        EXTRN   FILE_POINTER:NEAR
        EXTRN   FILE_CLOSE:NEAR

        EXTRN   STR_PRINT:NEAR
        EXTRN   STR_LEN:NEAR

;****************************************************************
; Programa principal
;****************************************************************
MAIN	PROC NEAR

        ;Tenta abrir um arquivo para inserir dados
        MOV     AL, 1                   ;Configura Atributo:
        MOV     FILE_MODE, AL           ;1 - escrita
        CALL    FILE_APPEND
        MOV     AL, FILE_STATUS         ;Verifica 
        CMP     AL, FALSE               ;a variável FILE_STATUS.
        JE      CRIA_ARQUIVO            ;Se o arquivo não existir, será criado
                                        ;HANDLE_IN possui o número do arquivo
        LEA     DX, FILE_MSG_OPEN       ;Se TRUE
        CALL    STR_PRINT               ;imprime a mensagem
        JMP     INSERE_DADOS            ;Insere dados

CRIA_ARQUIVO:
        ;Cria um arquivo
        MOV     AX, 0                   ;Configura o 
        MOV     ATTR, AX                ;Atributo do arquivo.
        CALL    FILE_CREATE             ;Tenta criar o arquivo;
        MOV     AL, FILE_STATUS         ;Verifica 
        CMP     AL, FALSE               ;a variável FILE_STATUS.
        JE      SAI_DOS                 ;Se FALSE, sai para o DOS
                                        ;HANDLE_IN possui o número do arquivo
        LEA     DX, FILE_MSG_CREATE     ;Se TRUE
        CALL    STR_PRINT               ;imprime a mensagem

INSERE_DADOS:
        ;Posiciona o ponteiro do arquivo no final
        MOV     AL, 02H                 ;Mover relativo
        MOV     FILE_ORIGIN, AL         ;ao FINAL do arquivo;
        MOV     AX, HANDLE_OUT          ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX           ;arquivo.
        MOV     AX, 0000h               ;Deslocamento
        MOV     FILE_NBYTES_H, AX       ;MSB
        MOV     FILE_NBYTES_L, AX       ;LSB.
        CALL    FILE_POINTER            ;Tenta posicionar o ponteiro.
        MOV     AL, FILE_STATUS         ;Verifica 
        CMP     AL, FALSE               ;a variável FILE_STATUS.
        JE      FECHA_ARQUIVO           ;Se FALSE, fecha o arquivo e sai para o DOS
        LEA     DX, FILE_MSG_POINTER    ;Se TRUE
        CALL    STR_PRINT               ;imprime a mensagem

        ;Prepara os dados que serão inseridos
        CALL    STR_LEN                 ;Passa TEXTO como parâmetro
        MOV     AX, STR_LENGHT          ;Número de bytes

        ;Insere dados no arquivo
        MOV     LEN, AX                 ;Configura o número de bytes
        MOV     AX, HANDLE_OUT          ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX           ;arquivo.
        CALL    FILE_INSERT             ;Insere dados no arquivo
        MOV     AL, FILE_STATUS         ;Verifica
        CMP     AL, FALSE               ;a variável FILE_STATUS.
        JE      FECHA_ARQUIVO           ;Se FALSE, sai para o DOS
        LEA     DX, FILE_MSG_INSERT     ;Se TRUE
        CALL    STR_PRINT               ;imprime a mensagem

        ;Fecha o arquivo
FECHA_ARQUIVO:
        MOV     AX, HANDLE_OUT          ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX           ;arquivo.
        CALL    FILE_CLOSE              ;Tenta Fechar o arquivo.
        MOV     AL, FILE_STATUS         ;Verifica
        CMP     AL, FALSE               ;a variável FILE_STATUS.
        JE      SAI_DOS                 ;Se FALSE, sai para o DOS
        LEA     DX, FILE_MSG_CLOSE      ;Se TRUE
        CALL    STR_PRINT               ;imprime a mensagem

SAI_DOS:
	MOV     AH, 4CH                 ;Retorna ao
	INT     21H                     ;MS-DOS

MAIN 	ENDP

CODE_SEG	ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

        PUBLIC FILE_NAME, ATTR, HANDLE_IN, TEXTO, LEN
        PUBLIC FILE_ORIGIN, FILE_NBYTES_H, FILE_NBYTES_L

DATA_SEG       SEGMENT PUBLIC

        TEXTO DB 'Esse eh o texto inserido no arquivo!',CR,LF,'$'
        LEN DW ?

        FILE_NAME DB 'texto.txt',0
        ATTR DW 0
        HANDLE_IN DW ?
        FILE_ORIGIN DB ?
        FILE_NBYTES_H DW ?
        FILE_NBYTES_L DW ?

        EXTERN FILE_STATUS:BYTE                 ;Recebe a variável externa        
        EXTERN HANDLE_OUT:WORD                  ;Recebe a variável externa
        EXTERN FILE_MODE:BYTE
        EXTERN STR_LENGHT:WORD                   ;tamanho do texto

        ;Mensagens
        FILE_MSG_CREATE DB 'Arquivo criado com sucesso!',CR,LF,'$'
        FILE_MSG_OPEN DB 'Arquivo aberto com sucesso!',CR,LF,'$'
        FILE_MSG_POINTER DB 'Ponteiro posicionado com sucesso!',CR,LF,'$'
        FILE_MSG_INSERT DB 'Dados inseridos com sucesso!',CR,LF,'$'
        FILE_MSG_CLOSE DB 'Arquivo fechado com sucesso!',CR,LF,'$'

DATA_SEG       ENDS

        END     MAIN
;----------------------------------------------------------------
; FIM DO PROGRAMA PRINCIPAL
;----------------------------------------------------------------