.model large
.stack 64
.data
tempvarcheck db ?
currentx dw 100
currenty dw 20
numobs dw 0

topoffsetstart equ 5
rightoffsetstart equ 5
trackcolor equ 0eh
numrands db 30
trackwidth equ 57
sectionlength equ 140d
upsectionlenght equ 170d
lastmove db 5
sectionsupcount db 1
bordercolor equ 0ch
numsectionsmoved db 0

;;;;;;;;;;;;;;;;
trackcheck dw 0
finalflag db 0
;;;;;;;;;;;;;;;;;;;obstacles
obstacleWidth equ 15
loopCounter dw 0d
obstacleColor db 1
;;;;;;;;;;;;;;;;;;;;;powerups&obstacles ;;under construction
;;5:purple  10:green   1:blue
Genarray db 1 , 10, 5
GenarraySize equ 3
startFlag db 0
rand_POWERUPS_COUNT dw ?
;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;limits of track  ;;;;;;;;;;;;;;; 
 rightlimit equ 635d
 downlimit equ 400d  
 leftlimit equ 5d
 uplimit equ 5d
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 .code
    checktrack proc far ;check if the pixel is already colored
    push ax
    push bx
    push dx
    push cx
    
    mov bh,0
    mov ah,0dh
    mov cx,currentx
    mov dx,currenty
    int 10h  
    mov tempvarcheck,al           
    pop cx
    pop dx
    pop bx
    
    pop ax
    cmp tempvarcheck,trackcolor
    jne skipcheck
    mov trackcheck,1
    skipcheck:
    ret 
   
    checktrack endp
 drawdown proc far

   cmp lastmove,0 ;;if last move up
   je terminatedown
  
   cmp currenty,downlimit-trackwidth
   jge terminatedown
   cmp currentx,rightlimit-trackwidth
   jge terminatedown
   cmp currentx,leftlimit+trackwidth
   jl terminatedown

    cmp lastmove,2 
    jne sd
    sub currentx,trackwidth -1
    sd:

   
   mov si,0

   drawdownpixel:

 
       cmp currenty,downlimit
       jge terminatedown

 
   
  mov cx,trackwidth 
   drawdownline:
 
    push bx 
    push di 
    push si
    push cx  
    mov si,0 
    mov bx,0 
    mov di,0 
    mov ah,0ch
    mov al,trackcolor
    mov cx,currentx
    mov dx,currenty
    int 10h 
    inc currentx
    pop cx 
    dec cx 
    pop si 
    pop di  
    pop bx
    cmp cx,0 
    jnz drawdownline
    sub currentx,trackwidth
    mov lastmove,3
    inc currenty   ;move 1 step down
    inc si
   
  
   cmp si,sectionlength  
   jnz drawdownpixel

   inc numsectionsmoved
  
   terminatedown:
   ret 
   drawdown endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
   drawright proc far
      
     
  
   
      ;;;;;;;;;;;cmp if last move is up
    
      cmp lastmove,0 
      jne skip
      add currentx,trackwidth
      inc currenty
      skip:
      
      cmp lastmove,3
      jne skip1
      sub currenty,trackwidth
      add currentx,trackwidth
      skip1:
      cmp lastmove,2
      je terminateright 
    
   cmp currenty, downlimit-trackwidth

   jg terminateright
   mov si,0
   drawrightpixel: 
   mov cx,0 
   
    repeatR:
       ;checkbounds  
      cmp currentx,rightlimit
      jge terminateright
    
     push ax 
     push cx    ;draw
     push dx 
     push bx 
     mov bx,0 
     mov ah,0ch 
     mov al,trackcolor
     mov cx, currentx
     mov dx ,currenty
      int 10h 
      pop bx 
      pop dx 
      pop cx 
      pop ax 
     mov lastmove,1
     inc cx     
     inc currenty  
     cmp cx,trackwidth
    jnz repeatR

   inc currentx     
   sub currenty,trackwidth
   
   inc si
   cmp si,upsectionlenght
   jnz drawrightpixel
   inc numsectionsmoved
   terminateright:
   ret

drawright endp


