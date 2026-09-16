; Essas rotinas manipulam arquivos
;

FALSE   EQU     0
TRUE    EQU     1

CR      EQU     13      ;Retorno de carro
LF      EQU     10      ;Mudança de linha

CGROUP          GROUP   CODE_SEG, DATA_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

                EXTRN   IMP_STR:NEAR

;****************************************************************
; FILE_CREATE
; Esta rotina cria um arquivo.
;
; Entradas: FILE_NAME = Nome do arquivo
;           ATTR = atributo do arquivo
;
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;                       Variável HANDLE_IN = número do arquivo
;       - Se deu errado: Variável FILE_STATUS = 0
; Atributo: 00h-normal|01h-apenas leitura|02-oculto|04h-sistema
; OBS: Guardar em outra variável a variável HANDLE_IN quando 
; use mais de um arquivo.
;****************************************************************
                PUBLIC  FILE_CREATE

FILE_CREATE     PROC    NEAR
                PUSH    AX
                PUSH    CX
                PUSH    DX

	            LEA     DX,FILE_NAME    ;Aponta para o nome do arquivo
	            MOV     CX,ATTR		    ;Atributo
	            MOV     AH,3CH		    ;Função para criar um arquivo
	            INT     21H			    ;Chama a interrupção 21h
	            JC      FILE_CREATE_ERROR
                MOV     HANDLE_IN,AX
                MOV     AL,TRUE
                MOV     FILE_STATUS,AL
                JMP     FILE_CREATE_END
FILE_CREATE_ERROR:
                MOV     AL,FALSE
                MOV     FILE_STATUS,AL

FILE_CREATE_END:
                POP     DX
                POP     CX
                POP     AX
                RET                     ; E retorna
FILE_CREATE     ENDP
;----------------------------------------------------------------
; FIM FILE_CREATE
;----------------------------------------------------------------

;****************************************************************
; FILE_INSERT
; Esta rotina insere dados em um arquivo.
;
; Entradas: HANDLE_OUT = número do arquivo
;           LEN = Número de bytes
;           TEXTO = dados a inserir
;
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;                       Variável HANDLE_IN = número do arquivo
;       - Se deu errado: Variável FILE_STATUS = 0
; Atributo: 00h-normal|01h-apenas leitura|02-oculto|04h-sistema
; OBS: Guardar em outra variável a variável HANDLE_IN quando 
; use mais de um arquivo.
;****************************************************************
                PUBLIC  FILE_INSERT

FILE_INSERT     PROC    NEAR
                PUSH    AX
                PUSH    CX
                PUSH    DX

                MOV     BX,HANDLE_OUT
                MOV     CX,LEN
                LEA     DX,TEXTO
                MOV     AH,40H
                INT     21H
                JC      FILE_INSERT_ERROR
                MOV     AL,TRUE
                MOV     FILE_STATUS,AL
                JMP     FILE_INSERT_END
FILE_INSERT_ERROR:
                MOV     AL,FALSE
                MOV     FILE_STATUS,AL

FILE_INSERT_END:
                POP     DX
                POP     CX
                POP     AX
                RET                     ; E retorna
FILE_INSERT     ENDP
;----------------------------------------------------------------
; FIM FILE_CREATE
;----------------------------------------------------------------


;****************************************************************
; FILE_CLOSE
; Esta rotina fecha um arquivo.
;
; Entradas: HANDLE_OUT = número do arquivo
;
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;       - Se deu errado: Variável FILE_STATUS = 0
;****************************************************************
                PUBLIC  FILE_CLOSE

FILE_CLOSE      PROC    NEAR
                PUSH    AX
                PUSH    BX
                PUSH    DX

	            MOV     BX,HANDLE_OUT   ;Recebe o HANDLE_OUT do arquivo
	            MOV     AH,3EH		    ;Função para fechar um arquivo
	            INT     21H			    ;Chama a interrupção 21h
	            JC      FILE_CLOSE_ERROR
                MOV     AL,TRUE
                MOV     FILE_STATUS,AL                
                JMP     FILE_CLOSE_END
FILE_CLOSE_ERROR:
                MOV     AL,FALSE
                MOV     FILE_STATUS,AL

FILE_CLOSE_END:
                POP     DX
                POP     BX
                POP     AX
                RET                     ; E retorna
FILE_CLOSE      ENDP
;----------------------------------------------------------------
; FIM FILE_CLOSE
;----------------------------------------------------------------

CODE_SEG        ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************
                PUBLIC  FILE_STATUS, HANDLE_IN

DATA_SEG        SEGMENT PUBLIC
                EXTERN ATTR:WORD        ;Recebe a variável externa
                EXTERN FILE_NAME:BYTE   ;Recebe a variável externa
                HANDLE_IN  DW  ?
                EXTERN HANDLE_OUT:WORD  ;Recebe a variável externa
                EXTERN TEXTO:BYTE       ;Recebe a variável externa
                EXTERN LEN:BYTE         ;Recebe a variável externa
                FILE_STATUS DB ?
DATA_SEG        ENDS

                END
