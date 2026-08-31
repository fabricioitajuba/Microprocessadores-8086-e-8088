;Ex12 - Entrada de parâmetros
; Este exemplo mostra os parâmetros digitados após a execussão do
; programa. Exemplo:
;
; ex12 a b c <ENTER>
; Parametros digitados: a b c
;
;Para ler parâmetros passados pela linha de comando no MASM (8086), 
;você deve acessar o PSP (Program Segment Prefix).
;Quando o DOS executa um programa .COM ou .EXE, o registrador DS 
;aponta para o início do PSP. O tamanho dos parâmetros digitados 
;fica armazenado no byte 80h do PSP, e a string de texto com os 
;parâmetros começa exatamente no byte 81h.
;Aqui está um exemplo de código completo e comentado. Ele lê os 
;parâmetros digitados, limpa o caractere especial de "Enter" (0Dh) 
;do final, e exibe o texto de volta na tela.

	.model small
	.stack 100h

	.data
	msg_info db 'Parametros digitados: ', '$'
	msg_vazio db 'Nenhum parametro foi digitado.', 13, 10, '$'
	buffer db 130 dup('$') ; Buffer para guardar o texto lido

	.code
main 	proc
	; 1. Salvar o segmento do PSP (que está em DS) antes de apontar para .DATA
	mov ax,ds          ; AX agora guarda o segmento do PSP
    
	; 2. Inicializar o segmento de dados padrão (.DATA) em ES para usar o buffer
	mov bx,@data
	mov es,bx
    
	; 3. Acessar o tamanho dos parâmetros no offset 80h do PSP
	mov si,80h
	mov cl,[si]        ; CL recebe a quantidade de caracteres
	cmp cl,0           ; Se for 0, nenhum parâmetro foi passado
	je sem_parametros
    
	; 4. Copiar os parâmetros do PSP (DS:SI) para o nosso buffer (ES:DI)
	mov si,81h         ; Offset onde começam os parâmetros no PSP
	lea di,es:buffer   ; Destino no nosso segmento de dados
    
loop_copia:
	mov al,[si]        ; Lê caractere do PSP
	mov es:[di],al     ; Salva no nosso buffer
	inc si
	inc di
	dec cl
	jnz loop_copia
    
	; 5. Ajustar o DS para o nosso segmento de dados para poder usar o buffer e exibir mensagens
	mov ax,@data
	mov ds,ax
    
	; Substituir o caractere de Carriage Return (13) por '$' para finalizar a string no DOS
	lea di, buffer
corrige_fim:
	cmp byte ptr [di],13
	je finaliza_string
	cmp byte ptr [di],'$'
	je exibe_resultado   ; Se chegou no fim do buffer sem achar o 13
	inc di
	jmp corrige_fim

finaliza_string:
	mov byte ptr[di], '$'

exibe_resultado:
	; Exibe a mensagem informativa
	mov ah,09h
	lea dx,msg_info
	int 21h
    
	; Exibe os parâmetros capturados
	mov ah,09h
	lea dx,buffer
	int 21h
	jmp fim

sem_parametros:
	; Se não houver parâmetros, ajusta DS e avisa o usuário
	mov ax,@data
	mov ds,ax
    
	mov ah,09h
	lea dx,msg_vazio
	int 21h

fim:
	; Finaliza o programa retornando ao DOS
	mov ax,4C00h
	int 21h
	
main 	endp
end 	main

