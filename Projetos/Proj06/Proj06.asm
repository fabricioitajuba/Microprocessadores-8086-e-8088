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
        EXTRN   HEXA2DECIMAL:NEAR
        EXTRN   HEXA2DECIMAL16:NEAR
        EXTRN   CAR_PRINT:NEAR

;...........................
; Programa principal
;...........................
MAIN	PROC NEAR

        CALL    GET_TIME

        MOV     AL, HORA 
        CALL    HEXA2DECIMAL
        MOV     DL, DEZENA
        ADD     DL, '0'
        CALL    CAR_PRINT
        MOV     DL, UNIDADE
        ADD     DL, '0'
        CALL    CAR_PRINT

        MOV     DL, ':'
        CALL    CAR_PRINT
        
        MOV     AL, MINUTO 
        CALL    HEXA2DECIMAL
        MOV     DL, DEZENA
        ADD     DL, '0'
        CALL    CAR_PRINT
        MOV     DL, UNIDADE
        ADD     DL, '0'
        CALL    CAR_PRINT

        MOV     DL, ':'
        CALL    CAR_PRINT

        MOV     AL, SEGUNDO 
        CALL    HEXA2DECIMAL
        MOV     DL, DEZENA
        ADD     DL, '0'
        CALL    CAR_PRINT
        MOV     DL, UNIDADE
        ADD     DL, '0'
        CALL    CAR_PRINT

        ; MOV     DL, ':'
        ; CALL    CAR_PRINT        
        
        ; MOV     AL, CENTESIMO 
        ; CALL    HEXA2DECIMAL
        ; MOV     DL, DEZENA
        ; ADD     DL, '0'
        ; CALL    CAR_PRINT
        ; MOV     DL, UNIDADE
        ; ADD     DL, '0'
        ; CALL    CAR_PRINT     

        MOV     DL, '-'
        CALL    CAR_PRINT                

        CALL    GET_DATA

        MOV     AL, DIA 
        CALL    HEXA2DECIMAL
        MOV     DL, DEZENA
        ADD     DL, '0'
        CALL    CAR_PRINT
        MOV     DL, UNIDADE
        ADD     DL, '0'
        CALL    CAR_PRINT  

        MOV     DL, '/'
        CALL    CAR_PRINT  

        MOV     AL, MES 
        CALL    HEXA2DECIMAL
        MOV     DL, DEZENA
        ADD     DL, '0'
        CALL    CAR_PRINT
        MOV     DL, UNIDADE
        ADD     DL, '0'
        CALL    CAR_PRINT  

        MOV     DL, '/'
        CALL    CAR_PRINT  

        MOV     AX, ANO
        MOV     NUM_NEXA, AX
        CALL    HEXA2DECIMAL16
        ;MOV     DL, DIGITOS
        ;ADD     DL, '0'        
        ;CALL    CAR_PRINT
        MOV     DL, DIGITOS+1
        ADD     DL, '0'
        CALL    CAR_PRINT
        MOV     DL, DIGITOS+2
        ADD     DL, '0'
        CALL    CAR_PRINT                
        MOV     DL, DIGITOS+3
        ADD     DL, '0'
        CALL    CAR_PRINT
        MOV     DL, DIGITOS+4
        ADD     DL, '0'
        CALL    CAR_PRINT        

SAI_DOS:
	MOV     AH,4CH                  ;Retorna ao
	INT     21H                     ;MS-DOS

MAIN 	ENDP

CODE_SEG	ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

        PUBLIC  TEXTO, CAR, NUM_NEXA

DATA_SEG       SEGMENT PUBLIC

        TEXTO DB ?
        CAR DB ?
        NUM_NEXA dw ?
        EXTERN DIGITOS:BYTE

        EXTERN UNIDADE:BYTE
        EXTERN DEZENA:BYTE

        EXTERN HORA:BYTE
        EXTERN MINUTO:BYTE
        EXTERN SEGUNDO:BYTE
        EXTERN CENTESIMO:BYTE

        EXTERN DIA_SEMANA:BYTE
        EXTERN MES:BYTE
        EXTERN DIA:BYTE
        EXTERN ANO:WORD
        
DATA_SEG       ENDS

        END     MAIN