drawleft proc far
 
  
 cmp currenty, downlimit-trackwidth
   jg skip02
   cmp currentx,leftlimit+trackwidth
   jle skip02
  cmp lastmove,0
   jnz skip4
   add currentx,trackwidth
   
  skip4:
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  cmp lastmove,1
  je skip02
  


        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
     cmp lastmove,3 ;if last move is down,adjust x        ; its functionality is en ba3d el down yzbat el x
     jnz skipL
     cmp currentx,leftlimit
     je skip02
      jle hh
      sub currenty,trackwidth
      dec currentx
      hh:
      add currentx,trackwidth-1
     skipL:
    mov si,0
    drawleftpixel: 
 
     mov cx,0 
         ;checkbounds  
      cmp currentx,leftlimit+trackwidth
      jle terminateleft
         push ax
   mov ax,currentx
   sub currentx,trackwidth
   mov trackcheck,0 
   call checktrack
   cmp trackcheck,1
   mov currentx,ax 
   pop ax 
   je terminateleft 
    repeatL:
    jmp skip03
    skip02:
    jmp terminateleft
    skip03:
   
   
     push ax 
     push cx    ;draw
     push dx 
     push bx 
     mov bx,0 
     mov al,trackcolor
     jmp skip05
     skip04:
     jmp drawleftpixel
     skip05:
     mov ah,0ch 
     mov cx, currentx
     mov dx ,currenty
      int 10h 
      pop bx 
      pop dx 
      pop cx 
      pop ax 
     
     inc cx     
    inc currenty
     cmp cx,trackwidth

    jnz repeatL
    mov lastmove,2
   dec currentx     
   sub currenty,trackwidth
   
   inc si
   cmp si,sectionlength
  
   jnz skip04
   inc numsectionsmoved

   terminateleft:
   ret
  

   drawleft endp


   drawup proc far

   cmp lastmove,3
   jz skip00
  
   cmp currenty,uplimit
   jle skip00
      cmp lastmove,2
   jz skip00
      push ax 
   mov ax, currenty
   sub currenty,trackwidth *2
   mov trackcheck,0
   call checktrack
   cmp trackcheck,1

   mov currenty,ax 
   pop ax
   je skip00 
   cmp currentx,rightlimit-trackwidth
   jg skip00
   cmp currenty, uplimit+trackwidth
   jle skip00
   cmp lastmove,1
   jnz skip111
   sub currentx,trackwidth

   skip111:
 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   
   mov si,0
 drawuppixel:
 cmp currenty,uplimit+trackwidth
   jle terminateup
       push ax
       mov ax,currenty
      sub currenty,trackwidth
      mov trackcheck,0
      call checktrack
      
      cmp trackcheck,1
      mov currenty,ax
      pop ax 
      je terminateup
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   jmp skip01
   skip00:
   jmp terminateup  
   skip01:
   mov cx,trackwidth
   drawupline:

    push bx 
    push di 
    push si
    push cx  
    mov si,0 
    mov bx,0 
    mov di,0 
    mov ah,0ch
    mov al,trackcolor
    mov cx,currentx
    mov dx,currenty
    int 10h 
    inc currentx
    pop cx 
    dec cx 
    pop si 
    pop di  
    pop bx
    cmp cx,0 
    jnz drawupline
   
  dec currenty  

  mov lastmove,0
  sub currentx,trackwidth
   inc si
   cmp si,upsectionlenght ;repeat 40 times to generate a vertical track section of width "track width"   
   jnz drawuppixel
  
    inc numsectionsmoved
   ;add currentx,trackwidth  
   terminateup:
   ret
   drawup endp   
   

       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;procedures done;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




 initialization proc far
mov ax,@DATA
mov ds,ax

mov ax,0A000h
mov es,ax
mov currentx,5d
mov currenty,5d
mov numrands,25d
mov ax,0600h
mov bh,07
mov cx,0
mov dx,184FH
int 10h
mov numsectionsmoved,0
mov sectionsupcount,1
mov lastmove,5d
;graphics mode
mov ah,0
mov al,12h
int 10h

  
mov finalflag,0
ret 
initialization endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


