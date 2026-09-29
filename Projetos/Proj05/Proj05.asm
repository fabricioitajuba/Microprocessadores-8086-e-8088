;----------------------------------------------------
; Proj05.asm - CRUD
; para compilar:
; $ NMAKE
; $ exe2bin proj05 proj05.com
; Autor: Eng. Fabrício Ribeiro
; Etapas: 
; Create - Concluído
; Read   - implementando
; Update - Não implementado
; Delete - Concluído
; Lista  - Concluído
;----------------------------------------------------

BUFFER_READ_SIZE        EQU     64      ;Buffer de leitura
BUFFER_WRITE_SIZE       EQU     64      ;Buffer de escrita

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        INCLUDE CONST.INC

        ORG     100h

	;Carrega funções externas
        EXTRN   CAR_READ:NEAR
        EXTRN   CAR_PRINT:NEAR
        EXTRN   STR_PRINT:NEAR

        EXTRN   GET_TIME:NEAR
        EXTRN   GET_DATA:NEAR

        EXTRN   CLR_SCREEN:NEAR
        EXTRN   HEXA2DECIMAL16:NEAR
        EXTRN   STRING_DECIMAL:NEAR

        EXTRN   FILE_CREATE:NEAR
        EXTRN   FILE_INSERT:NEAR
        EXTRN   FILE_APPEND:NEAR
        EXTRN   FILE_POINTER:NEAR
        EXTRN   FILE_READ:NEAR
        EXTRN   FILE_CLOSE:NEAR

;****************************************************************
; Programa principal
;****************************************************************
MAIN	PROC NEAR
        
        ;Tenta abrir o arquivo REGISTRO.TXT para ESCRITA e LEITURA
        ;Caso não exista, será criado.
        MOV     AL, 2
        MOV     FILE_MODE, AL
        CALL    FILE_APPEND
        MOV     AL, FILE_STATUS
        CMP     AL, TRUE      
        JE      INICIO_PROGRAMA

        ;Cria o arquivo
        MOV     AX, 0
        MOV     ATTR, AX
        CALL    FILE_CREATE
        MOV     AL, FILE_STATUS
        CMP     AL, FALSE
        MOV     AX, 0           ;Zera o contador
        MOV     ID, AX          ;de registros.
        JE      SAI_DOS      

INICIO_PROGRAMA:

        ;Calcula do tamanho de bytes do arquivo lido
        MOV     AL, 02H
        MOV     FILE_ORIGIN, AL
        MOV     AX, HANDLE_OUT
        MOV     HANDLE_IN, AX
        MOV     AX, 0000h
        MOV     FILE_NBYTES_H, AX
        MOV     FILE_NBYTES_L, AX
        CALL    FILE_POINTER
        MOV     AL, FILE_STATUS
        CMP     AL, FALSE
        JE      SAI_DOS

        MOV     AX, FILE_NUM_BYTES_L
        MOV     NUM_BYTES, AX   ;Guarda auantidade de bytes do arquivo.
        MOV     BL, 64          ;Calcula a
        DIV     BL              ;Quantidade de registros.
        MOV     ID, AX          ;Guarda a quantidade de registros.

        CALL    CLR_SCREEN      ;Limpa a tela


        LEA     DX, CRUD_MSG_INI1
        CALL    STR_PRINT
        LEA     DX, CRUD_MSG_INI2
        CALL    STR_PRINT
        LEA     DX, CRUD_MSG_INI1
        CALL    STR_PRINT

        ;******************************
        ;MENU
        ;******************************
        LEA     DX, CRUD_MSG_INI3
        CALL    STR_PRINT                        

        CALL    CAR_READ         ;Faz a leitura de uma tecla
        MOV     DL, AL
        CALL    CAR_PRINT        ;Mostra a tela pressionada
        CMP     AL,'C'
        JE      CRUD_CREATE
        CMP     AL,'R'
        JE      CRUD_READ
        CMP     AL,'D'
        JE      CRUD_DELETE        
        CMP     AL,'L'
        JE      CRUD_LIST_ALL
        CMP     AL,'Q'
        JE      SAI_DOS
              
        JMP     INICIO_PROGRAMA


