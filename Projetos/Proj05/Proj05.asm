;----------------------------------------------------
; Proj05.asm - CRUD
; para compilar:
; $ NMAKE
; $ exe2bin proj05 proj05.com
; Autor: Eng. Fabrício Ribeiro
; Status: Ainda não concluído
;----------------------------------------------------

BUFFER_READ_SIZE        EQU     512
BUFFER_REGISTRO_SIZE    EQU     32

CGROUP  GROUP   CODE_SEG, DATA_SEG
        ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG	SEGMENT PUBLIC

        INCLUDE CONST.INC

        ORG     100h

	;Carrega funções externas
        EXTRN   CAR_READ:NEAR
        EXTRN   CAR_PRINT:NEAR
        EXTRN   STR_PRINT:NEAR
        EXTRN   STR_LEN:NEAR
        EXTRN   STR_LEN:NEAR

        EXTRN   CLR_SCREEN:NEAR

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
        
INICIO_PROGRAMA:

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
        CALL    CAR_READ                        ;Faz a leitura de uma tecla <<<< TESTE

        LEA     DX, CRUD_MSG_CREATE_IDADE
        CALL    STR_PRINT
        CALL    CAR_READ                        ;Faz a leitura de uma tecla <<<< TESTE

        LEA     DX, CRUD_MSG_CREATE_SUCESSO
        CALL    STR_PRINT
        CALL    CAR_READ                        ;Faz a leitura de uma tecla <<<< TESTE        

        ;Inicializando o buffer de registro
        MOV     SI, 0
        MOV     AL, '*'
        MOV     BUFFER_REGISTRO[SI], AL
        MOV     SI, 30
        MOV     AL, CR
        MOV     BUFFER_REGISTRO[SI], AL
        MOV     SI, 31
        MOV     AL, LF
        MOV     BUFFER_REGISTRO[SI], AL              

        JMP     INICIO_PROGRAMA
;-------------------------------------------------------
; FIM CREATE
;-------------------------------------------------------

        ;Tenta abrir um arquivo para ESCRITA e LEITURA
        MOV     AL, 2                           ;Configura Atributo:
        MOV     FILE_MODE, AL                   ;2 - escrita e leitura
        CALL    FILE_APPEND                     ;Tenta abrir o arquivo para escrita
        MOV     AL, FILE_STATUS                 ;Verifica 
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      CRIA_ARQUIVO                    ;Se o arquivo não existir, será criado
                                                ;HANDLE_IN possui o número do arquivo
        MOV     AL, TRUE                        ;Configura que o arquivo
        MOV     FLAG, AL                        ;Já foi criado.
        JMP     INSERE_DADOS                    ;Insere dados

CRIA_ARQUIVO:
        ;Cria um arquivo
        MOV     AX, 0                           ;Configura o 
        MOV     ATTR, AX                        ;Atributo do arquivo.
        CALL    FILE_CREATE                     ;Tenta criar o arquivo;
        MOV     AL, FILE_STATUS                 ;Verifica 
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      SAI_DOS                         ;Se FALSE, sai para o DOS
                                                ;HANDLE_IN possui o número do arquivo
        JMP     FECHA_ARQUIVO                   ;Fecha o arquivo.

