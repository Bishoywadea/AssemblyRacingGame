.model small
.stack 64 
.data
message1 db 'Please Enter your name','$'
username db 20,?,20 dup('$')
message2 db 'Please Enter your initial points','$'
userpoints db 10,?,10 dup('$')
new_line db 10,13

.code
main proc far
mov ax,@DATA
mov ds,ax

;clearscreen
mov ax,0600h
mov bh,07
mov cx,0
mov dx,184FH
int 10h

    ;set cursor
   mov bh,00    
    mov dh,5
    mov dl,10       
    mov ah,02
    int 10h  
;;
mov ah,09h
mov dx,offset message1
int 21h

    ;set cursor
   mov bh,00    
    mov dh,10
    mov dl,10       
    mov ah,02
    int 10h  

;;
mov ah,09h
mov dx,offset message2
int 21h

    ;set cursor
   mov bh,00    
    mov dh,7
    mov dl,10       
    mov ah,02
    int 10h  
;;
    mov ah,0Ah
    mov dx,offset username
    int 21h
;;
    ;set cursor
   mov bh,00    
    mov dh,12
    mov dl,10  
    mov ah,02
    int 10h  
;;
    mov ah,0Ah
    mov dx,offset userpoints
    int 21h





     

main endp
end main

