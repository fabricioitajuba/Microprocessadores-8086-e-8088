	.model small

	.stack 100h

	.data
	Message DB 'Hello, World!',13,10,'$'

	.code

Hello 	Proc
	mov ax, @data
	mov ds, ax
	mov dx, OFFSET Message
	mov ah,9h
	int 21h
	mov al, 00h
	mov ah, 04ch
	int 21h       
Hello 	ENDP

END Hello