genRandom PROC far  ;;generate random number from 0 to 4 and store in ah
   
   cmp numrands,0
   je setFF

   jmp skipsetFF
   setFF:
   mov finalflag,1
   jmp terminaterandom
   skipsetFF:
   
   mov si,100h
     looprand:  ;loop to slow down

        mov ah, 2ch
        int 21h
        mov ah, 0
        mov al, dl  ;;micro seconds?
        mov bl, 4
        div bl
        ;;; ah = rest               
        dec si
        cmp si,0
        jnz looprand
       terminaterandom:
        RET
    genRandom ENDP   
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  trackend proc far  
      mov ah, 0
      int 16h
    ret
   trackend endp
   drawFinishLine proc far
      ;;;;;;;;;;;;;;;;;;;draw last line
   cmp lastmove,3 ;;;if last move is down 
   jne checkother
   dec currenty
     ;;;;;;;;;;;;;;;
    mov loopCounter,5
    drawdownlinefWIDTH:
    mov cx,trackwidth
     drawdownlinef:
   
    push bx 
    push di 
    push si
    push cx  
    mov si,0 
    mov bx,0 
    mov di,0 
    mov ah,0ch
    mov al,bordercolor
    mov cx,currentx
    mov dx,currenty
    
    int 10h 
    inc currentx
    pop cx 
    dec cx 
    pop si 
    pop di  
    pop bx
    cmp cx,0 
    jnz drawdownlinef
    sub currentx,trackwidth
    inc currenty
    dec loopCounter
    cmp loopCounter,0
    jnz drawdownlinefWIDTH
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  jmp terminateFinishLine
  jmp skiippp
  drawag:
  jmp drawagain
  skiippp:
   checkother:
   cmp lastmove,1
   jne checkother2
   sub currentx,1
    mov si,5
    repeatRfinWIDTH:
     mov cx,0 
    repeatRfin:
     push ax 
     push cx    ;draw
     push dx 
     push bx 
     mov bx,0 
     mov ah,0ch 
     mov al,bordercolor
     mov cx, currentx
     mov dx ,currenty
      int 10h 
      pop bx 
      pop dx 
      pop cx 
      pop ax 
     
     inc cx     
     inc currenty  
     cmp cx,trackwidth
     jnz repeatRfin
     sub currenty,trackwidth
     inc currentx
     dec si 
     cmp si,0
     jnz repeatRfinWIDTH
     jmp terminateFinishLine
   checkother2:
   cmp lastmove,0
   jne checkother3
  inc currenty
  mov loopCounter,5
