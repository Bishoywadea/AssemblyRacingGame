;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function : car MOVement using arrows
;author : -NoName  && Ahmed Hamdy
;Date : 28-11-2023
IDEAL
MODEL compact
STACK 100h

CODESEG
PROC send_from_AH
             PUSH AX ;;store aH value

             MOV  DX,3FBH
             MOV  AL,00011011B
             OUT  DX,AL
             ;;;;;;;;;;;;;;;;;;
                mov dx , 3FDH		; Line Status Register
                AGAIN_SEND_AH:  	
                In al , dx 			;Read Line Status
                AND al , 00100000b
                JZ AGAIN_SEND_AH
                mov dx , 3F8H		; Transmit data register
                POP AX ;;retrieve ax value
                MOV AL,AH
                out dx , aL
                PUSH AX
         

                ;;wait till recieved
                 mov dx , 3FDH		; Line Status Register
	             CHK_SEND_AH:	
                 in al , dx 
                 AND al , 1
                 JZ CHK_SEND_AH
                 mov dx , 03F8H
                 in al , dx 

                 POP AX
                 ret

ENDP

PROC send_from_AL
             PUSH AX ;;store al value

             MOV  DX,3FBH
             MOV  AL,00011011B
             OUT  DX,AL
             ;;;;;;;;;;;;;;;;;;
                mov dx , 3FDH		; Line Status Register
                AGAIN_SEND_AL:  	
                In al , dx 			;Read Line Status
                AND al , 00100000b
                JZ AGAIN_SEND_AL
                mov dx , 3F8H		; Transmit data register
                POP AX ;;retrieve ax value
                out dx , al
                PUSH AX
         

                ;;wait till recieved
                 mov dx , 3FDH		; Line Status Register
	             CHK_SEND_AL:	
                 in al , dx 
                 AND al , 1
                 JZ CHK_SEND_AL
                 mov dx , 03F8H
                 in al , dx 

                 POP AX
                 ret

ENDP

;;
PROC send_from_AX

             PUSH AX ;;store al value

             MOV  DX,3FBH
             MOV  AL,00011011B
             OUT  DX,AL
             ;;;;;;;;;;;;;;;;;;
                mov dx , 3FDH		; Line Status Register
                AGAIN_SEND_ALxxxx:  	
                In al , dx 			;Read Line Status
                AND al , 00100000b
                JZ AGAIN_SEND_ALxxxx
                mov dx , 3F8H		; Transmit data register
                POP AX ;;retrieve ax value
                out dx , ax
                PUSH AX
         

                ;;wait till recieved
                 mov dx , 3FDH		; Line Status Register
	             CHK_SEND_ALxx:	
                 in al , dx 
                 AND al , 1
                 JZ CHK_SEND_ALxx
                 mov dx , 03F8H
                 in ax , dx 

                 POP AX
                 ret

        ;    CALL send_from_AL
        ;    CALL send_from_AH
ENDP
;;
PROC recieve_in_AX

            mov dx , 3FDH		; Line Status Register
	        CHK_RECIEVE_AX:	
            in al , dx 
  		    AND al , 1
  		    JZ CHK_RECIEVE_AX
            mov dx , 03F8H
  		    in AL , dx 
            PUSH AX
           

             ;;send flag
              mov dx , 3FDH		; Line Status Register
              AGAIN_SEND_FLAG_AX:  	
              In al , dx 			;Read Line Status
              AND al , 00100000b
              JZ AGAIN_SEND_FLAG_AX
              mov dx , 3F8H		; Transmit data register
              mov al,1
              out dx , AL

              pop ax ;;data recieved is in ax


                 mov dx , 3FDH		; Line Status Register
	        CHK_RECIEVE_AX2:	
            in al , dx 
  		    AND al , 1
  		    JZ CHK_RECIEVE_AX2
            mov dx , 03F8H
            MOV AL,AH
  		    in AL , dx 
            PUSH AX
           

             ;;send flag
              mov dx , 3FDH		; Line Status Register
              AGAIN_SEND_FLAG_AX2:  	
              In al , dx 			;Read Line Status
              AND al , 00100000b
              JZ AGAIN_SEND_FLAG_AX2
              mov dx , 3F8H		; Transmit data register
              mov al,1
              out dx , AL

              pop ax ;;data recieved is in ax

           ret
ENDP

;;
PROC sendRandom


             MOV  DX,3FBH
             MOV  AL,00011011B
             OUT  DX,AL
             ;;;;;;;;;;;;;;;;;;
                mov dx , 3FDH		; Line Status Register
                AGAIN_SEND:  	
                In al , dx 			;Read Line Status
                AND al , 00100000b
                JZ AGAIN_SEND
                mov dx , 3F8H		; Transmit data register
                mov al,ah
                out dx , al
                ;;wait till recieved
                   mov dx , 3FDH		; Line Status Register
	                CHK_S:	
                    in al , dx 
                    AND al , 1
                    JZ CHK_S
                    mov dx , 03F8H
                    in al , dx 
                    
        
                    ret



ENDP
PROC recieveRandom
            

            mov dx , 3FDH		; Line Status Register
	        CHK:	
            in al , dx 
  		    AND al , 1
  		    JZ CHK
            mov dx , 03F8H
  		    in al , dx 
            mov ah,al  ;data recieved is in ah
            ;;;;;;;;;;;;print ah
           

            ;call drawSqr
            ;;send flag
              mov dx , 3FDH		; Line Status Register
              AGAIN_SEND_R:  	
              In al , dx 			;Read Line Status
              AND al , 00100000b
              JZ AGAIN_SEND_R
              mov dx , 3F8H		; Transmit data register
              mov al,1
              out dx , al

           ret


ENDP

PROC checktrack                                             ;check if the pixel is already colored
                        PUSH ax
                        PUSH bx
                        PUSH dx
                        PUSH cx
    
                        MOV  bh,0
                        MOV  ah,0dh
                        MOV  cx,col
                        MOV  dx,row
                        INT  10h
                        MOV  tempvarcheck,al
                        POP cx
                        POP dx
                        POP bx
    
                        POP ax
                        CMP  tempvarcheck,trackcolor
                        jne  skipcheck
                        MOV  trackcheck,1
    skipcheck:          
                        ret
   
ENDP
 PROC drawdown

                        CMP  lastmove,0                        ;;if last move up
                        je   terminatedown
  
                        CMP  row,downlimit-trackwidth
                        jge  terminatedown
                        CMP  col,rightlimit-trackwidth
                        jge  terminatedown
                        CMP  col,leftlimit+trackwidth
                        jl   terminatedown

                        CMP  lastmove,2
                        jne  sd
                        sub  col,trackwidth -1
    sd:                 

   
                        MOV  si,0

    drawdownpixel:      

 
                        CMP  row,downlimit
                        jge  terminatedown

 
   
                        MOV  cx,trackwidth
    drawdownline:       
 
                        PUSH bx
                        PUSH di
                        PUSH si
                        PUSH cx
                        MOV  si,0
                        MOV  bx,0
                        MOV  di,0
                        MOV  ah,0ch
                        MOV  al,trackcolor
                        MOV  cx,col
                        MOV  dx,row
                        INT  10h
                        INC  col
                        POP cx
                        DEC  cx
                        POP si
                        POP di
                        POP bx
                        CMP  cx,0
                        jnz  drawdownline
                        sub  col,trackwidth
                        MOV  lastmove,3
                        INC  row                          ;move 1 step down
                        INC  si
   
  
                        CMP  si,sectionlength
                        jnz  drawdownpixel

                        INC  numsectionsmoved
  
    terminatedown:      
                        ret
ENDP 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 PROC drawright
      
     
  
   
    ;;;;;;;;;;;CMP if last move is up
    
                        CMP  lastmove,0
                        jne  skip
                        add  col,trackwidth
                        INC  row
    skip:               
      
                        CMP  lastmove,3
                        jne  skip1
                        sub  row,trackwidth
                        add  col,trackwidth
    skip1:              
                        CMP  lastmove,2
                        je   terminateright
    
                        CMP  row, downlimit-trackwidth

                        jg   terminateright
                        MOV  si,0
    drawrightpixel:     
                        MOV  cx,col
                        mov rightCol,cx
                        mov cx,0
   
    repeatR:            
    ;checkbounds
                        CMP  col,rightlimit
                        jge  terminateright
    
                        PUSH ax
                        PUSH cx                                ;draw
                        PUSH dx
                        PUSH bx
                        MOV  bx,0
                        MOV  ah,0ch
                        MOV  al,trackcolor
                        MOV  cx, col
                        MOV  dx ,row
                        INT  10h
                        POP bx
                        POP dx
                        POP cx
                        POP ax
                        MOV  lastmove,1
                        INC  cx
                        INC  row
                        CMP  cx,trackwidth
                        jnz  repeatR

                        INC  col
                        inc rightCol
                        sub  row,trackwidth
                         
                        INC  si
                        CMP  si,upsectionlenght
                        jnz  drawrightpixel
                        INC  numsectionsmoved
                       
    terminateright:     
                        ret

ENDP 

PROC drawleft
 
  
                        CMP  row, downlimit-trackwidth
                        jg   skip02
                        CMP  col,leftlimit+trackwidth
                        jle  skip02
                        CMP  lastmove,0
                        jnz  skip4
                        add  col,trackwidth
   
    skip4:              
 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CMP  lastmove,1
                        je   skip02
  


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CMP  lastmove,3                        ;if last move is down,adjust x        ; its functionality is en ba3d el down yzbat el x
                        jnz  skipL
                        CMP  col,leftlimit
                        je   skip02
                        jle  hh
                        sub  row,trackwidth
                        DEC  col
    hh:                 
                        add  col,trackwidth-1
    skipL:              
                        MOV  si,0
    drawleftpixel:      
 
                        MOV  cx,0
    ;checkbounds
                        CMP  col,leftlimit+trackwidth
                        jle  terminateleft
                        PUSH ax
                        MOV  ax,col
                        sub  col,trackwidth
                        MOV  trackcheck,0
                        CALL checktrack
                        CMP  trackcheck,1
                        MOV  col,ax
                        POP ax
                        je   terminateleft
    repeatL:            
                        JMP  skip03
    skip02:             
                        JMP  terminateleft
    skip03:             
   
   
                        PUSH ax
                        PUSH cx                                ;draw
                        PUSH dx
                        PUSH bx
                        MOV  bx,0
                        MOV  al,trackcolor
                        JMP  skip05
    skip04:             
                        JMP  drawleftpixel
    skip05:             
                        MOV  ah,0ch
                        MOV  cx, col
                        MOV  dx ,row
                        INT  10h
                        POP bx
                        POP dx
                        POP cx
                        POP ax
     
                        INC  cx
                        INC  row
                        CMP  cx,trackwidth

                        jnz  repeatL
                        MOV  lastmove,2
                        DEC  col
                        sub  row,trackwidth
   
                        INC  si
                        CMP  si,sectionlength
  
                        jnz  skip04
                        INC  numsectionsmoved

    terminateleft:      
                        ret
  

ENDP 

PROC drawup

                        CMP  lastmove,3
                        jz   skip00
  
                        CMP  row,uplimit
                        jle  skip00
                        CMP  lastmove,2
                        jz   skip00
                        PUSH ax
                        MOV  ax, row
                        sub  row,trackwidth *2
                        MOV  trackcheck,0
                        CALL checktrack
                        CMP  trackcheck,1
                        MOV  row,ax
                        POP ax
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;
                        push cx 
                        mov cx, trackwidth*4
                        loopcheckup:
                        
                        PUSH ax
                        MOV  ax, row
                        sub  row,1
                        MOV  trackcheck,0
                        CALL checktrack
                        CMP  trackcheck,1

                        MOV  row,ax
                        POP ax
                        je   terminateupR 
                        dec cx 
                        cmp cx, 0
                        jne  loopcheckup
                        JMP skipterminateupR
                        terminateupR:
                            pop cx
                            JMP skip00
                        skipterminateupR:
                        pop cx 
                        CMP  col,rightlimit-trackwidth
                        jg   skip00
                        CMP  row, uplimit+trackwidth
                        jle  skip00
                        CMP  lastmove,1
                        jnz  skip111
                        sub  col,trackwidth

    skip111:            
 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   
                        MOV  si,0
    drawuppixel:        
                                            JMP  skip01
    skip00:             
                        JMP  terminateup
    skip01:       
                        CMP  row,uplimit+trackwidth
                        jle  terminateup
      
                        PUSH ax
                        MOV  ax,row
                        sub  row,trackwidth
                        MOV  trackcheck,0
                        CALL checktrack
      
                        CMP  trackcheck,1
                        MOV  row,ax
                        POP ax
                        je   terminateup
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
                        MOV  cx,trackwidth
    drawupline:         

                        PUSH bx
                        PUSH di
                        PUSH si
                        PUSH cx
                        MOV  si,0
                        MOV  bx,0
                        MOV  di,0
                        MOV  ah,0ch
                        MOV  al,trackcolor
                        MOV  cx,col
                        MOV  dx,row
                        INT  10h
                        INC  col
                        POP cx
                        DEC  cx
                        POP si
                        POP di
                        POP bx
                        CMP  cx,0
                        jnz  drawupline
   
                        DEC  row

                        MOV  lastmove,0
                        sub  col,trackwidth
                        INC  si
                        CMP  si,upsectionlenght                ;repeat 40 times to generate a vertical track section of width "track width"
                        jnz  drawuppixel
  
                        INC  numsectionsmoved
    ;add col,trackwidth
    terminateup:        
                        ret
 endp

PROC initialization
                    CALL RandomNum
                    MOV  START_X_LIMIT,ax
                    CMP START_X_LIMIT,1
                    JA START_AT_RIGHT

                    MOV  START_X_LIMIT,leftlimit
                    JMP START_TRACK_POSITION
                    START_AT_RIGHT:
                    MOV  START_X_LIMIT,rightlimit
                    JMP START_TRACK_POSITION
                    START_TRACK_POSITION:
                        PUSH CX
                        MOV CX,START_X_LIMIT
                        MOV  col,CX
                        POP CX
                        MOV  row,uplimit
                        MOV  numrands,25d
                        MOV  numsectionsmoved,0
                        MOV  sectionsupcount,1
                        MOV  lastmove,5d
    ;graphics mode
                      CALL  Draw_backGround 
                        MOV  finalflag,0
                        ret
 endp
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PROC genRandom                                             ;;generate random number from 0 to 4 and store in ah
    ;                     CMP  numrands,0
    ;                     je   setFF

    ;                     JMP  skipsetFF
    ; setFF:              
    ;                     MOV  finalflag,1
    ;                     mov ah,finalflag
    ;                     JMP  terminaterandom
    ; skipsetFF:          
                        MOV  si,0FFFh
    looprand:                                                  ;loop to slow down
                        mov cx,0 
                        mov dx,0bfffh 
                        mov ah,86h
                        int 15h 
                        MOV  ah, 2ch
                        INT  21h
                        MOV  ah, 0
                        MOV  al, dl                            ;;micro seconds?
                        MOV  bl, 4
                        div  bl
    ;;; ah = rest
                        DEC  si
                        CMP  si,0
                        ;jnz  looprand
                        call sendRandom
                        ;mov al,0  
                        ;call send_from_AX

    terminaterandom:    
                       
                       
                        RET
 ENDP
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROC trackend
                        MOV  ah, 0
                        INT  16h
                        ret
 endp

PROC drawFinishLine
    ;;;;;;;;;;;;;;;;;;;draw last line
                        CMP  lastmove,3                        ;;;if last move is down
                        jne  checkother
                        DEC  row
    ;;;;;;;;;;;;;;;
                        MOV  loopCounter,5
    drawdownlinefWIDTH: 
                        MOV  cx,trackwidth
    drawdownlinef:      
                        PUSH bx
                        PUSH di
                        PUSH si
                        PUSH cx
                        MOV  si,0
                        MOV  bx,0
                        MOV  di,0
                        MOV  ah,0ch
                        MOV  al,YellowClr
                        MOV  cx,col
                        MOV  dx,row
    
                        INT  10h
                        INC  col
                        POP cx
                        DEC  cx
                        POP si
                        POP di
                        POP bx
                        CMP  cx,0
                        jnz  drawdownlinef
                        sub  col,trackwidth
                        INC  row
                        DEC  loopCounter
                        CMP  loopCounter,0
                        jnz  drawdownlinefWIDTH
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        JMP  terminateFinishLine
                        JMP  skiippp
    drawag:             
                        JMP  drawagain
    skiippp:            
    checkother:         
                        CMP  lastmove,1 ;;right
                        jne  checkother2
                        dec col
                        mov si,rightCol
                        mov col,si
                        MOV  si,5
    repeatRfinWIDTH:    
                        MOV  cx,0
    repeatRfin:         
                        PUSH ax
                        PUSH cx                                ;draw
                        PUSH dx
                        PUSH bx
                        MOV  bx,0
                        MOV  ah,0ch
                        MOV  al,YellowClr
                        MOV  cx, col
                        MOV  dx ,row
                        INT  10h
                        POP bx
                        POP dx
                        POP cx
                        POP ax
     
                        INC  cx
                        INC  row
                        CMP  cx,trackwidth
                        jnz  repeatRfin
                        sub  row,trackwidth
                        INC  col
                        DEC  si
                        CMP  si,0
                        jnz  repeatRfinWIDTH
                        JMP  terminateFinishLine
    checkother2:        
                        CMP  lastmove,0
                        jne  checkother3
                        INC  row
                        MOV  loopCounter,5
    drawuplinefWIDTH:   
                        MOV  cx,trackwidth
    drawuplinef:        

                        PUSH bx
                        PUSH di
                        PUSH si
                        PUSH cx
                        MOV  si,0
                        MOV  bx,0
                        MOV  di,0
                        MOV  ah,0ch
                        MOV  al,YellowClr
                        MOV  cx,col
                        MOV  dx,row
                        INT  10h
                        INC  col
                        POP cx
                        DEC  cx
                        POP si
                        POP di
                        POP bx
                        CMP  cx,0
                        jnz  drawuplinef
                        sub  col,trackwidth
                        DEC  row
                        DEC  loopCounter
                        CMP  loopCounter,0
                        jnz  drawuplinefWIDTH

                        JMP  terminateFinishLine
    checkother3:        
                        add  col,1


                        MOV  si,5
    repeatLfinWIDTH:    
                        MOV  cx,0
    repeatLfin:         
                        PUSH ax
                        PUSH cx                                ;draw
                        PUSH dx
                        PUSH bx
                        MOV  bx,0
                        MOV  ah,0ch
                        MOV  al,YellowClr
                        MOV  cx, col
                        MOV  dx ,row
                        INT  10h
                        POP bx
                        POP dx
                        POP cx
                        POP ax
   
                        INC  cx
                        INC  row
                        CMP  cx,trackwidth
                        jnz  repeatLfin
                        sub  row,trackwidth
                        INC  col
                        DEC  si
                        CMP  si,0
                        jnz  repeatLfinWIDTH
    terminateFinishLine:
                        ret
 endp