;*******************************************************
; CREATE - Cria um registro
;*******************************************************
CRUD_CREATE:
        LEA     DX, CRUD_MSG_CREATE
        CALL    STR_PRINT

        LEA     DX, CRUD_MSG_CREATE_NOME
        CALL    STR_PRINT
        
	LEA     DX, NOME_LEN    ;Lê NOME
	MOV     AH, 0AH
	INT     21H

        LEA     DX, CRUD_MSG_CREATE_IDADE
        CALL    STR_PRINT

	LEA     DX, IDADE_LEN   ;Lê IDADE
	MOV     AH, 0AH
	INT     21H

        ;Prepara os dados que serão inseridos

        ;Limpa o registro
        CALL    REGISTRO_CLEAR   

        ;Incrementa o ID
        INC     WORD PTR [ID]
        MOV     AX, ID
        CALL    HEXA2DECIMAL16

        ;Copia o ID para o registro
        LEA     SI, DIGITOS+2
        LEA     DI, REG_ID
        XOR     CX, CX
        MOV     CL, 3
        CLD
        REP     MOVSB

        ;Adiciona Data
        CALL    GET_DATA
        LEA     SI, TIME_DATA
        LEA     DI, REG_DATA
        XOR     CX, CX
        MOV     CL, 10
        CLD
        REP     MOVSB

        ;Adiciona Hora
        CALL    GET_TIME
        LEA     SI, TIME_HORA
        LEA     DI, REG_HORA
        XOR     CX, CX
        MOV     CL, 8
        CLD
        REP     MOVSB

        ;Copia o nome para o registro
        LEA     SI, NOME
        LEA     DI, REG_NOME
        XOR     CX, CX
        MOV     CL, NOME_LEN_ACT
        CLD
        REP     MOVSB

        ;Copia a idade para o registro
        LEA     SI, IDADE
        LEA     DI, REG_IDADE
        XOR     CX, CX
        MOV     CL, IDADE_LEN_ACT
        CLD
        REP     MOVSB

        ;Posiciona o ponteiro do arquivo no final do arquivo
        MOV     AL, 02H
        MOV     FILE_ORIGIN, AL
        MOV     AX, HANDLE_OUT
        MOV     HANDLE_IN, AX
        MOV     AX, 0000h
        MOV     FILE_NBYTES_H, AX
        MOV     FILE_NBYTES_L, AX
        CALL    FILE_POINTER
        MOV     AL, FILE_STATUS
        CMP     AL, FALSE
        JE      SAI_DOS

        ;Insere dados no arquivo        
        MOV     AX, BUFFER_WRITE_SIZE
        MOV     BUFFER_WRITE_LEN, AX
        MOV     AX, HANDLE_OUT
        MOV     HANDLE_IN, AX
        CALL    FILE_INSERT
        MOV     AL, FILE_STATUS
        CMP     AL, FALSE
        JE      SAI_DOS

        LEA     DX, CRUD_MSG_CREATE_SUCESSO
        CALL    STR_PRINT

        ADD     WORD PTR [NUM_BYTES], 64        ;Calcula o número de bytes do arquivo.

        ;Mostra o novo número de bytes arquivo
        LEA     DX, CRUD_MSG_TOTAL_BYTES
        CALL    STR_PRINT
        MOV     AX, NUM_BYTES
        CALL    HEXA2DECIMAL16
        LEA     DX, DIGITOS
        CALL    STR_PRINT
      
        ;Mostra o tamanho de registros
        LEA     DX, CRUD_MSG_TOTAL_REGISTROS
        CALL    STR_PRINT
        MOV     AX, ID
        CALL    HEXA2DECIMAL16
        LEA     DX, DIGITOS
        CALL    STR_PRINT

        CALL    CAR_READ                        ;Faz a leitura de uma tecla <<<< TESTE        

        JMP     INICIO_PROGRAMA
;-------------------------------------------------------
; FIM CREATE
;-------------------------------------------------------

;*******************************************************
; CRUD_READ - Lê um registro
;*******************************************************
CRUD_READ:
        LEA     DX, CRUD_READ_MSG1
        CALL    STR_PRINT

        LEA     DX, CRUD_READ_MSG2
        CALL    STR_PRINT

	LEA     DX, REGISTRO_LEN        ;Lê REGISTRO
	MOV     AH, 0AH
	INT     21H

