;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function : car movement using arrows
;author : -NoName  && Ahmed Hamdy
;Date : 28-11-2023
.model COMPACT 
.STACK 1024
.DATA
    key             DB  42H                                                                                                                                                                                     ;key pressed
    direction       DB  ?                                                                                                                                                                                       ;direction
    Speed_p1        EQU 1
    Speed_p2        EQU 1

    curXLoc_p1      DW  0                                                                                                                                                                                       ;the current col
    curYLoc_p1      DW  0                                                                                                                                                                                       ;the current row
    col_p1          DW  0                                                                                                                                                                                       ;the current to be printed


    up_key          EQU 48h
    down_key        EQU 50h
    left_key        EQU 4Bh
    right_key       EQU 4Dh

    curXLoc_p2      DW  0                                                                                                                                                                                       ;the current col
    curYLoc_p2      DW  0                                                                                                                                                                                       ;the current row
    col_p2          DW  0                                                                                                                                                                                       ;the current to be printed

    w_key           EQU 77h
    s_key           EQU 73h
    a_key           EQU 61h
    d_key           EQU 64h

    BackGroundColor EQU 0
    CarColor        EQU 0FH
    imgW            EQU 32
    imgH            EQU 32
    
    img             DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 31, 31, 29, 30, 31, 31, 31, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 20, 23, 160, 137, 161, 160, 137, 137, 160, 161, 137, 161, 23, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 22, 136, 12, 12, 12, 12
                    DB  12, 12, 12, 12, 136, 22, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 22, 137, 12, 12, 12, 12, 12, 12, 12, 12, 137, 22, 20, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 22, 137, 140, 140, 140, 139, 139, 140, 140, 139, 137, 22, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 23, 137, 140, 140, 140, 139, 139, 140, 140, 139, 137, 23, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 24, 23, 138, 139, 139, 139, 139, 139, 139, 139, 139, 138, 23, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 24, 25, 24, 24, 24, 24
                    DB  24, 24, 24, 24, 25, 24, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 24, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 24, 23, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 29, 22, 21, 22, 22, 21, 21, 21, 21, 22, 22, 21, 22, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 21, 21, 23, 24, 24, 24, 24, 24, 24, 23, 21, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 21, 21, 172, 79, 25
                    DB  25, 79, 172, 21, 21, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 21, 20, 173, 79, 79, 79, 79, 173, 20, 21, 22, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 21, 20, 173, 79, 79, 79, 79, 173, 20, 21, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 21, 20, 175, 172, 25, 25, 172, 175, 20, 21, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 23, 21, 21, 20, 22, 24, 24, 22, 20, 21, 21, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 20, 20, 21, 23
                    DB  23, 21, 20, 20, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 19, 19, 20, 20, 20, 20, 19, 19, 19, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 19, 19, 19, 19, 19, 19, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 20, 22, 22, 22, 22, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 26, 24, 24, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22
                    DB  22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    img2            DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 17, 19, 20, 20, 20, 20, 20, 19, 19, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 23, 24, 27, 27
                    DB  27, 26, 26, 26, 25, 162, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 138, 140, 139, 163, 138, 139, 139, 139, 163, 139, 162, 164, 18
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 210, 140, 138, 161, 161, 161, 161, 161, 161, 161, 138, 161, 140, 212, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 212, 140, 138, 161, 161, 161, 161, 161, 161, 161, 138, 138, 140, 212, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 212, 140, 161, 161, 161, 161, 161, 161, 161, 161, 138, 161, 140, 212, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 212, 140, 161, 161, 161, 161
                    DB  161, 161, 161, 161, 161, 162, 140, 212, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 212, 140, 161, 161, 161, 161, 161, 161, 161, 161, 161, 162, 140, 212
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 140, 161, 161, 161, 161, 161, 161, 161, 161, 161, 162, 164, 210, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 18, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 210, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 161, 161, 161, 161
                    DB  161, 161, 161, 161, 161, 139, 210, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 138, 161, 161, 161, 161, 161, 161, 161, 161, 163, 210, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 138, 161, 161, 161, 161, 161, 161, 161, 161, 163, 210, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 138, 161, 161, 161, 161, 161, 161, 161, 161, 163, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 20, 161, 161, 161, 161, 161, 161, 161, 161, 138, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 20, 161, 161, 161
                    DB  161, 161, 161, 161, 161, 20, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 235, 161, 161, 161, 161, 161, 161, 161, 161, 235, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 235, 161, 161, 161, 161, 161, 161, 161, 161, 235, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 19, 20, 161, 161, 161, 161, 161, 161, 161, 161, 20, 19, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 17, 162, 26, 26, 26, 26, 26, 26, 26, 26, 162, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 27, 29, 30
                    DB  30, 30, 30, 29, 27, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 235, 25, 66, 66, 66, 66, 25, 235, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 138, 43, 43, 20, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 210, 43, 43, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 140, 26, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                    DB  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16