PROC generateObstacles
    genObstacles:       
    ;;generate a random x and a random y
    ;;check en mafesh 7waleha obstacles tanya w enaha track aslan
    ;;draw obstacle
    ;;randomizing x

    ;;if recieve flag is 0,recieve random x,if not,generate random x
    cmp recFlag,0
    je recieve_randomX
    ;;;;;;;;;;;;;;;;;generate and send
                        MOV  col,0
                        MOV  cx,6
    randomX:             
                        PUSH cx
                        MOV  ah, 00                            ; Function to get system time
                        INT  1ah

                        MOV  ah, 0
                        MOV  al, dl                            ;;micro seconds? 0-99
                        add  col,ax
                        POP cx
                        DEC  cx
                        CMP  cx,0
                        jnz  randomX

                       ;;random x is in col
                       MOV AX,col
                       call send_from_AX
                       JMP GO_TO_RANDY

                       recieve_randomX:
                       call recieve_in_AX
                       MOV col,AX     

    GO_TO_RANDY:
    ;;;;;;;;;;;randomizing y
    ;;;;;;;;;if recieve flag is 0,recieve random y,if
    cmp recFlag,0
    je recieve_randomY
    ;;;;;;;;;;;;;;;;;;;;;generate and send
                        MOV  row,0
                        MOV  cx,4
    randomY:            
                        PUSH cx
                        MOV  ah, 2Ch                           ; Function to get system time
                        INT  21h

                        MOV  ah, 0
                        MOV  al, dl                            ;;micro seconds? 0-99
                        add  row,ax
                        POP cx
                        DEC  cx
                        CMP  cx,0
                        jnz  randomY

                        ;;random Y is in row
                        MOV AX,row
                        call send_from_AX
                        JMP GO_TO_COLOR

                        recieve_randomY:
                        call recieve_in_AX
                        MOV row,AX
    GO_TO_COLOR:
    ;;randomizing a color
     CMP recFlag,0
     JE RECIEVE_COLOR
                       ;;generate and send
                        MOV  ah, 2ch
                        INT  21h
                        MOV  ah, 0
                        MOV  al, dl                            ;;micro seconds?
                        MOV  bl, GenarraySize
                        div  bl
        
                        MOV  al,ah ;;ah is reminder
                        MOV  ah,0
                        CALL send_from_AX
                        JMP GO_TO_OBSTS

                        RECIEVE_COLOR:
                        CALL recieve_in_AX
                        GO_TO_OBSTS:

                        CMP startFlag,0 ;;;THIS GENERATES JUST POWER UPS DURING THE GAME
                        JNE trackObs
                        
                        CMP AX,3 ;;color is obstacle color
                        JA trackObs
                        RET 
                        trackObs:
                        MOV  di,ax
                        MOV  bl,Genarray+di
                        MOV  obstacleColor,bl
                        

                        
                        
                        
                      
                        
    ;;randomizing number of power ups and obstacles
    ;checks
    ;;check square is in track area
    ;;check no nearby obstacles (not in col+obstaclewidth*2 and col-obstaclewidth
    ;;for cuurenty from row-obstaclewidth to row+obstaclewidth*2
    ;;;;;;;;
        CMP row, downlimit-obstacleWidth
        JB draw_obstacle
        RET 
        draw_obstacle:
                        PUSH col
                        PUSH row


    ;;                                              *******
                        sub  col,obstacleWidth*2            ;;;;;;;;;;;;;;;;;;;  ** __****
                        MOV  si,obstacleWidth*5                ;; **|    |**** ;;say en el square da el obstacle,
                        sub  row,obstacleWidth*2                  ;;**|    |***  ehna bn check mkano w 7waleh in all
    squareOuterCheck:                                          ;;  ** __ **** directions
                        MOV  cx,obstacleWidth*5                ;;   ********
    squareInnerCheck:   
                        PUSH cx
                        MOV  bx,0
                        MOV  ah,0dh
                        MOV  cx,col
                        MOV  dx,row
                        INT  10h
                        POP cx
                        CMP  al,trackcolor
                        jne  skip_draw_obstacle
                        INC  col
       
                        DEC  cx
                        CMP  cx,0
                        jnz  squareInnerCheck
                        sub  col,obstacleWidth*5
                        INC  row
                        DEC  si
                        CMP  si,0
                        jnz  squareOuterCheck

                        
                        POP row
                        POP col
    ;;;
                        JMP  skipINTER_OBST
    genObstaclesINTER:  
                        JMP  genObstacles
    skipINTER_OBST:     

    ;;;
    ;;;;;;;;;;;;;;;;;;
                        MOV  si,obstacleWidth

    squareOuterLoop:    
                        MOV  cx,obstacleWidth
    squareInnerLoop:    
                        PUSH cx

                        MOV  bx,0
                        MOV  ah,0ch
                        MOV  al,obstacleColor
                        MOV  cx,col
                        MOV  dx,row
                        INT  10h

                        INC  col

                        POP cx
                        DEC  cx
                        CMP  cx,0
                        jnz  squareInnerLoop

                        sub  col,obstacleWidth
                        INC  row
                        DEC  si
                        CMP  si,0

                        jnz  squareOuterLoop
                        INC  numobs
    ;JMPskip_draw_obstacle2
    ;skip_draw_obstacle:
    
                        JMP  skip_draw_obstacle2
    skip_draw_obstacle: 
                        POP row
                        POP col

    skip_draw_obstacle2:
                        ;MOV  di,rand_POWERUPS_COUNT
                        CMP  numobs,di
                        cmp numobs,9d

                        ;jle   genObstaclesINTER
    ;jge trackendinter
                        ret
 endp

PROC drawTrack
    init:               
                        CALL initialization
                        CALL InPort
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    randomfunc:         CMP  numrands,0
                        jz setFF

                        CMP recFlag,0
                        JE recieve_track

                        CALL genRandom                         ;returns random from 0-4 in AH
                        ;send the direction to the other player
                        JMP dontrecTrack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
recieve_track:
                  CALL recieveRandom
                ; call recieve_in_AX

                  jmp dontrecTrack

                  setFF:
                  MOV  finalflag,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dontrecTrack:
                        CMP  finalflag,1
                        je   final

    DECide:             
                        CMP  lastmove,0
                        jne  skip6
                        MOV  ah,1
    skip6:              
                        

                        DEC  numrands


                        CMP  ah,0
                        je   moveup
 
                        CMP  ah,1
                        je   moveright

                        CMP  ah,2
                        je   moveleft

                        CMP  ah,3
                        je   movedown

    ;;;;;;;;;;;;;;;;;;;;;;;
                        JMP  intermeddiatetry
    trackendinter:      
                        JMP  trackend
    intermeddiatetry:   
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    moveright:          
            CALL drawright
            JMP  randomfunc                        ;regenerate random and check limits (repeatt)
    movedown:           
            CALL drawdown
            JMP  randomfunc                        ;regenerate random and check limits (repeatt)                                                                        
    moveleft:           
            CALL drawleft
            JMP  randomfunc                        ;regenerate random and check limits (repeatt)
    moveup:             
            CALL drawup
            JMP  randomfunc
    final:              
            CMP  [numsectionsmoved],10d
            jl   drawagain
            CALL drawFinishLine
            JMP  endtrack
    drawagain:          
                        JMP  init
    ;mark end of track
    endtrack:           
                        MOV startFlag,1 ;;awel ma el track etrsm
                        ;;3ayzen nfady
                        call InPort
                        ret
 endp

PROC RandomNum
                       MOV  ah, 2ch
                        INT  21h
                        MOV  ah, 0
                        MOV  al, dl                            ;;micro seconds?
                        MOV  bl, 6
                        div  bl
                        add  ah,2
                        MOV  al,ah
                        MOV  ah,0
ENDP

PROC sleepSomeTime
    MOV cx, 0
    MOV dx, 20000  ; 20ms
    MOV ah, 86h
    int 15h  ; param is cx:dx (in microseconds)
    RET
ENDP

PROC PrintTimer
push ax
push dx
push bx
push cx 

mov al,120
SUB al,StopTimer
mov ah,00h
;get hundreds digit
mov bl,100
div bl
push ax
add al,48

LEA DI,TimerGameDisplay+2
MOV [DI],AL
INC DI
; mov bh,0
; mov cx,1h
; mov ah,09h
; int 10h

; ;move cursor
; mov dx, 01h
; mov ah,02h
; int 10h

pop ax
mov al,ah
mov ah,0
;get tens digit
mov bl,10
div bl
push ax
mov bh,0
mov cx,1h
add al,48

MOV [DI],AL
INC DI

; mov ah,09h
; int 10h

; ;move cursor
; mov dx, 02h
; mov ah,02h
; int 10h

;get ones digit
pop ax
mov al,ah
add al,48 
; mov bh,0
; mov cx,1h
; mov ah,09h
; int 10h
MOV [DI],AL
pop cx
pop bx
pop dx
pop ax
ret
endp

PROC CheckTimer

    MOV AH,2CH
    INT 21H
    CALL PrintTimer
    MOV AL,CL
    MOV BL,60D
    MUL BL
    SHR DX,8D ;MAKE DL= DH AND DH =0
    ADD AX,DX
    SUB AX,[TimerGame]
    mov StopTimer,al
    MOV BL,Stopping_Limit
    CMP StopTimer,BL
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

PROC drawPlayer1Vt
    MOV CX,[XPlayer1]
    SUB CX,(carW/2)
    MOV DX,[YPlayer1]
    SUB DX,(carH/2)
    MOV col,0
    MOV row,0
    CMP DirectionTOBeDrawn,0
    JNE reverseDown
    LEA SI, car1+(carH*carW-1)
    JMP horizontalDrawForUp1
    reverseDown:
    LEA SI, car1
    horizontalDrawForUp1:
    MOV AH,0CH
    MOV AL,[SI]     ;[BlackClr]
    CMP DirectionTOBeDrawn,0
    JNE reverseDown2
    DEC SI
    JMP cont
    reverseDown2:
    INC SI
    cont:
    int 10h
    INC CX
    INC col
    CMP col,(carW)
    JNE horizontalDrawForUp1
    MOV CX,[XPlayer1]
    SUB CX,(carW/2)
    INC DX
    INC row
    CMP row,(carH)
    MOV col,0
    JNE horizontalDrawForUp1
    RET
ENDP

PROC drawPlayer1Hz
    MOV CX,[XPlayer1]
    ADD CX,(carH/2)
    MOV DX,[YPlayer1]
    SUB DX,(carW/2)
    MOV col,0
    MOV row,0
    CMP DirectionTOBeDrawn,3
    JNE reverseLeft
    LEA SI, car1+(carH*carW-1)
    JMP horizontalDrawForRight1
    reverseLeft:
    LEA Si,car1
    horizontalDrawForRight1:
    MOV AH,0CH
    MOV AL,[SI]
    CMP DirectionTOBeDrawn,3
    JNE reverseLeft2
    DEC SI
    JMP cont2
    reverseLeft2:
    INC SI
    cont2:
    int 10h
    INC DX
    INC col
    CMP col,(carW)
    JNE horizontalDrawForRight1
    MOV DX,[YPlayer1]
    SUB DX,(carW/2)
    DEC CX
    INC row
    CMP row,(carH)
    MOV col,0
    JNE horizontalDrawForRight1
    RET
ENDP

PROC drawPlayer1
    CMP [orientaionP1],1
    JA drawHzP1
    CALL drawPlayer1Vt
    RET
    drawHzP1:
    CALL drawPlayer1Hz
    RET
ENDP

PROC cleanPlayer1Vt
    MOV CX,[XPlayer1]
    SUB CX,(carW/2)
    MOV DX,[YPlayer1]
    SUB DX,(carH/2)
    MOV col,0
    MOV row,0

    horizontalEraseFor1Vt:
    MOV AH,0CH
    MOV AL,BlackClr
    int 10h
    INC CX
    INC col
    CMP col,(carW)
    JNE horizontalEraseFor1Vt
    MOV CX,[XPlayer1]
    SUB CX,(carW/2)
    INC DX
    INC row
    CMP row,(carH)
    MOV col,0
    JNE horizontalEraseFor1Vt
    RET
ENDP

PROC cleanPlayer1Hz
    MOV CX,[XPlayer1]
    SUB CX,(carH/2)
    MOV DX,[YPlayer1]
    SUB DX,(carW/2)
    MOV col,0
    MOV row,0

    horizontalEraseFor1Hz:
    MOV AH,0CH
    MOV AL,BlackClr
    int 10h
    INC CX
    INC col
    CMP col,(carH)
    JNE horizontalEraseFor1Hz
    MOV CX,[XPlayer1]
    SUB CX,(carH/2)
    INC DX
    INC row
    CMP row,(carW)
    MOV col,0
    JNE horizontalEraseFor1Hz
    RET
ENDP

PROC cleanPlayer1
    CMP [orientaionP1],1
    JA eraseHz
    CALL cleanPlayer1Vt
    RET
    eraseHz:
    CALL cleanPlayer1Hz
    RET
ENDP

PROC drawPlayer2Vt
    MOV CX,[XPlayer2]
    SUB CX,(carW/2)
    MOV DX,[YPlayer2]
    SUB DX,(carH/2)
    MOV col,0
    MOV row,0
    CMP DirectionTOBeDrawn,0
    JNE reverseDownP2
    LEA SI, car2+(carH*carW-1)
    JMP horizontalDrawForUp2
    reverseDownP2:
    LEA SI, car2
    horizontalDrawForUp2:
    MOV AH,0CH
    MOV AL,[SI]     ;[BlackClr]
    CMP DirectionTOBeDrawn,0
    JNE reverseDown2P2
    DEC SI
    JMP cont4
    reverseDown2P2:
    INC SI
    cont4:
    int 10h
    INC CX
    INC col
    CMP col,(carW)
    JNE horizontalDrawForUp2
    MOV CX,[XPlayer2]
    SUB CX,(carW/2)
    INC DX
    INC row
    CMP row,(carH)
    MOV col,0
    JNE horizontalDrawForUp2
    RET
ENDP

PROC drawPlayer2Hz
    MOV CX,[XPlayer2]
    ADD CX,(carH/2)
    MOV DX,[YPlayer2]
    SUB DX,(carW/2)
    MOV col,0
    MOV row,0
    CMP DirectionTOBeDrawn,3
    JNE reverseLeftP2
    LEA SI, car2+(carH*carW-1)
    JMP horizontalDrawForRight1P2
    reverseLeftP2:
    LEA Si,car2
    horizontalDrawForRight1P2:
    MOV AH,0CH
    MOV AL,[SI]
    CMP DirectionTOBeDrawn,3
    JNE reverseLeft2P2
    DEC SI
    JMP cont3
    reverseLeft2P2:
    INC SI
    cont3:
    int 10h
    INC DX
    INC col
    CMP col,(carW)
    JNE horizontalDrawForRight1P2
    MOV DX,[YPlayer2]
    SUB DX,(carW/2)
    DEC CX
    INC row
    CMP row,(carH)
    MOV col,0
    JNE horizontalDrawForRight1P2
    RET
ENDP

PROC drawPlayer2
    CMP [orientaionP2],1
    JA drawHzP2
    CALL drawPlayer2Vt
    RET
    drawHzP2:
    CALL drawPlayer2Hz
    RET
ENDP

PROC cleanPlayer2Vt
    MOV CX,[XPlayer2]
    SUB CX,(carW/2)
    MOV DX,[YPlayer2]
    SUB DX,(carH/2)
    MOV col,0
    MOV row,0

    horizontalEraseFor2Vt:
    MOV AH,0CH
    MOV AL,BlackClr
    int 10h
    INC CX
    INC col
    CMP col,(carW)
    JNE horizontalEraseFor2Vt
    MOV CX,[XPlayer2]
    SUB CX,(carW/2)
    INC DX
    INC row
    CMP row,(carH)
    MOV col,0
    JNE horizontalEraseFor2Vt
    RET
ENDP

PROC cleanPlayer2Hz
    MOV CX,[XPlayer2]
    SUB CX,(carH/2)
    MOV DX,[YPlayer2]
    SUB DX,(carW/2)
    MOV col,0
    MOV row,0

    horizontalEraseFor2Hz:
    MOV AH,0CH
    MOV AL,BlackClr
    int 10h
    INC CX
    INC col
    CMP col,(carH)
    JNE horizontalEraseFor2Hz
    MOV CX,[XPlayer2]
    SUB CX,(carH/2)
    INC DX
    INC row
    CMP row,(carW)
    MOV col,0
    JNE horizontalEraseFor2Hz
    RET
ENDP

PROC cleanPlayer2
    CMP [orientaionP2],1
    JA eraseHzP2
    CALL cleanPlayer2Vt
    RET
    eraseHzP2:
    CALL cleanPlayer2Hz
    RET
ENDP

PROC checkPlayer1
    MOV CX,[NextXPlayer1]
    SUB CX,(carW/2)
    MOV DX,[NextYPlayer1]
    SUB DX,(carH/2)
    MOV col,0
    MOV row,0
    MOV BH,0

    horizontalCheckFor1Vt:
    MOV AH,0DH
    int 10H
    ; CMP AL,GreenClr
    ; JNE VT_CHECKTRACK
    ; MOV [FLAG],0
    ; RET
    VT_CHECKTRACK:
    CMP AL,BlackClr
    JNE p1_checkObstaclesVt
    INC CX
    INC col
    CMP col,(carW)
    JNE horizontalCheckFor1Vt
    MOV CX,[NextXPlayer1]
    SUB CX,(carW/2)
    INC DX
    INC row
    CMP row,(carH)
    MOV col,0
    JNE horizontalCheckFor1Vt
    RET

    ; check if it's an obstacle
    p1_checkObstaclesVt:
    MOV [XSqr],Cx
    MOV [YSqr],Dx
    MOV AH,0DH
    int 10H
    CMP AL,GreyClr
    JNE p1_checkSpeedUpVt
    CMP [PassFlagPlayer1],1  
    JNE p1_finshDownVt_brk
    CALL eraseSqr
    MOV CX,[XSqr]
    MOV DX,[YSqr]
    MOV [XSqrToBeDrawn],Cx
    MOV [YSqrToBeDrawn],Dx
    MOV [reDrawFlag],1
	  mov [PassFlagPlayer1],0
    JMP horizontalCheckFor1Vt

    ; check if it's a "speed up" power-up
    p1_checkSpeedUpVt:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,RedClr
    JNE p1_checkSlowDownVt
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],1
     MOV ClrSqr,RedClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
     CALL drawSqr
    JMP horizontalCheckFor1Vt

    ; check if it's a "slow down" power-up
    p1_checkSlowDownVt:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,BlueClr
    JNE p1_checkFreezeVt
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],2
    MOV ClrSqr,BlueClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Vt

JMP p1_finshDownVt_skip
    p1_finshDownVt_brk:
    JMP p1_finshDownVt
    p1_finshDownVt_skip:

p1_checkFreezeVt:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,NavyClr
    JNE p1_checkPassObstaclesVt
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],3

    ; JMP p1_finshDownVt_skip
    ; p1_finshDownVt_brk:
    ; JMP p1_finshDownVt
    ; p1_finshDownVt_skip:

    MOV ClrSqr,NavyClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Vt

    ; check if it's a "pass an obstacle" power-up
    p1_checkPassObstaclesVt:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,MagnitaClr
    JNE p1_checkGenerateObstaclesVt
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],4
    MOV ClrSqr,MagnitaClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Vt
    
    ; check if it's a "generate an obstacle" power-up
    p1_checkGenerateObstaclesVt:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,BrownClr
    JNE P1_CHECKFINISHtRACK_VT
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],5
    MOV ClrSqr,BrownClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Vt
    
    
    ; check if it's the end of the Track
    P1_CHECKFINISHtRACK_VT:
    MOV AH,0DH
    int 10H
    CMP AL,YellowClr
    JNE p1_finshDownVt
    MOV [WinnerFlag],1
    MOV GameFinishFlag,1
    RET

    p1_finshDownVt:
    MOV[flag],0
    RET
ENDP