;Implementar
        ;Limpa o buffer do registro
        MOV    SI, 0
        MOV    AL, '$'
;        XOR     CX, CX
;        MOV     CX, 3
;  CRUD_READ_LOOP2:        
;        MOV     REG_BUFFER[SI], AL
;        INC     SI
;        LOOP    CRUD_READ_LOOP2

;        ;Move a String digitada para o buffer
;        LEA     SI, REGISTRO
;        LEA     DI, REG_BUFFER
;        XOR     CX, CX
;        MOV     CL, REGISTRO_LEN_ACT
;        CLD
;        REP     MOVSB

;         ;Converter String Decimal para Número Inteiro (em AX)
;        LEA     SI, REG_BUFFER
;        CALL    STRING_DECIMAL        

        ; ;Calcula o OFFSET do REGISTRO
        ; DEC     AX
        ; MOV     BL, 64
        ; MUL     BL              ;AX agora tem o OFFSET do REGISTRO
        ; MOV     REG_OFFSET, AX

        ; ;Limpa o registro
        ; CALL    REGISTRO_CLEAR  

        ; ;Posiciona o ponteiro do arquivo no início
        ; MOV     AL, 00H
        ; MOV     FILE_ORIGIN, AL
        ; MOV     AX, HANDLE_OUT
        ; MOV     HANDLE_IN, AX
        ; MOV     AX, 0000h
        ; MOV     FILE_NBYTES_H, AX
        ; MOV     AX, REG_OFFSET  ;Faz a leitura a partir do OFFSET       
        ; MOV     FILE_NBYTES_L, AX
        ; CALL    FILE_POINTER
        ; MOV     AL, FILE_STATUS
        ; CMP     AL, FALSE
        ; JE      SAI_DOS

        ; ;Faz a leitura da linhado arquivo em blocos definidos por BUFFER_READ_SIZE:
        ; MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        ; MOV     HANDLE_IN, AX                   ;arquivo.
        ; MOV     AX, BUFFER_READ_SIZE            ;Configura o número
        ; MOV     BUFFER_READ_LEN, AX             ;de bytes para serem lidos.
        ; CALL    FILE_READ                       ;Tenta fazer a leitura do arquivo.
        ; MOV     AL, FILE_STATUS                 ;Verifica
        ; CMP     AL, FALSE                       ;a variável FILE_STATUS.
        ; JE      SAI_DOS                         ;Se FALSE, sai para o DOS

        ; ;Mostra o conteúdo do registro
        ; LEA     DX, BUFFER_READ                 ;Conteúdo do
        ; CALL    STR_PRINT                       ;arquivo.
;Implementar

        CALL    CAR_READ                        ;Faz a leitura de uma tecla <<<< TESTE        

        JMP     INICIO_PROGRAMA
;-------------------------------------------------------
; FIM READ
;-------------------------------------------------------

;*******************************************************
; DELETE - Deleta um registro
;*******************************************************
CRUD_DELETE:

        LEA     DX, CRUD_DELETE_MSG1
        CALL    STR_PRINT

        LEA     DX, CRUD_DELETE_MSG2
        CALL    STR_PRINT

	LEA     DX, REGISTRO_LEN        ;Lê REGISTRO
	MOV     AH, 0AH
	INT     21H

CRUD_DELETE_LOOP1:
        LEA     DX, CRUD_DELETE_MSG3
        CALL    STR_PRINT

        CALL    CAR_READ         ;Faz a leitura de uma tecla
        MOV     DL, AL
        CALL    CAR_PRINT        ;Mostra a tela pressionada
        CMP     AL,'Y'
        JE      CRUD_DELETE_Y
        CMP     AL,'N'
        JE      CRUD_DELETE_N
        JMP     CRUD_DELETE_LOOP1     

CRUD_DELETE_Y:
        LEA     DX, CRUD_DELETE_MSG4
        CALL    STR_PRINT

        ;Limpa o buffer do registro
        MOV     SI, 0
        MOV     AL, '$'
        XOR     CX, CX
        MOV     CX, 3
