;****************************************************************
; Essas rotinas manipulam strings
;
; CAR_PRINT - Imprime um caracter na tela;

;****************************************************************

CGROUP          GROUP   CODE_SEG, DATA_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

                INCLUDE CONST.INC

;****************************************************************
; GET_TIME
; Esta rotina recebe o valor da hora atual
;
; Saídas: 
; CH - Horas (0-23) | CL - Minutos (00-59) | CL - Minutos (00-59)
; DL - CENTÉSIMOS (00-99)
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

                POP     DX
                POP     CX
                POP     AX
                RET

GET_TIME       ENDP                

;----------------------------------------------------------------
; FIM GET_TIME
;----------------------------------------------------------------





CODE_SEG        ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************
                PUBLIC HORA, MINUTO, SEGUNDO, CENTESIMO

DATA_SEG        SEGMENT PUBLIC

                HORA        DB  ?
                MINUTO      DB  ?
                SEGUNDO     DB ?
                CENTESIMO   DB ?

DATA_SEG        ENDS

                END