PROC checkPlayer1Hz
    MOV CX,[NextXPlayer1]
    SUB CX,(carH/2)
    MOV DX,[NextYPlayer1]
    SUB DX,(carW/2)
    MOV col,0
    MOV row,0
    MOV BH,0

    horizontalCheckFor1Hz:
    MOV AH,0DH
    int 10H
    ; CMP AL,GreenClr
    ; JNE CHECKTRACKHZ
    ; MOV [FLAG],0
    ; RET
    CHECKTRACKHZ:
    CMP AL,BlackClr
    JNE p1_checkObstaclesHz
    INC CX
    INC col
    CMP col,(carH)
    JNE horizontalCheckFor1Hz
    MOV CX,[NextXPlayer1]
    SUB CX,(carH/2)
    INC DX
    INC row
    CMP row,(carW)
    MOV col,0
    JNE horizontalCheckFor1Hz
    RET

    ; check if it's an obstacle
    p1_checkObstaclesHz:
    MOV [XSqr],Cx
    MOV [YSqr],Dx
    ; MOV AH,0DH
    ; int 10H
    CMP AL,GreyClr
    JNE p1_checkSpeedUpHz
    CMP [PassFlagPlayer1],1  
    JNE p1_finshDownHz_brk
    CALL eraseSqr
    MOV CX,[XSqr]
    MOV DX,[YSqr]
    MOV [XSqrToBeDrawn],Cx
    MOV [YSqrToBeDrawn],Dx
    MOV [reDrawFlag],1
	  mov [PassFlagPlayer1],0
    JMP horizontalCheckFor1Hz
    
    ; check if it's a "speed up" power-up
    p1_checkSpeedUpHz:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,RedClr
    JNE p1_checkSlowDownHz
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],1
    MOV ClrSqr,RedClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Hz

    ; check if it's a "slow down" power-up
    p1_checkSlowDownHz:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,BlueClr
    JNE p1_checkFreezeHZ
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],2
    MOV ClrSqr,BlueClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Hz
    
    JMP p1_finshDownHz_skp
    p1_finshDownHz_brk:
    JMP p1_finshDownHz
    p1_finshDownHz_skp:

p1_checkFreezeHZ:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,NavyClr
    JNE p1_checkPassObstaclesHz
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],3
    MOV ClrSqr,NavyClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Hz

    ; check if it's a "pass an obstacle" power-up
    p1_checkPassObstaclesHz:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,MagnitaClr
    JNE p1_checkGenerateObstaclesHz
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],4
    MOV ClrSqr,MagnitaClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Hz
    
    ; check if it's a "generate an obstacle" power-up
    p1_checkGenerateObstaclesHz:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,BrownClr
    JNE P1_CHECKFINISHtRACK_HZ
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer1],5
    MOV ClrSqr,BrownClr
     MOV [XSqr],PowerUpsPlayer1_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor1Hz
    
    ; check if it's the end of the Track
    P1_CHECKFINISHtRACK_HZ:
    MOV AH,0DH
    int 10H
    CMP AL,YellowClr
    JNE p1_finshDownHz
    MOV [WinnerFlag],1
    MOV GameFinishFlag,1
    RET
    p1_finshDownHz:
    MOV[flag],0
    RET
ENDP

PROC checkPlayer2
    MOV CX,[NextXPlayer2]
    SUB CX,(carW/2)
    MOV DX,[NextYPlayer2]
    SUB DX,(carH/2)
    MOV col,0
    MOV row,0
    MOV BH,0

    horizontalCheckForUp2:
    MOV AH,0DH
    int 10H
    ; CMP AL,GreenClr
    ; JNE p1_CHECKTRACK
    ; MOV [FLAG],0
    ; RET
    p1_CHECKTRACK:
    CMP AL,BlackClr
    JNE p2_checkObstacles
    INC CX
    INC col
    CMP col,(carW)
    JNE horizontalCheckForUp2
    MOV CX,[NextXPlayer2]
    SUB CX,(carW/2)
    INC DX
    INC row
    CMP row,(carH)
    MOV col,0
    JNE horizontalCheckForUp2
    RET

    ; check if it's an obstacle
    p2_checkObstacles:
    MOV [XSqr],Cx
    MOV [YSqr],Dx
    MOV AH,0DH
    int 10H
    CMP AL,GreyClr
    JNE p2_checkSpeedUp
    CMP [PassFlagPlayer2],1  
    JNE p2_finshDown_brk
    CALL eraseSqr
    MOV CX,[XSqr]
    MOV DX,[YSqr]
    MOV [XSqrToBeDrawn],Cx
    MOV [YSqrToBeDrawn],Dx
    MOV [reDrawFlag],1
	  mov [PassFlagPlayer2],0
    JMP horizontalCheckForUp2

    ; check if it's a "speed up" power-up
    p2_checkSpeedUp:
    MOV AH,0DH
    int 10H
    CMP AL,RedClr
    JNE p2_checkSlowDown
    MOV [XSqr],Cx
    MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],1
    MOV ClrSqr,RedClr
     MOV [XSqr],PowerUpsPlayer2_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckForUp2


JMP p2_finshDown_skp
    p2_finshDown_brk:
    JMP p2_finshDown
    p2_finshDown_skp:

    ; check if it's a "slow down" power-up
    p2_checkSlowDown:
    MOV AH,0DH
    int 10H
    CMP AL,BlueClr
    JNE p2_checkFreezeVT
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],2
    MOV ClrSqr,BlueClr
     MOV [XSqr],PowerUpsPlayer2_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckForUp2
    ; JMP p2_finshDown_skp
    ; p2_finshDown_brk:
    ; JMP p2_finshDown
    ; p2_finshDown_skp:


    ; check if it's a "pass an obstacle" power-up
    
    p2_checkFreezeVT:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,NavyClr
    JNE p2_checkPassObstacles
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],3
    MOV ClrSqr,NavyClr
     MOV [XSqr],PowerUpsPlayer2_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckForUp2

    p2_checkPassObstacles:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,MagnitaClr
    JNE p2_checkGenerateObstacles
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],4
    MOV ClrSqr,MagnitaClr
     MOV [XSqr],PowerUpsPlayer2_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckForUp2
    
    ; check if it's a "generate an obstacle" power-up
    p2_checkGenerateObstacles:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,BrownClr
    JNE P2_CHECKFINISHtRACK_Vt
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],5
    MOV ClrSqr,BrownClr

     MOV [XSqr],PowerUpsPlayer2_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckForUp2
    
    ; check if it's the end of the Track
    P2_CHECKFINISHtRACK_Vt:
    MOV AH,0DH
    int 10H
    CMP AL,YellowClr
    JNE p2_finshDown
    MOV [WinnerFlag],2
    MOV GameFinishFlag,1
    RET

    p2_finshDown:
    MOV[flag],0
    RET
ENDP

PROC checkPlayer2Hz
    MOV CX,[NextXPlayer2]
    SUB CX,(carH/2)
    MOV DX,[NextYPlayer2]
    SUB DX,(carW/2)
    MOV col,0
    MOV row,0
    MOV BH,0

    horizontalCheckFor2Hz:
    MOV AH,0DH
    int 10H
    ; CMP AL,GreenClr
    ; JNE p1_CHECKTRACKHZ
    ; MOV [FLAG],0
    ; RET
    p1_CHECKTRACKHZ:
    CMP AL,BlackClr
    JNE p2_checkObstaclesHz
    INC CX
    INC col
    CMP col,(carH)
    JNE horizontalCheckFor2Hz
    MOV CX,[NextXPlayer2]
    SUB CX,(carH/2)
    INC DX
    INC row
    CMP row,(carW)
    MOV col,0
    JNE horizontalCheckFor2Hz
    RET

    ; check if it's an obstacle
    p2_checkObstaclesHz:
    MOV [XSqr],Cx
    MOV [YSqr],Dx
    ; MOV AH,0DH
    ; int 10H
    CMP AL,GreyClr
    JNE p2_checkSpeedUpHz
    CMP [PassFlagPlayer2],1  
    JNE p2_finshDownHz_brk
    CALL eraseSqr
    MOV CX,[XSqr]
    MOV DX,[YSqr]
    MOV [XSqrToBeDrawn],Cx
    MOV [YSqrToBeDrawn],Dx
    MOV [reDrawFlag],1
	MOV [PassFlagPlayer2],0
    JMP horizontalCheckFor2Hz

    ; check if it's a "speed up" power-up
    p2_checkSpeedUpHz:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,RedClr
    JNE p2_checkSlowDownHz
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],1
    MOV ClrSqr,RedClr
    MOV [XSqr],PowerUpsPlayer2_XLoc
    MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor2Hz

    ; check if it's a "slow down" power-up
    p2_checkSlowDownHz:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,BlueClr
    JNE p2_checkFreezeHZ
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],2
    MOV ClrSqr,BlueClr
    MOV [XSqr],PowerUpsPlayer2_XLoc
    MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor2Hz

    JMP p2_finshDownHz_skp
    p2_finshDownHz_brk:
    JMP p2_finshDownHz
    p2_finshDownHz_skp:
    ; check if it's a "pass an obstacle" power-up
    
    p2_checkFreezeHZ:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,NavyClr
    JNE p2_checkPassObstaclesHz
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],3
    MOV ClrSqr,NavyClr
     MOV [XSqr],PowerUpsPlayer2_XLoc
     MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckForUp2

    p2_checkPassObstaclesHz:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,MagnitaClr
    JNE p2_checkGenerateObstaclesHz
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],4
    MOV ClrSqr,MagnitaClr
    MOV [XSqr],PowerUpsPlayer2_XLoc
    MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor2Hz
    
    ; check if it's a "generate an obstacle" power-up
    p2_checkGenerateObstaclesHz:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,BrownClr
    JNE P2_CHECKFINISHtRACK_HZ
    ; MOV [XSqr],Cx
    ; MOV [YSqr],Dx
    CALL eraseSqr
    MOV [PowerUpsPlayer2],5
    MOV ClrSqr,BrownClr
    MOV [XSqr],PowerUpsPlayer2_XLoc
    MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    JMP horizontalCheckFor2Hz
    
    
    ; check if it's the end of the Track
    P2_CHECKFINISHtRACK_HZ:
    ; MOV AH,0DH
    ; int 10H
    CMP AL,YellowClr
    JNE p2_finshDownHz
    MOV [WinnerFlag],2
    MOV [GameFinishFlag],1
    RET

    p2_finshDownHz:
    MOV[flag],0
    RET
ENDP

PROC GenerateObstacle_p1
    ; MOV [flag],1
    ; CALL checkPlayer1
    ; CMP [flag],1
    ; JE SkipGenerate_p1
    MOV [PowerUpsPlayer1],0
    MOV [ClrSqr],GreyClr

    MOV AX,[orientaionP1]
    CMP AX,0
    JNE genDownP1
    MOV AX,[YPlayer1]
    ADD AX,34
    MOV [YSqr],Ax
    MOV AX,[XPlayer1]
    MOV [XSqr],Ax
    JMP generate

    genDownP1:
    MOV AX,[orientaionP1]
    CMP AX,1
    JNE genLeftP1
    MOV AX,[YPlayer1]
    SUB AX,34
    MOV [YSqr],Ax
    MOV AX,[XPlayer1]
    MOV [XSqr],Ax
    JMP generate

    genLeftP1:
    MOV AX,[orientaionP1]
    CMP AX,2
    JNE genRightP1
    MOV AX,[YPlayer1]
    MOV [YSqr],Ax
    MOV AX,[XPlayer1]
    ADD AX,34
    MOV [XSqr],Ax
    JMP generate

    genRightP1:
    MOV AX,[YPlayer1]
    MOV [YSqr],Ax
    MOV AX,[XPlayer1]
    SUB AX,34
    MOV [XSqr],Ax
    JMP generate

    generate:
    CALL drawSqr
    RET
ENDP

PROC GenerateObstacle_p2
    ; MOV [flag],1
    ; CALL checkPlayer1
    ; CMP [flag],1
    ; JE SkipGenerate_p1
    MOV [PowerUpsPlayer2],0
    MOV [ClrSqr],GreyClr

    MOV AX,[orientaionP2]
    CMP AX,0
    JNE genDownP2
    MOV AX,[YPlayer2]
    ADD AX,34
    MOV [YSqr],Ax
    MOV AX,[XPlayer2]
    MOV [XSqr],Ax
    JMP generateP2

    genDownP2:
    MOV AX,[orientaionP2]
    CMP AX,1
    JNE genLeftP2
    MOV AX,[YPlayer2]
    SUB AX,34
    MOV [YSqr],Ax
    MOV AX,[XPlayer2]
    MOV [XSqr],Ax
    JMP generateP2

    genLeftP2:
    MOV AX,[orientaionP2]
    CMP AX,2
    JNE genRightP2
    MOV AX,[YPlayer2]
    MOV [YSqr],Ax
    MOV AX,[XPlayer2]
    ADD AX,34
    MOV [XSqr],Ax
    JMP generateP2

    genRightP2:
    MOV AX,[YPlayer2]
    MOV [YSqr],Ax
    MOV AX,[XPlayer2]
    SUB AX,34
    MOV [XSqr],Ax
    JMP generate

    generateP2:
    CALL drawSqr
    RET
ENDP

PROC if_ArrowUp_isPressed
    CMP [KeyList + UpArrow], 1
    JNE handleUp_end
    CALL cleanPlayer1
    MOV AX,[SpeedPlayer1]
    SUB [NextYPlayer1],AX
    MOV AX,0
    mov [orientaionP1],AX
    CALL checkPlayer1
    CMP [flag],1
    JNE skip_ArrowUp
    MOV AX,0
    mov [PrevOrientaionP1],AX
    MOV AX,[SpeedPlayer1]
    SUB [YPlayer1],AX
    MOV BX,[YPlayer1]
    ; MOV [PrevYPlayer1],BX
    ; ADD [PrevYPlayer1],carH
    MOV [DirectionTOBeDrawn],0
    CALL drawPlayer1
    handleUp_end:
    MOV [flag],1
    RET
    skip_ArrowUp:
    MOV AX,[PrevOrientaionP1]
    MOV [orientaionP1],AX
    MOV AX,[SpeedPlayer1]
    ADD [NextYPlayer1],AX 
    MOV [flag],1
    CALL drawPlayer1
    RET
    ENDP

PROC if_ArrowDown_isPressed
    CMP [  KeyList + DownArrow], 1
    JNE handleDown_end
    CALL cleanPlayer1
    MOV AX,[SpeedPlayer1]
    ADD [NextYPlayer1],AX
    MOV AX,1
    mov [orientaionP1],AX
    CALL checkPlayer1
    CMP [flag],1
    JNE skip_ArrowDown
    MOV AX,1
    MOV [PrevOrientaionP1],AX
    MOV AX,[SpeedPlayer1]
    ADD [YPlayer1],AX
    MOV BX,[YPlayer1]
    ; MOV [PrevYPlayer1],BX
    ; SUB [PrevYPlayer1],carH
    MOV [DirectionTOBeDrawn],1
    CALL drawPlayer1
    handleDown_end:
    MOV [flag],1
    RET
    skip_ArrowDown:
    MOV AX,[PrevOrientaionP1]
    MOV [orientaionP1],AX
    MOV AX,[SpeedPlayer1]
    SUB [NextYPlayer1],AX
    MOV [flag],1
    CALL drawPlayer1
    RET
ENDP

PROC if_ArrowRight_isPressed
    CMP [  KeyList + RightArrow], 1
    JNE handleRight_end
    CALL cleanPlayer1
    MOV AX,[SpeedPlayer1]
    ADD [NextXPlayer1],AX
    MOV AX,3
    mov [orientaionP1],AX
    CALL checkPlayer1Hz
    CMP [flag],1
    JNE skip_ArrowRight
    MOV AX,3
    MOV [PrevOrientaionP1],AX
    MOV AX,[SpeedPlayer1]
    ADD [XPlayer1],AX
    MOV BX,[XPlayer1]
    ; MOV[PrevXPlayer1],BX
    ; SUB [PrevXPlayer1],carW
    MOV [DirectionTOBeDrawn],3
    CALL drawPlayer1
    handleRight_end:
    MOV [flag],1
    RET
    skip_ArrowRight:
    MOV AX,[PrevOrientaionP1]
    mov [orientaionP1],AX
    MOV AX,[SpeedPlayer1]
    SUB[NextXPlayer1],AX
    MOV [flag],1
    CALL drawPlayer1
    RET
ENDP

PROC if_ArrowLeft_isPressed
    CMP [  KeyList + LeftArrow], 1
    JNE handleLeft_end
    CALL cleanPlayer1
    MOV AX,[SpeedPlayer1]
    SUB [NextXPlayer1],AX
    MOV AX,2
    mov [orientaionP1],AX
    CALL checkPlayer1Hz
    CMP [flag],1
    JNE skip_ArrowLeft
    MOV AX,2
    MOV [PrevOrientaionP1],AX
    MOV AX,[SpeedPlayer1]
    SUB [XPlayer1],AX
    MOV BX,[XPlayer1]
    ; MOV[PrevXPlayer1],BX
    ; ADD [PrevXPlayer1],carW+obstacleWidth
    MOV [DirectionTOBeDrawn],2
    CALL drawPlayer1
    handleLeft_end:
    MOV [flag],1
    RET
    skip_ArrowLeft:
    MOV AX,[PrevOrientaionP1]
    mov [orientaionP1],AX
    MOV AX,[SpeedPlayer1]
    ADD[NextXPlayer1],AX
    MOV [flag],1
    CALL drawPlayer1
    RET
ENDP

PROC if_W_isPressed
    CMP [  KeyList + KeyW], 1
    JNE handleW_end
    CALL cleanPlayer2
    MOV AX,[SpeedPlayer2]
    SUB [NextYPlayer2],AX
    MOV AX,0
    MOV [orientaionP2],AX
    CALL checkPlayer2
    CMP [flag],1
    JNE skip_W
    MOV AX,0
    MOV [PrevOrientaionP2],AX
    MOV AX,[SpeedPlayer2]
    SUB [YPlayer2],AX
    MOV BX,[YPlayer2]
    ; MOV[PrevYPlayer2],BX
    ; ADD [PrevYPlayer2],carH+obstacleWidth
    MOV [DirectionTOBeDrawn],0
    CALL drawPlayer2
    handleW_end:
    MOV [flag],1
    RET
    skip_W:
    MOV AX,[PrevOrientaionP2]
    MOV [orientaionP2],AX
    MOV AX,[SpeedPlayer2]
    ADD[NextYPlayer2],AX
    MOV [flag],1
    CALL drawPlayer2
    RET
ENDP

PROC if_S_isPressed
    CMP [  KeyList + KeyS], 1
    JNE handleS_end
    CALL cleanPlayer2
    MOV AX,[SpeedPlayer2]
    ADD [NextYPlayer2],AX
    MOV AX,1
    MOV [orientaionP2],AX
    CALL checkPlayer2
    CMP [flag],1
    JNE skip_S
    MOV AX,1
    MOV [PrevOrientaionP2],AX
    MOV AX,[SpeedPlayer2]
    ADD [YPlayer2],AX
    MOV BX,[YPlayer2]
    ; MOV[PrevYPlayer2],BX
    ; SUB [PrevYPlayer2],obstacleWidth
    MOV [DirectionTOBeDrawn],1
    CALL drawPlayer2
    handleS_end:
    MOV [flag],1
    RET
    skip_S:
    MOV AX,[PrevOrientaionP2]
    MOV [orientaionP2],AX
    MOV AX,[SpeedPlayer2]
    SUB[NextYPlayer2],AX
    MOV [flag],1
    CALL drawPlayer2
    RET
ENDP