CRUD_DELETE_LOOP2:        
        MOV     REG_BUFFER[SI], AL
        INC     SI
        LOOP    CRUD_DELETE_LOOP2

        ;Move a String digitada para o buffer
        LEA     SI, REGISTRO
        LEA     DI, REG_BUFFER
        XOR     CX, CX
        MOV     CL, REGISTRO_LEN_ACT
        CLD
        REP     MOVSB

        ;Converter String Decimal para Número Inteiro (em AX)
        LEA     SI, REG_BUFFER
        CALL    STRING_DECIMAL        

        ;Calcula o OFFSET do REGISTRO
        DEC     AX
        MOV     BL, 64
        MUL     BL              ;AX agora tem o OFFSET do REGISTRO
        MOV     REG_OFFSET, AX

        ;Limpa o registro
        CALL    REGISTRO_CLEAR  

        ;Posiciona o ponteiro do arquivo no início
        MOV     AL, 00H
        MOV     FILE_ORIGIN, AL
        MOV     AX, HANDLE_OUT
        MOV     HANDLE_IN, AX
        MOV     AX, 0000h
        MOV     FILE_NBYTES_H, AX
        MOV     AX, REG_OFFSET  ;Faz a leitura a partir do OFFSET
        MOV     FILE_NBYTES_L, AX
        CALL    FILE_POINTER
        MOV     AL, FILE_STATUS
        CMP     AL, FALSE
        JE      SAI_DOS

        ;Insere caracteres em "branco" no arquivo        
        MOV     AX, BUFFER_WRITE_SIZE
        MOV     BUFFER_WRITE_LEN, AX
        MOV     AX, HANDLE_OUT
        MOV     HANDLE_IN, AX
        CALL    FILE_INSERT
        MOV     AL, FILE_STATUS
        CMP     AL, FALSE
        JE      SAI_DOS

        JMP     CRUD_DELETE_EXIT

CRUD_DELETE_N:
        LEA     DX, CRUD_DELETE_MSG5
        CALL    STR_PRINT

CRUD_DELETE_EXIT:
        CALL    CAR_READ                ;Faz a leitura de uma tecla <<<< TESTE 

        JMP     INICIO_PROGRAMA
;-------------------------------------------------------
; FIM CREATE
;-------------------------------------------------------

;*******************************************************
; LIST_ALL - Lista na tela dos os registros inseridos
;*******************************************************
CRUD_LIST_ALL:

        ;Limpa o buffer de leitura
        CALL    BUFFER_READ_CLEAR

        ;Posiciona o ponteiro do arquivo no início do arquivo
        MOV     AL, 00H                         ;Posiciona o ponteiro
        MOV     FILE_ORIGIN, AL                 ;no INÍCIO do arquivo;
        MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX                   ;arquivo.
        MOV     AX, 0000h                       ;Deslocamento
        MOV     FILE_NBYTES_H, AX               ;MSB
        MOV     FILE_NBYTES_L, AX               ;LSB.
        CALL    FILE_POINTER                    ;Tenta posicionar o ponteiro.
        MOV     AL, FILE_STATUS                 ;Verifica 
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      SAI_DOS                         ;Se FALSE, fecha o arquivo e sai para o DOS

        XOR     CX, CX
        CALL    CLR_SCREEN      ;Limpa a tela

CRUD_LIST_ALL_LOOP1:        
        LEA     DX, CRUD_MSG_LIST
        CALL    STR_PRINT

CRUD_LIST_ALL_LOOP:
        ;Faz a leitura do arquivo em blocos definidos por BUFFER_READ_SIZE:
        MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX                   ;arquivo.
        MOV     AX, BUFFER_READ_SIZE            ;Configura o número
        MOV     BUFFER_READ_LEN, AX             ;de bytes para serem lidos.
        CALL    FILE_READ                       ;Tenta fazer a leitura do arquivo.
        MOV     AL, FILE_STATUS                 ;Verifica
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      SAI_DOS                         ;Se FALSE, sai para o DOS

        MOV     AX, FILE_BYTES_READ
        CMP     AX, 0
        JE      CRUD_LIST_ALL_END

        ;Mostra o conteúdo do arquivo
        LEA     DX, BUFFER_READ                 ;Conteúdo do
        CALL    STR_PRINT                       ;arquivo.

        ;Pausa a casa 5 visualização de registros
        INC     CX
        CMP     CX, 5
        JNE     MOSTRA

        XOR     CX, CX        
        CALL    CAR_READ
        CALL    CLR_SCREEN      ;Limpa a tela
        JMP     CRUD_LIST_ALL_LOOP1

