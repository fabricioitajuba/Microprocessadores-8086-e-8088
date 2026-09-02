;-----------------------------------------------------
; Ex13.asm - Trabalhando com vetores
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

	.model small

	.stack 100h

	.data
	vetor db 'A', 'B', 'C', 'D'
	len db 4
    
	.code
MAIN	Proc

	;Inicializa o segmento de dados
	mov ax, @data
	mov ds, ax

	lea si,vetor	;Carrega SI com o endereço do vetor
	xor cx,cx	;Limpa o conteúdo de cx
	mov cl,len	;Quantidade de valores
mostra:
	mov dl,[si]	;Tansfere o dado em SI para dl
	;mov dl,es:[si]	;Dado de outro segmento
	
	;Imprime um caracter
	mov ah, 02h    	; Seleciona a função 02h Saída de caractere
	int 21h        	; Chama a interrupção 21h

	inc si
	loop mostra

	;Sai e retorna ao MSDOS
	mov al, 00h
	mov ah, 4ch
	int 21h 
    
MAIN	ENDP
END 	MAIN
