; Esta rotina imprime um caractere na tela usando a funcao
; de chamada do DOS
;
; Entrada:   DL - Byte a imprimir na tela

CODE_SEG        SEGMENT PUBLIC
                ASSUME  CS:CODE_SEG

                PUBLIC  IMP_CAR

IMP_CAR         PROC    NEAR

                PUSH    AX   
                PUSH    DX

IMPRESSO:       MOV     AH, 2           ; Chamada para saida de caractere
                INT     21h             ; Sai caractere no registrador DL

                POP     DX              ; Recupera valores de AX e DX
                POP     AX              ; Recupera antigo valor de AX
                RET                     ; E retorna

IMP_CAR         ENDP

CODE_SEG        ENDS
                END
