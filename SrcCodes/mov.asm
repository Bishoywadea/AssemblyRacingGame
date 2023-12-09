;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function : car MOVement using arrows
;author : -NoName  && Ahmed Hamdy
;Date : 28-11-2023
IDEAL
MODEL compact
STACK 100h
DATASEG
    FINISH  db 'GAME ENDED!!!.', '$'


;Location parameters
XPlayer2        dw 107
YPlayer2        dw 100
NextXPlayer2     dw 107
NextYPlayer2     dw 100
PrevXPlayer2     dw 107
PrevYPlayer2     dw 100
XPlayer1        dw 214
YPlayer1        dw 100
NextXPlayer1     dw 214
NextYPlayer1     dw 100
PrevXPlayer1     dw 214
PrevYPlayer1     dw 100

;Players' Flags
flag            db 1
PowerUpsPlayer1 db 0 ; idicates which power ups the player1 has
PowerUpsPlayer2 db 0 ; idicates which power ups the player2 has
PassFlagPlayer1 db 0 ; for "pass an obstacle" powerUp player1 
PassFlagPlayer2 db 0 ; for "pass an obstacle" powerUp player2 

;Time parameters
TimerGame       dw 0
TimerPlayer1    db 0 ; holds the time when the slow-down/speed-up is activated to compare with for player1
TimerPlayer2    db 0 ; holds the time when the slow-down/speed-up is activated to compare with for player2
GameFinishFlag  db 0 ;If It's 1 then the game timer has finished

;Speed parameters
Slow            EQU 1 ; when the "slow-down" power up is activated
Normal          EQU 4 ; when no power ups are activated
Fast            EQU 10 ; when the "slow-down" power up is activated
SpeedPlayer1    dW  Normal ; idicates the number of pixels the player1 can MOVe at single loop
SpeedPlayer2    dw  Normal ; idicates the number of pixels the player2 can MOVe at single loop

; Keyboard scan codes we'll need
KeyEsc      EQU 01h
KeyW        EQU 11h
KeyS        EQU 1Fh
KeyD        EQU 20h
KeyA        EQU 1Eh
UpArrow     EQU 48h
DownArrow   EQU 50h
RightArrow  EQU 4Dh
LeftArrow   EQU 4Bh
KeySpace    EQU 39h ;pressed to activate the current power up of player1
KeyY        EQU 15h ;pressed to activate the current power up of player2

; Colors
BlackClr    EQU 00H 
GreenClr    EQU 02H 
BrownClr    EQU 06H 
GreyClr     EQU 08H 
BlueClr     EQU 09H 
RedClr      EQU 0CH 
YellowClr   EQU 0EH 
WhiteClr    EQU 0FH 

; Players' images and parameters
obstacleWidth   EQU 3
imgW            EQU 13
imgH            EQU 23
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

; Custom handler for int 09h
PROC onKeyEvent 
    PUSH ax bx
    IN   al, 60h
    MOV  ah, 0
    MOV  bx, ax
    AND  bx, 127           ; 7-bit scancode goes to BX
    SHL  ax, 1             ; 1-bit pressed/released goes to AH
    XOR  ah, 1             ; -> AH=1 Pressed, AH=0 Released
    MOV  [KeyList + bx], ah
    MOV  al, 20h           ; The non specific EOI (End Of Interrupt)
    OUT  20h, al
    POP  bx ax
    IRET
ENDP

CODESEG

PROC sleepSomeTime
    MOV cx, 0
    MOV dx, 20000  ; 20ms
    MOV ah, 86h
    int 15h  ; param is cx:dx (in microseconds)
    RET
ENDP

PROC CheckTimer
    MOV AH,2CH
    INT 21H
    MOV AL,CL
    MOV BX,60D
    MUL BX
    SHR DX,8D ;MAKE DL= DH AND DH =0
    ADD AX,DX
    SUB AX,[TimerGame]
    CMP AX,1200
    JL GameNotFinished
    MOV [GameFinishFlag],1
    RET
    GameNotFinished:
    SUB DL,TimerPlayer1
    CMP DL,5
    JL  skip_player1 
    MOV [SpeedPlayer1],Normal
    skip_player1:
    ADD DL,TimerPlayer1
    SUB DL,TimerPlayer2
    CMP DL,5
    JL skip_player2
    MOV [SpeedPlayer2],Normal
    skip_player2: 
    RET
