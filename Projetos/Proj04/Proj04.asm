;----------------------------------------------------
; Proj03.asm - Manipula strings
; para compilar:
; $ NMAKE
; $ exe2bin proj04 proj04.com
; Autor: Eng. Fabrício Ribeiro
; Status: Não Concluído!
;----------------------------------------------------

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        INCLUDE CONST.INC

        ORG     100h

	;Carrega funções externas
        EXTRN   STR_PRINT:NEAR
        EXTRN   STR_LEN:NEAR
        EXTRN   STR_CMP:NEAR

;...........................
; Programa principal
;...........................
MAIN	PROC NEAR

        CALL    STR_CMP
        MOV     AL,STR_COMPARE
        CMP     AL,TRUE
        JE      IGUAIS
        LEA     DX,MSG2
        CALL    STR_PRINT
        JMP     SAI_DOS
IGUAIS: LEA     DX,MSG1
        CALL    STR_PRINT

SAI_DOS:
	MOV     AH,4CH                  ;Retorna ao
	INT     21H                     ;MS-DOS

MAIN 	ENDP

CODE_SEG	ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

        PUBLIC  TEXTO, LEN, STRING1, STRING2

DATA_SEG       SEGMENT PUBLIC

        ;Texto para inserir:
        TEXTO DB 'Esse eh o texto inserido no arquivo!',CR,LF,'$'
        LEN DW ?
        EXTERN STR_LENGHT:WORD                   ;tamanho do texto

        ;Strings
        STRING1 DB 'Essa eh a string 1!',CR,LF,'$'
        STRING2 DB 'Essa eh a string 2!',CR,LF,'$'
        EXTERN STR_COMPARE:BYTE

        MSG1 DB 'As strings saum iguais!',CR,LF,'$'
        MSG2 DB 'As strings saum diferentes!',CR,LF,'$'

DATA_SEG       ENDS

        END     MAIN
