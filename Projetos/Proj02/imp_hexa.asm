CODE_SEG        SEGMENT PUBLIC
                ASSUME  CS:CODE_SEG

		EXTRN   IMP_CAR:NEAR

; Esta rotina converte o byte em DL para hexa e imprime os
; dois digitos hexa na posicao corrente do cursor
;
; Entrada:   DL - Byte a ser convertido para hexa
; Usa:       IMP_DIG_HEXA

                PUBLIC  IMP_HEXA

IMP_HEXA        PROC    NEAR            ; Ponto de entrada

		PUSH	CX		; Salva registradores usados
		PUSH	DX		; nesta rotina

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
LETRA_HEXA:     ADD     DL, 'A'-10      ; Converte para letra hexa
IMP_DIGITO:     CALL    IMP_CAR         ; Imprime letra na tela

                POP     DX              ; Restaura valor de DX
                RET  
                   
IMP_DIG_HEXA    ENDP

CODE_SEG        ENDS
                END
