;*************************************************************************
; Essas rotinas manipulam arquivos
;
; FILE_CREATE  - Cria um arquivo;
; FILE_INSERT  - Insere dados em um arquivo;
; FILE_APPEND  - Abre um arquivo já criado para leitura ou escrita
; FILE_POINTER - Posiciona o PONTEIRO do arquivo para gravação ou leitura
; FILE_CLOSE   - Fecha um arquivo.
;*************************************************************************


CGROUP          GROUP   CODE_SEG, DATA_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

                INCLUDE CONST.INC

;****************************************************************
; FILE_CREATE
; Esta rotina cria um arquivo.
;
; Entradas: FILE_NAME = Nome do arquivo
;           ATTR = atributo do arquivo
;
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;                       Variável HANDLE_OUT = número do arquivo
;       - Se deu errado: Variável FILE_STATUS = 0
; Atributo: 00h-normal|01h-apenas leitura|02-oculto|04h-sistema
;
; OBS: Guardar em outra variável a variável HANDLE_OUT quando 
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
                MOV     HANDLE_OUT,AX
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
                RET 

FILE_CREATE     ENDP
;----------------------------------------------------------------
; FIM FILE_CREATE
;----------------------------------------------------------------

;****************************************************************
; FILE_INSERT
; Esta rotina insere dados em um arquivo já criado.
;
; Entradas: HANDLE_IN = número do arquivo
;           LEN = Número de bytes
;           TEXTO = dados a inserir
;
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;
;       - Se deu errado: Variável FILE_STATUS = 0
;
; Atributo: 00h-normal|01h-apenas leitura|02-oculto|04h-sistema
;****************************************************************

                PUBLIC  FILE_INSERT

FILE_INSERT     PROC    NEAR

                PUSH    AX
                PUSH    BX
                PUSH    CX
                PUSH    DX

                MOV     BX,HANDLE_IN
                MOV     CX,BUFFER_WRITE_LEN
                LEA     DX,BUFFER_WRITE
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
                POP     BX
                POP     AX
                RET

FILE_INSERT     ENDP
;----------------------------------------------------------------
; FIM FILE_INSERT
;----------------------------------------------------------------

;****************************************************************
; FILE_APPEND
; Esta rotina abre um arquivo já criado para leitura ou escrita
;
; Entradas: FILE_MODE = Modo de acesso
;           FILE_NAME = Nome do arquivo
;
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;                       Variável HANDLE_OUT = número do arquivo
;       - Se deu errado: Variável FILE_STATUS = 0
;
; Modo de acesso: 0=Leitura|1=escrita|2=leitura e escrita
; OBS: Guardar em outra variável a variável HANDLE_OUT quando 
; use mais de um arquivo.
;****************************************************************

                PUBLIC  FILE_APPEND

FILE_APPEND     PROC    NEAR

                PUSH    AX
                PUSH    DX

                MOV     AL, FILE_MODE
                LEA     DX, FILE_NAME
                MOV     AH, 3DH
                INT     21H
                JC      FILE_APPEND_ERROR
                MOV     HANDLE_OUT,AX
                MOV     AL,TRUE
                MOV     FILE_STATUS,AL
                JMP     FILE_APPEND_END
FILE_APPEND_ERROR:
                MOV     AL,FALSE
                MOV     FILE_STATUS,AL

FILE_APPEND_END:
                POP     DX
                POP     AX
                RET

FILE_APPEND     ENDP
;----------------------------------------------------------------
; FIM FILE_APPEND
;----------------------------------------------------------------

;****************************************************************
; FILE_POINTER
; Esta rotina posiciona o PONTEIRO do arquivo para gravação ou leitura
;
; Entradas: FILE_ORIGIN = 0 - Início do arquivo OFFSET +       - SEET_SET
;                         1 - Localização corrente do OFFSET + - SEEK_CUR
;                         2 - Fim do arquivo OFFSET +          - SEEK_END
;           HANDLE_IN = número do arquivo
;           FILE_NBYTES_H = Deslocamento de bytes MSB
;           FILE_NBYTES_L = Deslocamento de bytes LSB
;
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;                       Variável HANDLE_IN = número do arquivo
;       - Se deu errado: Variável FILE_STATUS = 0
;
;****************************************************************

                PUBLIC  FILE_POINTER