.CODE
MAIN PROC FAR
                      MOV   AX,@DATA
                      MOV   DS,AX

                      MOV   [curXLoc_p1],0
                      MOV   [curYLoc_p1],0
                      
                      MOV   [curXLoc_p2],200
                      MOV   [curYLoc_p2],150
                        
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; Inilaizing Video Mode ;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                      MOV   ax, 013h              ;
                      MOV   bx, 0100h             ; 640x400 screen graphics mode
                      INT   10h                   ;execute the configuration
                      CALL  DRAW_D
                      CALL  DRAW_D_p2
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Get Key From Buff Then Decide Its Direction ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    directionDecision:
    ;CALL  delay

                      MOV   ah, 00H
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
                      

    ;;;;;;;;;;;;;
    ; Moving w_key ;
    ;;;;;;;;;;;;;
    move_w:           
                      CALL  emptyBuffer
                      CALL  ERASE_V
                      DEC   curYLoc_p1
                      CALL  DRAW_U
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;
    ; Moving S_key ;
    ;;;;;;;;;;;;;;;
    move_s:           
                      CALL  emptyBuffer
                      CALL  ERASE_V
                      INC   curYLoc_p1
                      CALL  DRAW_D
                      JMP   directionDecision

    ;;;;;;;;;;;;;;;;
    ; Moving a_key  ;
    ;;;;;;;;;;;;;;;;
    move_a:           
                      CALL  emptyBuffer
                      CALL  ERASE_H
                      DEC   curXLoc_p1
                      CALL  DRAW_L
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;;
    ; Moving d_key ;
    ;;;;;;;;;;;;;;;;
    move_d:           
                      CALL  emptyBuffer
                      CALL  ERASE_H
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
                      CALL  ERASE_V_p2
                      DEC   curYLoc_p2
                      CALL  DRAW_U_p2
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;
    ; Moving down_key ;
    ;;;;;;;;;;;;;;;
    move_down:        
                      CALL  emptyBuffer
                      CALL  ERASE_V_p2
                      INC   curYLoc_p2
                      CALL  DRAW_D_p2
                      JMP   directionDecision

    ;;;;;;;;;;;;;;;;
    ; Moving left_key  ;
    ;;;;;;;;;;;;;;;;
    move_left:        
                      CALL  emptyBuffer
                      CALL  ERASE_H_p2
                      DEC   curXLoc_p2
                      CALL  DRAW_L_p2
                      JMP   directionDecision
        
    ;;;;;;;;;;;;;;;;
    ; Moving right_key ;
    ;;;;;;;;;;;;;;;;
    move_right:       
                      CALL  emptyBuffer
                      CALL  ERASE_H_p2
                      INC   curXLoc_p2
                      CALL  DRAW_R_p2
                      JMP   directionDecision

                      HLT
MAIN ENDP

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Horizontal MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_L PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p1],imgW-1
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgW              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgH              ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   DI, offset img        ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      JMP   Start_L
    Drawit_L:         
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p1        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p1        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, [DI]              ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p1
                      SUB   DX, curYLoc_p1
    Start_L:          
                      ADD   DI,32
                      DEC   CX                    ;  loop iteration in x direction
                      JNZ   Drawit_L              ;  check if we can draw c urrent x and y and excape the y iteration
                      MOV   Cx, imgW              ;  if loop iteration in y direction, then x should start over so that we sweep the grid
                      DEC   [col_p1]
                      MOV   DI, offset img        ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      DEC   DX                    ;  loop iteration in y direction
                      JZ    ENDING_L              ;  both x and y reached 00 so end program
                      JMP   Drawit_L
    ENDING_L:         
                      POPF
                      RET
DRAW_L ENDP


DRAW_R PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p1],imgH*imgW
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgW              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgH              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      JMP   Start_R
    Drawit_R:         
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p1        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p1        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, [DI]              ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p1
                      SUB   DX, curYLoc_p1
    Start_R:          
                      SUB   DI,32
                      DEC   CX                    ;  loop iteration in x direction
                      JNZ   Drawit_R              ;  check if we can draw c urrent x and y and excape the y iteration
                      MOV   Cx, imgW              ;  if loop iteration in y direction, then x should start over so that we sweep the grid
                      DEC   [col_p1]
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      DEC   DX                    ;  loop iteration in y direction
                      JZ    ENDING_R              ;  both x and y reached 00 so end program
                      JMP   Drawit_R
    ENDING_R:         
                      POPF
                      RET
DRAW_R ENDP


