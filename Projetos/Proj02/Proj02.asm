;----------------------------------------------------
; Mostra o conteúdo do PSP de um arquivo
; para compilar:
; $ NMAKE
; Autor: Eng. Fabrício Ribeiro
; Para testar digite:
; $Proj02 A B C D
; No endereço:
; 80h - número de bytes digitados, inclusive os espaços
; 82h - A | 84 - B | 86 - C | 88 - D
; O último sempre termina com 0D -> Tecla ENTER
;----------------------------------------------------

CR      EQU     13      ;Retorno de carro
LF      EQU     10      ;Mudança de linha

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        ORG     100h

	;Carrega funções externas
        EXTRN   IMP_HEXA:NEAR
        EXTRN   IMP_CAR:NEAR
	EXTRN	IMP_STR:NEAR
        EXTRN   ENVIA_CRLF:NEAR
;...........................
; Programa principal
;...........................
MAIN	PROC NEAR

        ;Imprime o PSP
        LEA     DX,MSG1
        CALL    IMP_STR

        MOV     SI,00H
        MOV     AX,0000H
        MOV     DH,16   ;Número de linhas 16
PRINT2: XOR     CX,CX
        MOV     CX,16   ;Número de colunas 16
        MOV     DL,AH
        CALL    IMP_HEXA
        MOV     DL,AL
        CALL    IMP_HEXA
        MOV     DL,' '
        CALL    IMP_CAR
        MOV     DL,'-'
        CALL    IMP_CAR
        MOV     DL,' '
        CALL    IMP_CAR                                
PRINT1: MOV     DL,BYTE PTR[SI]
        CALL    IMP_HEXA
        MOV     DL,' '
        CALL    IMP_CAR
        INC     SI
        INC     AX
        LOOP    PRINT1
        CALL    ENVIA_CRLF
        DEC     DH
        JNZ     PRINT2

SAI_DOS:
        ;Sai e retorna ao MSDOS
	MOV     AH,4CH
	INT     21H

MAIN 	ENDP

CODE_SEG	ENDS

DATA_SEG       SEGMENT PUBLIC
        MSG1 DB '### PSP:',CR,LF,'$'
        MSG2 DB '### CONTEUDO:',CR,LF,'$'
DATA_SEG       ENDS

        END     MAIN
