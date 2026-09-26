;----------------------------------------------------
; Proj05.asm - CRUD
; para compilar:
; $ NMAKE
; $ exe2bin proj05 proj05.com
; Autor: Eng. Fabrício Ribeiro
; Status: Create concluído
;----------------------------------------------------

BUFFER_READ_SIZE        EQU     512
BUFFER_WRITE_SIZE       EQU     64

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
        MOV     AH, 42H
        MOV     AL, 2
        MOV     BX, HANDLE_OUT
        MOV     CX, 0
        MOV     DX, 0
        INT     21H
        ; DX:AX agora contém o tamanho exato do arquivo em bytes!
        MOV     NUM_BYTES, AX   ;Guarda auantidade de bytes do arquivo.
        MOV     BL, 64          ;Calcula a
        DIV     BL              ;Quantidade de registros.
        MOV     ID, AX          ;Guarda a quantidade de registros.

        CALL    CLR_SCREEN                      ;Limpa a tela

        ;MensageNS inicias
        LEA     DX, CRUD_MSG_INI1
        CALL    STR_PRINT
        LEA     DX, CRUD_MSG_INI2
        CALL    STR_PRINT
        LEA     DX, CRUD_MSG_INI1
        CALL    STR_PRINT
        LEA     DX, CRUD_MSG_INI3
        CALL    STR_PRINT                        

        CALL    CAR_READ                        ;Faz a leitura de uma tecla
        MOV     DL, AL
        CALL    CAR_PRINT                       ;Mostra a tela pressionada
        CMP     AL,'C'
        JE      CRUD_CREATE
        CMP     AL,'Q'
        JE      SAI_DOS
              
        JMP     INICIO_PROGRAMA


;*******************************************************
; CREATE
;*******************************************************
CRUD_CREATE:
        LEA     DX, CRUD_MSG_CREATE
        CALL    STR_PRINT

        LEA     DX, CRUD_MSG_CREATE_NOME
        CALL    STR_PRINT
        
	LEA     DX, NOME_LEN                    ;Lê NOME
	MOV     AH, 0AH
	INT     21H

        LEA     DX, CRUD_MSG_CREATE_IDADE
        CALL    STR_PRINT

	LEA     DX, IDADE_LEN                   ;Lê IDADE
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
        LEA     DI, BUFFER_WRITE
        XOR     CX, CX
        MOV     CL, 3
        CLD
        REP     MOVSB

        ;Copia o nome para o registro
        LEA     SI, NOME
        LEA     DI, BUFFER_WRITE+24
        XOR     CX, CX
        MOV     CL, NOME_LEN_ACT
        CLD
        REP     MOVSB

        ;Copia a idade para o registro
        LEA     SI, IDADE
        LEA     DI, BUFFER_WRITE+59
        XOR     CX, CX
        MOV     CL, IDADE_LEN_ACT
        CLD
        REP     MOVSB

        ;Adiciona Data
        CALL    GET_DATA
        LEA     SI, TIME_DATA
        LEA     DI, BUFFER_WRITE+4
        XOR     CX, CX
        MOV     CL, 10
        CLD
        REP     MOVSB

        ;Separação entre data e hora
        MOV     AL,'-'
        MOV     BUFFER_WRITE+14, AL

        ;Adiciona Hora
        CALL    GET_TIME
        LEA     SI, TIME_HORA
        LEA     DI, BUFFER_WRITE+15
        XOR     CX, CX
        MOV     CL, 8
        CLD
        REP     MOVSB
 
        ;Posiciona o ponteiro do arquivo no final do arquivo
        MOV     AL, 02H                         ;Posiciona o ponteiro
        MOV     FILE_ORIGIN, AL                 ;no FINAL do arquivo;
        MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX                   ;arquivo.
        MOV     AX, 0000h                       ;Deslocamento
        MOV     FILE_NBYTES_H, AX               ;MSB
        MOV     FILE_NBYTES_L, AX               ;LSB.
        CALL    FILE_POINTER                    ;Tenta posicionar o ponteiro.
        MOV     AL, FILE_STATUS                 ;Verifica 
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      SAI_DOS                         ;Se FALSE, fecha o arquivo e sai para o DOS

        ;Insere dados no arquivo        
        MOV     AX, BUFFER_WRITE_SIZE           ;Número de bytes
        MOV     BUFFER_WRITE_LEN, AX            ;Configura o número de bytes
        MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX                   ;arquivo.
        CALL    FILE_INSERT                     ;Insere dados no arquivo
        MOV     AL, FILE_STATUS                 ;Verifica
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      SAI_DOS                         ;Se FALSE, sai para o DOS

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

