;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function : car movement using arrows
;author : -NoName  && Ahmed Hamdy
;Date : 28-11-2023
IDEAL
MODEL compact
STACK 100h
DATASEG
flag DB 1
xPlayer2 dw 107
yPlayer2 dw 100
NxtxPlayer2 dw 107
NxtyPlayer2 dw 100
xPlayer1 dw 214
yPlayer1 dw 100
NxtxPlayer1 dw 214
NxtyPlayer1 dw 100

; keyboard scan codes we'll need
KeyEsc    equ 01h
KeyW      equ 11h
KeyS      equ 1Fh
KeyD      equ 20h
KeyA      equ 1Eh
UpArrow   equ 48h
DownArrow equ 50h
RightArrow equ 4Dh
LeftArrow equ 4Bh

img DB 0, 0, 16, 16, 184, 184, 184, 184, 184, 16, 16, 0, 0, 0, 16, 113, 137, 113, 113, 113, 113, 113, 6, 112, 16, 0, 0, 208, 136, 136, 12, 6, 6, 6, 4, 184, 113, 185, 0, 0 
 DB 17, 12, 6, 6, 6, 6, 6, 6, 4, 4, 16, 0, 0, 209, 12, 6, 6, 6, 6, 6, 6, 6, 4, 184, 0, 0, 209, 12, 6, 6, 6, 6, 6, 6, 6, 4, 184, 0, 0, 209 
 DB 12, 6, 6, 136, 136, 136, 6, 6, 4, 184, 0, 0, 208, 161, 218, 244, 76, 76, 76, 244, 218, 112, 184, 0, 0, 16, 76, 76, 76, 76, 76, 76, 76, 11, 11, 16, 0, 17, 16, 75 
 DB 100, 76, 76, 76, 76, 76, 11, 11, 16, 17, 16, 146, 220, 75, 74, 17, 17, 17, 74, 11, 220, 146, 16, 0, 21, 26, 12, 12, 6, 6, 6, 4, 112, 25, 21, 0, 0, 147, 26, 12 
 DB 6, 6, 6, 6, 6, 4, 25, 147, 0, 0, 147, 208, 12, 6, 6, 6, 6, 6, 6, 184, 147, 0, 0, 244, 208, 6, 6, 6, 6, 6, 6, 6, 184, 244, 0, 0, 21, 208, 6, 6 
 DB 6, 6, 6, 6, 6, 184, 21, 0, 0, 147, 208, 12, 6, 6, 6, 6, 6, 6, 184, 147, 0, 0, 17, 137, 12, 6, 6, 6, 6, 6, 4, 184, 17, 0, 0, 209, 138, 12, 12, 6 
 DB 6, 6, 4, 4, 112, 184, 0, 0, 209, 17, 137, 113, 185, 185, 185, 113, 112, 16, 184, 0, 0, 209, 208, 12, 6, 6, 6, 6, 6, 4, 184, 184, 0, 0, 209, 208, 12, 6, 6, 6 
 DB 6, 6, 4, 184, 184, 0, 0, 16, 209, 136, 136, 113, 113, 184, 184, 184, 185, 16, 0

img2 DB 0, 0, 16, 16, 184, 184, 184, 184, 184, 16, 16, 0, 0, 0, 16, 113, 137, 113, 113, 113, 113, 113, 6, 112, 16, 0, 0, 208, 136, 136, 12, 6, 6, 6, 4, 184, 113, 185, 0, 0 
 DB 17, 12, 6, 6, 6, 6, 6, 6, 4, 4, 16, 0, 0, 209, 12, 6, 6, 6, 6, 6, 6, 6, 4, 184, 0, 0, 209, 12, 6, 6, 6, 6, 6, 6, 6, 4, 184, 0, 0, 209 
 DB 12, 6, 6, 136, 136, 136, 6, 6, 4, 184, 0, 0, 208, 161, 218, 244, 76, 76, 76, 244, 218, 112, 184, 0, 0, 16, 76, 76, 76, 76, 76, 76, 76, 11, 11, 16, 0, 17, 16, 75 
 DB 100, 76, 76, 76, 76, 76, 11, 11, 16, 17, 16, 146, 220, 75, 74, 17, 17, 17, 74, 11, 220, 146, 16, 0, 21, 26, 12, 12, 6, 6, 6, 4, 112, 25, 21, 0, 0, 147, 26, 12 
 DB 6, 6, 6, 6, 6, 4, 25, 147, 0, 0, 147, 208, 12, 6, 6, 6, 6, 6, 6, 184, 147, 0, 0, 244, 208, 6, 6, 6, 6, 6, 6, 6, 184, 244, 0, 0, 21, 208, 6, 6 
 DB 6, 6, 6, 6, 6, 184, 21, 0, 0, 147, 208, 12, 6, 6, 6, 6, 6, 6, 184, 147, 0, 0, 17, 137, 12, 6, 6, 6, 6, 6, 4, 184, 17, 0, 0, 209, 138, 12, 12, 6 
 DB 6, 6, 4, 4, 112, 184, 0, 0, 209, 17, 137, 113, 185, 185, 185, 113, 112, 16, 184, 0, 0, 209, 208, 12, 6, 6, 6, 6, 6, 4, 184, 184, 0, 0, 209, 208, 12, 6, 6, 6 
 DB 6, 6, 4, 184, 184, 0, 0, 16, 209, 136, 136, 113, 113, 184, 184, 184, 185, 16, 0