ERASE_H PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p1],imgW-1
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgW              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgH              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      JMP   Startt_H
    Drawitt_H:        
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p1        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p1        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, 0                 ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p1
                      SUB   DX, curYLoc_p1
    Startt_H:         
                      ADD   DI,imgH
                      DEC   CX                    ;  loop iteration in x direction
                      JNZ   Drawitt_H             ;  check if we can draw c urrent x and y and excape the y iteration
                      MOV   CX, imgW              ;  if loop iteration in y direction, then x should start over so that we sweep the grid
                      DEC   [col_p1]
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      DEC   DX                    ;  loop iteration in y direction
                      JZ    ENDINGG_H             ;  both x and y reached 00 so end program
                      JMP   Drawitt_H
    ENDINGG_H:        
                      POPF
                      RET
ERASE_H ENDP



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Vertical MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_D PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p1],imgH*imgW
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgH              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgW              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      JMP   Start_D
    Drawit_D:         
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p1        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p1        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, [DI]              ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p1
                      SUB   DX, curYLoc_p1
    Start_D:          
                      SUB   DI,imgW
                      DEC   DX                    ;  loop iteration in y direction
                      JNZ   Drawit_D              ;  check if we can draw current x and y and excape the y iteration
                      MOV   DX, imgH              ;  if loop iteration in x direction, then y should start over so that we sweep the grid
                      DEC   [col_p1]
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      DEC   CX                    ;  loop iteration in x direction
                      JZ    ENDING_D              ;  both x and y reached 00 so end program
                      JMP   Drawit_D
    ENDING_D:         
                      POPF
                      RET
DRAW_D ENDP


DRAW_U PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p1],-imgH
                      INC   [col_p1]
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgH              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgW              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      JMP   Start_U
    Drawit_U:         
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p1        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p1        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, [DI]              ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p1
                      SUB   DX, curYLoc_p1
    Start_U:          
                      ADD   DI,imgW
                      DEC   DX                    ;  loop iteration in y direction
                      JNZ   Drawit_U              ;  check if we can draw current x and y and excape the y iteration
                      MOV   DX, imgH              ;  if loop iteration in x direction, then y should start over so that we sweep the grid
                      INC   [col_p1]
                      LEA   DI, img               ; to iterate over the pixels
                      SUB   DI,[col_p1]
                      DEC   CX                    ;  loop iteration in x direction
                      JZ    ENDING_U              ;  both x and y reached 00 so end program
                      JMP   Drawit_U
    ENDING_U:         
                      POPF
                      RET
DRAW_U ENDP



ERASE_V PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p1],imgW-1
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgH              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgW              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      JMP   Startt_V
    Drawitt_V:        
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p1        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p1        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, 0                 ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p1
                      SUB   DX, curYLoc_p1
    Startt_V:         
                      ADD   DI,imgH
                      DEC   DX                    ;  loop iteration in Y direction
                      JNZ   Drawitt_V             ;  check if we can draw current x and y and escape the y iteration
                      MOV   DX, imgH              ;  if loop iteration in x direction, then y should start over so that we sweep the grid
                      DEC   [col_p1]
                      LEA   DI, img               ; to iterate over the pixels
                      ADD   DI,[col_p1]
                      DEC   CX                    ;  loop iteration in X direction
                      JZ    ENDINGG_V             ;  both x and y reached 00 so end program
                      JMP   Drawitt_V
    ENDINGG_V:        
                      POPF
                      RET
ERASE_V ENDP


    ;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;player two;;;;;
    ;;;;;;;;;;;;;;;;;;;;;


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Horizontal MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_L_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p2],imgW-1
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgW              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgH              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      JMP   Start_L_p2
    Drawit_L_p2:      
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p2        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p2        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, [DI]              ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p2
                      SUB   DX, curYLoc_p2
    Start_L_p2:       
                      ADD   DI,32
                      DEC   CX                    ;  loop iteration in x direction
                      JNZ   Drawit_L_p2           ;  check if we can draw c urrent x and y and excape the y iteration
                      MOV   Cx, imgW              ;  if loop iteration in y direction, then x should start over so that we sweep the grid
                      DEC   [col_p2]
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      DEC   DX                    ;  loop iteration in y direction
                      JZ    ENDING_L_p2           ;  both x and y reached 00 so end program
                      JMP   Drawit_L_p2
    ENDING_L_p2:      
                      POPF
                      RET
DRAW_L_p2 ENDP


DRAW_R_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p2],imgH*imgW
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgW              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgH              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      JMP   Start_R_p2
    Drawit_R_p2:      
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p2        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p2        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, [DI]              ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p2
                      SUB   DX, curYLoc_p2
    Start_R_p2:       
                      SUB   DI,32
                      DEC   CX                    ;  loop iteration in x direction
                      JNZ   Drawit_R_p2           ;  check if we can draw c urrent x and y and excape the y iteration
                      MOV   Cx, imgW              ;  if loop iteration in y direction, then x should start over so that we sweep the grid
                      DEC   [col_p2]
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      DEC   DX                    ;  loop iteration in y direction
                      JZ    ENDING_R_p2           ;  both x and y reached 00 so end program
                      JMP   Drawit_R_p2
    ENDING_R_p2:      
                      POPF
                      RET
