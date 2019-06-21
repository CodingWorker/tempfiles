data segment
	x dw 9,-6,34
	y dw 3 dup(?)
data ends

code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax

	mov cx,3
	mov si,0
let0:
	mov ax,x[si]
	cmp ax,0
	jge let1
	mov bx,ax
	imul bx
	jmp out1
let1:
	cmp ax,10
	jge let2
	mov bx,2
	imul bx
	add ax,3
	jmp out1
let2:
	mov bl,6
	idiv bl
	mov ah,0
	jmp out1
out1:
	mov y[si],ax
	add si,2
	dec cx
	cmp cx,0
	jnz let0
	mov ah,4c
	int 21
code ends
end start
