;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function : car movement using arrows
;author : -NoName  && Ahmed Hamdy
;Date : 28-11-2023
.model COMPACT 
.STACK 1024
.DATA
key DB 42H      ;key pressed
direction DB ?     ;direction
curXLoc DW 0  ;the current col
curYLoc DW 0  ;the current row
col DW 0  ;the current to be printed

UP EQU 77h
DOWN EQU 73h
LEFT EQU 61h
RIGHT EQU 64h
BackGroundColor EQU 0
CarColor EQU 0FH
Speed equ 1
imgW equ 32
imgH equ 32
img DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 17, 19, 20, 20, 20, 20, 20, 19, 19, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 23, 24, 27, 27 
 DB 27, 26, 26, 26, 25, 162, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 138, 140, 139, 163, 138, 139, 139, 139, 163, 139, 162, 164, 18 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 210, 140, 138, 161, 161, 161, 161, 161, 161, 161, 138, 161, 140, 212, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 212, 140, 138, 161, 161, 161, 161, 161, 161, 161, 138, 138, 140, 212, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 212, 140, 161, 161, 161, 161, 161, 161, 161, 161, 138, 161, 140, 212, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 212, 140, 161, 161, 161, 161 
 DB 161, 161, 161, 161, 161, 162, 140, 212, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 212, 140, 161, 161, 161, 161, 161, 161, 161, 161, 161, 162, 140, 212 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 140, 161, 161, 161, 161, 161, 161, 161, 161, 161, 162, 164, 210, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 18, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 210, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 161, 161, 161, 161 
 DB 161, 161, 161, 161, 161, 139, 210, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 138, 161, 161, 161, 161, 161, 161, 161, 161, 163, 210, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 138, 161, 161, 161, 161, 161, 161, 161, 161, 163, 210, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 138, 161, 161, 161, 161, 161, 161, 161, 161, 163, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 20, 161, 161, 161, 161, 161, 161, 161, 161, 138, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 20, 161, 161, 161 
 DB 161, 161, 161, 161, 161, 20, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 235, 161, 161, 161, 161, 161, 161, 161, 161, 235, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 235, 161, 161, 161, 161, 161, 161, 161, 161, 235, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 19, 20, 161, 161, 161, 161, 161, 161, 161, 161, 20, 19, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 17, 162, 26, 26, 26, 26, 26, 26, 26, 26, 162, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 27, 29, 30 
 DB 30, 30, 30, 29, 27, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 235, 25, 66, 66, 66, 66, 25, 235, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 138, 43, 43, 20, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 210, 43, 43, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 140, 26, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16


delay MACRO
        LOCAL Loopb, loopa
        PUSHF
        ;delete previous place (By Coloring its place with same backGround Color)
        mov ax, Speed
        loopa: mov bx, Speed
        loopb: dec bx
        jnz loopb
        dec ax
        jnz loopa
        POPF
ENDM    delay

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

        mov [curXLoc],160
        mov [curYLoc],100

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;; Inilaizing Video Mode ;;;;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov ax, 013h    ;
	mov bx, 0100h    ; 640x400 screen graphics mode
	INT 10h      	;execute the configuration
	looop:
	CALL DRAW

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
                CALL ERASE
                ADD curYLoc,-1
                JMP LOOOP
        
        ;;;;;;;;;;;;;;;
        ; Moving DOWN ;
        ;;;;;;;;;;;;;;;
        moveDown:
                emptyBuffer
                ;DRAW 0
                ADD curYLoc,1
                JMP LOOOP

        ;;;;;;;;;;;;;;;;
        ; Moving LEFT  ;
        ;;;;;;;;;;;;;;;;
        moveLeft:
                emptyBuffer
                ;DRAW 0
                ADD curXLoc,-1
                JMP LOOOP
        
        ;;;;;;;;;;;;;;;;
        ; Moving RIGHT ;
        ;;;;;;;;;;;;;;;;
        moveRight:
                emptyBuffer
                ;DRAW 0
                ADD curXLoc,1
                JMP LOOOP

        HLT
MAIN ENDP 

DRAW PROC
        ;delete previous place (By Coloring its place with same backGround Color)
        PUSHF
        MOV [col],31
        MOV AH,0Bh   	;set the configuration
	MOV CX, imgW  	;set the width (X) up to 64 (based on image resolution)
	MOV DX, imgH 	;set the hieght (Y) up to 64 (based on image resolution)
	mov DI, offset img  ; to iterate over the pixels
        ADD DI,[col]
        jmp Start  
        Drawit:
	MOV AH,0Ch   	;set the configuration to writing a pixel
        ADD CX, curXLoc  	;set the width (X) up to 64 (based on image resolution)
	ADD DX, curYLoc 	;set the hieght (Y) up to 64 (based on image resolution)
        mov al, [DI]     ; color of the current coordinates
	MOV BH,00h   	;set the page number
	INT 10h       	;Avoid drawing before the calculations
        SUB CX, curXLoc
        SUB DX, curYLoc
        Start:
        ADD DI,32
	DEC Cx       	;  loop iteration in x direction
	JNZ Drawit      	;  check if we can draw c urrent x and y and excape the y iteration
	mov Cx, imgW 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
        add [col],-1
        mov DI, offset img  ; to iterate over the pixels
        ADD DI,[col]
	DEC DX       	;  loop iteration in y direction
	JZ  ENDING   	;  both x and y reached 00 so end program
	Jmp Drawit
        ENDING:
        POPF
        ret
DRAW ENDP

ERASE PROC
        ;delete previous place (By Coloring its place with same backGround Color)
        PUSHF
        MOV [col],31
        MOV AH,0Bh   	;set the configuration
	MOV CX, imgW  	;set the width (X) up to 64 (based on image resolution)
	MOV DX, imgH 	;set the hieght (Y) up to 64 (based on image resolution)
	mov DI, offset img  ; to iterate over the pixels
        ADD DI,[col]
        jmp Startt  
        Drawitt:
	MOV AH,0Ch   	;set the configuration to writing a pixel
        ADD CX, curXLoc  	;set the width (X) up to 64 (based on image resolution)
	ADD DX, curYLoc 	;set the hieght (Y) up to 64 (based on image resolution)
        mov al, 0     ; color of the current coordinates
	MOV BH,00h   	;set the page number
	INT 10h       	;Avoid drawing before the calculations
        SUB CX, curXLoc
        SUB DX, curYLoc
        Startt:
        ADD DI,32
	DEC Cx       	;  loop iteration in x direction
	JNZ Drawitt      	;  check if we can draw c urrent x and y and excape the y iteration
	mov Cx, imgW 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
        add [col],-1
        mov DI, offset img  ; to iterate over the pixels
        ADD DI,[col]
	DEC DX       	;  loop iteration in y direction
	JZ  ENDINGG   	;  both x and y reached 00 so end program
	Jmp Drawitt
        ENDINGG:
        POPF
        ret
ERASE ENDP

END MAIN