KeyList db 128 dup (0)


proc onKeyEvent  ; custom handler for int 09h
    push ax bx
    in   al, 60h
    mov  ah, 0
    mov  bx, ax
    and  bx, 127           ; 7-bit scancode goes to BX
    shl  ax, 1             ; 1-bit pressed/released goes to AH
    xor  ah, 1             ; -> AH=1 Pressed, AH=0 Released
    mov  [KeyList + bx], ah
    mov  al, 20h           ; The non specific EOI (End Of Interrupt)
    out  20h, al
    pop  bx ax
    iret
endp

CODESEG

proc sleepSomeTime
    mov cx, 0
    mov dx, 20000  ; 20ms
    mov ah, 86h
    int 15h  ; param is cx:dx (in microseconds)
    ret
endp


proc drawPlayer1Up
    MOV AX,0A000h
    MOV ES,AX
    MOV AX,320d
    MUL yPlayer1
    ADD AX,xPlayer1
    MOV BX,AX
    SUB AX,3846            ;320*floor(imgH/2) + floor(imgW/2)

    MOV DI,AX
    ClD
    LEA SI,img
    MOV CX,0
    MOV DX,0
    p1_label_U:
    MOV CX,13             ; imgW
    rep MOVSB
    ADD DI,307           ;320-3   ;320-IMGW
    INC DX
    CMP DX,23             ; imgH
    JNE p1_label_U

    ret
endp

proc erasePlayer1Vertical
    MOV AX,0A000h
    MOV ES,AX
    MOV AX,320
    MUL yPlayer1
    ADD AX,xPlayer1
    SUB AX,3846           ;320*floor(imgH/2) + floor(imgW/2)
    MOV DI,AX
    ClD
    p1_label_eraseH:
    INC DX
    MOV CX,13          ;imgW
    MOV AL,00H
    rep STOSB
    ADD DI,307          ;320-3   ;320-IMGW
    CMP DX,23           ;imgH
    JNE p1_label_eraseH
    ret
endp

proc drawPlayer2Up
    MOV AX,0A000h
    MOV ES,AX
    MOV AX,320d
    MUL yPlayer2
    ADD AX,xPlayer2
    MOV BX,AX
    SUB AX,3846            ;320*floor(imgH/2) + floor(imgW/2)

    MOV DI,AX
    ClD
    LEA SI,img2
    MOV CX,0
    MOV DX,0
    p2_label_U:
    MOV CX,13             ; imgW
    rep MOVSB
    ADD DI,307           ;320-3   ;320-IMGW
    INC DX
    CMP DX,23             ; imgH
    JNE p2_label_U

    ret
endp

proc checkPlayer1
    MOV AX,0A000h
    MOV ES,AX
    MOV AX,320d
    MUL NxtyPlayer1
    ADD AX,NxtxPlayer1
    SUB AX,3846
    MOV DI,AX
    MOV CX,0
    p1_label_checkBDown2:
    MOV DX,0
    p1_label_checkBDown1:
    MOV AL,00h
    CMP ES:[DI],AL
    JNE p1_finshDown
    INC DI    
    INC DX
    CMP DX,13
    JNE p1_label_checkBDown1
    ADD DI,307
    INC CX
    CMP CX,23
    JNE p1_label_checkBDown2
    RET
    p1_finshDown:
    MOV[flag],0
    ret
endp

proc checkPlayer2
    MOV AX,0A000h
    MOV ES,AX
    MOV AX,320d
    MUL NxtyPlayer2
    ADD AX,NxtxPlayer2
    SUB AX,3846
    MOV DI,AX
    MOV CX,0
    p2_label_checkBDown2:
    MOV DX,0
    p2_label_checkBDown1:
    MOV AL,00h
    CMP ES:[DI],AL
    JNE p2_finshDown
    INC DI    
    INC DX
    CMP DX,13
    JNE p2_label_checkBDown1
    ADD DI,307
    INC CX
    CMP CX,23
    JNE p2_label_checkBDown2
    RET
    p2_finshDown:
    MOV[flag],0
    ret
endp

proc erasePlayer2Vertical
    MOV AX,0A000h
    MOV ES,AX
    MOV AX,320
    MUL yPlayer2
    ADD AX,xPlayer2
    SUB AX,3846           ;320*floor(imgH/2) + floor(imgW/2)
    MOV DI,AX
    ClD
    LEA SI,img2
    MOV BX,0
    p2_label_eraseH:
    INC DX
    MOV CX,13          ;imgW
    MOV AL,00H
    rep STOSB
    ADD DI,307          ;320-3   ;320-IMGW
    CMP DX,23           ;imgH
    JNE p2_label_eraseH
    ret
endp