PROC if_D_isPressed
    CMP [  KeyList + KeyD], 1
    JNE handleD_end
    CALL cleanPlayer2
    MOV AX,[SpeedPlayer2]
    ADD [NextXPlayer2],AX
    MOV AX,3
    MOV [orientaionP2],AX
    CALL checkPlayer2Hz
    CMP [flag],1
    JNE skip_D
    MOV AX,3
    MOV [PrevOrientaionP2],AX
    MOV AX,[SpeedPlayer2]
    ADD [XPlayer2],AX
    MOV BX,[XPlayer2]
    ; MOV[PrevXPlayer2],BX
    ; ADD [PrevXPlayer2],obstacleWidth
    MOV [DirectionTOBeDrawn],3
    CALL drawPlayer2
    handleD_end:
    MOV [flag],1
    RET
    skip_D:
    MOV AX,[PrevOrientaionP2]
    MOV [orientaionP2],AX
    MOV AX,[SpeedPlayer2]
    SUB[NextXPlayer2],AX
    MOV [flag],1
    CALL drawPlayer2
    RET
ENDP

PROC if_A_isPressed
    CMP [  KeyList + KeyA], 1
    JNE handleA_end
    CALL cleanPlayer2
    MOV AX,[SpeedPlayer2]
    SUB [NextXPlayer2],AX
    MOV AX,2
    MOV [OrientaionP2],AX
    CALL checkPlayer2Hz  
    CMP [flag],1
    JNE skip_A
    MOV AX,2
    MOV [PrevOrientaionP2],AX
    MOV AX,[SpeedPlayer2]
    SUB [XPlayer2],AX
    MOV BX,[XPlayer2]
    ; MOV[PrevXPlayer2],BX
    ; SUB [PrevXPlayer2],carW
    MOV [DirectionTOBeDrawn],2
    CALL drawPlayer2
    handleA_end:
    MOV [flag],1
    RET
    skip_A:
    MOV AX,[PrevOrientaionP2]
    MOV [orientaionP2],AX
    MOV AX,[SpeedPlayer2]
    ADD[NextXPlayer2],AX
    MOV [flag],1
    CALL drawPlayer2
    RET
ENDP

PROC if_player1_fired
CMP [KeyList + KeySpace], 1
    JE Space_pressed
    ret
    Space_pressed:
    CMP [PowerUpsPlayer1],0
    JNE powerUps1
    ret        
    powerUps1:
    CMP [PowerUpsPlayer1],1
    JNE CheckSlow_p1
    MOV [SpeedPlayer1],Fast
    JMP setTimer
    
    CheckSlow_p1:
    CMP [PowerUpsPlayer1],2
    JNE CHECK_FREEZW_P1    
    MOV [SpeedPlayer2],Slow
    JMP setTimer

    CHECK_FREEZW_P1:
    CMP [PowerUpsPlayer1],3
    JNE CheckPassObs_p1    
    MOV [SpeedPlayer2],freeze
    
    setTimer:
    MOV AH,2CH
    INT 21H
    CMP DH,55
    JL lessThan55
    SUB DH,60
    lessThan55:
        CMP [PowerUpsPlayer1],1
        JA setSlowTimer_p2
        MOV [TimerPlayer1],DH
        JMP Activate_Powerup_p1
        setSlowTimer_p2:
        MOV [TimerPlayer2],DH
    JMP Activate_Powerup_p1

    CheckPassObs_p1:
    CMP [PowerUpsPlayer1],4
    JNE CheckGenObs_p1
    MOV [PassFlagPlayer1],1
    JMP Activate_Powerup_p1
    
    CheckGenObs_p1:
    CMP [PowerUpsPlayer1],5
    JNE skip_Space        
    CALL GenerateObstacle_p1
    CMP [flag],0
    JNE     UPDATE_STATUS_P1
    MOV [flag],1
    RET

    Activate_Powerup_p1: 
    MOV [PowerUpsPlayer1],0 
    UPDATE_STATUS_P1:
    MOV ClrSqr,BlackClr
    MOV [XSqr],PowerUpsPlayer1_XLoc
    MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    skip_Space:
    RET
ENDP

PROC if_player2_fired
CMP [KeyList + KeyY], 1
    JE y_pressed
    ret
    y_pressed:
    CMP [PowerUpsPlayer2],0
    JNE powerUps2
    ret        
    powerUps2:
    CMP [PowerUpsPlayer2],1
    JNE CheckSlow_p2
    MOV [SpeedPlayer2],Fast
    JMP setTimer_p2
    
    CheckSlow_p2:
    CMP [PowerUpsPlayer2],2
    JNE CHECK_FREEZW_P2    
    MOV [SpeedPlayer1],Slow
    JMP setTimer_p2
    
    CHECK_FREEZW_P2:
    CMP [PowerUpsPlayer2],3
    JNE CheckPassObs_p2    
    MOV [SpeedPlayer1],freeze
    
    setTimer_p2:
    MOV AH,2CH
    INT 21H
    CMP DH,55
    JL lessThan55_p2
    SUB DH,60
    lessThan55_p2:
        CMP [PowerUpsPlayer2],1
        JA setSlowTimer_p1
        MOV [TimerPlayer2],DH
        JMP Activate_Powerup_p2
        setSlowTimer_p1:
        MOV [TimerPlayer1],DH
    JMP Activate_Powerup_p2

    CheckPassObs_p2:
    CMP [PowerUpsPlayer2],4
    JNE CheckGenObs_p2
    MOV [PassFlagPlayer2],1
    JMP Activate_Powerup_p2
    
    CheckGenObs_p2:
    CMP [PowerUpsPlayer2],5
    JNE skip_y        
    CALL GenerateObstacle_p2
    CMP [flag],0
    JNE     UPDATE_STATUS_P2
    MOV [flag],1
    RET

    Activate_Powerup_p2: 
    MOV [PowerUpsPlayer2],0 
    UPDATE_STATUS_P2:
    MOV ClrSqr,BlackClr
    MOV [XSqr],PowerUpsPlayer2_XLoc
    MOV [YSqr],PowerUps_YLoc
    CALL drawSqr
    skip_y:
    RET
ENDP

PROC drawSqr
    MOV CX,[XSqr]
    SUB CX,(obstacleWidth/2)
    MOV DX,[YSqr]
    SUB DX,(obstacleWidth/2)
    MOV col,0
    MOV row,0

    horizontalDrawSqr:
    MOV AH,0CH
    MOV AL,[ClrSqr]
    int 10h
    INC CX
    INC col
    CMP col,(obstacleWidth)
    JNE horizontalDrawSqr
    MOV CX,[XSqr]
    SUB CX,(obstacleWidth/2)
    INC DX
    INC row
    CMP row,(obstacleWidth)
    MOV col,0
    JNE horizontalDrawSqr
    RET
ENDP

PROC eraseSqr
    MOV CX,[XSqr]
    MOV DX,[YSqr]
    rightAndDown:
    MOV AH,0CH
    MOV AL,BlackClr
    int 10h
    INC CX
    MOV AH,0DH
    int 10H
    CMP AL,BlackClr
    JNE rightAndDown
    SUB CX,obstacleWidth+1
    INC DX
    MOV AH,0DH
    int 10H
    CMP AL,BlackClr
    JE rightAndDown
    MOV CX,[XSqr]
    MOV DX,[YSqr]
    leftAndUp:
    MOV AH,0CH
    MOV AL,BlackClr
    int 10h
    DEC CX
    MOV AH,0DH
    int 10H
    CMP AL,BlackClr
    JNE leftAndUp
    ADD CX,obstacleWidth+1
    DEC DX
    MOV AH,0DH
    int 10H
    CMP AL,BlackClr
    JE leftAndUp
    RET
ENDP

PROC checkSqr
    MOV CX,[XSqrToBeDrawn]
    SUB CX,(obstacleWidth/2)
    MOV DX,[YSqrToBeDrawn]
    SUB DX,(obstacleWidth/2)
    MOV col,0
    MOV row,0
    MOV BH,0

    
    checkSqrL:
    MOV AH,0DH
    int 10H
    CMP AL,BlackClr
    JNE checkObstaclesSQ
    INC CX
    INC col
    CMP col,(obstacleWidth)
    JNE checkSqrL
    MOV CX,[XSqrToBeDrawn]
    SUB CX,(obstacleWidth/2)
    INC DX
    INC row
    CMP row,(obstacleWidth)
    MOV col,0
    JNE checkSqrL
    RET
    checkObstaclesSQ:
    MOV [SqrFlag],0
    RET
ENDP

PROC reDrawObs
    MOV[SqrFlag],1
    CALL checkSqr
    CMP [SqrFlag],1
    JNE fff
    MOV AX,[XSqrToBeDrawn]
    MOV [XSqr],Ax
    MOV AX,[YSqrToBeDrawn]
    MOV [YSqr],Ax
    MOV [ClrSqr],GreyClr
    CALL drawSqr
    MOV [reDrawFlag],0
    fff:
    RET
ENDP


MACRO getString string                 ; get a string from the user, wait for the user to press enter
              lea dx, string
              mov ah, 0Ah
              int 21h
ENDM

MACRO printString string
                push dx 
                lea dx, string
                mov ah,09h
                int 21h
                pop dx
ENDM

MACRO printStringAtLoc string, row, col        ; pass the acctual string i.e. (string +2)
                     push dx
                     PUSH ax
                     PUSH bx
                     mov dh, row       ;Cursor position line
                     mov dl, col       ;Cursor position column
                     mov bh, 0
                     mov ah, 02h       ;Set cursor position function
                     int 10h
    ;printing
                     mov ah,09h
                     lea dx, string
                     add dx,2
                     int 21h
                     pop bx
                     POP ax
                     POP dx
ENDM


PROC exitBtnDraw                                    
    LEA SI, exitbtn + (Icon_Height*Icon_Width)-1 
    MOV CX,Icon_X
    MOV DX,ExitIcon_Y
    MOV BH,0
    MOV AH,0CH
    DRAW_LOOP:
    MOV AL,[SI]
    INT 10H
    DEC SI
    INC CX
    CMP CX,Icon_Width+Icon_X
    JNZ DRAW_LOOP
    MOV CX,Icon_X
    INC DX
    CMP DX,Icon_Height+ExitIcon_Y
    JNZ DRAW_LOOP
RET
ENDP

 PROC strtBtnDraw                                    
    LEA SI, gamebtn + (Icon_Height*Icon_Width)-1 
    MOV CX,Icon_X
    MOV DX,StartIcon_Y
    MOV BH,0
    MOV AH,0CH
    DRAW_LOOP_start:
    MOV AL,[SI]
    INT 10H
    DEC SI
    INC CX
    CMP CX,Icon_Width+Icon_X
    JNZ DRAW_LOOP_start
    MOV CX,Icon_X
    INC DX
    CMP DX,Icon_Height+StartIcon_Y
    JNZ DRAW_LOOP_start
RET
ENDP

PROC chatBtnDraw                                    
    LEA SI, chatbtn + (Icon_Height*Icon_Width)-1 
    MOV CX,Icon_X
    MOV DX,ChatIcon_Y
    MOV BH,0
    MOV AH,0CH
    DRAW_LOOP_chat:
    MOV AL,[SI]
    INT 10H
    DEC SI
    INC CX
    CMP CX,Icon_Width+Icon_X
    JNZ DRAW_LOOP_chat
    MOV CX,Icon_X
    INC DX
    CMP DX,Icon_Height+ChatIcon_Y
    JNZ DRAW_LOOP_chat
RET
ENDP

PROC logoDraw                                
    LEA SI,logo + (logoH*logoW)-1
    MOV CX,LOGO_XLOC
    MOV DX,LOGO_YLOC
    MOV BH,0
    MOV AH,0CH
    DRAW_LOOP_logo:
    MOV AL,[SI]
    INT 10H
    dec SI
    INC CX
    CMP CX,logoW+LOGO_XLOC
    JNZ DRAW_LOOP_logo
    MOV CX,LOGO_XLOC
    INC DX
    CMP DX,logoH+LOGO_YLOC
    JNZ DRAW_LOOP_logo
RET
ENDP

PROC Draw_backGround
    MOV CX,0
    MOV DX,0
    MOV BH,0
    MOV AH,0CH
    CMP backgrndClr,0
    JNE greenBackGrnd
    MOV AL,26d
    JMP DRAW_LOOP_backGrnd
    greenBackGrnd:
    MOV AL,GreenClr
    DRAW_LOOP_backGrnd:
    INT 10H
    INC CX
    CMP CX,641
    JNZ DRAW_LOOP_backGrnd
    MOV CX,0
    INC DX
    CMP backgrndClr,0
    JNE greenBackGrndLooP
    CMP DX,450
    JNZ DRAW_LOOP_backGrnd
    ret
greenBackGrndLooP:    CMP DX,399
    JNZ DRAW_LOOP_backGrnd
    ret
ENDP

PROC DrawmMainPage
        CALL InPort
        CALL EnterGraphicsMode
        MOV backgrndClr,0
        CALL Draw_backGround
        MOV backgrndClr,1
        CALL logoDraw
    
    ;fix the black line bug
        MOV CX,logoW+LOGO_XLOC-1
        MOV DX,LOGO_YLOC
        MOV BH,0
        MOV AH,0CH
        MOV AL,26d
        DRAW_heal_backGrnd:
        INT 10H
        INC DX
        CMP DX,LOGO_YLOC+logoH
        JNZ DRAW_heal_backGrnd

    ;Draw notifications bar
        MOV CX,0
        MOV DX,450
        MOV BH,0
        MOV AH,0CH
        MOV AL,0
        DRAW_natifications_backGrnd:
        INT 10H
        INC CX
        CMP CX,641
        JNZ DRAW_natifications_backGrnd
RET
ENDP

PROC getPlayersName
    CALL InPort

    ;////////////////////////////// get player1 name
    getPlayer1Name:
    CALL DrawmMainPage
    MOV NameValidationFlag,0
    printStringAtLoc Name_p1_label, 13, 28
    ;validate if first char is letter
    CALL getFirstLetter_p1
    CMP[NameValidationFlag],1
    JNE firstNameisLetterp1
    printStringAtLoc invalidStart, 15, 28
    MOV AH,00H
    INT 16H
    JMP getPlayer1Name
    firstNameisLetterp1:
    MOV value,al
    
    CALL getName_p1
    
    
    getPlayer2Name:
    MOV NameValidationFlag,0
    printStringAtLoc Name_p2_label, 15, 28
    ;validate if first char is letter
    CALL getFirstLetter_p2
    CMP[NameValidationFlag],1
    JNE firstNameisLetterp2
    printStringAtLoc invalidStart, 17, 28
    MOV AH,00H
    INT 16H
    JMP getPlayer2Name
firstNameisLetterp2:
    CALL getName_p2
RET
ENDP

PROC getFirstLetter_p1
MOV Bh,0
MOV AH,07H
INT 21h
MOV DL,AL
MOV AH,02H
INT 21h
	               cmp   al, 65                    	; 'A'
	               JB    invalidChar
	; 65 <= char
	               cmp   al, 122                   	; 'z'
	               JA    invalidChar
	; 65 <= char <= 122
	               cmp   al, 90                    	; 'Z'
	               jA    secondCheck
	; 65 <= char <= 90
	               jmp   validChar
	secondCheck:   
	               cmp   al, 97                    	; 'a'
	               jb    invalidChar
JMP validChar
invalidChar:
MOV [NameValidationFlag],1
validChar:
LEA DI,playerName1+2
MOV [DI],AL
RET
ENDP

PROC getFirstLetter_p2
MOV Bh,0
MOV AH,07H
INT 21h
MOV DL,AL
MOV AH,02H
INT 21h
	               cmp   al, 65                    	; 'A'
	               JB    invalidChar2
	; 65 <= char
	               cmp   al, 122                   	; 'z'
	               JA    invalidChar2
	; 65 <= char <= 122
	               cmp   al, 90                    	; 'Z'
	               jA    secondCheck2
	; 65 <= char <= 90
	               jmp   validChar2
	secondCheck2:   
	               cmp   al, 97                    	; 'a'
	               jb    invalidChar2
JMP validChar2
invalidChar2:
MOV [NameValidationFlag],1
validChar2:
LEA DI,playerName2+2
MOV [DI],AL
RET
ENDP

PROC getName_p1
LEA DI,playerName1+3
MOV CX,14
GetNameLoop:
MOV Bh,0
MOV AH,07H
INT 21h
CMP AL,13 ;Enter Key
JE NameIsInserted
MOV DL,AL
MOV AH,02H
INT 21h
MOV [DI],AL
INC DI
DEC CX
JNZ GetNameLoop
NameIsInserted:
RET
ENDP

PROC getName_p2
LEA DI,playerName2+3
MOV CX,14
GetNameLoop2:
MOV Bh,0
MOV AH,07H
INT 21h
CMP AL,13 ;Enter Key
JE NameIsInserted2
MOV DL,AL
MOV AH,02H
INT 21h
MOV [DI],AL
INC DI
DEC CX
JNZ GetNameLoop2
NameIsInserted2:
RET
ENDP

PROC getMode
        CALL DrawmMainPage
        CALL exitBtnDraw
        CALL strtBtnDraw
        CALL chatBtnDraw
        WaitGame:
        mov ah,00
        int 16h
        CMP ah,59 ;f1 --> Enter Game
        JNE no_Game 
        CALL EnterGraphicsMode
        CALL StartGame
        RET
        no_Game:
        CMP ah,60 ;f2 --> Enter Chat
        JNE no_Chat 
        JMP Chat
        no_Chat:
        CMP ah, 61 ;f3 --> Exit Game
        JNE WaitGame
        CALL EnterGraphicsMode
        MOV    AH,4CH
        INT    21H                     ;back to dos
        Chat:
        call drawchatscreen
RET 
ENDP


PROC InPort    
;port initilization
mov dx,3fbh ; Line Control Register
mov al,10000000b ;Set Divisor Latch Access Bit
out dx,al ;Out it
;Set LSB byte of the Baud Rate Divisor Latch register.
mov dx,3f8h
mov al,0ch
out dx,al
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Set MSB byte of the Baud Rate Divisor Latch register.
mov dx,3f9h
mov al,00h
out dx,al
;;;;;;;;;;;;;;;;;;;;;;
;Set port configuration
mov dx,3fbh
mov al,00011011b
out dx,al     
RET
ENDP




proc drawchatscreen
call InPort
;;;;;;;;;;;;;;;;;;;;;
mov ah, 0      ;open text mode
mov al, 3
int 10h
   
;;;;;;;;;;;;;;;;;;clear screen 
mov ax,0600h
mov bh,07
mov cx,0
mov dx,184FH
int 10h
 
;;;;split screen 
mov ah,06h 
mov bh, 0fh 
mov al,0h 
mov ch ,0h ;;upper screen corner (ch = row, cl = col)
mov cl ,0h 
mov dh , divdedx
mov dl , 79 ;; max screen width 
int 10h 

mov ah,06h 
mov al,0h 
mov bh ,0f0h
mov ch ,divdedx +1;;upper screen corner (ch = row, cl = col)
mov cl ,0h 
mov dh , 24 ;; max screen height
mov dl , 79 ;; max screen width 
int 10h 
;;;;;check if a key is pressed 
progloop:
mov ah,1    
int 16h
jz dummy2
jnz send

send:
mov ah, 0h ; clear buffer , ascii of char in al  
int 16h

mov value, al 
cmp al,0dh ; if enter handle newline 
jnz contsend 
jz newline 
dummy2:jmp recieve

newline:
cmp yS, 12 ;reached end of screen 
jz scrolluu 
jnz enterpressr 
scrolluu:
mov ax,060Dh
mov bh,04h
mov ch,0       
mov cl,0       
mov dh,12    
mov dl,79
int 10h 
;;;;;;;;;;
mov xS, 0 
mov yS, 0
setcursorS: 
mov ah,2
mov bh,0
mov dl,xS
mov dh,yS
int 10h
;;;;;;;;;;;;;;;;;;;;;;
jmp printtoscreen
enterpressr:
inc yS 
mov xS, 0 


