;----------------------------------------------------
; Proj03.asm - Manipula arquivo
; para compilar:
; $ NMAKE
; $ exe2bin proj03 proj03.com
; Autor: Eng. Fabrício Ribeiro
; Status: Concluído!
;----------------------------------------------------

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

        CALL    FILE_CREATE     ;Cria um arquivo
        CALL    FILE_CLOSE      ;Fecha um arquivo

SAI_DOS:
        ;Sai e retorna ao MSDOS
	MOV     AH,4CH
	INT     21H

MAIN 	ENDP

CODE_SEG	ENDS

DATA_SEG       SEGMENT PUBLIC
        ;EXTRN   FILE_NAME:BYTE
        ;EXTRN   HANBLE:WORD
DATA_SEG       ENDS

        END     MAIN
