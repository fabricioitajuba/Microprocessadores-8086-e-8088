;----------------------------------------------------
; Proj03.asm - Manipula arquivo
; para compilar:
; $ NMAKE
; $ exe2bin proj03 proj03.com
; Autor: Eng. Fabrício Ribeiro
; Status: Concluído!
;----------------------------------------------------

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        INCLUDE CONST.INC

        ORG     100h

	;Carrega funções externas
        EXTRN   FILE_CREATE:NEAR
        EXTRN   FILE_INSERT:NEAR
        EXTRN   FILE_CLOSE:NEAR
        EXTRN   STR_PRINT:NEAR
        EXTRN   STR_LEN:NEAR

;...........................
; Programa principal
;...........................
MAIN	PROC NEAR

        ;Cria um arquivo
        MOV     AX,0                    ;Configura o 
        MOV     ATTR,AX                 ;Atributo do arquivo.
        CALL    FILE_CREATE             ;Tenta criar o arquivo;
        MOV     AL,FILE_STATUS          ;Verifica 
        CMP     AL,FALSE                ;a variável FILE_STATUS.
        JE      SAI_DOS                 ;Se FALSE, sai para o DOS
        LEA     DX,FILE_MSG_CREATE      ;Se TRUE
        CALL    STR_PRINT               ;imprime a mensagem

        ;Calcula o número de bytes de uma string
        CALL    STR_LEN                 ;Passa TEXTO como parâmetro
        MOV     AX,STR_LENGHT           ;Número de bytes

        ;Insere dados no arquivo
        MOV     LEN,AX                  ;Configura o número de bytes
        MOV     AX,HANDLE_IN            ;Carrega o HANDLE do
        MOV     HANDLE_OUT,AX           ;arquivo.
        CALL    FILE_INSERT             ;Insere dados no arquivo
        MOV     AL,FILE_STATUS          ;Verifica
        CMP     AL,FALSE                ;a variável FILE_STATUS.
        JE      FILE_END                ;Se FALSE, sai para o DOS
        LEA     DX,FILE_MSG_INSERT      ;Se TRUE
        CALL    STR_PRINT               ;imprime a mensagem

        ;Fecha o arquivo
FILE_END:
        MOV     AX,HANDLE_IN            ;Carrega o HANDLE do
        MOV     HANDLE_OUT,AX           ;arquivo.
        CALL    FILE_CLOSE              ;Tenta Fechar o arquivo.
        MOV     AL,FILE_STATUS          ;Verifica
        CMP     AL,FALSE                ;a variável FILE_STATUS.
        JE      SAI_DOS                 ;Se FALSE, sai para o DOS
        LEA     DX,FILE_MSG_CLOSE       ;Se TRUE
        CALL    STR_PRINT               ;imprime a mensagem

SAI_DOS:
	MOV     AH,4CH                  ;Retorna ao
	INT     21H                     ;MS-DOS

MAIN 	ENDP

CODE_SEG	ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

        PUBLIC  FILE_NAME, ATTR, HANDLE_OUT, TEXTO, LEN

DATA_SEG       SEGMENT PUBLIC

        FILE_NAME DB 'texto.txt',0
        ATTR DW 0
        EXTERN FILE_STATUS:BYTE                 ;Recebe a variável externa
        EXTERN HANDLE_IN:WORD                   ;Recebe a variável externa
        HANDLE_OUT DW ?

        ;Texto para inserir:
        TEXTO DB 'Esse eh o texto inserido no arquivo!',CR,LF,'$'
        LEN DW ?
        EXTERN STR_LENGHT:WORD                   ;tamanho do texto

        ;Mensagens
        FILE_MSG_CREATE DB 'Arquivo criado com sucesso!',CR,LF,'$'
        FILE_MSG_INSERT DB 'Dados inseridos com sucesso!',CR,LF,'$'
        FILE_MSG_CLOSE DB 'Arquivo fechado com sucesso!',CR,LF,'$'

DATA_SEG       ENDS

        END     MAIN