contsend:
setcursor:
mov ah,2
mov bh,0
mov dl,xS
mov dh,yS
int 10h
;if x goes to the end of screen 
cmp xS, 79
jz checky 
jnz printtoscreen 
 checky: 
 cmp yS,12 
 jnz printtoscreen 
   
mov ax,060Dh
mov bh,04h
mov ch,0       
mov cl,0       
mov dh,12    
mov dl,79
int 10h
mov xS,0 
mov yS,0 
mov ah,2
mov bh,0
mov dl,xS
mov dh,yS
int 10h
printtoscreen:
 mov ah,2 
 mov dl,value 
 int 21h 
 ;;;;;;;;;;;;;;;;;;;
 mov dx, 3fdh 
 trysend: 
 in al,dx 
 and al,00100000b 
 jz recieve
 mov dx,3f8h 
 mov al,value 
 out dx,al 
 cmp al,114d
 savecursorsending:
mov ah,3h
mov bh,0h
int 10h
mov xS,dl
mov yS,dh
 jz dummyy 
dummy3:jmp send
recieve:
mov ah,1            ;check if there is key pressed then go to the sending mode
int 16h
jnz dummy3
mov dx , 3FDH ; Line Status Register

in al , dx
AND al , 1
JZ recieve

;If Ready read the VALUE in Receive data register

mov dx , 03F8H
in al , dx
mov value, al 
jmp skipoall
dummyy: jmp endchat 
skipoall:
cmp al,27  
jz endchat
cmp value, 0dh 
jnz continuerecieve 
jz newlineR 
newlineR:
cmp yR,24
JZ endofrowsR
jnz endofcolR
endofrowsR:
mov ax,060Ch
mov bh,40h
mov ch,13     
mov cl,0        
mov dh,24    
mov dl,79 
int 10h 

mov xR,0
mov yR,0Dh
mov ah,2
mov bh,0
mov dl,xR
mov dh,yR
int 10h
jmp printR

endofcolR:
inc yR
mov xR,0

continuerecieve:
setcursorR:
mov ah,2
mov bh,0
mov dl,xR
mov dh,yR
CMP xR,79
jnz printR
;;;;;;;;;;;;;;;;;;
printR: 
mov ah,2 
mov dl,value
int 21h  
saveCursorRecieving:
mov ah,3h
mov bh,0h
int 10h
mov xR,dl
mov yR,dh
jmp progloop
endchat:
RET 
ENDP

PROC EnterGraphicsMode
    MOV    AX,VIDEO_MODE
    MOV    BX,VIDEO_MODE_BX
    INT    10h                     ; Set video mode
RET
ENDP


PROC StatusBarDraw
    
    MOV CX,0
    MOV DX,downlimit+1
    MOV BH,0
    MOV AH,0CH
    MOV AL,BlackClr
    DRAW_LOOP_status:
    INT 10H
    INC CX
    CMP CX,640
    JNZ DRAW_LOOP_status
    MOV CX,0
    INC DX
    CMP DX,480
    JNZ DRAW_LOOP_status


    MOV CX,0
    MOV DX,downlimit+1
    MOV BH,0
    MOV AH,0CH
    MOV AL,DarkGreyClr
    DRAW_LOOP_statusHZ:
    INT 10H
    INC CX
    CMP CX,640
    JNZ DRAW_LOOP_statusHZ
    CMP [flag],0
    JNE DrawPlayerStatus
    printStringAtLoc GameStartLabel 27 25
    mov ah,00
    int 16H
    RET

    DrawPlayerStatus:
    MOV CX,308
    MOV DX,downlimit+1
    DRAW_LOOP_TimerVT:
    INT 10H
    INC DX
    CMP DX,downlimit+16
    JNE DRAW_LOOP_TimerVT
    MOV CX,338
    MOV DX,downlimit+1
    DRAW_Timer:
    INT 10H
    INC DX
    CMP DX,downlimit+16
    JNE DRAW_Timer

    MOV CX,308
    MOV DX,downlimit+16
    DRAW_TimerHZ:
    INT 10H
    INC CX
    CMP CX,338
    JNZ DRAW_TimerHZ
    
    MOV CX,321
    MOV DX,downlimit+16
    ; MOV BH,0
    ; MOV AH,0CH
    ; MOV AL,DarkGreyClr

    DRAW_LOOP_statusVT:
    INT 10H
    INC DX
    CMP DX,480
    JNZ DRAW_LOOP_statusVT
    
    printStringAtLoc playerName1 29 1
    printStringAtLoc score 29 18
    printStringAtLoc POWERUPS 29 28
    printStringAtLoc playerName2 29 41
    printStringAtLoc score 29 58
    printStringAtLoc POWERUPS 29 68
    RET
ENDP


PROC PrintScores
    CALL EnterGraphicsMode
    printStringAtLoc playerName1 10 34
    printStringAtLoc scoreLabel1 11 34

    printStringAtLoc playerName2 10 50
    printStringAtLoc scoreLabel2 11 50
    MOV startFlag,1
RET
ENDP

PROC PrintWinner
    CALL EnterGraphicsMode
    printStringAtLoc FINISH 10 34
    printStringAtLoc YouWon 12 32
    CMP WinnerFlag,0
    JA check_p1_won
    printStringAtLoc Losers 12 46
    ret
     check_p1_won:
    CMP WinnerFlag,1  
    JA check_p2_won
    printStringAtLoc playerName1 12 46
    MOV XPlayer1,300
    MOV YPlayer1,250
    CALL drawPlayer1Hz
    ret
    check_p2_won:
    CMP WinnerFlag,2  
    printStringAtLoc playerName2 12 46
    MOV XPlayer2,300
    MOV YPlayer2,250
    CALL drawPlayer2Hz
ret
ret
ENDP

PROC InitializeTimer
        
         MOV AH,2CH
         INT 21H
         MOV AL,CL
         CMP AL,58
         JL lessThan58
         SUB AL,60
         lessThan58:
         MOV BL,60D
         MUL BL
         SHR DX,8D ;MAKE DL= DH AND DH =0
         ADD AX,DX
         MOV [TimerGame],AX
RET
ENDP

PROC if_Esc_isPressed
    CMP [KeyList + KeyEsc], 1
    JNE handleESC_end
    mov startFlag,1
    CALL DrawScorePage
    mov [GameFinishFlag],1
    handleESC_end:
        RET
ENDP

PROC if_F4_isPressed

    CMP [KeyList + KeyF4], 1
    JNE handleF4_end

    MOV SpeedPlayer1,freeze
    MOV SpeedPlayer2,freeze

    CMP  [StopGameFlag],1
    JNE setEndFlag2
    MOV WinnerFlag,2
    MOV [GameFinishFlag],1
    setEndFlag2:
    MOV [StopGameFlag],2
    
    handlef4_end:
        RET
ENDP

PROC DrawScorePage
    CALL EnterGraphicsMode
    MOV backgrndClr,0
    CALL Draw_backGround
    ; printStringAtLoc score
RET
ENDP

PROC InitializePlayersPosition

        MOV [PrevYPlayer1],40 
        MOV [YPlayer1],40 
        MOV [NextYPlayer1],40 
        
        
        MOV [PrevYPlayer2],60 
        MOV [YPlayer2],60 
        MOV [NextYPlayer2],60 
        
        CMP START_X_LIMIT,leftlimit
        JNE START_GAME_AT_RIGHT
        MOV [PrevXPlayer1],50
        MOV [XPlayer1],50
        MOV [NextXPlayer1],50

        MOV [PrevXPlayer2],50
        MOV [XPlayer2],50
        MOV [NextXPlayer2],50

        JMP START_DRAWING_PLAYERS        
        
        START_GAME_AT_RIGHT:
        
        MOV [PrevXPlayer1],550
        MOV [XPlayer1],550
        MOV [NextXPlayer1],550


        MOV [PrevXPlayer2],550
        MOV [XPlayer2],550
        MOV [NextXPlayer2],550


        MOV [PrevYPlayer2],60 
        MOV [YPlayer2],60 
        MOV [NextYPlayer2],60 
                
        START_DRAWING_PLAYERS:
        CALL drawPlayer1
        CALL drawPlayer2
RET
ENDP

PROC StartGame
        CALL EnterGraphicsMode
        CALL drawTrack
       CMP recFlag,0
        JE RECIEVE_RANDO
        ;generate in ax if you are the sender
        CALL RandomNum
        CALL send_from_AX
        JMP SKIP_RECIEVE_RANDO
        RECIEVE_RANDO:
        CALL recieve_in_AX
        SKIP_RECIEVE_RANDO:
        ;recieve in ax if you are the reciever
        MOV  rand_POWERUPS_COUNT,ax
     MOV [GameFinishFlag], 0    
        gen_obst:
        CALL generateObstacles
        DEC rand_POWERUPS_COUNT
        CMP rand_POWERUPS_COUNT,0
        JNE gen_obst
        MOV Stopping_Limit,120
        CALL InitializeTimer
        MOV Flag,0
        CALl StatusBarDraw
        MOV Flag,1
        CALl StatusBarDraw
        CALL RandomNum
        MOV  rand_POWERUPS_COUNT,ax
        CALL InitializePlayersPosition
RET
ENDP

PROC main
    mov AX,@data     ;initializing the data segemnt
	mov                  DS,AX
    ;   Set video mode
    CALL EnterGraphicsMode
    CALL getPlayersName
    
    StartAgain:
    CALL getMode
    
    ; ;;; get the Address of the existing int09h handler to modify it and enable multiple movements at the same time
    ; MOV ax, 3509h ; Get Interrupt Vector
    ; int  21h ; -> ES:BX
    ; push es bx
    ; MOV dx, offset onKeyEvent
    ; MOV ax, 2509h
    ; int 21h


 ;;; get the Address of the existing int09h handler to modify it and enable multiple movements at the same time
    MOV ax, 3509h ; Get Interrupt Vector
    int  21h ; -> ES:BX
    push es bx
    MOV dx, offset onKeyEvent
    MOV ax, 2509h
    int 21h
   

     ;     ;get the starting time of the game
    mov startFlag,0
     mainLoop:
    printStringAtLoc TimerGameDisplay 25 39

     CMP [reDrawFlag],1
     JNE skipReDraw
     CALL reDrawObs
     skipReDraw:
         CALL CheckTimer
         CALL sleepSomeTime
        ;;generate a random num in ax if you are the sender
        CMP recFlag,0
        JE RECIEVE_RANDO2

        CALL RandomNum
        CALL send_from_AX
        JMP SKIP_RECIEVE_RANDO2
        RECIEVE_RANDO2:
        CALL recieve_in_AX
        SKIP_RECIEVE_RANDO2:
        ;;recieve in ax if you are the reciever
        CMP AX,40D
        JA SKIP_GenerationObstacles
        gen_obst_atgame:
        CALL generateObstacles
        SKIP_GenerationObstacles:
            MOV [flag],1
            CALL if_ArrowUp_isPressed
            MOV [flag],1
            CALL if_ArrowDown_isPressed
            MOV [flag],1
            CALL if_ArrowRight_isPressed
            MOV [flag],1
            CALL if_ArrowLeft_isPressed
            MOV [flag],1
            JMP mainLoop_skp
            mainLoop_brk:
            JMP mainLoop
            mainLoop_skp:
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
            CALL if_Esc_isPressed
            CALL if_F4_isPressed
    ; if Esc is not pressed, jump back to mainLoop
    CMP [GameFinishFlag], 1
    JNE mainLoop_brk
    
    MOV [GameFinishFlag], 0
    ;Print Winner and return to main screen
    CMP startFlag,1
    JE skipWinner
    CALL PrintWinner
   skipWinner:
    CALL InitializeTimer
    MOV Stopping_Limit,5
    keepScore:
    CALL CheckTimer
    CMP [GameFinishFlag], 1
    JNE keepScore
    ; Return the INT09
    pop dx ds
    mov ax, 2509h
    int 21h
    MOV AX,@data
    MOV DS,AX 
   
    JMP StartAgain
    EndProgram:
    HLT
ENDP 

DATASEG
    recFlag db 1
    value db ?
    x db 0
    y db 0 
    xS db 0 
    yS db 0 
    xR db 0 
    yR db 0Dh
    divdedx equ 12
    VIDEO_MODE      EQU 4F02h                                      ; SVGA MODE
    VIDEO_MODE_BX   EQU 0101h                                      ; SCREEN SIZES
    SCREEN_WIDTH    EQU 640
    SCREEN_HEIGHT   EQU 480
    YouWon          DB '  The Winner is: ', '$'
    FINISH          DB '  GAME ENDED', '$'
    invalidStart    DB '  Start With Letter', '$'
    invalidSize    DB '  Name at most 15 chars', '$'
    NameValidationFlag    DB 0
    tempvarcheck        db  ?
    numobs              dw  0
    topoffsetstart      equ 5
    rightoffsetstart    equ 5
    numrands            db  30
    trackwidth          equ 65
    sectionlength       equ 140d
    upsectionlenght     equ 150d
    lastmove            db  5
    sectionsupcount     db  1
    bordercolor         equ 0ch
    numsectionsmoved    db  0
    ;;;;;;;;;;;;;;;;
    trackcheck          dw  0
    finalflag           db  0
    ;;;;;;;;;;;;;;;;;;;obstacles
    obstacleWidth       equ 10
    loopCounter         dw  0d
    ;;;;;;;;;;Colors;;;;;;;;;
    BlackClr    EQU 00H ;trackClr
    BlueClr     EQU 01H ;SlowDown
    GreenClr    EQU 02H ;Plants
    MagnitaClr    EQU 05H ;Pass Obstacles
    BrownClr    EQU 06H ;generateObstacles
    GreyClr     EQU 08H ;Obstacles
    NavyClr     EQU 09H ;Freeze
    RedClr      EQU 0CH ;SpeedUp
    YellowClr   EQU 0EH ;Final Row
    WhiteClr    EQU 0FH ;Track line
    DarkGreyClr     EQU 18H ;Status Line
    backgrndClr         db 0
    obstacleColor       db  1
    trackcolor          equ BlackClr

    Genarray            db  08h ,08H,08H,08H, 01h, 05h,06h,09H,0CH
    GenarraySize        equ 9
    startFlag           db  0
    rand_POWERUPS_COUNT dw  ?
    ;;;;;;;;;;;;;;;;;;;;;;;;;;
     rightCol dw 0
    ;limits of track  ;;;;;;;;;;;;;;;
    rightlimit          equ 620d
    downlimit           equ 400d
    leftlimit           equ 20d
    uplimit             equ 20d
    START_X_LIMIT       DW ?
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    PowerUps_YLoc EQU 471D
    PowerUpsPlayer1_XLoc EQU 310D
    PowerUpsPlayer2_XLoc EQU 630D
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
track_coords dw 200 dup(?)
    track_coords_index dw 0
    initial_x dw ?
    initial_y dw ?
    score1 dw 0  
    score2 dw 0
    x1 dw ?
    x2 dw ?
    y1 dw ?
    y2 dw ?
col dw 0
row dw 0
XSqr dw 0
YSqr dw 0
ClrSqr DB 0
StopGameFlag db 0
;Location parameters
XPlayer2        dw 50
YPlayer2        dw 40
NextXPlayer2     dw 50
NextYPlayer2     dw 40
PrevXPlayer2     dw 50
PrevYPlayer2     dw 40
XPlayer1        dw 50
YPlayer1        dw 60
NextXPlayer1     dw 50
NextYPlayer1     dw 60
PrevXPlayer1     dw 50
PrevYPlayer1     dw 60
orientaionP1     dw 3           ;0-> up   1->down  2->left   3->right
orientaionP2     dw 3           ;0-> up   1->down  2->left   3->right
PrevOrientaionP1     dw 0       ;0-> up   1->down  2->left   3->right
PrevOrientaionP2     dw 0       ;0-> up   1->down  2->left   3->right
DirectionTOBeDrawn   dw 0       ;0-> up   1->down  2->left   3->right

;Players' Names
Name_p1_label                 DB           "  Player1 Name:",'$'
Name_p2_label                 DB           "  Player2 Name:",'$'
playerName1              DB           17,?,17 dup("$")
playerName2             DB           17,?,17 dup("$")
scoreLabel1       DB "  000","$"
scoreLabel2       DB "  000","$"
Losers                 DB "  NOBODY WON$"
POWERUPS                DB "  Power-Ups:","$"
score                DB "  Score:123","$"


WinnerFlag DB ?
GameStartLabel DB "  Press Any Key To Start The Game",'$' 
;;;;;;chatting 
    MESG DB 20 dup(' '),'$'
    buffer db 20 dup(' '),'$'
    displayx db 5d
    displayy db 5d
;Images Parameter
LOGO_XLOC EQU 176 ; TO CENTER THE LOGO 
LOGO_YLOC EQU 70 ; TO CENTER THE LOGO
logoH   EQU 108
logoW   EQU 271


Icon_Width  EQU 188 
Icon_Height  EQU 56 
Icon_X  EQU 220 
StartIcon_Y EQU 200
ChatIcon_Y EQU 280
ExitIcon_Y EQU 360 


carW EQU 15
carH EQU 37

XSqrToBeDrawn DW 0
YSqrToBeDrawn DW 0
SqrFlag  DB 0
reDrawFlag DB 0

;Players' Flags
flag            DB 1
PowerUpsPlayer1 DB 0 ; idicates which power ups the player1 has
PowerUpsPlayer2 DB 0 ; idicates which power ups the player2 has
PassFlagPlayer1 DB 0 ; for "pass an obstacle" powerUp player1 
PassFlagPlayer2 DB 0 ; for "pass an obstacle" powerUp player2 


;Time parameters
TimerGameDisplay       DB "  120","$"
TimerGame       DW 0
TimerPlayer1    DB 0 ; holds the time when the slow-down/speed-up is activated to compare with for player1
TimerPlayer2    DB 0 ; holds the time when the slow-down/speed-up is activated to compare with for player2
GameFinishFlag  DB 0 ;If It's 1 then the game timer has finished
StopTimer       DB 0
Stopping_Limit DB 120

;Speed parameters
freeze          EQU 0 ; when the "freeze" power up is activated
Slow            EQU 1 ; when the "slow-down" power up is activated
Normal          EQU 2 ; when no power ups are activated
Fast            EQU 4 ; when the "slow-down" power up is activated
SpeedPlayer1    DW  2 ; idicates the number of pixels the player1 can MOVe at single loop
SpeedPlayer2    DW  2 ; idicates the number of pixels the player2 can MOVe at single loop

; Keyboard scan codes we'll need
KeyEsc      EQU 01h
KeyW        EQU 11h
KeyS        EQU 1Fh
KeyD        EQU 20h
KeyA        EQU 1Eh
KeyY        EQU 15h ;pressed to activate the current power up of player2
UpArrow     EQU 48h
DownArrow   EQU 50h
RightArrow  EQU 4Dh
LeftArrow   EQU 4Bh
KeySpace    EQU 39h ;pressed to activate the current power up of player1
KeyF1       EQU 3BH
KeyF2       EQU 3CH
KeyF3       EQU 3DH
KeyF4       EQU 3EH

KeyList DB 128 dup (0)

