;****************************************************************
; Essas rotinas manipulam o ambiente gráfico
;
;****************************************************************

CGROUP          GROUP   CODE_SEG, DATA_SEG
                ASSUME  CS:CGROUP, DS:CGROUP

CODE_SEG        SEGMENT PUBLIC

                INCLUDE CONST.INC

;****************************************************************
; CLR_SCREEN - Limpa a tela e coloca o cursor na primeira posição
;****************************************************************

                PUBLIC  CLR_SCREEN

CLR_SCREEN         PROC    NEAR

                ; -----------------------------------------
                ; ROTINA PARA LIMPAR A TELA (BIOS INT 10h)
                ; -----------------------------------------
                MOV AH, 06h         ; Função 06h: Rolar a tela para cima (0 = limpa tudo)
                MOV AL, 00h         ; AL = 0 significa limpar toda a janela
    
                ; Define a cor de fundo e do texto (Atributo de vídeo)
                ; 07h = Texto branco (7) com fundo preto (0)
                MOV BH, 07h         
    
                ; Define o canto superior esquerdo da tela
                MOV CH, 00h         ; Linha 0
                MOV CL, 00h         ; Coluna 0
    
                ; Define o canto inferior direito da tela (Modo texto padrão: 25 linhas x 80 colunas)
                MOV DH, 24h         ; Linha 24 (25ª linha)
                MOV DL, 4Fh         ; Coluna 79 (80ª coluna, 4F em hexadecimal)
    
                INT 10h             ; Chama a interrupção de vídeo da BIOS

                ; -----------------------------------------
                ; COLOQUE O CURSOR DE VOLTA NO TOPO (0,0)
                ; -----------------------------------------
                MOV AH, 02h         ; Função 02h: Definir posição do cursor
                MOV BH, 00h         ; Página de vídeo 0
                MOV DH, 00h         ; Linha 0
                MOV DL, 00h         ; Coluna 0
                INT 10h             ; Chama a interrupção da BIOS

                RET

CLR_SCREEN         ENDP
;----------------------------------------------------------------
; FIM CLR_SCREEN
;----------------------------------------------------------------

CODE_SEG        ENDS

;****************************************************************
; ÁREA DE DADOS
;****************************************************************

DATA_SEG        SEGMENT PUBLIC


                
DATA_SEG        ENDS

                END
