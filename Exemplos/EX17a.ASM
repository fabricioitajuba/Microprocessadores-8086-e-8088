;----------------------------------------------
; EX17a.asm - Usando funções externas
; Autor: Eng. Fabrício Ribeiro
; para compilar:
; masm ex17a.asm;
; masm funcoes.asm;
; link ex17a funcoes;
; exe2bin ex17a ex17a.com
;----------------------------------------------
CODE_SEG    SEGMENT PUBLIC
    ASSUME  CS:CODE_SEG
    ORG CS:CODE_SEG
    ORG 100h

    EXTRN   IMP_CAR:NEAR
    EXTRN   IMP_HEXA:NEAR
    EXTRN   IMP_DECIMAL:NEAR

TESTE_IMP_DECIMAL PROC  NEAR
    
    ;Imprime caracter
    MOV DL,'A'
    CALL IMP_CAR

    MOV DL,' '
    CALL IMP_CAR

    ;Imprime um número em hexadecimal
    MOV DL,0FAH
    CALL IMP_HEXA

    MOV DL,' '
    CALL IMP_CAR

    ;Imprime um número em decimal
    MOV DX,3039H
    CALL IMP_DECIMAL

    ; Retorna ao DOS     
    MOV AH,04CH
	INT 21H

TESTE_IMP_DECIMAL ENDP

CODE_SEG ENDS

END TESTE_IMP_DECIMAL