ENDP

PROC drawPlayer1Up
    MOV AX,0A000h
    MOV ES,AX
    MOV AX,320d
    MUL [YPlayer1]
    ADD AX,[XPlayer1]
    MOV BX,AX
    SUB AX,320*(imgH/2)+(imgW/2)            ;320*floor(imgH/2) + floor(imgW/2)

    MOV DI,AX
    CLD
    LEA SI,img
    MOV CX,0
    MOV DX,0
    p1_label_U:
    MOV CX,imgW             ; imgW
    rep MOVSB
    ADD DI,320-imgW         ; 320-IMGW
    INC DX
    CMP DX,imgH             ; imgH
    JNE p1_label_U

    RET
ENDP

PROC cleanPlayer1
    MOV AX,320
    MUL YPlayer1
    ADD AX,XPlayer1
    SUB AX,320*(imgH/2)+(imgW/2)           ;320*floor(imgH/2) + floor(imgW/2)
    MOV DI,AX
    ClD
    p1_label_eraseH:
    INC DX
    MOV CX,imgW             ;imgW
    MOV AL,00H
    rep STOSB
    ADD DI,320-imgW         ; 320-IMGW
    CMP DX,imgH             ;imgH
    JNE p1_label_eraseH
    RET
ENDP

PROC drawPlayer2Up
    MOV AX,0A000h
    MOV ES,AX
    MOV AX,320d
    MUL [YPlayer2]
    ADD AX,[XPlayer2]
    MOV BX,AX
    SUB AX,320*(imgH/2)+(imgW/2)            ;320*floor(imgH/2) + floor(imgW/2)

    MOV DI,AX
    CLD
    LEA SI,img2
    MOV CX,0
    MOV DX,0
    p2_label_U:
    MOV CX,imgW             ; imgW
    rep MOVSB
    ADD DI,320-imgW             ;320-IMGW
    INC DX
    CMP DX,imgH             ; imgH
    JNE p2_label_U

    RET
ENDP

PROC checkPlayer1
    MOV AX,320d
    MUL [NextYPlayer1]
    ADD AX,[NextXPlayer1]
    SUB AX,320*(imgH/2)+(imgW/2)
    MOV DI,AX
    MOV CX,0
    p1_checkBDown2:
    MOV DX,0
    p1_checkBDown1:
    ; Check if it's track
    MOV AL,BlackClr
    CMP ES:[DI],AL
    JNE p1_checkObstacles
    
    acceptMOVement_p1:
    INC DI    
    INC DX
    CMP DX,imgW
    JNE p1_checkBDown1
    ADD DI,320-imgW
    INC CX
    CMP CX,imgH
    JNE p1_checkBDown2
    RET

    ; check if it's an obstacle
    p1_checkObstacles:
    MOV AL,GreyClr
    CMP ES:[DI],AL
    JNE p1_checkSpeedUp
    CMP [PassFlagPlayer1],1  
    JE acceptMOVement_p1

    ; check if it's a "speed up" power-up
    p1_checkSpeedUp:
    MOV AL,RedClr
    CMP ES:[DI],AL
    JNE p1_checkSlowDown
    MOV [PowerUpsPlayer1],1
    JMP acceptMOVement_p1

    ; check if it's a "slow down" power-up
    p1_checkSlowDown:
    MOV AL,BlueClr
    CMP ES:[DI],AL
    JNE p1_checkPassObstacles
    MOV [PowerUpsPlayer1],2
    JMP acceptMOVement_p1
    
    ; check if it's a "pass an obstacle" power-up
    p1_checkPassObstacles:
    MOV AL,WhiteClr
    CMP ES:[DI],AL
    JNE p1_checkGenerateObstacles
    MOV [PowerUpsPlayer1],3
    JMP acceptMOVement_p1
    
    ; check if it's a "generate an obstacle" power-up
    p1_checkGenerateObstacles:
    MOV AL,BrownClr
    CMP ES:[DI],AL
    JNE p1_finshDown
    MOV [PowerUpsPlayer1],4
    JMP acceptMOVement_p1
    
    p1_finshDown:
    MOV[flag],0
    RET
ENDP

