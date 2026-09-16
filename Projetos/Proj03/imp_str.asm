; Esta rotina imprime uma string na tela usando a funcao
; de chamada do DOS
;
; Entrada:   DX - Endereço base da string
; 
; Exemplo de uso:
; LEA DX,STRING
; CALL IMP_STR

CGROUP          GROUP   CODE_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

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
