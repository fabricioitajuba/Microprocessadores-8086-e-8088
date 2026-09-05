;-----------------------------------------------------
; Ex14b.asm - Soma de 2 números
; usando decimais codificados em binário BCD empacotados
; Autor: Eng. Fabrício Ribeiro
;
; DB - Define Byte        - 1 Byte  -  8 bits
; DW - Define Word        - 2 Bytes - 16 bits
; DD - Define Doubleword  - 4 Bytes - 32 bits
; DQ - Define Quadword    - 8 Bytes - 64 bits
; DT - Define Ten-Bytes  - 10 Bytes - 80 bits
;-----------------------------------------------------

	.model small

	.stack 100h

	.data
	; NUM1 e NUM2 agora usam a diretiva DT (10 bytes cada / até 20 dígitos BCD).
    ; O sufixo H indica valores hexadecimais que mapeiam diretamente os dígitos BCD.
    ; Armazenados em Little Endian (bytes menos significativos primeiro).
    NUM1 DT 00000099900000000099H
    NUM2 DT 00000099900000000099H  ; Representa o número 1
    
    ; O resultado agora precisa de 11 bytes para acomodar o "vai um" do 10º byte.
    RESULT DB 11 DUP(0)

	.code
MAIN PROC

	;1. Inicializa o segmento de dados
	mov ax,@data
	mov ds,ax

    ; 2. Prepara os registradores para o Loop de 10 bytes
    mov si,0					; SI será o índice para percorrer os bytes (0 a 9)
    mov cx,10					; CX agora é 10 (pois a diretiva DT aloca 10 bytes)
    
    clc							; Limpa o Carry antes de começar a somar

_SOMA_LOOP:
    mov al, byte ptr NUM1[si]   ; Usa BYTE PTR porque o MASM precisa saber que 
    adc al, byte ptr NUM2[si]  	; estamos lendo apenas 1 byte de cada vez do bloco DT.
    daa                        	; Ajusta o resultado em AL para BCD Compactado
    mov result[si],al          	; Salva o byte corrigido na memória de destino
    
    inc si					   	; Avança para o próximo byte
    loop _SOMA_LOOP     	   	; Decrementa CX e repete até fazer os 10 bytes

    ; 3. Guarda o bit de Carry final (o 11º byte do resultado)
    mov al,0
    adc al,0           			; AL recebe 0 + 0 + Carry Final
    mov RESULT[si],al	  		; Salva o dígito de estouro no 11º byte de RESULT

    ; ========================================================
    ; 2. IMPRESSÃO DO RESULTADO BCD NA TELA
    ; ========================================================
    ; RESULT tem 11 bytes (índices de 0 a 10). 
    ; Para imprimir da esquerda para a direita, começamos no índice 10.
    mov si,10           ; Aponta para o byte mais significativo (o do Carry)
    mov cx,11           ; Vamos processar todos os 11 bytes

_IMPRIME_LOOP:
    mov al,result[si]   ; AL recebe o byte atual (ex: 98H)
    mov bl,al           ; Faz uma cópia de segurança em BL

    ; --- Passo A: Isolar e imprimir o dígito esquerdo (mais significativo do byte) ---
    ; Usamos ROR 4 vezes com o registrador CL para inverter os nibbles
    ; Nota: Como CX é o nosso contador do loop principal, usamos o registrador DH 
    ; temporariamente para salvar o CX e usar o CL na rotação sem perder o controle.
    mov dh,cl           ; Salva o contador do loop principal
    mov cl,4            ; Define o contador da rotação para 4
    ror al,cl           ; Rotaciona 4 vezes (98H vira 89H)
    mov cl,dh           ; Restaura o contador do loop principal original

    and al,0fh          ; Máscara de bits: isola o dígito (89H vira 09H)
    add al,30h          ; Converte o número (0-9) para o caractere ASCII ('0'-'9')
    mov dl,al           ; Coloca em DL para a interrupção de vídeo
    mov ah,02h          ; Função DOS 02h: Exibir caractere na tela
    int 21h             ; Executa a impressão

    ; --- Passo B: Isolar e imprimir o dígito direito (menos significativo do byte) ---
    mov al,bl           ; Recupera o byte original armazenado em BL (ex: 98H)
    and al,0fh          ; Isola os 4 bits da direita (98H vira 08H)
    add al,30h          ; Converte para caractere ASCII
    mov dl,al           ; Move para DL
    mov ah,02h          ; Função DOS 02h
    int 21h             ; Executa a impressão

    dec si              ; Move o ponteiro para o próximo byte à esquerda na memória
    loop _IMPRIME_LOOP  ; Repete até imprimir todos os 11 bytes

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 4ch
	int 21h 

MAIN	ENDP
END 	MAIN
