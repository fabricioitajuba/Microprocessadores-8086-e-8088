;----------------------------------------------------
; Teste
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------------

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG SEGMENT PUBLIC

        INCLUDE CONST.INC

        ORG     100h

	;Carrega funções externas
        EXTRN   STR_PRINT:NEAR
        EXTRN   CAR_PRINT:NEAR
        EXTRN   DECIMAL99:NEAR
        EXTRN   HEXA2DECIMAL16:NEAR

;...........................
; Programa principal
;...........................
MAIN    PROC NEAR

        MOV     AL, 73
        CALL    DECIMAL99 
        LEA     DX, DECIMAL
        CALL    STR_PRINT        

        MOV     DL,CR
        CALL    CAR_PRINT
        MOV     DL,LF
        CALL    CAR_PRINT        

        MOV     AX, 12345
        CALL    HEXA2DECIMAL16 
        LEA     DX, DIGITOS
        CALL    STR_PRINT 

SAI_DOS:
	MOV     AH,4CH                  ;Retorna ao
	INT     21H                     ;MS-DOS

MAIN 	ENDP

CODE_SEG ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

DATA_SEG SEGMENT PUBLIC

        EXTERN DECIMAL:BYTE
        EXTERN NUM_HEXA:WORD
        EXTERN DIGITOS:BYTE

DATA_SEG ENDS

        END     MAIN