proc if_ArrowUp_isPressed
    cmp [byte KeyList + UpArrow], 1
    jne handleUp_end
    call erasePlayer1Vertical
    dec [NxtyPlayer1]
    call checkPlayer1
    CMP [flag],1
    JNE skip_ArrowUp
    dec [yPlayer1]
    call drawPlayer1Up
    handleUp_end:
    MOV [flag],1
    ret
    skip_ArrowUp:
    inc[NxtyPlayer1]
    MOV [flag],1
    call drawPlayer1Up
    ret
endp

proc if_ArrowDown_isPressed
    cmp [byte KeyList + DownArrow], 1
    jne handleDown_end
    call erasePlayer1Vertical
    inc [NxtyPlayer1]
    call checkPlayer1
    CMP [flag],1
    JNE skip_ArrowDown
    inc [yPlayer1]
    call drawPlayer1Up
    handleDown_end:
    MOV [flag],1
    ret
    skip_ArrowDown:
    dec[NxtyPlayer1]
    MOV [flag],1
    call drawPlayer1Up
    ret
endp

proc if_ArrowRight_isPressed
    cmp [byte KeyList + RightArrow], 1
    jne handleRight_end
    call erasePlayer1Vertical
    inc [NxtxPlayer1]
    call checkPlayer1
    CMP [flag],1
    JNE skip_ArrowRight
    inc [xPlayer1]
    call drawPlayer1Up
    handleRight_end:
    MOV [flag],1
    ret
    skip_ArrowRight:
    dec[NxtxPlayer1]
    MOV [flag],1
    call drawPlayer1Up
    ret
endp

proc if_ArrowLeft_isPressed
    cmp [byte KeyList + LeftArrow], 1
    jne handleLeft_end
    call erasePlayer1Vertical
    dec [NxtxPlayer1]
    call checkPlayer1
    CMP [flag],1
    JNE skip_ArrowLeft
    dec [xPlayer1]
    call drawPlayer1Up
    handleLeft_end:
    MOV [flag],1
    ret
    skip_ArrowLeft:
    inc[NxtxPlayer1]
    MOV [flag],1
    call drawPlayer1Up
    ret
endp

proc if_W_isPressed
    cmp [byte KeyList + KeyW], 1
    jne handleW_end
    call erasePlayer2Vertical
    dec [NxtyPlayer2]
    call checkPlayer2
    CMP [flag],1
    JNE skip_W
    dec [yPlayer2]
    call drawPlayer2Up
    handleW_end:
    MOV [flag],1
    ret
    skip_W:
    inc[NxtyPlayer2]
    MOV [flag],1
    call drawPlayer2Up
    ret
endp

proc if_S_isPressed
    cmp [byte KeyList + KeyS], 1
    jne handleS_end
    call erasePlayer2Vertical
    inc [NxtyPlayer2]
    call checkPlayer2
    CMP [flag],1
    JNE skip_S
    inc [yPlayer2]
    call drawPlayer2Up
    handleS_end:
    MOV [flag],1
    ret
    skip_S:
    dec[NxtyPlayer2]
    MOV [flag],1
    call drawPlayer2Up
    ret
endp

proc if_D_isPressed
    cmp [byte KeyList + KeyD], 1
    jne handleD_end
    call erasePlayer2Vertical
    inc [NxtxPlayer2]
    call checkPlayer2
    CMP [flag],1
    JNE skip_D
    inc [xPlayer2]
    call drawPlayer2Up
    handleD_end:
    MOV [flag],1
    ret
    skip_D:
    dec[NxtxPlayer2]
    MOV [flag],1
    call drawPlayer2Up
    ret
endp

proc if_A_isPressed
    cmp [byte KeyList + KeyA], 1
    jne handleA_end
    call erasePlayer2Vertical
    dec [NxtxPlayer2]
    call checkPlayer2
    CMP [flag],1
    JNE skip_A
    dec [xPlayer2]
    call drawPlayer2Up
    handleA_end:
    MOV [flag],1
    ret
    skip_A:
    inc[NxtxPlayer2]
    MOV [flag],1
    call drawPlayer2Up
    ret
endp

proc main
    call drawPlayer1Up
    call drawPlayer2Up
    
    mainLoop:
        call sleepSomeTime
        MOV [flag],1
        call if_ArrowUp_isPressed
        MOV [flag],1
        call if_ArrowDown_isPressed
        MOV [flag],1
        call if_ArrowRight_isPressed
        MOV [flag],1
        call if_ArrowLeft_isPressed
        MOV [flag],1
        call if_W_isPressed
        MOV [flag],1
        call if_S_isPressed
        MOV [flag],1
        call if_D_isPressed
        MOV [flag],1
        call if_A_isPressed

    ; if Esc is not pressed, jump back to mainLoop
    cmp [byte KeyList + KeyEsc], 1
    jne mainLoop
    
    ret
endp


start:
    MOV   AX,@DATA
    MOV   DS,AX
    MOV AX,0A000h
    MOV ES,AX
; enter graphic mode
    mov ax, 13h
    int 10h

; get the address of the existing int09h handler
    mov ax, 3509h ; Get Interrupt Vector
    int  21h ; -> ES:BX
    push es bx

    mov dx, offset onKeyEvent
    mov ax, 2509h
    int 21h

    call main

    HLT
end start