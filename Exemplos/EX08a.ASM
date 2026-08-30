;-----------------------------------------------------
; EX08a.asm - Impressão de horas continua CRONOMETRO
; Autor: Eng. Fabrício Ribeiro
; Para sair: Ctrl+q
;-----------------------------------------------------
	
CR	equ	0DH	;ASCII carriage return
LF	equ	0AH	;ASCII line feed

	.model small

	.stack 100h

	.data
	hora db 0
	minuto db 0
	segundo db 0

    unidade db 0
    dezena db 0

	var db 0

	Msg DB 'Ctrl+q para sair!',CR,LF,'$'

	.code
MAIN Proc

	;Inicializa o segmento de dados
	mov ax, @data
	mov ds, ax

	mov dx,OFFSET Msg
	mov ah,9h
	int 21h

check_time:
	mov ah,06h		;Verifica
	mov dl,0ffh		;se alguma
	int 21h			;tecla
	jz sem_tecla	;foi pressionada.
	cmp al,11h 		;Se as teclas forem: Ctrl+q
	je exit_dos		;Sai do programa.
sem_tecla:			;Se nenhuma tecla foi pressionada:
	mov ah,2ch		;Leia as.
	int 21h 		;horas
	cmp dh,var		;Compara o segundo atual com o anterior
	je check_time	;Se for igual, volta em "check_time"
	mov var,dh		;Se não, guarda o valor atual.

	call get_time	;Obtem a hora
	call show_time	;Imprime a hora

	mov al,CR		;Retorna o cursor
	call print_char	;na primeira posição da linha.

	jmp check_time	;volta em "check_time"

exit_dos:
	;Sai e retorna ao MSDOS
	mov al,00h
	mov ah,04ch
	int 21h 


;-----------------------------------------------------
; Obtenção das horas
;-----------------------------------------------------
get_time:
	mov ah,2ch
	int 21h 
	mov hora,ch
	mov minuto,cl
	mov segundo,dh
	ret

;-----------------------------------------------------
; mostra horas
;-----------------------------------------------------
show_time:
	mov al,hora
	call print_digitos
	mov al,':'
	call print_char
	mov al,minuto
	call print_digitos
	mov al,':'
	call print_char		
	mov al,segundo
	call print_digitos
	ret

;---------------------------------------------------
;Imprime os digitos
;al = valor
;---------------------------------------------------
print_digitos:
	call hexa2decimal
    
	mov dl,dezena
    add dl,'0'
    mov ah,02h
    int 21h

    mov dl,unidade
    add dl,'0'
    mov ah,02h
    int 21h	
	
	ret

;---------------------------------------------------
;hexa para decimal
;al = valor entre 00h a 63h
;---------------------------------------------------
hexa2decimal:
    xor ah,ah
    mov bl,10
    div bl
    mov unidade,ah
    mov dezena,al
    ret

;-----------------------------------------------------
;Imprime um caracter
;al=código ASCII do caracter
;-----------------------------------------------------
print_char:
	mov dl, al
	mov ah, 02h    ; Seleciona a função 02h Saída de caractere
	int 21h        ; Chama a interrupção 21h	
	ret

MAIN  	ENDP
END 	MAIN 