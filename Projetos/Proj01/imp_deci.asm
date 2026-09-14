; Esta rotina imprime um numero de 16 bits sem sinal em
; notacao decimal
;
; Entrada:   DX - N numero de 16 bits sem sinal
; Usa:       IMP_DIG_HEXA

		EXTRN   IMP_DIG_HEXA:NEAR

CODE_SEG        SEGMENT PUBLIC
                ASSUME  CS:CODE_SEG

                PUBLIC  IMP_DECIMAL

IMP_DECIMAL     PROC    NEAR

                PUSH    AX              ; Salva registradores usados
                PUSH    CX              
                PUSH    DX              
                PUSH    SI  
            
                MOV     AX, DX          
                MOV     SI, 10          ; Dividira por 10 usando SI
                XOR     CX, CX          ; Contador digitos na pilha
NAO_ZEHO:       XOR     DX, DX          ; Zera palavra de N
                DIV     SI              ; Calcula N/10 e (N mod 10)
                PUSH    DX              ; Coloca um digito na pilha
                INC     CX              ; Mais um digito colocado
                OR      AX, AX          ; N ja igual a 0?
                JNE     NAO_ZEHO        ; Nao, continua
IMP_DIG_LOOP:   POP     DX              ; Apanha os digitos em
                CALL    IMP_DIG_HEXA    ; ordem contraria                
                LOOP    IMP_DIG_LOOP   
 
FIM_DECIMAL:    POP     SI              
                POP     DX              
                POP     CX              
                POP     AX              
                RET       
              
IMP_DECIMAL     ENDP

CODE_SEG        ENDS
                END
