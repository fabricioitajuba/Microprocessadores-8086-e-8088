;----------------------------------------------------
; Proj03.asm - Manipula arquivo
; para compilar:
; $ NMAKE
; $ exe2bin proj03 proj03.com
; Autor: Eng. Fabrício Ribeiro
; Status: NÃO Concluído!
;----------------------------------------------------

FALSE   EQU     0
TRUE    EQU     1

CR      EQU     13      ;Retorno de carro
LF      EQU     10      ;Mudança de linha

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        ORG     100h

	;Carrega funções externas
        EXTRN   FILE_CREATE:NEAR
        EXTRN   FILE_CLOSE:NEAR
        EXTRN   IMP_STR:NEAR

;...........................
; Programa principal
;...........................
MAIN	PROC NEAR

        MOV     AX,0                    ;Configura o 
        MOV     ATTR,AX                 ;Atributo do arquivo.
        CALL    FILE_CREATE             ;Tenta criar o arquivo;
        MOV     AL,FILE_STATUS          ;Verifica 
        CMP     AL,FALSE                ;a variável FILE_STATUS.
        JE      SAI_DOS                 ;Se FALSE, sai para o DOS
        LEA     DX,FILE_MSG_CREATE      ;Se TRUE
        CALL    IMP_STR                 ;imprime a mensagem

        MOV     AX,HANDLE_IN            ;Carrega o HANDLE do
        MOV     HANDLE_OUT,AX           ;arquivo.
        CALL    FILE_CLOSE              ;Tenta Fechar o arquivo.
        MOV     AL,FILE_STATUS          ;Verifica
        CMP     AL,FALSE                ;a variável FILE_STATUS.
        JE      SAI_DOS                 ;Se FALSE, sai para o DOS
        LEA     DX,FILE_MSG_CLOSE       ;Se TRUE
        CALL    IMP_STR                 ;imprime a mensagem

SAI_DOS:
	MOV     AH,4CH
	INT     21H

MAIN 	ENDP

CODE_SEG	ENDS

        PUBLIC  FILE_NAME, ATTR, HANDLE_OUT, TEXTO, LEN

DATA_SEG       SEGMENT PUBLIC
        FILE_NAME DB 'texto.txt',0
        ATTR DW 0
        EXTERN FILE_STATUS:BYTE                 ;Recebe a variável externa
        EXTERN HANDLE_IN:WORD                   ;Recebe a variável externa
        HANDLE_OUT DW ?

        ;Texto para inserir:
        TEXTO DB 'Texto inserido no arquivo!',CR,LF
        LEN EQU $-TEXTO                         ;Calcula o tamanho do texto

        ;Mensagens
        FILE_MSG_CREATE DB 'Arquivo criado com sucesso!',CR,LF,'$'
        FILE_MSG_CLOSE DB 'Arquivo fechado com sucesso!',CR,LF,'$'
DATA_SEG       ENDS

        END     MAIN
