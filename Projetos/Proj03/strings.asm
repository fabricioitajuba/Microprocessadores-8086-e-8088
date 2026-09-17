;****************************************************************
; Essas rotinas manipulam strings
;
; STR_PRINT - Imprime uma string na tela;
; STR_LEN - Calcula o número de bytes de uma string;
;****************************************************************

CGROUP          GROUP   CODE_SEG, DATA_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

;****************************************************************
; STR_PRINT
; Esta rotina imprime uma string na tela
; Entrada:   DX - Endereço base da string
;****************************************************************

                PUBLIC  STR_PRINT

STR_PRINT       PROC    NEAR

                PUSH    AX   
                PUSH    DX

                MOV     AH,09H          ; Chamada para impressão de string
                INT     21h             ; apontada por DX

                POP     DX              ; Recupera valores de AX e DX
                POP     AX              ; Recupera antigo valor de AX
                RET                     ; E retorna

STR_PRINT       ENDP

;----------------------------------------------------------------
; FIM FILE_CLOSE
;----------------------------------------------------------------

;****************************************************************
; STR_LEN
; Esta rotina calcula o número de bytes de uma string
; Entrada: TEXTO - ponteiro da string
; Saída: STR_LENGHT - número de bytes da string
;****************************************************************

                PUBLIC  STR_LEN

STR_LEN         PROC    NEAR

                PUSH    AX
                PUSH    CX
                PUSH    SI
                PUSH    DI

                LEA     DI, TEXTO       ;Salva o endereço inicial em SI
                MOV     SI, DI          ;para calcular a diferença depois
                MOV     CX, 0FFFFH      ;Carrega o maior valor possível em 16-bits
                MOV     AL,'$'          ;Procura pelo terminador '$' (mude para 0 se usar string ASCIIZ)
                CLD                     ;Limpa o Direction Flag (DF=0) para avançar o ponteiro DI para a direita
                REPNZ   SCASB           ;Busca o caractere AL na string enquanto não encontrar (ZF=0) e CX > 0
                SUB     DI, SI          ;DI = DI - SI (Diferença de bytes entre os ponteiros)
                DEC     DI              ;Subtrai 1 para desconsiderar o próprio caractere '$'
                MOV     STR_LENGHT, DI  ;Move o tamanho final para LEN

                POP     DI
                POP     SI
                POP     CX
                POP     AX
                RET

STR_LEN         ENDP
;----------------------------------------------------------------
; FIM STR_LEN
;----------------------------------------------------------------

CODE_SEG        ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************
                PUBLIC STR_LENGHT

DATA_SEG        SEGMENT PUBLIC

                STR_LENGHT  DW  ?
                EXTERN TEXTO:BYTE   ;Recebe a variável externa
                
DATA_SEG        ENDS

                END