PROC checkPlayer2
    MOV AX,320d
    MUL [NextYPlayer2]
    ADD AX,[NextXPlayer2]
    SUB AX,320*(imgH/2)+(imgW/2)
    MOV DI,AX
    MOV CX,0
    p2_checkBDown2:
    MOV DX,0
    p2_checkBDown1:
    ; Check if it's track
    MOV AL,BlackClr
    CMP ES:[DI],AL
    JNE p2_checkObstacles
    
    acceptMOVement_p2:
    INC DI    
    INC DX
    CMP DX,imgW
    JNE p2_checkBDown1
    ADD DI,320-imgW
    INC CX
    CMP CX,imgH
    JNE p2_checkBDown2
    RET

    ; check if it's an obstacle
    p2_checkObstacles:
    MOV AL,GreyClr
    CMP ES:[DI],AL
    JNE p2_checkSpeedUp
    CMP [PassFlagPlayer2],1
    JE acceptMOVement_p2

    ; check if it's a "speed up" power-up
    p2_checkSpeedUp:
    MOV AL,RedClr
    CMP ES:[DI],AL
    JNE p2_checkSlowDown
    MOV [PowerUpsPlayer2],1
    JMP acceptMOVement_p2

    ; check if it's a "slow down" power-up
    p2_checkSlowDown:
    MOV AL,BlueClr
    CMP ES:[DI],AL
    JNE p2_checkPassObstacles
    MOV [PowerUpsPlayer2],2
    JMP acceptMOVement_p2
    
    ; check if it's a "pass an obstacle" power-up
    p2_checkPassObstacles:
    MOV AL,WhiteClr
    CMP ES:[DI],AL
    JNE p2_checkGenerateObstacles
    MOV [PowerUpsPlayer2],3
    JMP acceptMOVement_p2
    
    ; check if it's a "generate an obstacle" power-up
    p2_checkGenerateObstacles:
    MOV AL,BrownClr
    CMP ES:[DI],AL
    JNE p2_finshDown
    MOV [PowerUpsPlayer2],4
    JMP acceptMOVement_p2

    
    p2_finshDown:
    MOV[flag],0
    RET
ENDP

PROC cleanPlayer2
    MOV AX,320
    MUL [YPlayer2]
    ADD AX,[XPlayer2]
    SUB AX,320*(imgH/2)+(imgW/2)           ;320*floor(imgH/2) + floor(imgW/2)
    MOV DI,AX
    ClD
    LEA SI,img2
    MOV BX,0
    p2_label_eraseH:
    INC DX
    MOV CX,imgW          ;imgW
    MOV AL,00H
    rep STOSB
    ADD DI,320-imgW          ;320-3   ;320-IMGW
    CMP DX,imgH           ;imgH
    JNE p2_label_eraseH
    RET
ENDP

PROC GenerateObstacle_p1
    MOV [flag],1
    CALL checkPlayer1
    CMP [flag],1
    JE SkipGenerate_p1
    MOV [PowerUpsPlayer1],0
    MOV AX,320
    MUL [PrevYPlayer1]
    ADD AX,[PrevXPlayer1]
    MOV DI,AX
    MOV AL,GreyClr
    CALL drawSqr
    ; CLD
    ; MOV BX,0
    ; p1_eraseH:
    ; INC DX
    ; MOV CX,imgW          ;imgW
    ; rep STOSB
    ; ADD DI,320-imgW            ;320-IMGW
    ; CMP DX,obstacleWidth           
    ; JNE p1_eraseH
    SkipGenerate_p1:
    RET
ENDP

PROC GenerateObstacle_p2
    MOV [flag],1
    CALL checkPlayer2
    CMP [flag],1
    JE SkipGenerate_p2
    MOV [PowerUpsPlayer2],0
    MOV AX,320
    MUL [PrevYPlayer2]
    ADD AX,[PrevXPlayer2]
    MOV DI,AX
    MOV AL,GreyClr
    CALL drawSqr
    ; CLD
    ; LEA SI,img2
    ; MOV BX,0
    ; p2_eraseH:
    ; INC DX
    ; MOV CX,imgW          ;imgW
    ; MOV AL,GreyClr
    ; rep STOSB
    ; ADD DI,320-imgW            ;320-IMGW
    ; CMP DX,obstacleWidth           
    ; JNE p2_eraseH
    SkipGenerate_p2:
    RET
