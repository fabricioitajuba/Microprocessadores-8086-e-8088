;****************************************************************
; Essas rotinas retornam a HORA e/ou DATA do sistema
;
; GET_TIME - Endereço base de uma STRING com a HORA atual
; GET_DATA - Endereço base de uma STRING com a DATA atual
;****************************************************************

CGROUP          GROUP   CODE_SEG, DATA_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

                INCLUDE CONST.INC

                EXTRN   HEXA2DECIMAL16:NEAR

;****************************************************************
; GET_TIME
; Esta rotina recebe o valor da hora atual
;
; Saídas: 
; CH - Horas (0-23) | CL - Minutos (00-59) | CL - Minutos (00-59)
; DL - CENTÉSIMOS (00-99)
; TIME_HORA: Endereço base de uma STRING com a HORA atual
;****************************************************************

                PUBLIC  GET_TIME

GET_TIME       PROC    NEAR

                PUSH    AX
                PUSH    CX
                PUSH    DX

                MOV     AH, 2CH
                INT     21H
                MOV     HORA, CH
                MOV     MINUTO, CL
                MOV     SEGUNDO, DH
                MOV     CENTESIMO, DL

                XOR     AX, AX

                MOV     AL, HORA 
                CALL    HEXA2DECIMAL16
                MOV     DL, DIGITOS+3
                MOV     TIME_HORA, DL
                MOV     DL, DIGITOS+4
                MOV     TIME_HORA+1, DL

                MOV     DL, ':'
                MOV     TIME_HORA+2, DL
        
                MOV     AL, MINUTO 
                CALL    HEXA2DECIMAL16
                MOV     DL, DIGITOS+3
                MOV     TIME_HORA+3, DL
                MOV     DL, DIGITOS+4
                MOV     TIME_HORA+4, DL

                MOV     DL, ':'
                MOV     TIME_HORA+5, DL

                MOV     AL, SEGUNDO 
                CALL    HEXA2DECIMAL16
                MOV     DL, DIGITOS+3
                MOV     TIME_HORA+6, DL
                MOV     DL, DIGITOS+4
                MOV     TIME_HORA+7, DL                

                POP     DX
                POP     CX
                POP     AX
                RET

GET_TIME       ENDP                

;----------------------------------------------------------------
; FIM GET_TIME
;----------------------------------------------------------------

;****************************************************************
; GET_DATA
; Esta rotina recebe o valor da data atual
;
; Saídas: 
; CH - Horas (0-23) | CL - Minutos (00-59) | CL - Minutos (00-59)
; DL - CENTÉSIMOS (00-99)
; TIME_DATA: Endereço base de uma STRING com a DATA atual
;****************************************************************

                PUBLIC  GET_DATA

GET_DATA       PROC    NEAR

                PUSH    AX
                PUSH    CX
                PUSH    DX

                MOV     AH, 2AH
                INT     21H
                MOV     DIA_SEMANA, AL
                MOV     ANO, CX
                MOV     MES, DH
                MOV     DIA, DL 

                XOR     AX, AX

                MOV     AL, DIA 
                CALL    HEXA2DECIMAL16
                MOV     DL, DIGITOS+3
                MOV     TIME_DATA, DL
                MOV     DL, DIGITOS+4
                MOV     TIME_DATA+1, DL

                MOV     DL, '/'
                MOV     TIME_DATA+2, DL

                MOV     AL, MES 
                CALL    HEXA2DECIMAL16
                MOV     DL, DIGITOS+3
                MOV     TIME_DATA+3, DL
                MOV     DL, DIGITOS+4
                MOV     TIME_DATA+4, DL

                MOV     DL, '/'
                MOV     TIME_DATA+5, DL

                MOV     AX, ANO
                CALL    HEXA2DECIMAL16
                MOV     DL, DIGITOS+1
                MOV     TIME_DATA+6, DL
                MOV     DL, DIGITOS+2
                MOV     TIME_DATA+7, DL                
                MOV     DL, DIGITOS+3
                MOV     TIME_DATA+8, DL
                MOV     DL, DIGITOS+4
                MOV     TIME_DATA+9, DL

                POP     DX
                POP     CX
                POP     AX
                RET

GET_DATA       ENDP                

;----------------------------------------------------------------
; FIM GET_DATA
;----------------------------------------------------------------

CODE_SEG        ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

                ;PUBLIC HORA, MINUTO, SEGUNDO, CENTESIMO
                ;PUBLIC DIA_SEMANA, ANO, MES, DIA
                PUBLIC TIME_HORA, TIME_DATA

DATA_SEG        SEGMENT PUBLIC

                TIME_HORA db 9 dup('$')
                TIME_DATA db 11 dup('$')

                HORA        DB  ?
                MINUTO      DB  ?
                SEGUNDO     DB  ?
                CENTESIMO   DB  ?

                DIA_SEMANA  DB  ?
                ANO         DW  ?
                MES         DB  ?
                DIA         DB  ?  

                EXTERN DIGITOS:BYTE

DATA_SEG        ENDS

                END
