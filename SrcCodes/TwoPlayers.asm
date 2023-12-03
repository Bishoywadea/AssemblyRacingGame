;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function : car movement using arrows
;author : -NoName  && Ahmed Hamdy
;Date : 28-11-2023
.model compact 
.STACK 1024
.DATA
    key                     DB  42H                                                                                                                                                                                     ;key pressed
    direction               DB  ?                                                                                                                                                                                       ;direction
    Speed_p1                EQU 1
    Speed_p2                EQU 1

    curXLoc_p1              DW  50                                                                                                                                                                                       ;the current col
    curYLoc_p1              DW  50                                                                                                                                                                                      ;the current row
    orientation_p1          DB  1    ;1->mean Vertical    0->mean Horizontal                                                                                                                                                                                   ;the current to be printed


    up_key                  EQU 48h
    down_key                EQU 50h
    left_key                EQU 4Bh
    right_key               EQU 4Dh

    curXLoc_p2              DW  200                                                                                                                                                                                       ;the current col
    curYLoc_p2              DW  150                                                                                                                                                                                       ;the current row
    orientation_p2          DB  1     ;1->mean Vertical    0->mean Horizontal                                                                                                                                                                                   ;the current to be printed

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
    directionDecision:
    CALL  delay

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
                      JE    move_a
    ;checks if key is d_key
                      CMP   [key],d_key
                      JE    move_d
                      JMP   directionDecision
                      
    p2_move:          
                      MOV   [key],AH
            
    ;checks if key is up_key
                      CMP   [key],up_key
                      JE    move_up
    ;checks if key is down_key
                      CMP   [key],down_key
                      JE    move_down
    ;checks if key is left_key
                      CMP   [key],left_key
                      JE    move_left
    ;checks if key is right_key
                      CMP   [key],right_key
                      JE    move_right
                      JMP   directionDecision
                      

    ;;;;;;;;;;;;;
    ; Moving w_key ;
    ;;;;;;;;;;;;;
    move_w:           
                      CALL  emptyBuffer
                      CMP [orientation_p1],0
                      JNE doNotEraseHori1
                      call ERASE_V
                      doNotEraseHori1:
                      MOV AL,1
                      MOV   [orientation_p1],AL
                      CALL  ERASE_H
                      DEC   curYLoc_p1
                      CALL  DRAW_U
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;
    ; Moving S_key ;
    ;;;;;;;;;;;;;;;
    move_s:           
                      CALL  emptyBuffer
                    ;   CMP [orientation_p1],0
                    ;   JNE doNotEraseHori2
                    ;   call ERASE_V
                    ;   doNotEraseHori2:
                    ;   MOV AL,1
                    ;   MOV   [orientation_p1],AL
                      CALL  ERASE_H
                      INC   curYLoc_p1
                      CALL  DRAW_D
                      JMP   directionDecision

    ;;;;;;;;;;;;;;;;
    ; Moving a_key  ;
    ;;;;;;;;;;;;;;;;
    move_a:           
                      CALL  emptyBuffer
                    ;   CMP [orientation_p1],1
                    ;   JNE doNotEraseVerti1
                    ;   call ERASE_H
                    ;   doNotEraseVerti1:
                    ;   MOV AL,0
                    ;   MOV   [orientation_p1],AL
                      CALL  ERASE_V
                      DEC   curXLoc_p1
                      CALL  DRAW_L
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;;
    ; Moving d_key ;
    ;;;;;;;;;;;;;;;;
    move_d:           
                      CALL  emptyBuffer
                    ;   CMP [orientation_p1],1
                    ;   JNE doNotEraseVerti2
                    ;   call ERASE_H
                    ;   doNotEraseVerti2:
                    ;   MOV AL,0
                    ;   MOV   [orientation_p1],AL
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
                      CALL  ERASE_H_p2
                      DEC   curYLoc_p2
                      CALL  DRAW_U_p2
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;
    ; Moving down_key ;
    ;;;;;;;;;;;;;;;
    move_down:        
                      CALL  emptyBuffer
                      CALL  ERASE_H_p2
                      INC   curYLoc_p2
                      CALL  DRAW_D_p2
                      JMP   directionDecision

    ;;;;;;;;;;;;;;;;
    ; Moving left_key  ;
    ;;;;;;;;;;;;;;;;
    move_left:        
                      CALL  emptyBuffer
                      CALL  ERASE_V_p2
                      DEC   curXLoc_p2
                      CALL  DRAW_L_p2
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;;
    ; Moving right_key ;
    ;;;;;;;;;;;;;;;;
    move_right:       
                      CALL  emptyBuffer
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
