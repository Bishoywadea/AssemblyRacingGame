;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function : car movement using arrows
;author : -NoName  && Ahmed Hamdy
;Date : 28-11-2023
.model small
.STACK 64
.DATA
key DB 42H      ;key pressed
curXLoc DW 0  ;the current col
curYLoc DW 0  ;the current row

UP EQU 57h
DOWN EQU 53h
LEFT EQU 41h
RIGHT EQU 44h
BackGroundColor EQU 0
CarColor EQU 0FH
Speed equ 100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     Moving Car in Direction     ;;
;; 1->UP  2->Down 3->Left 4->Right ;; TODO MERGE THESE 4 MACROS IN 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveUpp MACRO
        PUSHF
        MOV AX,-1
        ADD [curYLoc],AX
        ;Placing it in the new Postion
        MOV AH,0Ch
        MOV AL,CarColor
        MOV CX,[curXLoc]
        MOV DX,[curYLoc]
        INT 10H
        mov [curXLoc],cx
        mov [curYLoc],dx
        POPF
ENDM

moveDownn MACRO
        PUSHF
        MOV AX,1
        ADD [curYLoc],AX
        ;Placing it in the new Postion
        MOV AH,0Ch
        MOV AL,CarColor
        MOV CX,[curXLoc]
        MOV DX,[curYLoc]
        INT 10H
        mov [curXLoc],cx
        mov [curYLoc],dx
        POPF
ENDM

moveLeftt MACRO
        PUSHF
        MOV AX,-1
        ADD [curXLoc],AX
        ;Placing it in the new Postion
        MOV AH,0Ch
        MOV AL,CarColor
        MOV CX,[curXLoc]
        MOV DX,[curYLoc]
        INT 10H
        mov [curXLoc],cx
        mov [curYLoc],dx
        POPF
ENDM

moveRightt MACRO
        PUSHF
        MOV AX,1
        ADD [curXLoc],AX
        ;Placing it in the new Postion
        MOV AH,0Ch
        MOV AL,CarColor
        MOV CX,[curXLoc]
        MOV DX,[curYLoc]
        INT 10H
        mov [curXLoc],cx
        mov [curYLoc],dx
        POPF
ENDM

erasePrevLoc MACRO
        ;delete previous place (By Coloring its place with same backGround Color)
        PUSHF
        MOV AH,0Ch
        MOV AL,BackGroundColor
        MOV CX,[curXLoc]
        MOV DX,[curYLoc]
        INT 10H
        POPF
ENDM

delay MACRO
        PUSHF
        ;delete previous place (By Coloring its place with same backGround Color)
        ;WARNING THIS LABEL ISNT WORKING
        LOCAL loopa
        LOCAL loopb
        mov ax, Speed
        loopa: mov bx, Speed
        loopb: dec bx
        jnz loopb
        dec ax
        jnz loopa
        POPF
ENDM

emptyBuffer MACRO
        PUSHF
        mov ah, 0
        int 16h
        POPF
ENDM

.CODE
MAIN PROC FAR
        MOV AX,@DATA
        MOV DS,AX
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;; Inilaizing Video Mode ;;;;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV AH,0
        MOV AL,13H
        int 10H

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Inilaizing Location of Car ;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV AH,0CH
        MOV AL,CarColor ; color of pixel
        MOV CX,160 ; intial col location
        MOV DX,100 ; intial row location
        INT 10H
        mov [curXLoc],cx
        mov [curYLoc],dx


        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Get Key From Buff Then Decide Its Direction ;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        directionDecision:
        delay

        mov ah, 01H
        int 16H
        mov [key],al

        ;checks if key is up
        cmp [key],UP
        je moveUp
        ;checks if key is down
        cmp [key],DOWN 
        je moveDown
        ;checks if key is left
        cmp [key],LEFT
        je moveLeft
        ;checks if key is right
        cmp [key],RIGHT
        jne noPress
        jmp moveRight
        noPress:
        jmp directionDecision

        ;;;;;;;;;;;;;
        ; Moving UP ;
        ;;;;;;;;;;;;;
        moveUp:
                emptyBuffer
                erasePrevLoc
                moveUpp
                JMP directionDecision
        
        ;;;;;;;;;;;;;;;
        ; Moving DOWN ;
        ;;;;;;;;;;;;;;;
        moveDown:
                emptyBuffer
                erasePrevLoc
                moveDownn
                JMP directionDecision

        ;;;;;;;;;;;;;;;;
        ; Moving LEFT  ;
        ;;;;;;;;;;;;;;;;
        moveLeft:
                emptyBuffer
                erasePrevLoc
                moveLeftt
                JMP directionDecision
        
        ;;;;;;;;;;;;;;;;
        ; Moving RIGHT ;
        ;;;;;;;;;;;;;;;;
        moveRight:
                emptyBuffer
                erasePrevLoc
                moveRightt
                JMP directionDecision

        HLT
MAIN ENDP
END MAIN