;Image Offsets
car1 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16      
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 187, 187, 187, 17, 16, 16, 16, 16, 16, 16, 16, 16, 187, 6, 6, 43, 43, 43, 6, 6, 187, 16, 16, 16, 16, 16, 188, 42, 43       
 DB 42, 42, 6, 42, 42, 43, 42, 188, 16, 16, 16, 187, 6, 42, 42, 42, 42, 43, 42, 42, 42, 42, 6, 187, 16, 17, 6, 43, 43, 43, 43, 140, 24, 140, 43, 43, 43, 43, 6, 17
 DB 17, 42, 43, 6, 43, 42, 164, 21, 164, 42, 43, 6, 43, 42, 17, 18, 43, 6, 116, 43, 140, 21, 222, 21, 140, 43, 116, 6, 43, 18, 17, 42, 42, 43, 43, 140, 223, 244, 223, 140 
 DB 43, 43, 42, 42, 17, 17, 6, 43, 43, 43, 212, 198, 223, 198, 212, 43, 43, 43, 6, 17, 16, 6, 43, 43, 43, 215, 17, 198, 17, 215, 43, 43, 43, 6, 16, 16, 6, 43, 42, 6       
 DB 18, 17, 18, 17, 18, 6, 42, 43, 6, 16, 16, 6, 43, 116, 116, 17, 17, 18, 17, 17, 116, 116, 43, 6, 16, 16, 6, 6, 188, 116, 17, 18, 201, 18, 17, 116, 188, 6, 6, 16
 DB 17, 116, 6, 187, 212, 17, 18, 201, 18, 17, 212, 187, 6, 116, 17, 17, 115, 187, 188, 187, 16, 17, 201, 17, 16, 187, 188, 187, 115, 17, 17, 115, 187, 188, 18, 16, 17, 18, 17, 16        
 DB 18, 188, 187, 115, 17, 17, 115, 186, 115, 17, 16, 17, 19, 17, 16, 17, 115, 186, 115, 17, 17, 116, 188, 212, 17, 16, 17, 201, 17, 16, 17, 212, 188, 116, 17, 16, 6, 139, 212, 17        
 DB 17, 17, 17, 17, 17, 17, 212, 139, 6, 16, 116, 6, 116, 212, 198, 198, 198, 17, 223, 222, 198, 212, 116, 6, 116, 188, 6, 6, 19, 222, 221, 244, 244, 244, 20, 221, 240, 6, 6, 188
 DB 16, 6, 6, 221, 244, 21, 21, 174, 174, 21, 244, 18, 6, 6, 16, 16, 116, 6, 240, 21, 24, 24, 23, 174, 21, 222, 215, 6, 116, 16, 17, 6, 43, 115, 18, 24, 26, 22, 21, 221
 DB 18, 115, 43, 6, 17, 17, 6, 43, 6, 115, 20, 22, 21, 243, 240, 115, 6, 43, 6, 17, 17, 6, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 6, 17, 16, 115, 43, 43, 43
 DB 43, 43, 43, 43, 43, 43, 43, 43, 115, 16, 16, 17, 140, 14, 43, 43, 43, 43, 43, 43, 43, 14, 140, 17, 16, 16, 16, 17, 140, 43, 6, 115, 66, 115, 6, 43, 140, 17, 16, 16
 DB 16, 16, 16, 17, 116, 6, 6, 66, 6, 6, 116, 17, 16, 16, 16, 16, 16, 16, 16, 16, 18, 188, 212, 212, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16

car2  DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 18, 21, 21, 21, 18
 DB 17, 16, 16, 16, 16, 16, 16, 18, 21, 22, 22, 24, 25, 24, 22, 22, 21, 18, 16, 16, 16, 16, 21, 24, 24, 24, 24, 25, 24, 24, 24, 24, 21, 16, 16, 16, 18, 23, 24, 23
 DB 23, 24, 24, 24, 23, 23, 24, 23, 18, 16, 16, 19, 23, 22, 23, 23, 24, 24, 24, 23, 23, 22, 23, 19, 16, 16, 22, 23, 22, 22, 22, 22, 23, 22, 22, 22, 22, 23, 22, 16
 DB 16, 23, 24, 23, 21, 21, 22, 24, 22, 21, 21, 23, 24, 23, 16, 16, 24, 24, 24, 22, 22, 23, 24, 23, 22, 22, 24, 24, 24, 16, 16, 23, 22, 23, 22, 22, 23, 24, 23, 22
 DB 22, 23, 22, 23, 16, 16, 22, 23, 232, 207, 208, 232, 23, 232, 208, 207, 232, 23, 22, 16, 16, 24, 25, 232, 135, 135, 230, 21, 230, 135, 135, 232, 24, 24, 16, 16, 24, 24, 232, 229       
 DB 229, 230, 20, 230, 229, 229, 232, 24, 24, 16, 16, 24, 24, 208, 207, 232, 207, 22, 232, 232, 207, 208, 24, 24, 16, 16, 24, 24, 208, 229, 229, 232, 24, 230, 229, 229, 208, 24, 24, 16   
 DB 16, 24, 24, 18, 18, 18, 232, 24, 229, 20, 20, 18, 24, 24, 16, 16, 23, 25, 18, 17, 17, 19, 22, 21, 19, 19, 18, 24, 23, 16, 21, 23, 23, 21, 20, 20, 22, 24, 27, 25
 DB 24, 24, 23, 23, 21, 18, 22, 23, 24, 23, 23, 26, 27, 27, 27, 27, 25, 23, 22, 18, 16, 22, 26, 24, 24, 25, 25, 26, 26, 26, 24, 24, 26, 22, 16, 16, 23, 26, 25, 25
 DB 24, 22, 22, 22, 24, 25, 25, 26, 23, 16, 16, 23, 24, 21, 25, 26, 26, 27, 26, 26, 25, 21, 24, 23, 16, 16, 23, 24, 19, 20, 25, 26, 27, 26, 25, 20, 19, 24, 23, 16
 DB 16, 22, 25, 23, 18, 22, 26, 27, 26, 22, 18, 23, 25, 22, 16, 16, 22, 24, 25, 23, 22, 26, 27, 26, 22, 23, 25, 24, 22, 16, 16, 23, 24, 25, 25, 25, 26, 26, 26, 25
 DB 25, 25, 24, 23, 16, 16, 24, 23, 24, 25, 25, 25, 26, 25, 25, 25, 24, 23, 24, 16, 16, 23, 23, 24, 24, 25, 25, 26, 25, 25, 24, 24, 23, 23, 16, 16, 22, 22, 24, 23
 DB 25, 25, 26, 25, 25, 23, 24, 22, 22, 16, 16, 18, 22, 22, 21, 24, 24, 25, 24, 24, 23, 23, 22, 18, 16, 16, 16, 20, 22, 21, 24, 23, 23, 23, 24, 24, 24, 20, 16, 16
 DB 16, 16, 16, 20, 23, 25, 24, 22, 24, 25, 23, 20, 17, 16, 16, 16, 16, 16, 16, 17, 20, 22, 24, 22, 20, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 19, 17, 16
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16

