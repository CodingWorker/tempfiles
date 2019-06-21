;5-2-1.asm  计算Y=5X-18，用正常程序格式,X从键盘输入
data segment
    x db ?             ;x初始为空
    y dw ?               ;y初始为空
    cc  db 0ah,0dh,'Y=5X-18=$'    ;换行0ah  回车 0dh
    hint db 'input a number:$'
    newline_c db 0ah
    enter_c db 0dh
    echo_x db 'X=$'
    neg_v db 02dh    ;短横线ascii值
data ends
code segment 
    assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax

out_hint:
    mov dx,offset hint
    mov ah,9    ; 输出提示
    int 21h

    mov dl,[newline_c] ;换行
    int 21h

    mov dl,[enter_c] ;回车
    int 21h
    
    mov cx,0    ;标记输入了几次
scan_a_num:     ;输入一个数字
    inc cx
    mov ah,1    ; 输入中断
    int 21h

    cmp cx,1
    jge temp    ;假设第2次是数字

    cmp al,neg_v    ;比对-字符的ascii
    jg temp

    jmp scan_a_num  ;接收下一个字符
temp:       ;为利用之前的逻辑，这里将al移到x
    mov dx,offset echo_x
    mov ah,9
    int 21h

    mov dl,al   ;输出 X=输入的值
    mov ah,2
    int 21h

    sub al,30   ;转换为真实数字
    mov x,al
    

cal:
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
    mov dx,offset cc    ;9号功能显示提示，offset取偏移量
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