DRAW_R_p2 ENDP


ERASE_H_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p2],imgW-1
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgW              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgH              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      JMP   Startt_H_p2
    Drawitt_H_p2:     
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p2        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p2        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, 0                 ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p2
                      SUB   DX, curYLoc_p2
    Startt_H_p2:      
                      ADD   DI,imgH
                      DEC   CX                    ;  loop iteration in x direction
                      JNZ   Drawitt_H_p2          ;  check if we can draw c urrent x and y and excape the y iteration
                      MOV   CX, imgW              ;  if loop iteration in y direction, then x should start over so that we sweep the grid
                      DEC   [col_p2]
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      DEC   DX                    ;  loop iteration in y direction
                      JZ    ENDINGG_H_p2          ;  both x and y reached 00 so end program
                      JMP   Drawitt_H_p2
    ENDINGG_H_p2:     
                      POPF
                      RET
ERASE_H_p2 ENDP



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Vertical MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_D_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p2],imgH*imgW
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgH              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgW              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      JMP   Start_D_p2
    Drawit_D_p2:      
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p2        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p2        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, [DI]              ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p2
                      SUB   DX, curYLoc_p2
    Start_D_p2:       
                      SUB   DI,imgW
                      DEC   DX                    ;  loop iteration in y direction
                      JNZ   Drawit_D_p2           ;  check if we can draw current x and y and excape the y iteration
                      MOV   DX, imgH              ;  if loop iteration in x direction, then y should start over so that we sweep the grid
                      DEC   [col_p2]
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      DEC   CX                    ;  loop iteration in x direction
                      JZ    ENDING_D_p2           ;  both x and y reached 00 so end program
                      JMP   Drawit_D_p2
    ENDING_D_p2:      
                      POPF
                      RET
DRAW_D_p2 ENDP


DRAW_U_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p2],-imgH
                      INC   [col_p2]
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgH              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgW              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      JMP   Start_U_p2
    Drawit_U_p2:      
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p2        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p2        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, [DI]              ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p2
                      SUB   DX, curYLoc_p2
    Start_U_p2:       
                      ADD   DI,imgW
                      DEC   DX                    ;  loop iteration in y direction
                      JNZ   Drawit_U_p2           ;  check if we can draw current x and y and excape the y iteration
                      MOV   DX, imgH              ;  if loop iteration in x direction, then y should start over so that we sweep the grid
                      INC   [col_p2]
                      LEA   DI, img2              ; to iterate over the pixels
                      SUB   DI,[col_p2]
                      DEC   CX                    ;  loop iteration in x direction
                      JZ    ENDING_U_p2           ;  both x and y reached 00 so end program
                      JMP   Drawit_U_p2
    ENDING_U_p2:      
                      POPF
                      RET
DRAW_U_p2 ENDP



ERASE_V_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV   [col_p2],imgW
                      MOV   AH,0Bh                ;set the configuration
                      MOV   CX, imgH              ;set the width (X) up to 64 (based on image resolution)
                      MOV   DX, imgW              ;set the hieght (Y) up to 64 (based on image resolution)
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      JMP   Startt_V_p2
    Drawitt_V_p2:     
                      MOV   AH,0Ch                ;set the configuration to writing a pixel
                      ADD   CX, curXLoc_p2        ;set the width (X) up to 64 (based on image resolution)
                      ADD   DX, curYLoc_p2        ;set the hieght (Y) up to 64 (based on image resolution)
                      MOV   AL, 0                 ; color of the current coordinates
                      MOV   BH,00h                ;set the page number
                      INT   10h                   ;Avoid drawing before the calculations
                      SUB   CX, curXLoc_p2
                      SUB   DX, curYLoc_p2
    Startt_V_p2:      
                      ADD   DI,imgH
                      DEC   DX                    ;  loop iteration in Y direction
                      JNZ   Drawitt_V_p2          ;  check if we can draw current x and y and escape the y iteration
                      MOV   DX, imgH              ;  if loop iteration in x direction, then y should start over so that we sweep the grid
                      DEC   [col_p2]
                      LEA   DI, img2              ; to iterate over the pixels
                      ADD   DI,[col_p2]
                      DEC   CX                    ;  loop iteration in X direction
                      JZ    ENDINGG_V_p2          ;  both x and y reached 00 so end program
                      JMP   Drawitt_V_p2
    ENDINGG_V_p2:     
                      POPF
                      RET
ERASE_V_p2 ENDP




delay PROC
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

emptyBuffer PROC
                      PUSHF
                      MOV   ah, 0
                      INT   16h
                      POPF
                      RET
emptyBuffer ENDP
  
END MAIN