;logo
logo DB 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 22, 22, 22, 22, 22 
 DB 22, 22, 22, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 23, 22, 22, 22, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 16, 16, 16, 16, 16, 16, 16, 22, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 20, 18, 16, 16, 16, 16, 16, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 16, 199, 199, 199, 199, 17, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 24, 19, 16, 16, 16, 16, 16, 184, 112, 184, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 21, 16, 16, 16, 184, 4, 40, 40, 40, 40 
 DB 112, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16 
 DB 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 16, 184, 40, 40, 40, 40, 40, 40, 40, 112, 16, 20, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 16, 4, 40, 40, 40, 40, 40, 40, 40, 40, 112, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 22, 16, 16, 4, 40, 40, 40, 40, 40, 40, 40, 40, 40, 112, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 16, 16, 16, 16, 16, 16, 16, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 17, 20, 16, 16, 16, 16, 16, 16, 127, 127, 127, 127, 199, 16, 16, 16, 16, 16, 16, 16, 16, 24, 22, 20, 224, 18, 17, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 19, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 17, 16, 112, 40, 40, 40, 40, 40, 40 
 DB 4, 112, 184, 112, 184, 16, 16, 16, 24, 26, 26, 26, 26, 23, 19, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 24, 22, 20, 224, 18, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 18, 19, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 20, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 17, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 16, 40, 40, 40, 40, 40, 40, 184, 16, 16, 16, 16, 16, 16, 16, 16, 24 
 DB 26, 26, 24, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 24, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 55, 55, 55, 1 
 DB 199, 127, 55, 55, 55, 55, 55, 55, 1, 199, 127, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 55, 55, 55, 55 
 DB 55, 55, 55, 55, 55, 55, 55, 17, 16, 16, 199, 127, 127, 1, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 1, 127, 17, 16, 16, 22 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 4, 40, 40, 40, 40, 40, 4, 40, 40, 40, 40, 40, 40, 40, 16, 16, 24, 26, 24, 16, 16, 16, 112, 4, 40, 40 
 DB 40, 40, 40, 40, 40, 40, 40, 16, 16, 16, 16, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 16, 16, 16 
 DB 184, 112, 4, 4, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 4, 4, 16, 16, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55 
 DB 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 199, 127 
 DB 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 127, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 22, 16, 184, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 16, 16, 24, 24, 16, 16, 112, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 16, 16 
 DB 16, 16, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 184, 112, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40 
 DB 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 112, 16, 16, 23, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55 
 DB 55, 55, 55, 55, 55, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55 
 DB 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 127, 16, 17, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 18, 16, 4, 40, 40, 40, 40 
 DB 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 16, 16, 24, 17, 16, 112, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 16, 16, 16, 16, 40, 40, 40, 40, 40, 40, 40 
 DB 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40 
 DB 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 112, 16, 17, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 17, 16, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55 
 DB 16, 17, 20, 16, 127, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55 
 DB 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 199, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 25, 16, 16, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40 
 DB 40, 16, 16, 20, 16, 16, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 16, 16, 16, 16, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40 
 DB 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40 
 DB 40, 40, 184, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55 
 DB 55, 127, 1, 55, 55, 55, 55, 55, 55, 55, 127, 127, 55, 55, 55, 55, 55, 55, 55, 127, 127, 127, 127, 127, 127, 127, 1, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55 
 DB 127, 127, 127, 127, 127, 127, 127, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 127, 55, 55, 55, 55, 55, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 55, 55 
 DB 55, 55, 55, 1, 16, 16, 25, 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 40, 40, 40, 40, 4, 4, 4, 40, 40, 40, 40, 16, 16, 16, 16, 4, 40, 40, 40 
 DB 40, 40, 4, 4, 40, 40, 40, 40, 4, 112, 112, 16, 16, 16, 16, 40, 40, 40, 40, 4, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 4, 40, 40, 40 
 DB 40, 40, 40, 40, 40, 40, 4, 4, 4, 40, 40, 40, 40, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 4, 40, 40, 40, 40, 40, 4, 16, 16, 25, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 16, 127, 55, 55, 55, 55, 55 
 DB 55, 16, 16, 199, 55, 55, 55, 55, 55, 55, 17, 16, 16, 16, 16, 16, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 16, 16, 16, 16, 16, 199, 55, 55 
 DB 55, 55, 55, 55, 55, 127, 16, 16, 16, 127, 55, 55, 55, 55, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 55, 55, 55, 55, 55, 199, 16, 23, 26, 26 
 DB 26, 26, 26, 26, 26, 20, 16, 112, 40, 40, 40, 40, 40, 4, 184, 16, 16, 16, 112, 40, 40, 40, 40, 16, 16, 16, 16, 40, 40, 40, 40, 40, 16, 16, 16, 40, 40, 40, 40, 112 
 DB 16, 16, 16, 16, 16, 16, 40, 40, 40, 40, 112, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 184, 40, 40, 40, 40, 40, 40, 40, 112, 17, 16, 16, 4 
 DB 40, 40, 40, 40, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 40, 40, 40, 40, 40, 184, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 16, 16, 1, 55, 55, 55, 55, 55, 16, 16, 16, 127, 55, 55, 55, 55 
 DB 55, 17, 16, 20, 20, 20, 18, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 16, 20, 20, 19, 16, 199, 55, 55, 55, 55, 55, 1, 16, 16, 16, 16, 16 
 DB 127, 55, 55, 55, 55, 16, 16, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 18, 16, 199, 55, 55, 55, 55, 127, 16, 19, 26, 26, 26, 26, 26, 26, 26, 19, 16, 4, 40 
 DB 40, 40, 40, 4, 16, 16, 16, 16, 16, 112, 40, 40, 40, 40, 16, 16, 16, 112, 40, 40, 40, 40, 112, 16, 16, 16, 40, 40, 40, 40, 112, 16, 224, 20, 20, 16, 16, 40, 40, 40 
 DB 40, 112, 16, 224, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 19, 16, 184, 40, 40, 40, 40, 40, 4, 16, 16, 16, 16, 16, 4, 40, 40, 40, 40, 16, 16, 20, 20, 20 
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 19, 16, 184, 40, 40, 40, 40, 4, 16, 19, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 16, 16, 127, 55, 55, 55, 55, 55, 16, 16, 16, 16, 55, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127 
 DB 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 55, 17, 16, 18, 23, 19, 16, 127, 55, 55, 55, 55, 16, 16, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 17, 16, 55, 55, 55, 55, 55, 16, 17, 26, 26, 26, 26, 26, 26, 26, 18, 16, 4, 40, 40, 40, 40, 16, 16, 20, 25, 20, 16 
 DB 112, 40, 40, 40, 40, 16, 16, 16, 4, 40, 40, 40, 40, 16, 16, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 40, 16, 16, 18, 23, 19, 16, 4, 40, 40, 40, 40, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 25, 17, 16, 4, 40, 40, 40, 40, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16 
 DB 55, 55, 55, 55, 127, 16, 17, 16, 17, 55, 55, 55, 55, 55, 16, 17, 17, 16, 1, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127 
 DB 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 127, 16, 19, 26, 26, 19, 16, 127, 55, 55, 55, 55, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 19, 16, 127, 55, 55, 55, 55, 16, 16, 25, 26, 26, 26, 26, 26, 26, 17, 16, 40, 40, 40, 40, 4, 16, 18, 26, 26, 20, 16, 112, 40, 40, 40, 40, 16, 16, 16, 40 
 DB 40, 40, 40, 4, 16, 18, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16 
 DB 184, 40, 40, 40, 40, 4, 16, 18, 26, 26, 19, 16, 4, 40, 40, 40, 40, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 4, 40, 40, 40, 40, 16 
 DB 16, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 17, 16 
 DB 55, 55, 55, 55, 55, 16, 17, 19, 16, 127, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23 
 DB 16, 199, 55, 55, 55, 55, 199, 16, 22, 26, 26, 19, 16, 127, 55, 55, 55, 55, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 22, 16, 199, 55, 55, 55, 55 
 DB 17, 16, 24, 26, 26, 26, 26, 26, 26, 16, 16, 40, 40, 40, 40, 112, 16, 20, 26, 26, 20, 16, 112, 40, 40, 40, 40, 16, 16, 16, 40, 40, 40, 40, 112, 16, 20, 16, 16, 40 
 DB 40, 40, 40, 112, 16, 22, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 112, 16, 21, 26 
 DB 26, 19, 16, 4, 40, 40, 40, 40, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 22, 16, 112, 40, 40, 40, 40, 184, 16, 24, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 17, 16, 1, 55, 55, 55, 55, 16, 17, 20, 16 
 DB 127, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 199, 16, 23 
 DB 26, 26, 19, 16, 127, 55, 55, 55, 55, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16, 199, 55, 55, 55, 55, 199, 16, 22, 26, 26, 26, 26, 26, 25 
 DB 16, 16, 40, 40, 40, 40, 112, 16, 21, 26, 26, 20, 16, 112, 40, 40, 40, 40, 16, 16, 184, 40, 40, 40, 40, 184, 16, 21, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 24, 16 
 DB 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 184, 16, 23, 26, 26, 19, 16, 4, 40, 40, 40, 40, 16 
 DB 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 184, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 18, 16, 1, 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26 
 DB 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 199, 16, 23, 26, 26, 19, 16, 127, 55, 55, 55, 55 
 DB 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22 
 DB 26, 26, 20, 16, 112, 40, 40, 40, 40, 16, 16, 184, 40, 40, 40, 40, 184, 16, 22, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 184, 16, 23, 26, 26, 19, 16, 4, 40, 40, 40, 40, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 19, 16, 1, 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16 
 DB 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 199, 16, 23, 26, 26, 18, 16, 1, 55, 55, 55, 55, 16, 17, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 20, 16, 112, 40, 40, 40, 40 
 DB 16, 16, 184, 40, 40, 40, 40, 184, 16, 22, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 23, 16, 184, 40, 40, 40, 40, 184, 16, 23, 26, 26, 19, 16, 4, 40, 40, 40, 40, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 16, 40 
 DB 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127 
 DB 16, 19, 19, 16, 127, 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16 
 DB 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 199, 16, 23, 26, 26, 17, 16, 1, 55, 55, 55, 1, 16, 18, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17 
 DB 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 18, 16, 4, 40, 40, 40, 40, 16, 16, 184, 40, 40, 40, 40, 16, 16 
 DB 23, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 20, 24, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40 
 DB 184, 16, 23, 26, 26, 17, 16, 4, 40, 40, 40, 4, 16, 18, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 19, 16, 127, 55, 55, 55, 55 
 DB 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55 
 DB 55, 199, 16, 23, 26, 20, 16, 17, 55, 55, 55, 55, 127, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26 
 DB 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 25, 20, 16, 16, 40, 40, 40, 40, 4, 16, 16, 184, 40, 40, 40, 40, 16, 16, 23, 16, 16, 40, 40, 40, 40, 112, 16 
 DB 22, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 22, 16, 16, 19, 24, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 184, 16, 23, 26, 21, 16, 16, 40, 40 
 DB 40, 40, 4, 16, 19, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 19, 16, 127, 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55 
 DB 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 199, 16, 224, 18, 16, 16, 127, 55 
 DB 55, 55, 55, 199, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40 
 DB 40, 112, 16, 17, 16, 16, 16, 4, 40, 40, 40, 40, 112, 16, 16, 184, 40, 40, 40, 40, 16, 16, 23, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 24, 16, 16, 40, 40, 40, 40 
 DB 112, 16, 17, 22, 23, 22, 20, 16, 16, 16, 16, 16, 20, 24, 26, 23, 16, 184, 40, 40, 40, 40, 184, 16, 224, 18, 16, 16, 4, 40, 40, 40, 40, 184, 16, 22, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 19, 16, 127, 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55 
 DB 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 199, 16, 16, 16, 16, 127, 55, 55, 55, 55, 55, 16, 16, 24, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 112, 16, 16, 16, 184, 4, 40, 40 
 DB 40, 40, 40, 16, 16, 16, 184, 40, 40, 40, 40, 16, 16, 23, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 17, 16, 40, 40, 40, 40, 40, 184, 16, 16, 16, 16, 16, 16, 112 
 DB 40, 112, 16, 16, 17, 20, 22, 16, 184, 40, 40, 40, 40, 184, 16, 16, 16, 16, 4, 40, 40, 40, 40, 40, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55 
 DB 55, 55, 55, 127, 16, 19, 19, 16, 127, 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55 
 DB 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 127, 199, 127, 1, 55, 55, 55, 55, 55, 55, 199, 16, 19, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 4, 112, 4, 40, 40, 40, 40, 40, 40, 40, 112, 16, 16, 16, 184, 40, 40 
 DB 40, 40, 16, 16, 23, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 18, 16, 112, 40, 40, 40, 40, 40, 4, 184, 184, 112, 4, 40, 40, 40, 40, 40, 184, 16, 16, 18, 16, 184 
 DB 40, 40, 40, 40, 112, 184, 112, 4, 40, 40, 40, 40, 40, 40, 112, 16, 18, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 40, 40, 40, 40, 112, 16 
 DB 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 19, 16, 127 
 DB 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16 
 DB 199, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 1, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127 
 DB 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 4, 16, 16, 22, 16, 184, 40, 40, 40, 40, 16, 16, 23, 16, 16, 40, 40 
 DB 40, 40, 112, 16, 22, 26, 26, 23, 16, 16, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 4, 16, 17, 22, 16, 184, 40, 40, 40, 40, 40, 40, 40, 40, 40 
 DB 40, 40, 40, 40, 4, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 19, 16, 127, 55, 55, 55, 55, 16, 17, 22, 16, 199 
 DB 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 55, 55, 55, 55 
 DB 55, 55, 55, 55, 1, 16, 16, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16 
 DB 16, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 4, 16, 16, 20, 23, 16, 184, 40, 40, 40, 40, 16, 16, 23, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 18 
 DB 16, 184, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 16, 16, 20, 23, 16, 184, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 4, 16, 16, 20, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 19, 16, 127, 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26, 26 
 DB 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 127, 16, 16, 20, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 40, 40, 40, 40 
 DB 40, 40, 4, 184, 16, 16, 20, 26, 23, 16, 184, 40, 40, 40, 40, 16, 16, 23, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 24, 17, 16, 16, 40, 40, 40, 40, 40, 40 
 DB 40, 40, 40, 40, 40, 4, 16, 16, 17, 26, 23, 16, 184, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 112, 16, 16, 19, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 17, 16, 55, 55, 55, 55, 127, 16, 19, 19, 16, 127, 55, 55, 55, 55, 16, 17, 22, 16, 199, 55, 55, 55, 55, 17, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17 
 DB 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 23, 16, 199, 55, 55, 55, 55, 55, 55, 55, 55, 127, 199, 16, 16, 16, 16, 18, 19, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 24, 16, 17, 55, 55, 55, 55, 127, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 40, 40, 40, 40, 40, 40, 40, 4, 112, 16, 16, 16, 16, 22, 26, 26, 23 
 DB 16, 184, 40, 40, 40, 40, 16, 16, 23, 16, 16, 40, 40, 40, 40, 112, 16, 22, 26, 26, 26, 26, 24, 17, 16, 16, 112, 4, 40, 40, 40, 40, 40, 40, 4, 184, 16, 16, 18, 24 
 DB 26, 23, 16, 184, 40, 40, 40, 40, 40, 40, 40, 40, 4, 112, 16, 16, 16, 16, 18, 18, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 40, 40 
 DB 40, 40, 112, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 199, 199, 199, 199, 17, 16 
 DB 19, 19, 16, 199, 199, 199, 199, 199, 16, 17, 22, 16, 17, 199, 199, 199, 199, 16, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 17, 199, 199, 199, 199, 16, 17 
 DB 26, 26, 23, 16, 16, 199, 199, 199, 199, 199, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 16, 199 
 DB 199, 199, 199, 16, 16, 22, 26, 26, 26, 26, 26, 24, 16, 16, 184, 184, 184, 184, 16, 16, 16, 16, 16, 16, 16, 20, 25, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 16, 16, 23 
 DB 16, 16, 184, 184, 184, 184, 16, 16, 22, 26, 26, 26, 26, 26, 24, 19, 16, 16, 16, 16, 184, 184, 184, 16, 16, 16, 16, 16, 21, 26, 26, 26, 23, 16, 16, 184, 184, 184, 184, 184 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 184, 184, 184, 184, 16, 16, 22, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 16, 16, 16, 16, 16, 16, 19, 19, 16, 16, 16, 16, 16, 16, 16 
 DB 17, 22, 16, 16, 16, 16, 16, 16, 16, 16, 24, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 20, 16, 16, 16, 16, 16, 16, 16, 17, 26, 26, 23, 16, 16, 16, 16, 16, 16 
 DB 127, 1, 1, 1, 127, 127, 1, 1, 1, 1, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 16, 16, 16, 16, 16, 16, 16, 16, 22, 26, 26, 26 
 DB 26, 26, 24, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 20, 23, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 16, 16, 23, 16, 16, 16, 16, 16, 16, 16, 16, 22 
 DB 26, 26, 26, 26, 26, 26, 26, 24, 19, 17, 16, 16, 16, 16, 16, 17, 19, 22, 26, 26, 26, 26, 26, 23, 16, 16, 16, 16, 16, 16, 4, 4, 4, 4, 4, 112, 4, 4, 4, 4 
 DB 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 16, 16, 16, 16, 16, 16, 16, 16, 22, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 23, 23, 23, 23, 23, 23, 23, 24, 24, 23, 23, 23, 23, 23, 23, 23, 24, 24, 23, 23, 23, 23, 23, 23, 23 
 DB 23, 26, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 24, 23, 23, 23, 23, 23, 23, 23, 24, 26, 26, 25, 23, 23, 23, 23, 17, 16, 55, 55, 55, 55, 127, 127, 55, 55, 55 
 DB 55, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 23, 23, 23, 23, 23, 23, 23, 23, 25, 26, 26, 26, 26, 26, 25, 23, 23, 23, 23, 23, 23 
 DB 24, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 16, 16, 24, 23, 23, 23, 23, 23, 23, 23, 23, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 25, 23, 23, 24, 25, 26, 26, 26, 26, 26, 26, 26, 26, 25, 23, 23, 23, 23, 18, 16, 4, 40, 40, 40, 4, 112, 40, 40, 40, 40, 16, 16, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 23, 23, 23, 23, 23, 23, 23, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 127, 55, 55 
 DB 55, 55, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 127, 55, 55, 55, 55, 16, 17, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 18, 16, 4, 40, 40, 40, 4, 112, 40, 40, 40, 40, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 55, 55, 55, 55, 127, 127, 55, 55, 55, 55, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40 
 DB 40, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 18, 16, 4, 40, 40, 40, 4, 112, 40, 40, 40, 40, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 17, 16, 55, 55, 55, 55, 127, 127, 55, 55, 55, 55, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 16, 16, 24, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 18, 16, 4, 40, 40, 40, 4, 112 
 DB 40, 40, 40, 40, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 127, 55, 55, 55, 55, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16, 184, 40, 40, 40, 40, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20 
 DB 16, 17, 199, 199, 199, 199, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 23, 16, 16, 112, 112, 112, 112, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 16, 16, 16, 16, 16, 16, 17, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 24, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25 
 DB 24, 23, 22, 21, 21, 21, 20, 20, 20, 20, 20, 20, 20, 227, 19, 19, 19, 19, 19, 19, 224, 18, 17, 17, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18 
 DB 18, 18, 18, 18, 224, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19 
 DB 227, 227, 227, 227, 227, 227, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 227, 227, 227, 227, 227, 19, 19, 19, 19, 19, 19, 19, 18, 18, 18, 18, 18, 18, 18, 18, 19, 19 
 DB 19, 19, 19, 19, 19, 19, 224, 224, 18, 18, 18, 18, 18, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 18, 18, 18, 18, 19, 19, 20, 20, 21, 21, 21, 22, 22, 23 
 DB 23, 23, 24, 24, 25, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 23, 21, 20, 19, 224, 18, 18, 18, 18 
 DB 18, 18, 18, 18, 18, 18, 18, 18, 17, 17, 17, 17, 17, 18, 18, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 18, 17, 17, 17, 17, 17, 17, 17, 17 
 DB 17, 17, 18, 18, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18 
 DB 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 17, 17, 17, 17, 17 
 DB 17, 17, 18, 18, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 18, 18, 18, 18, 18, 18, 18, 18, 224, 19, 19, 20, 20, 20, 21, 21, 22, 23, 23, 24, 25, 25, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 24, 21, 19, 18, 18, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17 
 DB 17, 17, 17, 17, 18, 16, 16, 16, 17, 19, 19, 224, 224, 224, 19, 224, 19, 19, 224, 17, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17 
 DB 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17 
 DB 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 16, 16, 16, 17, 19, 240 
 DB 19, 19, 19, 232, 232, 19, 224, 224, 16, 16, 16, 16, 18, 17, 17, 17, 17, 18, 18, 18, 18, 19, 19, 20, 20, 21, 22, 23, 23, 24, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 24, 21, 20, 19, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 16, 16, 17, 18 
 DB 211, 211, 240, 232, 232, 19, 211, 211, 210, 210, 17, 17, 16, 16, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18 
 DB 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18 
 DB 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 16, 17, 17, 208, 211, 211, 211, 211, 210, 232, 211, 211, 211, 211, 17 
 DB 17, 16, 16, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 224, 19, 20, 21, 21, 23, 24, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 25, 20, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 17, 224, 138, 42, 6, 209, 19, 19, 210, 42, 42, 42 
 DB 42, 210, 217, 17, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 224, 18, 17, 17, 17, 17, 17, 17, 17 
 DB 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 224, 18, 17 
 DB 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 18, 209, 138, 42, 42, 42, 6, 209, 235, 42, 42, 42, 42, 210, 215, 17, 16, 17, 17, 17, 17, 17, 17 
 DB 17, 17, 18, 17, 18, 18, 19, 19, 20, 21, 22, 24, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 17, 17, 17, 17 
 DB 17, 17, 17, 17, 17, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 185, 186, 210, 138, 42, 140, 232, 19, 19, 210, 42, 42, 42, 42, 210, 224, 17, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 18, 224, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 232, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 18, 187, 6, 42, 42, 42, 140, 209, 211, 42, 42, 42, 42, 187, 210, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 18, 18, 19, 20, 20 
 DB 21, 23, 24, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 150, 24, 24, 172, 172, 172, 172, 172, 24, 172, 24, 223, 224 
 DB 18, 18, 224, 224, 17, 16, 16, 16, 115, 42, 42, 42, 6, 210, 210, 210, 240, 19, 210, 210, 114, 42, 42, 211, 19, 224, 18, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17 
 DB 224, 224, 224, 232, 18, 224, 18, 18, 224, 224, 224, 224, 224, 224, 224, 18, 224, 224, 224, 224, 224, 224, 224, 224, 224, 224, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 224, 224, 224, 224, 224, 224, 18, 240, 18, 18, 16, 16, 16, 16, 16, 16, 18, 209, 138 
 DB 42, 6, 187, 210, 210, 210, 240, 210, 211, 114, 42, 42, 42, 42, 210, 224, 17, 16, 18, 232, 209, 224, 17, 16, 16, 17, 17, 17, 17, 17, 17, 17, 18, 25, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 20, 16, 149, 3, 25, 25, 25, 25, 25, 25, 25, 3, 25, 222, 19, 215, 240, 224, 19, 17, 16, 16, 16, 6 
 DB 42, 42, 42, 6, 209, 232, 232, 232, 19, 232, 224, 210, 42, 42, 210, 19, 232, 210, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 224, 224, 19, 19, 224, 19, 19, 224, 19 
 DB 224, 224, 19, 19, 19, 19, 19, 224, 224, 224, 224, 224, 224, 224, 224, 224, 224, 19, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 222, 19, 19, 19, 19, 240, 240, 19, 247, 224, 16, 16, 16, 16, 17, 16, 18, 209, 6, 42, 6, 209, 232, 19, 232, 240, 240, 232 
 DB 210, 42, 42, 42, 42, 210, 210, 17, 16, 18, 232, 19, 19, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 78, 78, 78, 78, 25, 26, 78, 78, 78, 78, 78, 26, 172, 148, 148, 172, 18, 16, 18, 18, 6, 42, 6, 187, 115, 42, 6, 18, 240, 19 
 DB 215, 240, 215, 210, 211, 19, 209, 6, 42, 114, 224, 17, 16, 221, 149, 150, 149, 149, 148, 148, 148, 148, 148, 148, 24, 24, 172, 24, 172, 148, 172, 24, 24, 172, 172, 172, 172, 25, 25, 25 
 DB 25, 25, 25, 25, 25, 25, 24, 25, 24, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 172, 26, 79, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 79, 172, 172, 24, 172, 148, 148, 24, 24, 17, 16, 16, 16, 6, 42, 42, 42, 115, 187, 138, 42, 6, 232, 19, 19, 212, 42, 42, 187, 210, 211, 210, 42, 42, 211, 209 
 DB 17, 16, 16, 16, 18, 224, 224, 224, 224, 224, 224, 224, 224, 224, 18, 18, 224, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 27, 78, 78, 78, 78, 79, 79, 78, 78, 78, 78, 78, 78, 148, 172, 148, 172, 18, 16, 18, 232, 6, 42, 138, 19, 138, 42, 6, 209, 209, 210, 209, 231, 232, 210, 210, 232, 209, 42, 42 
 DB 137, 19, 17, 16, 220, 149, 149, 149, 148, 148, 148, 148, 148, 148, 148, 25, 25, 25, 25, 148, 148, 172, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25 
 DB 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 3, 3, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 25, 25, 25, 25 
 DB 148, 148, 25, 25, 17, 16, 16, 16, 6, 42, 42, 42, 138, 210, 138, 42, 6, 210, 232, 210, 114, 42, 42, 210, 232, 224, 210, 42, 42, 114, 210, 17, 16, 16, 16, 17, 19, 232, 224, 224 
 DB 232, 232, 224, 224, 19, 232, 16, 17, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 148, 148, 148, 172, 78, 78, 79, 26 
 DB 26, 26, 79, 79, 79, 79, 172, 172, 18, 16, 18, 232, 211, 137, 211, 232, 234, 114, 211, 232, 211, 140, 6, 232, 210, 6, 6, 211, 209, 42, 42, 114, 19, 17, 16, 244, 148, 172, 172, 172 
 DB 172, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 78, 78, 78, 78, 78, 78, 78, 25, 79, 78, 78, 78, 78, 172, 172, 16, 16, 16, 16, 6 
 DB 42, 6, 212, 210, 209, 211, 137, 212, 240, 211, 6, 42, 42, 42, 210, 232, 18, 208, 42, 42, 42, 6, 186, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 232, 224, 16, 17, 25 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 150, 150, 149, 148, 78, 78, 25, 25, 25, 25, 3, 3, 78, 78, 148, 148, 18 
 DB 16, 18, 224, 232, 209, 210, 19, 217, 232, 232, 209, 114, 42, 42, 209, 210, 42, 42, 211, 209, 42, 42, 114, 210, 17, 16, 220, 148, 172, 25, 25, 25, 79, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 79, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 3, 78, 78, 78, 78, 78, 78, 78, 25, 79, 78, 78, 78, 78, 148, 148, 16, 16, 16, 16, 6, 42, 114, 19, 19, 224, 224, 232, 240, 210 
 DB 114, 42, 42, 42, 42, 210, 240, 18, 18, 42, 42, 42, 42, 186, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 240, 240, 16, 17, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 150, 149, 148, 172, 26, 79, 78, 78, 78, 78, 78, 78, 78, 78, 25, 172, 18, 16, 18, 209, 138, 6, 137, 231, 240, 224 
 DB 236, 6, 6, 137, 115, 6, 6, 114, 212, 232, 207, 6, 42, 42, 6, 186, 16, 150, 24, 25, 25, 79, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 3, 26, 79, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 79, 25, 79, 79, 78, 78, 78, 78, 78, 25, 25, 79, 79, 78, 78, 78, 26, 17, 16, 16, 16, 6, 42, 114, 240, 232, 19, 209, 209, 137, 6, 6, 114, 115, 42, 42, 210, 224, 18, 186 
 DB 42, 42, 42, 42, 186, 16, 16, 16, 16, 16, 221, 148, 172, 172, 172, 16, 16, 17, 17, 16, 16, 19, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 23, 244, 149, 148, 148, 25, 79, 78, 78, 78, 78, 78, 78, 78, 78, 26, 25, 18, 16, 18, 210, 6, 42, 115, 231, 232, 232, 114, 42, 6, 209, 210, 42, 42, 210, 224 
 DB 224, 209, 42, 42, 42, 42, 187, 16, 149, 25, 3, 3, 79, 78, 78, 77, 77, 77, 77, 77, 77, 78, 78, 79, 25, 3, 3, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 25, 25, 3, 78, 78, 78, 78, 78 
 DB 25, 25, 3, 79, 78, 78, 78, 78, 17, 16, 16, 16, 6, 42, 114, 19, 224, 240, 19, 232, 137, 42, 6, 209, 211, 42, 42, 210, 240, 18, 186, 42, 42, 42, 42, 187, 16, 16, 16, 16 
 DB 16, 244, 25, 79, 78, 25, 17, 16, 16, 16, 16, 16, 16, 17, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 149, 172, 26, 26 
 DB 25, 79, 78, 79, 79, 79, 79, 78, 78, 78, 78, 78, 223, 16, 18, 232, 6, 42, 138, 209, 137, 6, 6, 138, 6, 6, 6, 42, 42, 210, 224, 240, 209, 42, 42, 6, 138, 18, 16, 149 
 DB 25, 79, 78, 78, 78, 78, 77, 77, 77, 77, 77, 77, 78, 78, 79, 25, 79, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 26, 3, 78, 78, 78, 78, 78, 78, 79, 3, 79, 78, 78, 78, 78, 17 
 DB 16, 16, 16, 6, 42, 115, 217, 19, 222, 19, 210, 211, 115, 6, 6, 6, 138, 138, 233, 209, 6, 6, 42, 42, 6, 115, 185, 16, 16, 16, 16, 16, 220, 25, 25, 3, 172, 244, 150, 149 
 DB 149, 16, 16, 16, 17, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 149, 172, 78, 78, 25, 25, 3, 25, 25, 25, 25, 3, 78 
 DB 78, 78, 78, 223, 16, 18, 232, 6, 42, 6, 209, 138, 42, 6, 209, 114, 42, 42, 42, 42, 210, 232, 210, 210, 42, 42, 114, 209, 17, 16, 149, 25, 78, 78, 78, 78, 78, 77, 77, 77 
 DB 77, 77, 77, 77, 77, 25, 25, 78, 78, 78, 78, 78, 78, 78, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77 
 DB 77, 77, 78, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 25, 78, 78, 78, 77, 78, 78, 78, 3, 79, 78, 78, 78, 78, 17, 16, 16, 16, 6, 42, 114, 233, 232, 240 
 DB 232, 209, 210, 233, 114, 42, 6, 210, 240, 240, 187, 42, 42, 42, 42, 212, 210, 17, 16, 16, 16, 16, 16, 244, 3, 172, 148, 148, 148, 148, 25, 25, 17, 16, 16, 17, 25, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 24, 148, 172, 78, 79, 25, 25, 25, 25, 25, 25, 25, 25, 78, 78, 78, 78, 223, 16, 18, 224, 6, 42 
 DB 6, 6, 6, 6, 138, 232, 211, 6, 6, 42, 42, 6, 138, 210, 210, 6, 42, 114, 232, 17, 16, 149, 25, 79, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 26, 3, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 79, 25, 78, 78, 78, 77, 78, 78, 78, 3, 79, 78, 78, 78, 78, 17, 16, 16, 16, 138, 6, 138, 6, 212, 232, 236, 138, 137, 224, 211, 139, 138, 210, 240 
 DB 224, 210, 138, 6, 42, 42, 212, 240, 17, 16, 16, 16, 221, 149, 172, 78, 79, 25, 25, 25, 25, 25, 25, 17, 16, 16, 17, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 27, 78, 25, 148, 172, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 3, 78, 78, 223, 16, 18, 209, 6, 42, 42, 42, 6, 209, 224, 232, 232, 232, 210 
 DB 42, 42, 42, 42, 211, 209, 42, 42, 114, 19, 17, 16, 149, 25, 25, 3, 79, 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 25, 25, 78, 78, 78, 77, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 78, 79, 25, 78 
 DB 78, 78, 77, 78, 78, 78, 3, 3, 78, 78, 78, 78, 17, 16, 16, 16, 18, 209, 6, 42, 138, 209, 115, 42, 6, 240, 19, 232, 232, 19, 224, 224, 240, 210, 209, 42, 42, 212, 19, 17 
 DB 16, 16, 16, 149, 78, 78, 78, 78, 78, 78, 78, 78, 25, 25, 17, 16, 16, 17, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 78, 78 
 DB 25, 26, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 79, 78, 78, 148, 151, 223, 18, 137, 6, 42, 42, 6, 115, 137, 19, 232, 232, 234, 6, 6, 6, 139, 210, 224, 139, 6, 210 
 DB 18, 17, 16, 149, 25, 26, 79, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 25, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 78, 78, 25, 78, 78, 78, 77, 78, 78, 78, 172, 25, 78 
 DB 78, 78, 78, 150, 244, 17, 16, 17, 18, 6, 42, 6, 115, 6, 6, 138, 19, 232, 232, 232, 240, 210, 138, 138, 210, 232, 139, 6, 209, 18, 17, 16, 16, 16, 149, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 26, 150, 150, 244, 244, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 77, 77, 77, 77, 78, 77, 77, 77, 77, 77, 77 
 DB 77, 77, 77, 78, 78, 78, 78, 78, 78, 221, 16, 18, 209, 6, 42, 42, 42, 6, 209, 224, 224, 224, 210, 232, 232, 210, 232, 19, 210, 209, 17, 16, 16, 16, 149, 25, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 77, 77, 25, 25, 78, 78, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 77, 78, 25, 78, 78, 78, 77, 77, 78, 78, 148, 148, 25, 3, 78, 78, 78, 78, 223, 16, 16, 16 
 DB 6, 42, 42, 42, 6, 209, 210, 19, 240, 210, 240, 240, 210, 42, 42, 209, 19, 215, 232, 17, 16, 16, 16, 16, 16, 149, 78, 78, 78, 78, 77, 78, 78, 78, 78, 78, 78, 78, 79, 25 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 149, 221, 223, 18, 137, 6, 42, 42, 6, 114, 212, 232, 210, 115, 114, 114, 137, 232, 19, 18, 18, 17, 16, 18, 221, 148, 26, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77 
 DB 25, 25, 78, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 25, 78, 78, 78, 77, 78, 78, 78, 172, 172, 3, 3, 78, 78, 78, 78, 150, 221, 17, 16, 137, 6, 42, 42, 6, 114, 114, 114, 114 
 DB 114, 114, 114, 6, 42, 42, 187, 224, 18, 18, 17, 16, 16, 16, 223, 220, 148, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 25, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 28, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 150, 16, 18, 209, 115, 42, 42 
 DB 42, 140, 209, 210, 42, 42, 42, 42, 211, 224, 17, 16, 16, 16, 172, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 25, 25, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 77, 78, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 3, 79, 78, 78, 78, 78, 78, 78, 222, 16, 16, 16, 6, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 210, 224, 16 
 DB 16, 16, 16, 16, 16, 172, 78, 78, 78, 78, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 3, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 27, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 148, 223, 18, 18, 137, 6, 6, 6, 6, 114, 114, 6, 6, 42, 6, 209 
 DB 18, 17, 16, 18, 18, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 3, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 79, 78, 78, 78, 77, 78, 78 
 DB 78, 78, 78, 25, 25, 78, 78, 78, 78, 78, 78, 150, 222, 17, 16, 114, 6, 6, 6, 6, 6, 6, 6, 42, 42, 42, 6, 6, 209, 18, 16, 16, 16, 16, 16, 16, 172, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 3, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 78, 78, 78, 78, 3, 79, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 149, 16, 17, 209, 210, 210, 114, 42, 42, 209, 209, 209, 209, 17, 16, 16, 16, 172, 25, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 3, 3, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 3, 79, 78, 78, 77, 78, 78, 78, 79, 25, 3, 25, 78, 78 
 DB 78, 78, 78, 78, 220, 16, 16, 16, 17, 209, 209, 209, 209, 209, 209, 210, 210, 209, 232, 16, 16, 16, 16, 16, 16, 16, 16, 24, 77, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 3, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 78, 78, 78, 78, 79, 79, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 148, 198, 18, 18, 18, 18, 211, 6, 6, 208, 18, 18, 18, 18, 18, 18, 198, 172, 3, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 79, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 25, 79, 78, 78, 77, 78, 78, 78, 79, 79, 3, 3, 78, 78, 78, 78, 78, 78, 150, 18, 17, 16, 17 
 DB 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 16, 16, 16, 16, 18, 18, 18, 18, 24, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 26, 26, 24, 24, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 78, 78, 78, 78, 78, 78, 25, 3, 3, 79, 78, 78, 78, 78, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 173, 16, 16, 16, 17, 17, 17, 16, 17, 16, 17, 172, 172, 172, 172, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 25, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 25, 79, 78, 78, 77, 78, 78, 78, 78, 78, 79, 25, 3, 3, 78, 78, 78, 78, 78, 78, 150, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 
 DB 16, 16, 16, 16, 17, 25, 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 77, 77, 77, 77, 77, 27, 22, 12, 161, 162, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 27, 78, 78, 78, 78, 78, 78, 25, 25, 25, 26, 78, 78, 78, 78, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 148, 17, 17, 17, 17, 17, 17, 17 
 DB 17, 17, 198, 172, 25, 25, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77 
 DB 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 25 
 DB 79, 78, 78, 77, 78, 78, 78, 78, 78, 79, 25, 25, 3, 78, 78, 78, 78, 78, 78, 149, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 79, 78, 77, 77 
 DB 78, 78, 78, 78, 78, 77, 77, 77, 77, 77, 78, 27, 27, 162, 12, 12, 12, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 103, 101 
 DB 101, 101, 102, 102, 102, 78, 78, 78, 78, 3, 3, 78, 77, 77, 77, 78, 78, 78, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 25, 25, 79, 78, 78, 78, 78, 78, 77, 77, 77, 78, 78, 78, 78, 77, 77, 77, 77, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 25, 79, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 25, 25, 25, 3, 3, 3, 78, 78, 78, 78, 78, 78, 78, 78, 26, 172, 172, 172, 25, 78, 78, 172, 25, 26, 78, 78, 78, 78, 77, 77, 78, 78, 77, 77, 77, 78, 77, 77 
 DB 77, 27, 22, 162, 64, 64, 64, 64, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 28, 29, 99, 99, 101, 101, 102, 78, 78, 78, 78 
 DB 3, 3, 78, 77, 77, 77, 78, 78, 78, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 79, 3, 3, 25, 78, 78, 78, 78, 78, 77, 77, 77, 78, 78, 78, 77, 77, 77, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 78, 78, 78, 78, 25, 79, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 25, 25, 25, 25, 25, 3, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 25, 25, 25, 79, 78, 78, 3, 3, 78, 78, 78, 78, 78, 77, 78, 78, 77, 77, 77, 78, 77, 77, 77, 77, 26, 12, 12, 64, 64, 64, 64, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 28, 102, 101, 101, 101, 101, 101, 78, 78, 3, 25, 25, 25, 25, 25, 78 
 DB 77, 77, 77, 77, 78, 77, 77, 78, 78, 78, 78, 78, 78, 78, 77, 77, 77, 77, 77, 77, 77, 78, 78, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 78, 78, 77, 77, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 25, 79, 78, 78, 78, 78, 78, 78, 77, 77, 77, 77, 78, 78, 78, 78, 78, 78, 3, 3, 25, 25, 25, 79, 3, 3, 25, 25 
 DB 25, 25, 25, 25, 3, 25, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 27, 64, 64, 64, 64, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 28, 29, 102, 102, 102, 102, 102, 78, 78, 79, 25, 25, 3, 25, 25, 78, 78, 77, 77, 78, 78, 78, 77, 78, 78 
 DB 78, 78, 78, 78, 78, 77, 77, 77, 78, 78, 78, 77, 78, 77, 77, 77, 77, 77, 77, 77, 78, 77, 77, 77, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 79, 79, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 78, 78, 78, 78, 78, 78, 79, 25, 25, 25, 3, 3, 3, 25, 25, 3, 3, 3, 25, 25, 25, 25, 25, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 27, 64, 64, 64, 64, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27, 27, 78, 78, 78, 78, 78, 78, 79, 25, 79, 79, 26, 26, 26, 26, 26, 26, 26, 3, 3, 3, 26, 26, 26, 79, 79, 79, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 77, 77, 78, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 3, 25, 79, 3, 3, 3, 3, 79, 79, 79, 79, 3, 3 
 DB 3, 3, 3, 3, 26, 26, 27, 26, 26, 26, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 78, 78, 78, 78, 78, 78, 3, 3, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25 
 DB 25, 25, 3, 79, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 77 
 DB 77, 77, 77, 77, 78, 77, 77, 77, 77, 77, 78, 78, 78, 78, 78, 78, 78, 78, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 26, 78, 78, 78 
 DB 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27 
 DB 27, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 26, 26, 3, 79, 78, 78, 78, 78, 172, 149, 150, 150, 172, 78, 78, 78, 78, 150, 150, 173, 174, 173, 173, 173, 173, 173, 173, 173, 173, 173, 173, 173, 173, 149, 150, 150, 150, 150, 150 
 DB 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 150, 244, 221, 221, 221, 221, 221, 244, 150, 150, 244, 244, 244, 151, 244, 150, 26, 79, 78, 78, 78, 79, 79, 79, 78, 78, 78, 78 
 DB 78, 79, 79, 79, 79, 79, 79, 79, 79, 25, 25, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 78, 78, 78, 78, 78, 78, 78, 77 
 DB 78, 78, 78, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 78, 78, 78, 78, 78, 77, 78, 77, 78, 25, 25, 25, 25, 78, 78, 78, 78 
 DB 175, 224, 19, 19, 173, 78, 78, 78, 79, 224, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 19, 224, 19, 224, 224, 224, 19, 224, 19, 224, 224, 19, 19, 19, 224 
 DB 224, 19, 232, 19, 17, 16, 16, 16, 16, 16, 17, 224, 18, 18, 18, 18, 18, 18, 18, 25, 79, 78, 78, 79, 25, 25, 25, 78, 78, 78, 78, 78, 3, 3, 3, 3, 25, 25, 25, 25 
 DB 25, 25, 78, 78, 77, 77, 78, 78, 78, 78, 78, 77, 77, 78, 77, 77, 77, 77, 78, 78, 78, 78, 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 27, 27, 78, 78, 78, 77, 77, 78, 78, 77, 77, 77, 77, 77, 77 
 DB 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 78, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 79, 3, 79, 79, 148, 149, 244, 224, 173, 24, 79, 78, 78, 78, 79 
 DB 245, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 227, 19, 19, 19, 19, 19, 20, 20, 20, 20, 19, 19, 19, 19, 19, 224, 232, 19, 17, 16, 16, 16, 16 
 DB 16, 17, 240, 224, 18, 18, 18, 18, 18, 18, 21, 150, 78, 78, 78, 78, 79, 25, 79, 79, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 27, 27, 27 
 DB 27, 27, 27, 27, 27, 26, 173, 172, 27, 27, 27, 27, 27, 27, 27, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 77, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 3, 3, 3, 25, 150, 19, 19, 19, 172, 78, 78, 78, 78, 78, 79, 243, 20, 19, 224, 224, 232, 224, 232, 232 
 DB 232, 232, 232, 232, 232, 232, 232, 19, 20, 20, 20, 20, 20, 20, 21, 21, 21, 21, 20, 20, 20, 20, 19, 19, 19, 19, 17, 16, 16, 16, 16, 16, 17, 232, 19, 19, 224, 19, 19, 224 
 DB 19, 19, 247, 26, 78, 78, 78, 79, 25, 25, 3, 78, 78, 78, 78, 78, 78, 78, 77, 77, 77, 77, 77, 78, 78, 78, 78, 78, 27, 26, 26, 26, 26, 26, 26, 26, 24, 224, 21, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27 
 DB 27, 172, 172, 148, 148, 172, 172, 26, 78, 78, 78, 172, 172, 20, 19, 172, 78, 78, 78, 79, 172, 149, 238, 19, 232, 19, 19, 232, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20 
 DB 20, 20, 20, 20, 21, 21, 21, 20, 20, 20, 20, 20, 20, 227, 19, 18, 17, 17, 16, 17, 18, 18, 18, 18, 224, 19, 20, 20, 19, 19, 19, 224, 240, 19, 25, 79, 79, 78, 79, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 78, 78, 78, 78, 27, 27, 27, 27, 26, 26, 26, 26, 26, 26, 26, 26, 25, 23, 24, 22, 23, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 224, 19, 224, 224, 224, 224, 78, 77 
 DB 78, 78, 78, 78, 149, 19, 172, 78, 78, 78, 24, 19, 240, 240, 240, 232, 232, 19, 232, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 224, 19 
 DB 21, 21, 21, 21, 20, 20, 17, 16, 16, 16, 18, 19, 224, 224, 19, 232, 19, 21, 20, 19, 240, 19, 19, 240, 246, 172, 25, 25, 25, 78, 78, 78, 78, 78, 78, 78, 77, 77, 77, 77 
 DB 77, 78, 78, 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 18, 20, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 22, 22, 22, 22, 19, 224, 24, 24, 78, 78, 78, 78, 172, 172, 172, 172, 24 
 DB 25, 172, 20, 227, 224, 19, 19, 240, 240, 224, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 20, 20, 19, 19, 20, 20, 21, 21, 20, 20, 17, 16, 17 
 DB 17, 18, 19, 19, 19, 19, 20, 20, 21, 20, 19, 19, 19, 19, 172, 148, 24, 3, 79, 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 78, 78, 78, 78, 78, 27, 27, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 18, 245, 23, 23, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 227, 224, 218, 222, 26, 77, 78, 77, 78, 78, 172, 218, 245, 21, 21, 21, 20, 19, 19, 19, 224, 240 
 DB 224, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 20, 224, 224, 224, 224, 19, 224, 21, 21, 20, 20, 17, 16, 18, 19, 19, 19, 232, 232, 19, 21, 21, 21 
 DB 20, 19, 19, 19, 246, 78, 78, 79, 3, 78, 78, 78, 77, 77, 77, 77, 77, 77, 77, 77, 77, 78, 78, 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 25, 18, 224, 232, 19, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 22, 22, 21, 22, 24, 25, 25, 25, 78, 78, 25, 172, 175, 20, 20, 21, 21, 235, 235, 19, 229, 229, 19, 20, 20, 21, 21, 21, 21, 21, 21 
 DB 21, 21, 21, 21, 21, 21, 21, 21, 21, 19, 20, 227, 19, 19, 19, 21, 21, 20, 19, 17, 16, 18, 19, 19, 224, 19, 235, 20, 21, 21, 21, 20, 232, 19, 150, 149, 78, 78, 79, 79 
 DB 78, 78, 78, 77, 77, 77, 77, 78, 78, 78, 78, 78, 78, 27, 27, 27, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 23, 23, 18, 224, 19, 19, 23, 24 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 21, 247, 224, 19, 25, 78, 78, 78, 24, 224, 243, 21, 21, 21, 21, 21, 21, 21, 21, 19, 19, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21 
 DB 21, 21, 21, 21, 21, 21, 21, 21, 19, 19, 17, 16, 18, 19, 19, 19, 19, 21, 21, 21, 21, 21, 20, 19, 245, 25, 3, 3, 3, 78, 78, 78, 77, 77, 77, 77, 77, 77, 78, 78 
 DB 78, 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 232, 224, 19, 19, 224, 224, 19, 19, 25, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 21, 21, 21, 24 
 DB 26, 26, 26, 172, 150, 149, 172, 173, 21, 20, 20, 20, 21, 21, 19, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 21, 21, 21, 20, 224 
 DB 18, 17, 17, 18, 19, 19, 19, 20, 21, 21, 20, 20, 20, 21, 150, 149, 26, 79, 79, 79, 78, 78, 78, 78, 77, 77, 78, 78, 77, 77, 78, 78, 78, 78, 27, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 25, 150, 150, 150, 150, 150, 150, 150, 150, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 21, 19, 240, 19, 173, 78, 78, 78, 25, 247 
 DB 19, 232, 19, 21, 21, 21, 21, 19, 224, 224, 224, 224, 224, 224, 224, 224, 224, 224, 19, 19, 19, 224, 19, 224, 19, 19, 21, 21, 19, 19, 17, 16, 18, 19, 224, 19, 20, 21, 21, 21 
 DB 20, 224, 232, 19, 150, 78, 78, 78, 78, 78, 78, 77, 77, 78, 78, 78, 77, 78, 78, 78, 78, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 27, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 20, 20, 20, 172, 26, 78, 78, 26, 244, 244, 244, 244, 20, 21, 21, 21, 19, 19 
 DB 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 21, 21, 19, 232, 17, 16, 18, 224, 224, 19, 20, 21, 21, 21, 20, 244, 244, 244, 149, 78, 78, 78, 78 
 DB 78, 78, 78, 77, 78, 78, 78, 77, 78, 78, 78, 78, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 23, 222, 149, 78, 78, 78, 78, 78, 26, 245, 224, 19, 19, 232, 240, 20, 21, 21, 21, 21, 21, 21, 21, 21 
 DB 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 19, 224, 17, 16, 18, 19, 240, 19, 20, 21, 20, 224, 175, 78, 78, 78, 78, 78, 78, 78, 78, 77, 77, 78, 78, 78, 78, 78, 78, 27 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 78, 78, 77, 77, 77, 77, 77, 77, 77, 28, 27 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 24, 20, 172, 26, 78, 78, 78, 78, 78, 150, 20, 244, 20, 19, 240, 20, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21 
 DB 21, 19, 224, 17, 16, 222, 244, 244, 244, 150, 173, 150, 244, 148, 78, 78, 78, 78, 78, 78, 78, 77, 77, 78, 78, 78, 78, 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 78, 78, 78, 78, 78, 78, 78, 78, 78, 28, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 24, 245, 245, 245, 150, 78, 77, 78, 78, 78, 78, 244, 232, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 224, 232, 17, 16, 172, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 77, 78, 78, 78, 78, 78, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 19, 19, 19, 244, 103, 78, 77, 78 
 DB 78, 78, 151, 224, 19, 218, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 218, 218, 17, 16, 172, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 246, 150, 78, 77, 77, 77, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 232, 20, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78 
 DB 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26 
 DB 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26
;Chat
    chatbtn DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31
	        DB  31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31
	        DB  31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31
	        DB  31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31
	        DB  31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31
	        DB  31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31
	        DB  31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31
	        DB  31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31
	        DB  31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31
	        DB  31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31
	        DB  31, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27
	        DB  27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31
	        DB  31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 43, 43, 43, 43, 27, 27, 27, 27, 43
	        DB  43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 27, 27, 27, 27, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43
	        DB  43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31
            

;game
	gamebtn DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3
	        DB  31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25
	        DB  25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31
	        DB  31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 3, 3, 3, 3, 25, 25, 25, 25, 3
	        DB  3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 25, 25, 25, 25, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	        DB  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31

;exit
    exitbtn DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31
	        DB  31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 31, 31
	        DB  31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 31, 31
	        DB  31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110
	        DB  110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27
	        DB  27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31
	        DB  31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 110, 110, 110, 110, 27, 27, 27, 27, 110
	        DB  110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 27, 27, 27, 27, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110
	        DB  110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 110, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31
	        DB  31, 31, 31, 31, 31, 31, 31, 31

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
    POP  bx
    pop ax 
    IRET
ENDP

END MAIN