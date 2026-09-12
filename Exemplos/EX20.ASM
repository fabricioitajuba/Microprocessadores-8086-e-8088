;----------------------------------------------
; EX20.asm - Programa residente na memória
; Este programa fica residente na memória e mostra 
; as horas quando as teclas "Shift" e "H" são
; pressionadas.
; Autor: Eng. Fabrício Ribeiro
;
; masm ex20.asm;
; link ex20.obj;
; exe2bin ex20 ex20.com
; ex20
;----------------------------------------------

;TSR - Terminate and Stay Resident

    .model tiny
    .code
    org 100h            ; Essencial para programas .COM

inicio:
    jmp instalar          ; Desvia do código residente e vai para a instalação

; -------------------------------------------------------------------
; VARIÁVEIS DO PROGRAMA RESIDENTE
; -------------------------------------------------------------------
velha_int9  dd  ?   ; Guarda o endereço (Offset/Segment) da INT 9 original
msg_hora    db  '00:00:00', 13, 10, '$'
msg_sucesso db 'TSR instalado com sucesso! Pressione Ctrl + H para ver a hora.', 13, 10, '$'

; -------------------------------------------------------------------
; ROTINA DE INSTALAÇÃO (EXECUTADA APENAS UMA VEZ NA INICIALIZAÇÃO)
; -------------------------------------------------------------------
instalar:
    ; 1. Salva o endereço da INT 9 original
    mov ah,35h             ; Função do DOS para ler vetor de interrupção
    mov al,09h             ; Queremos a interrupção 9 (teclado)
    int 21h
    mov word ptr [velha_int9],bx     ; Salva Offset
    mov word ptr [velha_int9+2],es   ; Salva Segment

    ; 2. Substitui a INT 9 pela nossa rotina modificada
    mov ah,25h             ; Função do DOS para escrever vetor de interrupção
    mov al,09h
    mov dx,offset nova_int9
    int 21h

    ; 3. Exibe mensagem de sucesso na tela
    mov dx,offset msg_sucesso
    mov ah,09h
    int 21h

    ; 4. Termina o programa e fica residente (TSR)
    ; Calcula o tamanho necessário em parágrafos (1 parágrafo = 16 bytes)
    mov dx,offset fim_do_residente
    shr dx,1               ; Divide por 16
    shr dx,1
    shr dx,1
    shr dx,1
    inc dx                  ; Adiciona 1 por segurança
    mov ah,31h             ; Função TSR do DOS
    mov al,0               ; Código de retorno 0
    int 21h

; -------------------------------------------------------------------
; ROTINA DE INTERRUPÇÃO (FICA RESIDENTE)
; -------------------------------------------------------------------
nova_int9 proc far
    pushf                   ; Preserva as flags
    push ax                 ; Preserva os registradores que vamos usar
    push bx
    push cx
    push dx
    push ds

    ; Configura o DS para o segmento correto do nosso TSR
    mov ax,cs
    mov ds,ax

    ; Verifica o estado das teclas de controle (Shift/Ctrl/Alt) na BIOS
    mov ax,0040h
    mov es,ax
    mov al,es:[0017h]      ; Endereço do teclado na área de dados da BIOS
    and al,00000100b       ; Verifica se o bit do CONTROL esquerdo/direito está ativo
    jz passar_adiante       ; Se Ctrl não estiver pressionado, ignora

    ; Lê a última tecla que entrou no buffer do teclado sem remover
    in al,60h              ; Porta do controlador do teclado
    cmp al,23h             ; Scan code da tecla 'H'
    jne passar_adiante      ; Se não for 'H', ignora

    ; --- SE CHEGOU AQUI, O USUÁRIO PRESSIONOU CTRL + H ---
    
    ; 1. Limpa o buffer do teclado para o caractere não aparecer na tela
    in al,61h
    or al,80h
    out 61h,al
    and al,7Fh
    out 61h,al
    mov al,20h
    out 20h,al             ; Envia o sinal EOI (End of Interrupt) para o PIC

    ; 2. Pega a hora do sistema via BIOS (INT 1Ah)
    mov ah,02h
    int 1Ah                 ; Retorna CH=Hora, CL=Minuto, DH=Segundo em BCD

    ; 3. Converte a Hora (CH) de BCD para ASCII e joga na string
    mov al,ch
    call bcd_para_ascii
    mov [msg_hora],ah
    mov [msg_hora+1],al

    ; 4. Converte o Minuto (CL)
    mov al,cl
    call bcd_para_ascii
    mov [msg_hora+3],ah
    mov [msg_hora+4],al

    ; 5. Converte o Segundo (DH)
    mov al,dh
    call bcd_para_ascii
    mov [msg_hora+6],ah
    mov [msg_hora+7],al

    ; 6. Imprime a string na tela usando a INT 21h (Função 09h)
    mov dx,offset msg_hora
    mov ah,09h
    int 21h

    ; Restaura os registradores e sai da interrupção (já tratada)
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    popf
    iret

passar_adiante:
    ; Se não foi o nosso atalho, passa o controle para a INT 9 original do DOS
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    popf
    jmp dword ptr cs:[velha_int9]

nova_int9 endp

; --- FUNÇÃO AUXILIAR PARA CONVERTER BCD PARA ASCII ---
bcd_para_ascii proc near
    mov ah,al
    and al,0Fh             ; Isolando o dígito menos significativo
    add al,'0'             ; Transforma em caractere
    shr ah,1               ; Isolando o dígito mais significativo
    shr ah,1
    shr ah,1
    shr ah,1
    add ah,'0'             ; Transforma em caractere
    ret
bcd_para_ascii endp

fim_do_residente:           ; Marcador para sabermos o tamanho do bloco residente

end inicio