ENDP

PROC if_ArrowUp_isPressed
    CMP [byte KeyList + UpArrow], 1
    JNE handleUp_end
    CALL cleanPlayer1
    MOV AX,[SpeedPlayer1]
    SUB [NextYPlayer1],AX
    CALL checkPlayer1
    CMP [flag],1
    JNE skip_ArrowUp
    MOV AX,[SpeedPlayer1]
    SUB [YPlayer1],AX
    MOV BX,[YPlayer1]
    MOV [PrevYPlayer1],BX
    ADD [PrevYPlayer1],imgH
    CALL drawPlayer1Up
    handleUp_end:
    MOV [flag],1
    RET
    skip_ArrowUp:
    MOV AX,[SpeedPlayer1]
    ADD [NextYPlayer1],AX 
    MOV [flag],1
    CALL drawPlayer1Up
    RET
    ENDP

PROC if_ArrowDown_isPressed
    CMP [byte KeyList + DownArrow], 1
    JNE handleDown_end
    CALL cleanPlayer1
    MOV AX,[SpeedPlayer1]
    ADD [NextYPlayer1],AX
    CALL checkPlayer1
    CMP [flag],1
    JNE skip_ArrowDown
    MOV AX,[SpeedPlayer1]
    ADD [YPlayer1],AX
    MOV BX,[YPlayer1]
    MOV [PrevYPlayer1],BX
    SUB [PrevYPlayer1],imgH
    CALL drawPlayer1Up
    handleDown_end:
    MOV [flag],1
    RET
    skip_ArrowDown:
    MOV AX,[SpeedPlayer1]
    SUB [NextYPlayer1],AX
    MOV [flag],1
    CALL drawPlayer1Up
    RET
ENDP

PROC if_ArrowRight_isPressed
    CMP [byte KeyList + RightArrow], 1
    JNE handleRight_end
    CALL cleanPlayer1
    MOV AX,[SpeedPlayer1]
    ADD [NextXPlayer1],AX
    CALL checkPlayer1
    CMP [flag],1
    JNE skip_ArrowRight
    MOV AX,[SpeedPlayer1]
    ADD [XPlayer1],AX
    MOV BX,[XPlayer1]
    MOV[PrevXPlayer1],BX
    SUB [PrevXPlayer1],imgW
    CALL drawPlayer1Up
    handleRight_end:
    MOV [flag],1
    RET
    skip_ArrowRight:
    MOV AX,[SpeedPlayer1]
    SUB[NextXPlayer1],AX
    MOV [flag],1
    CALL drawPlayer1Up
    RET
ENDP

PROC if_ArrowLeft_isPressed
    CMP [byte KeyList + LeftArrow], 1
    JNE handleLeft_end
    CALL cleanPlayer1
    MOV AX,[SpeedPlayer1]
    SUB [NextXPlayer1],AX
    CALL checkPlayer1
    CMP [flag],1
    JNE skip_ArrowLeft
    MOV AX,[SpeedPlayer1]
    SUB [XPlayer1],AX
    MOV BX,[XPlayer1]
    MOV[PrevXPlayer1],BX
    ADD [PrevXPlayer1],imgW+obstacleWidth
    CALL drawPlayer1Up
    handleLeft_end:
    MOV [flag],1
    RET
    skip_ArrowLeft:
    MOV AX,[SpeedPlayer1]
    ADD[NextXPlayer1],AX
    MOV [flag],1
    CALL drawPlayer1Up
    RET
ENDP

PROC if_W_isPressed
    CMP [byte KeyList + KeyW], 1
    JNE handleW_end
    CALL cleanPlayer2
    MOV AX,[SpeedPlayer2]
    SUB [NextYPlayer2],AX
    CALL checkPlayer2
    CMP [flag],1
    JNE skip_W
    MOV AX,[SpeedPlayer2]
    SUB [YPlayer2],AX
    MOV BX,[YPlayer2]
    MOV[PrevYPlayer2],BX
    ADD [PrevYPlayer2],imgH+obstacleWidth
    CALL drawPlayer2Up
    handleW_end:
    MOV [flag],1
    RET
    skip_W:
    MOV AX,[SpeedPlayer2]
    ADD[NextYPlayer2],AX
    MOV [flag],1
    CALL drawPlayer2Up
    RET
