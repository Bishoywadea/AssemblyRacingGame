;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function : car movement using arrows
;author : -NoName  && Ahmed Hamdy
;Date : 28-11-2023
.model compact 
.STACK 1024
.DATA
    flag                    DB  1
    key                     DB  42H     ;key pressed
    direction               DB  ?       ;direction
    Speed_p1                EQU 1
    Speed_p2                EQU 1

    curXLoc_p1              DW  50       ;the current col
    curYLoc_p1              DW  50      ;the current row
    orientation_p1          DB  1    ;1->mean Vertical    0->mean Horizontal
    up_key                  EQU 48h
    down_key                EQU 50h
    left_key                EQU 4Bh
    right_key               EQU 4Dh
    curXLoc_p2              DW  200       ;the current col
    curYLoc_p2              DW  150       ;the current row 
    orientation_p2          DB  1     ;1->mean Vertical    0->mean Horizontal                                                                                                                                                                               ;the current to be printed

    w_key                   EQU 77h
    s_key                   EQU 73h
    a_key                   EQU 61h
    d_key                   EQU 64h

    BackGroundColor         EQU 0
    CarColor                EQU 0FH
    imgW                    EQU 13
    imgH                    EQU 23
    
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

.CODE
MAIN PROC FAR
                      MOV   AX,@DATA
                      MOV   DS,AX
                      MOV AX,0A000h
                      MOV ES,AX
                        



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; Inilaizing Video Mode ;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                      MOV   ax, 013h              ;
                      ;MOV   bx, 0100h             ; 640x400 screen graphics mode
                      INT   10h                   ;execute the configuration
                      CALL  DRAW_U
                      CALL  DRAW_U_p2
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Get Key From Buff Then Decide Its Direction ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    CALL CheckMoveP2Down

    ; Test
    mov cl,60
    mov di,6450d
    mov al,0Ah
    lp3:
    mov es:[di],al
    inc di
    dec cl
    cmp cl,0
    jne lp3

    mov cl,60
    mov di,6510d
    mov al,0Ah
    lp:
    mov es:[di],al
    ADD di,320
    dec cl
    cmp cl,0
    jne lp
    

    directionDecision:
    CALL  delay

                      MOV[flag],1
                      MOV   ah, 01H
                      INT   16H
                      CMP   AL,0
                      JE    p2_move
                      MOV   [key],al

    ;checks if key is w_key
                      CMP   [key],w_key
                      JE    move_w
    ;checks if key is s_key
                      CMP   [key],s_key
                      JE    move_s
    ;checks if key is a_key
                      CMP   [key],a_key
                      JE    BreakAJMP
    ;checks if key is d_key
                      CMP   [key],d_key
                      JE    BreakDJMP
                      JMP   directionDecision
                      
    p2_move:          
                      MOV   [key],AH
            
    ;checks if key is up_key
                      CMP   [key],up_key
                      JE    BreakUpJMP
    ;checks if key is down_key
                      CMP   [key],down_key
                      JE    BreakDownJMP
    ;checks if key is left_key
                      CMP   [key],left_key
                      JE    BreakleftJMP
    ;checks if key is right_key
                      CMP   [key],right_key
                      JE    BreakRightJMP
                      JMP   directionDecision
                      

    BreakDJMP:
        JMP move_d
    
    BreakAJMP:
        JMP move_a


    ;;;;;;;;;;;;;
    ; Moving w_key ;
    ;;;;;;;;;;;;;
    move_w:           
                      CALL  emptyBuffer
                      CALL CheckMoveP1Up
                      CMP [flag],1
                      JNE skip1
                      CMP [orientation_p1],0
                      JNE doNotEraseHoriP11
                      call ERASE_V
                      doNotEraseHoriP11:
                      MOV AL,1
                      MOV   [orientation_p1],AL
                      CALL  ERASE_H
                      DEC   curYLoc_p1
                      CALL  DRAW_U
                      skip1:
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;
    ; Moving S_key ;
    ;;;;;;;;;;;;;;;
    move_s:           
                      CALL  emptyBuffer
                      CALL CheckMoveP1Down
                      CMP [flag],1
                      JNE skip1
                      CMP [orientation_p1],0
                      JNE doNotEraseHori12
                      call ERASE_V
                      doNotEraseHori12:
                      MOV AL,1
                      MOV   [orientation_p1],AL
                      CALL  ERASE_H
                      INC   curYLoc_p1
                      CALL  DRAW_D
                      JMP   directionDecision

    BreakleftJMP:
        JMP move_left

    BreakRightJMP:
        JMP move_right

    BreakUpJMP:
        JMP move_up

    BreakDownJMP:
        JMP move_down

    ;;;;;;;;;;;;;;;;
    ; Moving a_key  ;
    ;;;;;;;;;;;;;;;;
    move_a:           
                      CALL  emptyBuffer
                      CALL CheckMoveP1Left
                      CMP [flag],1
                      JNE skip1
                      CMP [orientation_p1],1
                      JNE doNotEraseVerti1
                      call ERASE_H
                      doNotEraseVerti1:
                      MOV AL,0
                      MOV   [orientation_p1],AL
                      CALL  ERASE_V
                      DEC   curXLoc_p1
                      CALL  DRAW_L
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;;
    ; Moving d_key ;
    ;;;;;;;;;;;;;;;;
    move_d:           
                      CALL  emptyBuffer
                      CALL CheckMoveP1Right
                      CMP [flag],1
                      JNE skip1
                      CMP [orientation_p1],1
                      JNE doNotEraseVerti2
                      call ERASE_H
                      doNotEraseVerti2:
                      MOV AL,0
                      MOV   [orientation_p1],AL
                      CALL  ERASE_V
                      INC   curXLoc_p1
                      CALL  DRAW_R
                      JMP   directionDecision


    ;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;player 2;;;;;;
    ;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;
    ; Moving up_key ;
    ;;;;;;;;;;;;;;;;
    move_up:          
                      CALL  emptyBuffer
                      CALL CheckMoveP2Up
                      CMP [flag],1
                      JNE skip2
                      CMP [orientation_p2],0
                      JNE doNotEraseHoriP21
                      call ERASE_V_p2
                      doNotEraseHoriP21:
                      MOV AL,1
                      MOV   [orientation_p2],AL
                      CALL  ERASE_H_p2
                      DEC   curYLoc_p2
                      CALL  DRAW_U_p2
                      skip2:
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;
    ; Moving down_key ;
    ;;;;;;;;;;;;;;;
    move_down:        
                      CALL  emptyBuffer
                      CALL CheckMoveP2Down
                      CMP [flag],1
                      JNE skip2
                      CMP [orientation_p2],0
                      JNE doNotEraseHoriP22
                      call ERASE_V_p2
                      doNotEraseHoriP22:
                      MOV AL,1
                      MOV   [orientation_p2],AL
                      CALL  ERASE_H_p2
                      INC   curYLoc_p2
                      CALL  DRAW_D_p2
                      JMP   directionDecision

    ;;;;;;;;;;;;;;;;
    ; Moving left_key  ;
    ;;;;;;;;;;;;;;;;
    move_left:        
                      CALL  emptyBuffer
                      CALL CheckMoveP2Left
                      CMP [flag],1
                      JNE skip2
                      CMP [orientation_p2],1
                      JNE doNotEraseVertiP21
                      call ERASE_H_p2
                      doNotEraseVertiP21:
                      MOV AL,0
                      MOV   [orientation_p2],AL
                      CALL  ERASE_V_p2
                      DEC   curXLoc_p2
                      CALL  DRAW_L_p2
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;;
    ; Moving right_key ;
    ;;;;;;;;;;;;;;;;
    move_right:       
                      CALL  emptyBuffer
                      CALL CheckMoveP2Right
                      CMP [flag],1
                      JNE skip2
                      CMP [orientation_p2],1
                      JNE doNotEraseVertiP22
                      call ERASE_H_p2
                      doNotEraseVertiP22:
                      MOV AL,0
                      MOV   [orientation_p2],AL
                      CALL  ERASE_V_p2
                      INC   curXLoc_p2
                      CALL  DRAW_R_p2
                      JMP   directionDecision

                      HLT
