;5-2.asm  计算Y=5X-18，用正常程序格式
data segment
    x db  -6             ;x初始为-6
    y dw ?               ;y初始为空
    cc  db 0ah,0dh,'Y=$'
data ends
code segment 
    assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax
    
    mov al,5            ;5X
    imul x 
    sub ax,18           ;-18
    jns let0            ;结果不为负则转移
    neg ax              ;结果为负，求绝对值,-ax -> ax
let0:
    mov y,ax            ;保存结果,ax -> y

                        ;将ax中的二进制数变为十进制数，并显示
    mov cx,0
    mov bx,10                
let1:                        
    mov dx,0
    inc cx              ;统计余数个数
    idiv bx             ;AX/10，商在AX，余数在DX
    push dx             ;保存余数
    cmp ax,0            ;商为0，则退出循环
    jnz let1
    mov dx,offset cc    ;9号功能显示提示
    mov ah,9
    int 21h
let2:                   ;循环执行cx次，显示十进制结果    
    pop ax              ;将余数弹入ax
    add ax,0030h        ;调整为ASCII码
    mov dl,al           ;2号功能，显示一个字符
    mov ah,2
    int 21h
    dec cx
    cmp cx,0
    jnz let2
    mov ah,4ch
    int 21h
code ends
end start
