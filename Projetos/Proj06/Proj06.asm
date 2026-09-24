;----------------------------------------------------
; Proj06.asm - Data e hora do sistema
; para compilar:
; $ NMAKE
; $ exe2bin proj06 proj06.com
; Autor: Eng. Fabrício Ribeiro
;----------------------------------------------------

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        INCLUDE CONST.INC

        ORG     100h

	;Carrega funções externas
        EXTRN   GET_TIME:NEAR
        EXTRN   GET_DATA:NEAR        
        EXTRN   STR_PRINT:NEAR

;...........................
; Programa principal
;...........................
MAIN	PROC NEAR

        ;Mostra a hora do sistema
        CALL    GET_TIME
        LEA     DX, TIME_HORA
        CALL    STR_PRINT

        ;Mostra a data do sistema
        CALL    GET_DATA 
        LEA     DX, TIME_DATA
        CALL    STR_PRINT        

SAI_DOS:
	MOV     AH,4CH                  ;Retorna ao
	INT     21H                     ;MS-DOS

MAIN 	ENDP

CODE_SEG	ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

        ;PUBLIC  TEXTO, CAR, NUM_NEXA

DATA_SEG       SEGMENT PUBLIC

        EXTERN TIME_HORA:BYTE
        EXTERN TIME_DATA:BYTE
      
DATA_SEG       ENDS

        END     MAIN