MAIN ENDP

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Horizontal MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_L PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,1932          ;320*6 + 12
                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV BX,0
                      p1_label_L2:
                      MOV DX,0
                      p1_label_L:
                      MOV CX,1
                      rep MOVSB
                      ADD DI,319
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_L
                      SUB DI,4159            ;320*13-1
                      INC BX
                      CMP BX,imgH
                      JNE p1_label_L2
                      POPF
                      RET
DRAW_L ENDP


DRAW_R PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,1908          ;320*6 - 12
                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV BX,0
                      p1_label_R2:
                      MOV DX,0
                      p1_label_R:
                      MOV CX,1
                      rep MOVSB
                      ADD DI,319
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_R
                      SUB DI,4161            ;320*13+1
                      INC BX
                      CMP BX,imgH
                      JNE p1_label_R2
                      POPF
                      RET
DRAW_R ENDP


ERASE_H PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      ADD AX,3846         ;320*12 + 6
                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV BX,0
                      p1_label_eraseH2:
                      MOV DX,0
                      p1_label_eraseH:
                      MOV CX,1
                      MOV AL,0H
                      rep STOSB
                      SUB DI,2
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_eraseH
                      SUB DI,307         ;320-13
                      INC BX
                      CMP BX,imgH+2
                      JNE p1_label_eraseH2
                      POPF
                      RET
