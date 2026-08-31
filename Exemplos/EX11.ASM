;-----------------------------------------------------
; EX11.asm - Comprimento de uma String
; Autor: Eng. Fabrício Ribeiro
;-----------------------------------------------------

	title StringSize (MASM 8086)
	.model small
	.stack 100h

	.data
	; String de teste (terminada em '$')
	string db 'Assembly 8086 MASM', '$'
    
	; Mensagem para exibir o resultado textualmente
	msg_res db 'Tamanho da string foi calculado: ', '$'

	unidade db 0
	dezena db 0

	.code
MAIN 	PROC

	; Inicializa o segmento de dados
	mov ax,@data
	MOV ds,ax
	MOV es,ax	; ES é obrigatório para instruções de string (SCASB)

	; Ponteiro para o início da string
	lea di,string
	mov si,di	; Salva o endereço inicial em SI para calcular a diferença depois

	; Define o valor máximo de busca no pior cenário
	mov cx,0ffffh	; Carrega o maior valor possível em 16-bits
    
	; Define o caractere de parada
	mov al,'$'	; Procura pelo terminador '$' (mude para 0 se usar string ASCIIZ)

	; Limpa o Direction Flag (DF=0) para avançar o ponteiro DI para a direita
	cld

	; Busca o caractere AL na string enquanto não encontrar (ZF=0) e CX > 0
	repnz scasb

	; Calcula o tamanho real da string
	; DI agora aponta para o caractere LOGO APÓS o '$'
	sub di,si	; DI = DI - SI (Diferença de bytes entre os ponteiros)
	dec di		; Subtrai 1 para desconsiderar o próprio caractere '$'
    
	; Move o tamanho final para CX para uso geral do sistema
	mov cx,di	; CX agora contém o tamanho exato da string

	; Exibe mensagem de finalização na tela
	lea dx,msg_res
	mov ah,09h
	int 21h

	mov al,cl

	call hexa2decimal

	mov dl,dezena
	add dl,'0'
	mov ah,02h
	int 21h

	mov dl,unidade
	add dl,'0'
	mov ah,02h
	int 21h

fim:
	; Finaliza o programa retornando ao DOS
	mov ah,4ch
	int 21h

hexa2decimal:
	xor ah,ah
	mov bl,10
	div bl
	mov unidade,ah
	mov dezena,al
	ret

MAIN 	ENDP
END 	MAIN