drawuplinefWIDTH:
  mov cx,trackwidth 
   drawuplinef:

    push bx 
    push di 
    push si
    push cx  
    mov si,0 
    mov bx,0 
    mov di,0 
    mov ah,0ch
    mov al,bordercolor
    mov cx,currentx
    mov dx,currenty
    int 10h 
    inc currentx
    pop cx 
    dec cx 
    pop si 
    pop di  
    pop bx
    cmp cx,0 
    jnz drawuplinef
    sub currentx,trackwidth
    dec currenty
    dec loopCounter     
    cmp loopCounter,0
    jnz drawuplinefWIDTH

    jmp terminateFinishLine
    checkother3:
    add currentx,1


    mov si,5
    repeatLfinWIDTH:
     mov cx,0 
    repeatLfin:
     push ax 
     push cx    ;draw
     push dx 
     push bx 
     mov bx,0 
     mov ah,0ch 
     mov al,bordercolor
     mov cx, currentx
     mov dx ,currenty
      int 10h 
      pop bx 
      pop dx 
      pop cx 
      pop ax 
   
     inc cx     
     inc currenty  
     cmp cx,trackwidth
     jnz repeatLfin
     sub currenty,trackwidth
     inc currentx
     dec si 
     cmp si,0
     jnz repeatLfinWIDTH
     terminateFinishLine:
     ret
     drawFinishLine endp

   generateObstacles proc far
  
    ;mov loopCounter,10d 
   genObstacles:
   ;;generate a random x and a random y
   ;;check en mafesh 7waleha obstacles tanya w enaha track aslan
   ;;draw obstacle
   
        ;;randomizing x
        mov currentx,0
        mov cx,6
        randomX:
        push cx
        mov ah, 00 ; Function to get system time
        int 1ah

        mov ah, 0
        mov al, dl  ;;micro seconds? 0-99
        add currentx,ax
        pop cx
        dec cx
        cmp cx,0
        jnz randomX
        ;;;;;;;;;;;randomizing y
        mov currenty,0
        mov cx,4
        randomY:
        push cx
        mov ah, 2Ch ; Function to get system time
        int 21h

        mov ah, 0
        mov al, dl  ;;micro seconds? 0-99
        add currenty,ax
        pop cx
        dec cx
        cmp cx,0
        jnz randomY
   ;;randomizing a color
        mov ah, 2ch
        int 21h
        mov ah, 0
        mov al, dl  ;;micro seconds?
        mov bl, GenarraySize
        div bl
        
        mov al,ah
        mov ah,0
        mov di,ax
        mov bl,Genarray[di]
        mov obstacleColor,bl
    ;;randomizing number of power ups and obstacles
            mov ah, 2ch
        int 21h
        mov ah, 0
        mov al, dl  ;;micro seconds?
        mov bl, 6
        div bl
        
        add ah,8
        mov al,ah
        mov ah,0
        mov rand_POWERUPS_COUNT,ax

    ;checks
    ;;check square is in track area
    ;;check no nearby obstacles (not in currentX+obstaclewidth*2 and currentx-obstaclewidth 
    ;;for cuurenty from currenty-obstaclewidth to currenty+obstaclewidth*2
    ;;;;;;;;
    push currentx
    push currenty
    ;;                                              *******
    sub currentx,obstacleWidth ;;;;;;;;;;;;;;;;;;;  ** __****
    mov si,obstacleWidth*3                      ;; **|    |**** ;;say en el square da el obstacle,
    sub currenty,obstacleWidth                   ;;**|    |***  ehna bn check mkano w 7waleh in all
    squareOuterCheck:                           ;;  ** __ **** directions
    mov cx,obstacleWidth*3                      ;;   ********
    squareInnerCheck:
        push cx
        mov bx,0 
        mov ah,0dh 
        mov cx,currentx
        mov dx,currenty
        int 10h 
        pop cx
        cmp al,trackcolor
        jne skip_draw_obstacle
        inc currentx
       
        dec cx
        cmp cx,0
        jnz squareInnerCheck
    sub currentx,obstacleWidth*3
    inc currenty
    dec si 
    cmp si,0
    jnz squareOuterCheck

    ;;;
    pop currenty
    pop currentx
    ;;;
    jmp skipINTER_OBST
    genObstaclesINTER:
    jmp genObstacles
    skipINTER_OBST:

    ;;;
    ;;;;;;;;;;;;;;;;;;
    mov si,obstacleWidth

    squareOuterLoop:
    mov cx,obstacleWidth
    squareInnerLoop:
        push cx

        mov bx,0 
        mov ah,0ch 
        mov al,obstacleColor
        mov cx,currentx
        mov dx,currenty
        int 10h 

        inc currentx

        pop cx
        dec cx
        cmp cx,0
        jnz squareInnerLoop

    sub currentx,obstacleWidth
    inc currenty
    dec si 
    cmp si,0

    jnz squareOuterLoop
      inc numobs
    ;jmp skip_draw_obstacle2
    ;skip_draw_obstacle:
       ; pop currenty
        ;pop currentx
        jmp skip_draw_obstacle2
        skip_draw_obstacle:
        pop currenty    
        pop currentx   
    skip_draw_obstacle2:
     mov di,rand_POWERUPS_COUNT 
    cmp numobs,di
    jl genObstaclesINTER
   ;jge trackendinter
   ret
   generateObstacles endp

   drawTrack proc far
init:
call initialization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
randomfunc:
call genRandom ;returns random from 0-4 in AH

cmp finalflag,1
je final

decide:
 cmp lastmove,0
 jne skip6
mov ah,1
skip6:


dec numrands


cmp ah,0
 je moveup
 
cmp ah,1
je moveright 

cmp ah,2
je moveleft

cmp ah,3
je movedown 

;;;;;;;;;;;;;;;;;;;;;;;
jmp intermeddiatetry 
trackendinter:
jmp trackend
intermeddiatetry:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveright:        
call drawright
jmp randomfunc  ;regenerate random and check limits (repeatt)   

  
 movedown:
     call drawdown     
     jmp randomfunc  ;regenerate random and check limits (repeatt) 
                                                            
                                                                        
   moveleft: 
     call drawleft     
   jmp randomfunc  ;regenerate random and check limits (repeatt) 

   moveup:
      call drawup
      jmp randomfunc
  final: 
   cmp numsectionsmoved,10d
   jl drawagain

     call drawFinishLine
     jmp endtrack
   drawagain:
   jmp init
   ;mark end of track
   endtrack:
   call generateObstacles
   ret
   drawTrack endp

main proc far

   call drawTrack
   hlt
   ret
   
 main endp



 end main