ERASE_H ENDP



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Vertical MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_D PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      ADD AX,3846         ;320*12 + 6
                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV BX,0
                      p1_label_D2:
                      MOV DX,0
                      p1_label_D:
                      MOV CX,1
                      rep MOVSB
                      SUB DI,2
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_D
                      SUB DI,307         ;320-13
                      INC BX
                      CMP BX,imgH
                      JNE p1_label_D2
                      POPF
                      RET
DRAW_D ENDP


DRAW_U PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320d
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      MOV BX,AX
                      SUB AX,3846           ;320*12 + 6

                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV CX,0
                      MOV DX,0
                      p1_label_U:
                      MOV CX,imgW
                      rep MOVSB
                      ADD DI,307          ;320-13
                      INC DX
                      CMP DX,imgH
                      JNE p1_label_U
                      POPF
                      RET
DRAW_U ENDP



ERASE_V PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,1932          ;320*6 + 12
                      MOV DI,AX
                      ClD
                      MOV BX,0
                      p1_label_eraseV2:
                      MOV DX,0
                      p1_label_eraseV:
                      MOV AL,0H
                      MOV CX,1
                      rep STOSB
                      ADD DI,319
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_eraseV
                      SUB DI,4159            ;320*13-1
                      INC BX
                      CMP BX,imgH+2
                      JNE p1_label_eraseV2
                      POPF
                      RET
ERASE_V ENDP


    ;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;player two;;;;;
    ;;;;;;;;;;;;;;;;;;;;;


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Horizontal MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_L_p2 PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,1932          ;320*6 + 12
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV BX,0
                      p2_label_L2:
                      MOV DX,0
                      p2_label_L:
                      MOV CX,1
                      rep MOVSB
                      ADD DI,319
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_L
                      SUB DI,4159            ;320*13-1
                      INC BX
                      CMP BX,imgH
                      JNE p2_label_L2
                      POPF
                      RET
DRAW_L_p2 ENDP


DRAW_R_p2 PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,1908          ;320*6 - 12
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV BX,0
                      p2_label_R2:
                      MOV DX,0
                      p2_label_R:
                      MOV CX,1
                      rep MOVSB
                      ADD DI,319
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_R
                      SUB DI,4161            ;320*13+1
                      INC BX
                      CMP BX,imgH
                      JNE p2_label_R2
                      POPF
                      RET
DRAW_R_p2 ENDP