FILE_POINTER    PROC    NEAR

                PUSH    AX
                PUSH    BX
                PUSH    CX
                PUSH    DX

                MOV     AL, FILE_ORIGIN
                MOV     BX, HANDLE_IN
                MOV     CX, FILE_NBYTES_H
                MOV     DX, FILE_NBYTES_L
                MOV     AH, 42H
                INT     21H

                JC      FILE_POINTER_ERROR
                MOV     AL, TRUE
                MOV     FILE_STATUS, AL
                JMP     FILE_POINTER_END
FILE_POINTER_ERROR:
                MOV     AL, FALSE
                MOV     FILE_STATUS, AL

FILE_POINTER_END:
                POP     DX
                POP     CX
                POP     BX
                POP     AX
                RET

FILE_POINTER    ENDP
;----------------------------------------------------------------
; FIM FILE_POINTER
;----------------------------------------------------------------

;****************************************************************
; FILE_READ
; Esta rotina faz a leitura de um arquivo.
;
; Entradas: HANDLE_IN = número do arquivo
;           BUFFER_READ_LEN = tamanho do buffer de leitura
;           BUFFER_READ = ponteiro do buffer de leitura
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;       - Se deu errado: Variável FILE_STATUS = 0
;****************************************************************

                PUBLIC  FILE_READ

FILE_READ       PROC    NEAR

                PUSH    AX
                PUSH    BX
                PUSH    CX
                PUSH    DX

                MOV     BX, HANDLE_IN       ;Recebe o HANDLE_OUT do arquivo
                MOV     CX, BUFFER_READ_LEN
                LEA     DX, BUFFER_READ
                MOV     AH, 3FH             ;Função para fechar um arquivo
                INT     21H                 ;Chama a interrupção 21h
                JC      FILE_READ_ERROR
                MOV     AL, TRUE
                MOV     FILE_STATUS, AL                
                JMP     FILE_READ_END
FILE_READ_ERROR:
                MOV     AL, FALSE
                MOV     FILE_STATUS, AL

FILE_READ_END:
                POP     DX
                POP     CX
                POP     BX
                POP     AX
                RET

FILE_READ      ENDP
;----------------------------------------------------------------
; FIM FILE_READ
;----------------------------------------------------------------

;****************************************************************
; FILE_CLOSE
; Esta rotina fecha um arquivo.
;
; Entradas: HANDLE_IN = número do arquivo
;
; Saídas: 
;       - Se deu certo: Variável FILE_STATUS = 1
;       - Se deu errado: Variável FILE_STATUS = 0
;****************************************************************

                PUBLIC  FILE_CLOSE

FILE_CLOSE      PROC    NEAR

                PUSH    AX
                PUSH    BX

	            MOV     BX, HANDLE_IN   ;Recebe o HANDLE_OUT do arquivo
	            MOV     AH, 3EH		    ;Função para fechar um arquivo
	            INT     21H			    ;Chama a interrupção 21h
	            JC      FILE_CLOSE_ERROR
                MOV     AL, TRUE
                MOV     FILE_STATUS, AL                
                JMP     FILE_CLOSE_END
FILE_CLOSE_ERROR:
                MOV     AL, FALSE
                MOV     FILE_STATUS, AL

FILE_CLOSE_END:
                POP     BX
                POP     AX
                RET

FILE_CLOSE      ENDP
;----------------------------------------------------------------
; FIM FILE_CLOSE
;----------------------------------------------------------------

CODE_SEG        ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************
                PUBLIC  FILE_STATUS, HANDLE_OUT

DATA_SEG        SEGMENT PUBLIC

                HANDLE_OUT DW ?
                FILE_STATUS DB ?

                ;Recebe a variável externa
                EXTERN ATTR:WORD
                EXTERN FILE_NAME:BYTE
                EXTERN HANDLE_IN:WORD
                EXTERN FILE_ORIGIN:BYTE
                EXTERN FILE_NBYTES_H:WORD
                EXTERN FILE_NBYTES_L:WORD
                EXTERN FILE_MODE:BYTE
                
                EXTERN BUFFER_WRITE:BYTE
                EXTERN BUFFER_WRITE_LEN:WORD
                EXTERN BUFFER_READ:BYTE
                EXTERN BUFFER_READ_LEN:WORD

DATA_SEG        ENDS

                END
