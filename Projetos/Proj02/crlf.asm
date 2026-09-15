;.......................................................
; Esta rotina envia um par CR/LF para o video,
; usando as rotinas do DOS para que a tela seja
; passada corretamente
; Usa:       IMP_CAR
;.......................................................

CR      EQU     13      ;Retorno de carro
LF      EQU     10      ;Mudança de linha

CODE_SEG        SEGMENT PUBLIC
                ASSUME  CS:CODE_SEG

		EXTRN   IMP_CAR:NEAR

                PUBLIC  ENVIA_CRLF

ENVIA_CRLF      PROC    NEAR

                PUSH    AX
                PUSH    DX

                MOV     DL,CR
                CALL	IMP_CAR
                MOV     DL,LF
                CALL	IMP_CAR

                POP     DX
                POP     AX
                RET

ENVIA_CRLF      ENDP

CODE_SEG        ENDS
                END
