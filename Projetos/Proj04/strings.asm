;****************************************************************
; Essas rotinas manipulam strings
;
; CAR_PRINT - Imprime um caracter na tela;
; STR_PRINT - Imprime uma string na tela;
; STR_LEN - Calcula o número de bytes de uma string;
; STR_CMP - Compara duas strings;
;****************************************************************

CGROUP          GROUP   CODE_SEG, DATA_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

                INCLUDE CONST.INC

;****************************************************************
; CAR_PRINT
; Esta rotina imprime uma caracter na tela
; Entrada: DL - Código ASCII do caracter
;****************************************************************

                PUBLIC  CAR_PRINT

CAR_PRINT       PROC    NEAR

                PUSH    AX   
                PUSH    DX

IMPRESSO:       MOV     AH, 02H
                INT     21h

                POP     DX
                POP     AX
                RET

CAR_PRINT       ENDP                

;----------------------------------------------------------------
; FIM CAR_PRINT
;----------------------------------------------------------------

;****************************************************************
; STR_PRINT
; Esta rotina imprime uma string na tela
; Entrada: DX - Endereço base da string
;****************************************************************

                PUBLIC  STR_PRINT

STR_PRINT       PROC    NEAR

                PUSH    AX   
                PUSH    DX

                MOV     AH, 09H
                INT     21h

                POP     DX
                POP     AX
                RET

STR_PRINT       ENDP

;----------------------------------------------------------------
; FIM FILE_CLOSE
;----------------------------------------------------------------

;****************************************************************
; STR_LEN
; Esta rotina calcula o número de bytes de uma string
; Entrada: TEXTO - ponteiro da string
; Saída:   STR_LENGHT - número de bytes da string
;****************************************************************

                PUBLIC  STR_LEN

STR_LEN         PROC    NEAR

                PUSH    AX
                PUSH    CX
                PUSH    SI
                PUSH    DI

                LEA     DI, TEXTO
                MOV     SI, DI
                MOV     CX, 0FFFFH
                MOV     AL,'$'
                CLD
                REPNZ   SCASB
                SUB     DI, SI
                DEC     DI
                MOV     STR_LENGHT, DI

                POP     DI
                POP     SI
                POP     CX
                POP     AX
                RET

STR_LEN         ENDP
;----------------------------------------------------------------
; FIM STR_LEN
;----------------------------------------------------------------

;****************************************************************
; STR_CMP
; Esta rotina compara 2 strings e colona na variável STR_COMPARE
; o resultado da comparação.
;
; Entradas: STRING1 - ponteiro da string1
;           STRING2 - ponteiro da string2
; Saída:    STR_LENGHT - |0-diferentes|1-iguais|
;****************************************************************

                PUBLIC  STR_CMP

STR_CMP         PROC    NEAR

                PUSH    AX
                PUSH    SI
                PUSH    DI

                LEA     SI, STRING1
                LEA     DI, STRING2

STR_CMP_INI:    MOV     AH, [SI]
                MOV     AL, [DI]

                CMP     AH, AL
                JNE     STR_CMP_RET_FALSE
                CMP     AH, '$'
                JE      STR_CMP_RET_TRUE
                INC     SI
                INC     DI
                JMP     STR_CMP_INI                

STR_CMP_RET_TRUE:
                MOV     AL, TRUE
                MOV     STR_COMPARE, AL
                JMP     STR_CMP_END

STR_CMP_RET_FALSE:
                MOV     AL, FALSE
                MOV     STR_COMPARE, AL

STR_CMP_END:    POP     DI
                POP     SI
                POP     AX
                RET

STR_CMP         ENDP
;----------------------------------------------------------------
; FIM STR_LEN
;----------------------------------------------------------------

CODE_SEG        ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************
                PUBLIC STR_LENGHT, STR_COMPARE

DATA_SEG        SEGMENT PUBLIC

                STR_LENGHT  DW  ?
                STR_COMPARE  DB  ?
                EXTERN STRING1:BYTE
                EXTERN STRING2:BYTE
                EXTERN TEXTO:BYTE   ;Recebe a variável externa
                EXTERN CAR:BYTE     ;Recebe a variável externa
                
DATA_SEG        ENDS

                END