ERASE_H_p2 PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                     PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      ADD AX,3846         ;320*12 + 6
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV BX,0
                      p2_label_eraseH2:
                      MOV DX,0
                      p2_label_eraseH:
                      MOV CX,1
                      MOV AL,0H
                      rep STOSB
                      SUB DI,2
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_eraseH
                      SUB DI,307         ;320-13
                      INC BX
                      CMP BX,imgH+2
                      JNE p2_label_eraseH2
                      POPF
                      RET
ERASE_H_p2 ENDP



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Vertical MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_D_p2 PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      ADD AX,3846         ;320*12 + 6
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV BX,0
                      p2_label_D2:
                      MOV DX,0
                      p2_label_D:
                      MOV CX,1
                      rep MOVSB
                      SUB DI,2
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_D
                      SUB DI,307         ;320-13
                      INC BX
                      CMP BX,imgH
                      JNE p2_label_D2
                      POPF
                      RET
DRAW_D_p2 ENDP


DRAW_U_p2 PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320d
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,3846           ;320*12 + 6
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV CX,0
                      MOV DX,0
                      p2_label_U:
                      MOV CX,imgW
                      rep MOVSB
                      ADD DI,307          ;320-13
                      INC DX
                      CMP DX,imgH
                      JNE p2_label_U
                      POPF
                      RET
DRAW_U_p2 ENDP



ERASE_V_p2 PROC ;FAR
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,1932          ;320*6 + 12
                      MOV DI,AX
                      ClD
                      MOV BX,0
                      p2_label_eraseV2:
                      MOV DX,0
                      p2_label_eraseV:
                      MOV AL,0H
                      MOV CX,1
                      rep STOSB
                      ADD DI,319
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_eraseV
                      SUB DI,4159            ;320*13-1
                      INC BX
                      CMP BX,imgH+2
                      JNE p2_label_eraseV2
                      POPF
                      RET
ERASE_V_p2 ENDP

CheckMoveP1Up PROC
                      PUSHF

                      MOV AX,320d
                      MUL curYLoc_p1
                      SUB AX,320
                      ADD AX,curXLoc_p1
                      SUB AX,3846           ;320*12 + 6
                      MOV DI,AX
                      MOV CX,0
                      p1_label_checkBUp2:
                      MOV DX,0
                      p1_label_checkBUp1:
                      MOV AL,0Ah
                      CMP ES:[DI],AL
                      JE p1_finshUp
                      INC DI    
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_checkBUp1
                      ADD DI,307
                      INC CX
                      CMP CX,13
                      JNE p1_label_checkBUp2
                      POPF
                      RET
                      p1_finshUp:
                      MOV[flag],0
                      POPF
                      RET
CheckMoveP1Up ENDP

CheckMoveP1Down PROC
                      PUSHF

                      MOV AX,320d
                      MUL curYLoc_p1
                      ADD AX,320
                      ADD AX,curXLoc_p1
                      SUB AX,6
                      MOV DI,AX
                      MOV CX,0
                      p1_label_checkBDown2:
                      MOV DX,0
                      p1_label_checkBDown1:
                      MOV AL,0Ah
                      CMP ES:[DI],AL
                      JE p1_finshDown
                      INC DI    
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_checkBDown1
                      ADD DI,307
                      INC CX
                      CMP CX,12
                      JNE p1_label_checkBDown2
                      POPF
                      RET
                      p1_finshDown:
                      MOV[flag],0
                      POPF
                      RET
CheckMoveP1Down ENDP

CheckMoveP1Right PROC
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,1907      ;320*6-13   
                      MOV DI,AX
                      MOV BX,0
                      p1_label_checkBRight2:
                      MOV DX,0
                      p1_label_checkBRight1:
                      MOV AL,0Ah
                      CMP ES:[DI],AL
                      JE p1_finshRight
                      ADD DI,320
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_checkBRight1
                      SUB DI,4160            ;320*13
                      INC BX
                      CMP BX,13
                      JNE p1_label_checkBRight2
                      POPF
                      RET
                      p1_finshRight:
                      MOV[flag],0
                      POPF
                      RET
CheckMoveP1Right ENDP