INSERE_DADOS:
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
        JE      FECHA_ARQUIVO                   ;Se FALSE, fecha o arquivo e sai para o DOS

        ;Prepara os dados que serão inseridos
        CALL    STR_LEN                         ;Passa TEXTO como parâmetro
        MOV     AX, STR_LENGHT                  ;Número de bytes

        ;Insere dados no arquivo
        MOV     LEN, AX                         ;Configura o número de bytes
        MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX                   ;arquivo.
        CALL    FILE_INSERT                     ;Insere dados no arquivo
        MOV     AL, FILE_STATUS                 ;Verifica
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      FECHA_ARQUIVO                   ;Se FALSE, sai para o DOS

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
        JE      FECHA_ARQUIVO                   ;Se FALSE, fecha o arquivo e sai para o DOS

        ;Faz a leitura do arquivo:
        MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX                   ;arquivo.
        MOV     AX, BUFFER_READ_SIZE            ;Configura o número
        MOV     BUFFER_READ_LEN, AX             ;de bytes para serem lidos.
        CALL    FILE_READ                       ;Tenta fazer a leitura do arquivo.
        MOV     AL, FILE_STATUS                 ;Verifica
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      FECHA_ARQUIVO                   ;Se FALSE, sai para o DOS

        LEA     DX, FILE_MSG_READ               ;Se TRUE
        CALL    STR_PRINT                       ;imprime a mensagem

        ;Mostra o conteúdo do arquivo
        LEA     DX, BUFFER_READ                 ;Conteúdo do
        CALL    STR_PRINT                       ;arquivo.

        ;Fecha o arquivo
FECHA_ARQUIVO:
        MOV     AX, HANDLE_OUT                  ;Carrega o HANDLE do
        MOV     HANDLE_IN, AX                   ;arquivo.
        CALL    FILE_CLOSE                      ;Tenta Fechar o arquivo.
        MOV     AL, FILE_STATUS                 ;Verifica
        CMP     AL, FALSE                       ;a variável FILE_STATUS.
        JE      SAI_DOS                         ;Se FALSE, sai para o DOS

        MOV     AL, FLAG                        ;Testa se
        CMP     AL, TRUE                        ;o arquivo foi
        JE      SAI_DOS                         ;criado recentemente.
        MOV     AL, TRUE                        ;Configura que
        MOV     FLAG, AL                        ;o arquivo
        JMP     INICIO_PROGRAMA                 ;já foi criado.

SAI_DOS:
	MOV     AH, 4CH                         ;Retorna ao
	INT     21H                             ;MS-DOS

MAIN 	ENDP

CODE_SEG	ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

        PUBLIC FILE_NAME, ATTR, HANDLE_IN, TEXTO, LEN, FILE_ORIGIN, FILE_MODE
        PUBLIC FILE_NBYTES_H, FILE_NBYTES_L, BUFFER_READ, BUFFER_READ_LEN

DATA_SEG       SEGMENT PUBLIC

        FLAG DB FALSE

        TEXTO DB 'Esse eh o texto inserido no arquivo!',CR,LF,'$'
        LEN DW ?

        FILE_NAME DB 'registro.txt',0
        ATTR DW 0
        HANDLE_IN DW ?
        FILE_ORIGIN DB ?
        FILE_NBYTES_H DW ?
        FILE_NBYTES_L DW ?
        FILE_MODE DB ?
  
        BUFFER_READ DB BUFFER_READ_SIZE DUP('$')                ;Buffer de leitura do arquivo
        BUFFER_READ_LEN DW ?                                    ;Quantidade de bytes a serem lidos

        BUFFER_REGISTRO DB BUFFER_REGISTRO_SIZE DUP(' ')        ;Buffer de registro

        EXTERN FILE_STATUS:BYTE                                 ;Recebe a variável externa        
        EXTERN HANDLE_OUT:WORD                                  ;Recebe a variável externa
        EXTERN STR_LENGHT:WORD                                  ;tamanho do texto

        ;Mensagens
        CRUD_MSG_INI1 DB CR,LF,'---------------------------------',CR,LF,'$'
        CRUD_MSG_INI2 DB '### CRUD versao 1.0, 21/09/20206','$'
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
        CRUD_MSG_CREATE_SUCESSO DB CR,LF,'# Registro criado com sucesso!','$'

        FILE_MSG_READ DB CR,LF,'### Conteudo do arquivo:',CR,LF,'$'

DATA_SEG       ENDS

        END     MAIN
;----------------------------------------------------------------
; FIM DO PROGRAMA PRINCIPAL
;----------------------------------------------------------------