MOSTRA:
        JMP     CRUD_LIST_ALL_LOOP

CRUD_LIST_ALL_END:

        LEA     DX, CRUD_MSG_TECLA
        CALL    STR_PRINT
        CALL    CAR_READ                        ;Faz a leitura de uma tecla <<<< TESTE        

        JMP     INICIO_PROGRAMA
;-------------------------------------------------------
; FIM LIST_ALL
;-------------------------------------------------------

SAI_DOS:
        ;Fecha o arquivo
        MOV     AX, HANDLE_OUT
        MOV     HANDLE_IN, AX
        CALL    FILE_CLOSE

        ;Retorna ao sistema operacional
	MOV     AH, 4CH
	INT     21H

MAIN 	ENDP

;****************************************************************
; REGISTRO_CLEAR - Esta rotina limpa o buffer de registro
;****************************************************************

REGISTRO_CLEAR     PROC    NEAR

        PUSH    AX
        PUSH    CX
        PUSH    SI

        MOV     SI, 0
        MOV     AL, ' '
        XOR     CX, CX
        MOV     CX, BUFFER_WRITE_SIZE-2

REGISTRO_CLEAR_LOOP:        
        MOV     REG_ID[SI], AL
        INC     SI
        LOOP    REGISTRO_CLEAR_LOOP

        POP     SI
        POP     CX
        POP     AX

        RET

REGISTRO_CLEAR     ENDP

;****************************************************************
; BUFFER_READ_CLEAR - Limpa o buffer de leitura
;****************************************************************

BUFFER_READ_CLEAR     PROC    NEAR

        PUSH    AX
        PUSH    CX
        PUSH    SI

        MOV     SI, 0
        MOV     AL, '$'
        XOR     CX, CX
        MOV     CX, BUFFER_READ_SIZE+1

BUFFER_READ_CLEAR_LOOP:        
        MOV     BUFFER_READ[SI], AL
        INC     SI
        LOOP    BUFFER_READ_CLEAR_LOOP

        POP     SI
        POP     CX
        POP     AX

        RET

BUFFER_READ_CLEAR     ENDP

CODE_SEG	ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

        PUBLIC FILE_NAME, BUFFER_WRITE, BUFFER_WRITE_LEN, BUFFER_READ, BUFFER_READ_LEN, REG_ID