CheckMoveP1Left PROC
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,1934        
                      MOV DI,AX
                      MOV BX,0
                      p1_label_checkBLeft2:
                      MOV DX,0
                      p1_label_checkBLeft1:
                      MOV AL,0Ah
                      CMP ES:[DI],AL
                      JE p1_finshLeft
                      ADD DI,320
                      INC DX
                      CMP DX,imgW
                      JNE p1_label_checkBLeft1
                      SUB DI,4159            ;320*13+1
                      INC BX
                      CMP BX,13
                      JNE p1_label_checkBLeft2
                      POPF
                      RET
                      p1_finshLeft:
                      MOV[flag],0
                      POPF
                      RET
CheckMoveP1Left ENDP

CheckMoveP2Up PROC
                      PUSHF

                      MOV AX,320d
                      MUL curYLoc_p2
                      SUB AX,320
                      ADD AX,curXLoc_p2
                      SUB AX,3846           ;320*12 + 6
                      MOV DI,AX
                      MOV CX,0
                      p2_label_checkBUp2:
                      MOV DX,0
                      p2_label_checkBUp1:
                      MOV AL,0Ah
                      CMP ES:[DI],AL
                      JE p2_finshUp
                      INC DI    
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_checkBUp1
                      ADD DI,307
                      INC CX
                      CMP CX,13
                      JNE p2_label_checkBUp2
                      POPF
                      RET
                      p2_finshUp:
                      MOV[flag],0
                      POPF
                      RET
CheckMoveP2Up ENDP

CheckMoveP2Down PROC
                      PUSHF

                      MOV AX,320d
                      MUL curYLoc_p2
                      ADD AX,320
                      ADD AX,curXLoc_p2
                      SUB AX,6           ;320*12 + 6
                      MOV DI,AX
                      MOV CX,0
                      p2_label_checkBDown2:
                      MOV DX,0
                      p2_label_checkBDown1:
                      MOV AL,0Ah
                      CMP ES:[DI],AL
                      JE p2_finshDown
                      INC DI    
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_checkBDown1
                      ADD DI,307
                      INC CX
                      CMP CX,12
                      JNE p2_label_checkBDown2
                      POPF
                      RET
                      p2_finshDown:
                      MOV[flag],0
                      POPF
                      RET
CheckMoveP2Down ENDP

CheckMoveP2Right PROC
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,1907         
                      MOV DI,AX
                      MOV BX,0
                      p2_label_checkBRight2:
                      MOV DX,0
                      p2_label_checkBRight1:
                      MOV AL,0Ah
                      CMP ES:[DI],AL
                      JE p2_finshRight
                      ADD DI,320
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_checkBRight1
                      SUB DI,4160            ;320*13+1
                      INC BX
                      CMP BX,13
                      JNE p2_label_checkBRight2
                      POPF
                      RET
                      p2_finshRight:
                      MOV[flag],0
                      POPF
                      RET
CheckMoveP2Right ENDP

CheckMoveP2Left PROC
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,1934        
                      MOV DI,AX
                      MOV BX,0
                      p2_label_checkBLeft2:
                      MOV DX,0
                      p2_label_checkBLeft1:
                      MOV AL,0Ah
                      CMP ES:[DI],AL
                      JE p2_finshLeft
                      ADD DI,320
                      INC DX
                      CMP DX,imgW
                      JNE p2_label_checkBLeft1
                      SUB DI,4159            ;320*13+1
                      INC BX
                      CMP BX,13
                      JNE p2_label_checkBLeft2
                      POPF
                      RET
                      p2_finshLeft:
                      MOV[flag],0
                      POPF
                      RET
CheckMoveP2Left ENDP

delay PROC ;FAR
                      PUSHF
    ;delete previous place (By Coloring its place with same backGround Color)
                      MOV   ax, Speed_p1
    loopa:            MOV   bx, Speed_p1
    loopb:            DEC   bx
                      JNZ   loopb
                      DEC   ax
                      JNZ   loopa
                      POPF
                      RET
delay ENDP

emptyBuffer PROC ;FAR
                      PUSHF
                      MOV   ah, 00
                      INT   16h
                      POPF
                      RET
emptyBuffer ENDP
  
END MAIN
