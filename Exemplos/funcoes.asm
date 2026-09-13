CODE_SEG        SEGMENT PUBLIC
                ASSUME  CS:CODE_SEG

; Esta rotina converte o byte em DL para hexa e imprime os
; dois digitos hexa na posicao corrente do cursor
;
; Entrada:   DL - Byte a ser convertido para hexa
; Usa:       IMP_DIG_HEXA
                PUBLIC  IMP_HEXA
IMP_HEXA        PROC    NEAR            ; Ponto de entrada
                PUSH    CX              ; Salva registradores usados
                PUSH    DX              ; nesta rotina
                MOV     DH, DL          ; Copia o byte
                MOV     CL, 4           ; Coloca nibble alto em DL
                SHR     DL, CL          
                CALL    IMP_DIG_HEXA    ; Imprime primeiro digito
                MOV     DL, DH          ; Nibble baixo para DL
                AND     DL, 0Fh         ; Remove nibble alto
                CALL    IMP_DIG_HEXA    ; Imprime segundo digito
                POP     DX              
                POP     CX              
                RET                     
IMP_HEXA        ENDP

; Esta rotina converte os 4 bits baixos de DL para um digito
; hexa e o imprime na tela
;
; Entrada:   DL - 4 bits baixos contem numero a ser impresso
; Usa:       IMP_CAR
                PUBLIC  IMP_DIG_HEXA
IMP_DIG_HEXA    PROC    NEAR
                PUSH    DX              ; Salva registradores usados
                CMP     DL, 10          ; O nibble < 10?
                JAE     LETRA_HEXA      ; Nao: converte para letra
                ADD     DL, '0'         ; Sim: converte para digito
                JMP     SHORT IMP_DIGITO
LETRA_HEXA:
                ADD     DL, 'A' - 10    ; Converte para letra hexa
IMP_DIGITO:
                CALL    IMP_CAR         ; Imprime letra na tela
                POP     DX              ; Restaura valor de DX
                RET                     
IMP_DIG_HEXA    ENDP

; Esta rotina imprime um caractere na tela usando a funcao
; de chamada do DOS
;
; Entrada:   DL - Byte a imprimir na tela
                PUBLIC  IMP_CAR
IMP_CAR         PROC    NEAR
                PUSH    AX              
                MOV     AH, 2           ; Chamada para saida de caractere
                INT     21h             ; Sai caractere no registrador DL
                POP     AX              ; Recupera antigo valor de AX
                RET                     ; E retorna
IMP_CAR         ENDP


; Esta rotina imprime um numero de 16 bits sem sinal em
; notacao decimal
;
; Entrada:   DX - N numero de 16 bits sem sinal
; Usa:       IMP_DIG_HEXA
                PUBLIC  IMP_DECIMAL
IMP_DECIMAL     PROC    NEAR
                PUSH    AX              ; Salva registradores usados
                PUSH    CX              
                PUSH    DX              
                PUSH    SI              
                MOV     AX, DX          
                MOV     SI, 10          ; Dividira por 10 usando SI
                XOR     CX, CX          ; Contador digitos na pilha
NAO_ZEHO:
                XOR     DX, DX          ; Zera palavra de N
                DIV     SI              ; Calcula N/10 e (N mod 10)
                PUSH    DX              ; Coloca um digito na pilha
                INC     CX              ; Mais um digito colocado
                OR      AX, AX          ; N ja igual a 0?
                JNE     NAO_ZEHO        ; Nao, continua
IMP_DIG_LOOP:
                POP     DX              ; Apanha os digitos em
                                        ; ordem contraria
                CALL    IMP_DIG_HEXA    
                LOOP    IMP_DIG_LOOP    
FIM_DECIMAL:
                POP     SI              
                POP     DX              
                POP     CX              
                POP     AX              
                RET                     
IMP_DECIMAL     ENDP


CODE_SEG        ENDS
                END
