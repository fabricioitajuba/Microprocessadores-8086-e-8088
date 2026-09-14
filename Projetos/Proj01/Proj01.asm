;----------------------------------------------------
; Exemplo de projeto utilizando as funções separadas
; e compilando usando o NMAKE do MASM
; no arquivo MAKEFILE tem as diretifas de compilação
; para compilar:
; $ NMAKE
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------------

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        ORG     100h

	;Carrega funções externas
        EXTRN   IMP_HEXA:NEAR
        EXTRN   ENVIA_CRLF:NEAR
        EXTRN   IMP_CAR:NEAR
	EXTRN	IMP_DECIMAL:NEAR

;...........................
; Programa principal
;...........................
MAIN	PROC NEAR
        
        MOV     DL,12H
        CALL    IMP_HEXA

        CALL    ENVIA_CRLF

        MOV     DL,'A'
        CALL    IMP_CAR

        CALL    ENVIA_CRLF

        MOV     DX,12345
        CALL    IMP_DECIMAL

        CALL    ENVIA_CRLF

        ;Sai e retorna ao MSDOS
	MOV     AH,4CH
	INT     21H

MAIN 	ENDP

CODE_SEG	ENDS

DATA_SEG       SEGMENT PUBLIC
        EXTRN   SETOR:BYTE
DATA_SEG       ENDS

        END     MAIN