ENDP

PROC if_S_isPressed
    CMP [byte KeyList + KeyS], 1
    JNE handleS_end
    CALL cleanPlayer2
    MOV AX,[SpeedPlayer2]
    ADD [NextYPlayer2],AX
    CALL checkPlayer2
    CMP [flag],1
    JNE skip_S
    MOV AX,[SpeedPlayer2]
    ADD [YPlayer2],AX
    MOV BX,[YPlayer2]
    MOV[PrevYPlayer2],BX
    SUB [PrevYPlayer2],obstacleWidth
    CALL drawPlayer2Up
    handleS_end:
    MOV [flag],1
    RET
    skip_S:
    MOV AX,[SpeedPlayer2]
    SUB[NextYPlayer2],AX
    MOV [flag],1
    CALL drawPlayer2Up
    RET
ENDP

PROC if_D_isPressed
    CMP [byte KeyList + KeyD], 1
    JNE handleD_end
    CALL cleanPlayer2
    MOV AX,[SpeedPlayer2]
    ADD [NextXPlayer2],AX
    CALL checkPlayer2
    CMP [flag],1
    JNE skip_D
    MOV AX,[SpeedPlayer2]
    ADD [XPlayer2],AX
    MOV BX,[XPlayer2]
    MOV[PrevXPlayer2],BX
    ADD [PrevXPlayer2],obstacleWidth
    CALL drawPlayer2Up
    handleD_end:
    MOV [flag],1
    RET
    skip_D:
    MOV AX,[SpeedPlayer2]
    SUB[NextXPlayer2],AX
    MOV [flag],1
    CALL drawPlayer2Up
    RET
ENDP

PROC if_A_isPressed
    CMP [byte KeyList + KeyA], 1
    JNE handleA_end
    CALL cleanPlayer2
    MOV AX,[SpeedPlayer2]
    SUB [NextXPlayer2],AX
    CALL checkPlayer2
    CMP [flag],1
    JNE skip_A
    MOV AX,[SpeedPlayer2]
    SUB [XPlayer2],AX
    MOV BX,[XPlayer2]
    MOV[PrevXPlayer2],BX
    SUB [PrevXPlayer2],imgW
    CALL drawPlayer2Up
    handleA_end:
    MOV [flag],1
    RET
    skip_A:
    MOV AX,[SpeedPlayer2]
    ADD[NextXPlayer2],AX
    MOV [flag],1
    CALL drawPlayer2Up
    RET
ENDP

PROC if_player1_fired
    CMP [byte KeyList + KeySpace], 1
    JNE skip_Space
    CMP [PowerUpsPlayer1],0
    JE skip_Space        

    CMP [PowerUpsPlayer1],1
    JNE CheckSlow_p1
    MOV [SpeedPlayer1],Fast
    JMP setTimer
    
    CheckSlow_p1:
    CMP [PowerUpsPlayer1],2
    JNE CheckPassObs_p1    
    MOV [SpeedPlayer2],Slow
    JMP setTimer

    setTimer:
    MOV AH,2CH
    INT 21H
    CMP DH,55
    JL lessThan55
    SUB DH,60
    lessThan55:
        CMP [PowerUpsPlayer1],1
        JNE setSlowTimer_p2
        MOV [TimerPlayer1],DH
        JMP Activate_Powerup_p1
        setSlowTimer_p2:
        MOV [TimerPlayer2],DH
    JMP Activate_Powerup_p1

    CheckPassObs_p1:
    CMP [PowerUpsPlayer1],3
    JNE CheckGenObs_p1
    MOV [PassFlagPlayer1],1
    JMP Activate_Powerup_p1
    
    CheckGenObs_p1:
    CMP [PowerUpsPlayer1],4
    JNE skip_Space        
    CALL GenerateObstacle_p1
    CMP [flag],0
    JNE skip_Space
    MOV [flag],1
    RET

    Activate_Powerup_p1: 
    MOV [PowerUpsPlayer1],0 
    skip_Space:
    RET
ENDP

