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
    imgW            EQU 33
    imgH            EQU 33
    
    img DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17 
 DB 17, 18, 18, 18, 18, 18, 18, 16, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 143, 117, 117, 140, 140, 140, 140, 140, 140 
 DB 18, 16, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 18, 117, 117, 117, 141, 140, 140, 140, 140, 140, 18, 16, 17, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 17, 18, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 18, 238, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 236, 18, 142, 117, 117, 117 
 DB 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164 
 DB 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212 
 DB 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117 
 DB 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 238, 18, 142, 141, 141, 141, 141, 141, 141, 141, 140, 216, 166, 18, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 18, 141, 140, 140, 140, 140, 140, 140, 140, 140, 18, 17, 17, 17, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 18, 143, 143, 143, 143, 143, 143, 143, 143, 118, 17, 16, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 16, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 142, 140, 236, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 142, 140, 236, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 142, 140, 142, 215, 18, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 190, 215, 140, 140, 236, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 215, 141, 143, 18, 16, 16, 16, 16, 16, 16, 16, 215, 142, 141, 18, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 214, 140, 141, 118, 190, 190, 190, 190, 190, 190, 215, 117, 117, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 214, 140, 117, 117, 117, 117, 117, 117, 117, 117, 117, 117, 117, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 17, 214, 140, 117, 117, 117, 117, 117, 117, 117, 117, 117, 117, 141, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 214, 140, 117, 117, 117, 117 
 DB 117, 117, 117, 117, 117, 117, 141, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 215, 141, 140, 140, 117, 117, 117, 117, 117, 117, 141, 140, 140 
 DB 141, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 214, 141, 140, 140, 140, 140, 140, 140, 140, 140, 141, 141, 215, 17, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 18, 18, 214, 141, 141, 141, 141, 141, 141, 141, 215, 216, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 17, 17, 18, 118, 118, 118, 118, 118, 118, 212, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16

    img2 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17 
 DB 17, 18, 18, 18, 18, 18, 18, 16, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 143, 117, 117, 140, 140, 140, 140, 140, 140 
 DB 18, 16, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 18, 117, 117, 117, 141, 140, 140, 140, 140, 140, 18, 16, 17, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 17, 18, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 18, 238, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 236, 18, 142, 117, 117, 117 
 DB 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164 
 DB 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212 
 DB 18, 142, 117, 117, 117, 117, 117, 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 216, 212, 18, 142, 117, 117, 117, 117, 117 
 DB 117, 141, 140, 215, 164, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 238, 18, 142, 141, 141, 141, 141, 141, 141, 141, 140, 216, 166, 18, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 18, 141, 140, 140, 140, 140, 140, 140, 140, 140, 18, 17, 17, 17, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 18, 143, 143, 143, 143, 143, 143, 143, 143, 118, 17, 16, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 16, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 142, 140, 236, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 142, 140, 236, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 142, 140, 142, 215, 18, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 190, 215, 140, 140, 236, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 215, 141, 143, 18, 16, 16, 16, 16, 16, 16, 16, 215, 142, 141, 18, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 214, 140, 141, 118, 190, 190, 190, 190, 190, 190, 215, 117, 117, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 214, 140, 117, 117, 117, 117, 117, 117, 117, 117, 117, 117, 117, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 17, 214, 140, 117, 117, 117, 117, 117, 117, 117, 117, 117, 117, 141, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 214, 140, 117, 117, 117, 117 
 DB 117, 117, 117, 117, 117, 117, 141, 140, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 215, 141, 140, 140, 117, 117, 117, 117, 117, 117, 141, 140, 140 
 DB 141, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 214, 141, 140, 140, 140, 140, 140, 140, 140, 140, 141, 141, 215, 17, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 18, 18, 214, 141, 141, 141, 141, 141, 141, 141, 215, 216, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 17, 17, 18, 118, 118, 118, 118, 118, 118, 212, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16

.CODE
MAIN PROC FAR
                      MOV   AX,@DATA
                      MOV   DS,AX

                      MOV AX,0A000h
                      MOV ES,AX

                      MOV   [curXLoc_p1],50
                      MOV   [curYLoc_p1],50
                      
                      MOV   [curXLoc_p2],200
                      MOV   [curYLoc_p2],150
                        
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; Inilaizing Video Mode ;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                      MOV   ax, 013h              ;
                      ;MOV   bx, 0100h             ; 640x400 screen graphics mode
                      INT   10h                   ;execute the configuration
                      CALL  DRAW_U
                      CALL  DRAW_D_p2
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Get Key From Buff Then Decide Its Direction ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    directionDecision:
    CALL  delay

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
                      CALL  ERASE_H
                      INC   curYLoc_p1
                      CALL  DRAW_D
                      JMP   directionDecision

    ;;;;;;;;;;;;;;;;
    ; Moving a_key  ;
    ;;;;;;;;;;;;;;;;
    move_a:           
                      CALL  emptyBuffer
                      CALL  ERASE_V
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
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,5104
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
                      CMP DX,33
                      JNE p1_label_L
                      SUB DI,10561
                      INC BX
                      CMP BX,33
                      JNE p1_label_L2
                      POPF
                      RET
