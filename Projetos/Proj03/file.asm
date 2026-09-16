; Essas rotinas manipulam arquivos
;

CR      EQU     13      ;Retorno de carro
LF      EQU     10      ;Mudança de linha

CGROUP          GROUP   CODE_SEG, DATA_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

                EXTRN   IMP_STR:NEAR

;****************************************************************
; FILE_CREATE
; Esta rotina cria um arquivo definido por FILE_NAME
; Se der certo, retorna na variável HANDLE o número do arquivo
;****************************************************************
                PUBLIC  FILE_CREATE

FILE_CREATE     PROC    NEAR
                PUSH    AX
                PUSH    CX
                PUSH    DX
        
	            LEA     DX,FILE_NAME    ;Aponta para o nome do arquivo
	            MOV     CX,0		    ;Atributo normal (sem oculto ou somente leitura)
	            MOV     AH,3CH		    ;Função para criar um arquivo
	            INT     21H			    ;Chama a interrupção 21h
	            JC      FILE_CREATE_ERROR
	            MOV     HANDLE,AX
                JMP     FILE_CREATE_END
FILE_CREATE_ERROR:
                LEA     DX,FILE_MSG_ERROR_CREATE
                CALL    IMP_STR
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
; FILE_CLOSE
; Esta rotina fecha um arquivo, através da variável HANDLE
;****************************************************************
                PUBLIC  FILE_CLOSE

FILE_CLOSE      PROC    NEAR
                PUSH    AX
                PUSH    BX
                PUSH    DX

	            MOV     BX,HANDLE       ;Recebe o HANDLE do arquivo
	            MOV     AH,3EH		    ;Função para fechar um arquivo
	            INT     21H			    ;Chama a interrupção 21h
	            JC      FILE_CLOSE_ERROR
                JMP     FILE_CLOSE_END
FILE_CLOSE_ERROR:
                LEA     DX,FILE_MSG_ERROR_CLOSE
                CALL    IMP_STR
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
DATA_SEG        SEGMENT PUBLIC
                ;PUBLIC  FILE_NAME, HANDLE, FILE_MSG_ERROR_CREATE,FILE_MSG_ERROR_CLOSE
                FILE_NAME DB 'texto.txt',0
                HANDLE  DW  ?
                FILE_MSG_ERROR_CREATE DB 'Erro ao criar o arquivo!',CR,LF,'$'
                FILE_MSG_ERROR_CLOSE DB 'Erro ao fechar o arquivo!',CR,LF,'$'
DATA_SEG        ENDS

                END