DATA_SEG       SEGMENT PUBLIC

        ID              DW ?
        NUM_BYTES       DW ?
        EXTERN FILE_NUM_BYTES_L:WORD

        REG_OFFSET      DW ?

        ;Buffer de registro
        REG_ID          DB 3 DUP(' ')
                        DB ' '
        REG_DATA        DB 10 DUP(' ')
                        DB ' '
        REG_HORA        DB 8 DUP(' ')
                        DB ' '
        REG_NOME        DB 34 DUP(' ')
                        DB ' '
        REG_IDADE       DB 3 DUP(' ')
                        DB CR
                        DB LF

        REG_BUFFER      DB 4 DUP('$')

        ;Armazena o registro
        REGISTRO_LEN       DB 4  		;Tamanho do buffer 4 char+return
        REGISTRO_LEN_ACT   DB ?   	        ;Tamanho atual
        REGISTRO           DB 4 DUP(' ') 	;Buffer, 4 posições inicializadas com " "  

        ;Armazena o nome
        NOME_LEN        DB 35  		;Tamanho do buffer 35 char+return
        NOME_LEN_ACT    DB ?   		;Tamanho atual
        NOME            DB 35 DUP(' ') 	;Buffer, 35 posições inicializadas com " "

        ;Armazena a idade
        IDADE_LEN       DB 4  		;Tamanho do buffer 4 char+return
        IDADE_LEN_ACT   DB ?   	        ;Tamanho atual
        IDADE           DB 4 DUP(' ') 	;Buffer, 4 posições inicializadas com " "      

        FILE_NAME       DB 'registro.txt',0
        EXTERN ATTR:WORD
        EXTERN HANDLE_IN:WORD
        EXTERN FILE_NBYTES_H:WORD
        EXTERN FILE_NBYTES_L:WORD
        EXTERN FILE_BYTES_READ:WORD
        EXTERN FILE_MODE:BYTE

        BUFFER_WRITE DB BUFFER_WRITE_SIZE DUP('$')                ;Buffer de leitura do arquivo
        BUFFER_WRITE_LEN DW BUFFER_WRITE_SIZE                     ;Quantidade de bytes a serem lidos

        BUFFER_READ DB BUFFER_READ_SIZE+1 DUP('$')                ;Buffer de leitura do arquivo
        BUFFER_READ_LEN DW BUFFER_READ_SIZE                     ;Quantidade de bytes a serem lidos

        EXTERN FILE_STATUS:BYTE                                 ;Recebe a variável externa 
        EXTERN FILE_ORIGIN:BYTE                                 ;Recebe a variável externa        
        EXTERN HANDLE_OUT:WORD                                  ;Recebe a variável externa
        EXTERN STR_LENGHT:WORD                                  ;tamanho do texto

        ;Mensagens
        CRUD_MSG_INI1 DB CR,LF,'---------------------------------',CR,LF,'$'
        CRUD_MSG_INI2 DB '### CRUD versao 1.0, 21/09/2026','$'
        CRUD_MSG_INI3 DB '- O que Voce deseja?',CR,LF,CR,LF
                      DB 'C - Criar um registro;',CR,LF
                      DB 'R - Ler um registro;',CR,LF
                      DB 'U - Atualizar um registro;',CR,LF
                      DB 'D - Deletar um registro;',CR,LF
                      DB 'L - Listar todos os registros;',CR,LF
                      DB 'Q - Sair;',CR,LF
                      DB '>> ','$'

        CRUD_MSG_CREATE DB CR,LF,'### Criar registro:',CR,LF,'$'
        CRUD_MSG_CREATE_NOME DB CR,LF,'- Digite o nome: ','$'
        CRUD_MSG_CREATE_IDADE DB CR,LF,'- Digite a idade: ','$'
        CRUD_MSG_CREATE_SUCESSO DB CR,LF,'# Registro criado com sucesso!',CR,LF,'$'
        CRUD_MSG_TOTAL_BYTES DB CR,LF,CR,LF,'- Total de BYTES: ','$'
        CRUD_MSG_TOTAL_REGISTROS DB CR,LF,'- Total de REGISTROS: ','$'
        CRUD_MSG_TECLA DB CR,LF,CR,LF,'# Pressione qualquer tecla para continuar... ','$'

        CRUD_MSG_LIST DB CR,LF,'-------------------------------------------------------------------',CR,LF
                      DB 'ID |   DATA   |  HORA  |              NOME                |IDADE   ',CR,LF
                      DB '-------------------------------------------------------------------',CR,LF,'$'

        CRUD_DELETE_MSG1 DB CR,LF,'### Deletar registro:',CR,LF,'$'
        CRUD_DELETE_MSG2 DB CR,LF,'- Deseja deletar qual registro? ','$'
        CRUD_DELETE_MSG3 DB CR,LF,'- Deseja mesmo deletar o registro? (Y/N)','$'
        CRUD_DELETE_MSG4 DB CR,LF,'- Registro DELETADO com SUCESSO!','$'
        CRUD_DELETE_MSG5 DB CR,LF,'- Registro NAO DELETADO!','$'

        CRUD_READ_MSG1 DB CR,LF,'### Ler registro:',CR,LF,'$'
        CRUD_READ_MSG2 DB CR,LF,'- Deseja ler qual registro? ','$'

        ;Variáveis referentes a data e hora
        EXTERN TIME_HORA:BYTE
        EXTERN TIME_DATA:BYTE

        EXTERN DIGITOS:BYTE

DATA_SEG       ENDS

        END     MAIN
;----------------------------------------------------------------
; FIM DO PROGRAMA PRINCIPAL
;----------------------------------------------------------------