INSERE_DADOS:

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
        ;JE      FECHA_ARQUIVO                   ;Se FALSE, fecha o arquivo e sai para o DOS

        ;Faz a leitura do arquivo:
        MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX                   ;arquivo.
        MOV     AX, BUFFER_READ_SIZE            ;Configura o número
        MOV     BUFFER_READ_LEN, AX             ;de bytes para serem lidos.
        CALL    FILE_READ                       ;Tenta fazer a leitura do arquivo.
        MOV     AL, FILE_STATUS                 ;Verifica
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        ;JE      FECHA_ARQUIVO                   ;Se FALSE, sai para o DOS

        LEA     DX, FILE_MSG_READ               ;Se TRUE
        CALL    STR_PRINT                       ;imprime a mensagem

        ;Mostra o conteúdo do arquivo
        LEA     DX, BUFFER_READ                 ;Conteúdo do
        CALL    STR_PRINT                       ;arquivo.

SAI_DOS:
        ;Fecha o arquivo
        MOV     AX, HANDLE_OUT
        MOV     HANDLE_IN, AX
        CALL    FILE_CLOSE
        ;MOV     AL, FILE_STATUS
        ;CMP     AL, FALSE
        ;JE      SAI_DOS

        ;Retorna ao sistema operacional
	MOV     AH, 4CH
	INT     21H

MAIN 	ENDP

;****************************************************************
; REGISTRO_CLEAR
; Esta rotina limpa o registro
;****************************************************************

REGISTRO_CLEAR     PROC    NEAR

        ;Inicializando o buffer de registro
        MOV     SI, 0

        XOR     CX, CX
        MOV     CX, 62

REGISTRO_CLEAR_LOOP:        

        MOV     AL, ' '
        MOV     BUFFER_WRITE[SI], AL
        INC     SI
        LOOP    REGISTRO_CLEAR_LOOP

        MOV     SI, 62
        MOV     AL, CR
        MOV     BUFFER_WRITE[SI], AL

        MOV     SI, 63
        MOV     AL, LF
        MOV     BUFFER_WRITE[SI], AL 

        RET

REGISTRO_CLEAR     ENDP

CODE_SEG	ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

        PUBLIC FILE_NAME, ATTR, HANDLE_IN, BUFFER_WRITE, BUFFER_WRITE_LEN, FILE_ORIGIN
        PUBLIC FILE_MODE, FILE_NBYTES_H, FILE_NBYTES_L, BUFFER_READ, BUFFER_READ_LEN

DATA_SEG       SEGMENT PUBLIC

        ID              DW ?
        NUM_BYTES       DW ?

        ;Armazena o nome
        NOME_LEN        DB 36  		;Tamanho do buffer 36 char+return
        NOME_LEN_ACT    DB ?   		;Tamanho atual
        NOME            DB 36 DUP(' ') 	;Buffer, 27 posições inicializadas com " "

        ;Armazena a idade
        IDADE_LEN       DB 4  		;Tamanho do buffer 4 char+return
        IDADE_LEN_ACT   DB ?   	;Tamanho atual
        IDADE           DB 4 DUP(' ') 	;Buffer, 4 posições inicializadas com " "      

        FILE_NAME       DB 'registro.txt',0
        ATTR            DW 0
        HANDLE_IN       DW ?
        FILE_ORIGIN     DB ?
        FILE_NBYTES_H   DW ?
        FILE_NBYTES_L   DW ?
        FILE_MODE       DB ?

        BUFFER_WRITE DB BUFFER_WRITE_SIZE DUP('$')                ;Buffer de leitura do arquivo
        BUFFER_WRITE_LEN DW BUFFER_WRITE_SIZE                     ;Quantidade de bytes a serem lidos

        BUFFER_READ DB BUFFER_READ_SIZE DUP('$')                ;Buffer de leitura do arquivo
        BUFFER_READ_LEN DW BUFFER_READ_SIZE                     ;Quantidade de bytes a serem lidos

        EXTERN FILE_STATUS:BYTE                                 ;Recebe a variável externa        
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
                      DB 'Q - Sair;',CR,LF
                      DB '>> ','$'

        CRUD_MSG_CREATE DB CR,LF,'### Criar registro:',CR,LF,'$'
        CRUD_MSG_CREATE_NOME DB CR,LF,'- Digite o nome: ','$'
        CRUD_MSG_CREATE_IDADE DB CR,LF,'- Digite a idade: ','$'
        CRUD_MSG_CREATE_SUCESSO DB CR,LF,'# Registro criado com sucesso!',CR,LF,'$'
        CRUD_MSG_TOTAL_BYTES DB CR,LF,CR,LF,'- Total de BYTES: ','$'
        CRUD_MSG_TOTAL_REGISTROS DB CR,LF,'- Total de REGISTROS: ','$'

        FILE_MSG_READ DB CR,LF,'### Conteudo do arquivo:',CR,LF,'$'

        ;Variáveis referentes a data e hora
        EXTERN TIME_HORA:BYTE
        EXTERN TIME_DATA:BYTE

        EXTERN DIGITOS:BYTE

DATA_SEG       ENDS

        END     MAIN
;----------------------------------------------------------------
; FIM DO PROGRAMA PRINCIPAL
;----------------------------------------------------------------