PROC if_player2_fired
    CMP [byte KeyList + KeyY], 1
    JNE skip_y
    CMP [PowerUpsPlayer2],0
    JE skip_y
    
    CMP [PowerUpsPlayer2],1
    JNE CheckSlow_p2
    MOV [SpeedPlayer2],Fast
    JMP setTimer_p2
    
    CheckSlow_p2:
    CMP [PowerUpsPlayer2],2
    JNE CheckPassObs_p2    
    MOV [SpeedPlayer1],Slow
    JMP setTimer_p2

    setTimer_p2:
    MOV AH,2CH
    INT 21H
    CMP DH,55
    JL lessThan55_p2
    SUB DH,60
    lessThan55_p2:
        CMP [PowerUpsPlayer2],1
        JNE setSlowTimer_p1
        MOV [TimerPlayer2],DH
        JMP Activate_Powerup_p2
        setSlowTimer_p1:
        MOV [TimerPlayer1],DH
    JMP Activate_Powerup_p2



    CheckPassObs_p2:
    CMP [PowerUpsPlayer2],3
    JNE CheckGenObs_p2        
    MOV [PassFlagPlayer2],1
    JMP Activate_Powerup_p2
    
    CheckGenObs_p2:
    CMP [PowerUpsPlayer2],4
    JNE skip_y        
    CALL GenerateObstacle_p2
    CMP [flag],0
    JNE skip_y
    MOV [flag],1
    RET
    
    Activate_Powerup_p2: 
    MOV [PowerUpsPlayer2],0    
    skip_y:
    RET
ENDP

PROC drawSqr
    MOV cl,6
    MOV ch,6
    lp3:
        MOV es:[di],al
        ADD di,320
        DEC cl
        CMP cl,0
        JNE lp3
        DEC ch
        MOV cl,6
        SUB di,6*320
        INC di
        CMP ch,0
        JNE lp3
    lp1: RET
ENDP

PROC main
    CALL drawPlayer1Up
    CALL drawPlayer2Up
    
    ;Hard coded Obstacles and power ups
        MOV di,6450d
    ;slowDown
        MOV al,BlueClr
        CALL drawSqr
        ADD di, 49600
    ;speedUp
        MOV al,RedClr
        CALL drawSqr
        ADD di, 19600
    ;passObstacles
        MOV al,GreyClr
        CALL drawSqr
        ADD di, 8200
    ;genObstacles
        MOV al,GreyClr
        CALL drawSqr
        SUB di, 12600
    ;obstacles
        MOV al,GreyClr
        CALL drawSqr
        ADD di, 24600
        
        CALL drawSqr
        
        ;get the starting time of the game
        MOV AH,2CH
        INT 21H
        MOV AL,CL
        CMP AL,58
        JL lessThan58
        SUB AL,60
        lessThan58:
        MOV BX,60D
        MUL BX
        SHR DX,8D ;MAKE DL= DH AND DH =0
        ADD AX,DX
        MOV [TimerGame],AX

    mainLoop:
        CALL CheckTimer
        CALL sleepSomeTime
        MOV [flag],1
        CALL if_ArrowUp_isPressed
        MOV [flag],1
        CALL if_ArrowDown_isPressed
        MOV [flag],1
        CALL if_ArrowRight_isPressed
        MOV [flag],1
        CALL if_ArrowLeft_isPressed
        MOV [flag],1
        CALL if_W_isPressed
        MOV [flag],1
        CALL if_S_isPressed
        MOV [flag],1
        CALL if_D_isPressed
        MOV [flag],1
        CALL if_A_isPressed
        MOV [flag],1
        CALL if_player1_fired
        MOV [flag],1
        CALL if_player2_fired

    ; if Esc is not pressed, jump back to mainLoop
    CMP [GameFinishFlag], 1
    JNE mainLoop
    
    ;test Timer
    
                 mov        ah, 0
                 mov        al, 13h
                 int        10h
                
               mov dl, 0AH
               mov dh, 7H
               mov ah, 2H
               int 10h
            mov ah,09h
            lea dx,FINISH
            int 21h

    RET
ENDP


start:
    MOV   AX,@DATA
    MOV   DS,AX
    MOV AX,0A000h
    MOV ES,AX
; enter graphic mode
    MOV ax, 13h
    int 10h

; get the ADDress of the existing int09h handler
    MOV ax, 3509h ; Get Interrupt Vector
    int  21h ; -> ES:BX
    push es bx

    MOV dx, offset onKeyEvent
    MOV ax, 2509h
    int 21h

    CALL main

    HLT
end start