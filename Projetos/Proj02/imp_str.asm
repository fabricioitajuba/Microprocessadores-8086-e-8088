; Esta rotina imprime uma string na tela usando a funcao
; de chamada do DOS
;
; Entrada:   DX - Endereço base da string
; 
; Exemplo de uso:
; LEA DX,STRING
; CALL IMP_STR

CR      EQU     13      ;Retorno de carro
LF      EQU     10      ;Mudança de linha

CODE_SEG        SEGMENT PUBLIC
                ASSUME  CS:CODE_SEG

                PUBLIC  IMP_STR

IMP_STR         PROC    NEAR

                PUSH    AX   
                PUSH    DX

                MOV     AH,09H          ; Chamada para impressão de string
                INT     21h             ; apontada por DX

                POP     DX              ; Recupera valores de AX e DX
                POP     AX              ; Recupera antigo valor de AX
                RET                     ; E retorna

IMP_STR         ENDP

CODE_SEG        ENDS
                END