DRAW_L ENDP


DRAW_R PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,5136
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
                      CMP DX,33
                      JNE p1_label_R
                      SUB DI,10559
                      INC BX
                      CMP BX,33
                      JNE p1_label_R2
                      POPF
                      RET
DRAW_R ENDP


ERASE_H PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320d
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,5136
                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV CX,0
                      MOV DX,0
                      MOV AL,0H
                      p1_label_eraseH:
                      MOV CX,imgH
                      rep STOSB
                      ADD DI,287
                      INC DX
                      CMP DX,33
                      JNE p1_label_eraseH
                      POPF
                      RET
ERASE_H ENDP



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Vertical MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_D PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320d
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,5136
                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV CX,0
                      MOV DX,0
                      p1_label_D:
                      MOV CX,imgH
                      rep MOVSB
                      ADD DI,287
                      INC DX
                      CMP DX,33
                      JNE p1_label_D
                      POPF
                      RET
DRAW_D ENDP


DRAW_U PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      ADD AX,5136
                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV BX,0
                      p1_label_U2:
                      MOV DX,0
                      p1_label_U:
                      MOV CX,1
                      rep MOVSB
                      SUB DI,2
                      INC DX
                      CMP DX,33
                      JNE p1_label_U
                      SUB DI,287
                      INC BX
                      CMP BX,33
                      JNE p1_label_U2
                      POPF
                      RET
DRAW_U ENDP



ERASE_V PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p1
                      ADD AX,curXLoc_p1
                      SUB AX,5136
                      MOV DI,AX
                      ClD
                      LEA SI,img
                      MOV BX,0
                      p1_label_eraseV:
                      MOV DX,0
                      p1_label_label_eraseV2:
                      MOV CX,1
                      MOV AL,0H
                      rep STOSB
                      ADD DI,319
                      INC DX
                      CMP DX,33
                      JNE p1_label_label_eraseV2
                      SUB DI,10561
                      INC BX
                      CMP BX,33
                      JNE p1_label_eraseV
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
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,5104
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
                      CMP DX,33
                      JNE p2_label_L
                      SUB DI,10561
                      INC BX
                      CMP BX,33
                      JNE p2_label_L2
                      POPF
                      RET
DRAW_L_p2 ENDP


DRAW_R_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,5136
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
                      CMP DX,33
                      JNE p2_label_R
                      SUB DI,10559
                      INC BX
                      CMP BX,33
                      JNE p2_label_R2
                      POPF
                      RET
DRAW_R_p2 ENDP


ERASE_H_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                     PUSHF
                      MOV AX,320d
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,5136
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV CX,0
                      MOV DX,0
                      MOV AL,0H
                      p2_label_eraseH:
                      MOV CX,imgH
                      rep STOSB
                      ADD DI,287
                      INC DX
                      CMP DX,33
                      JNE p2_label_eraseH
                      POPF
                      RET
ERASE_H_p2 ENDP



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;Vertical MOVEMENT;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_D_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320d
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,5136
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV CX,0
                      MOV DX,0
                      p2_label_D:
                      MOV CX,imgH
                      rep MOVSB
                      ADD DI,287
                      INC DX
                      CMP DX,33
                      JNE p2_label_D
                      POPF
                      RET
DRAW_D_p2 ENDP


DRAW_U_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      ADD AX,5136
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV BX,0
                      p2_label_U2:
                      MOV DX,0
                      p2_label_U:
                      MOV CX,1
                      rep MOVSB
                      SUB DI,2
                      INC DX
                      CMP DX,33
                      JNE p2_label_U
                      SUB DI,287
                      INC BX
                      CMP BX,33
                      JNE p2_label_U2
                      POPF
                      RET
DRAW_U_p2 ENDP



ERASE_V_p2 PROC
    ;delete previous place (By Coloring its place with same backGround Color)
                      PUSHF
                      MOV AX,320
                      MUL curYLoc_p2
                      ADD AX,curXLoc_p2
                      SUB AX,5136
                      MOV DI,AX
                      ClD
                      LEA SI,img2
                      MOV BX,0
                      p2_label_eraseV:
                      MOV DX,0
                      p2_label_label_eraseV2:
                      MOV CX,1
                      MOV AL,0H
                      rep STOSB
                      ADD DI,319
                      INC DX
                      CMP DX,33
                      JNE p2_label_label_eraseV2
                      SUB DI,10561
                      INC BX
                      CMP BX,33
                      JNE p2_label_eraseV
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
