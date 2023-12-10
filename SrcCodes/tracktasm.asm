.model large
.stack 64
.data
tempvarcheck db ?
currentx dw ?
currenty dw ?
topoffsetstart equ 5
rightoffsetstart equ 5
trackcolor equ 0eh
numrands db 40d
trackwidth equ 21
sectionlength equ 60
upsectionlenght equ 20
lastmove db 5
sectionsupcount db 1
bordercolor equ 04h
numsectionsmoved db 0
outlinecolor equ 0fh 
;;;;;;;;;;;;;;;;
trackcheck dw 0
finalflag db 0
obstacleColor equ 1d
 ;limits of track  ;;;;;;;;;;;;;;; 
 rightlimit equ 315d
 downlimit equ 160d  
 leftlimit equ 5d
 uplimit equ 5d
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 .code
 calc_di proc far
  push ax
  push bx
  push dx
  mov ax,currenty
  mov bx,320d
  mul bx
  add ax,currentx
  mov di,ax
  pop dx
  pop bx
  pop ax
  ret
calc_di endp
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
    jnz skipcheck

    mov trackcheck,1
    ret
    skipcheck:
    cmp tempvarcheck,outlinecolor
    jnz skipcheck1
    mov trackcheck,1
    ret 
    skipcheck1:
    ret
    checktrack endp
 drawdown proc far
  
   cmp lastmove,0 ;;if last move up
   je skip100
   ;;;;;;;;;;;;;;;;;;;;;;
   cmp lastmove,3
   jne skip52
   dec currenty 
   skip52:
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   push ax 
   mov ax ,currentx
   add currentx,trackwidth ;;
   cmp currentx,rightlimit
   jle skip8
   mov currentx,ax 
   pop ax 
   jmp terminatedown
   skip8:
   mov currentx,ax 
   pop ax 
   mov si,0

   drawdownpixel:
    
   ;;;;;;;;;;;;;;;calculate di (memory offset);;;;;;;;;;;;
   call calc_di
   mov al,outlinecolor
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;check f top is colored
   push ax 
   mov ax,currenty
   dec currenty
   mov trackcheck,0
   call checktrack
   cmp trackcheck,1
   mov currenty,ax
   pop ax 

   je skip20;; if colored
   mov al, outlinecolor
   jmp skip21
   skip20: 
   mov al,trackcolor
    
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;jmpskip
   jmp skip101
   skip100:
   jmp terminatedown
   skip101:
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;check if the right side is colored
   push ax 
   mov ax, currentx
   dec currentx
   mov trackcheck,0
   call checktrack
   
   cmp trackcheck,1
   je skip17
   push ax 
   mov ah,0
   mov al,outlinecolor
   mov es:[di], al
   pop ax 
   jmp skip18
   skip17:
   push ax
   mov ah,0
   mov al,trackcolor
   mov es:[di], al
   pop ax
   skip18:
   mov currentx,ax
   pop ax
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   inc di
 
    
   ;;;;check borders
       cmp currenty,downlimit
       jae terminatedown

  ; checktrack  
  
 
   mov cx,trackwidth-2  ;horizontal line of length "track width" 
   cmp si,sectionlength-1
   jne colorbor
   mov al,outlinecolor
   
   colorbor:
   
   rep stosb
   jmp skip22
   skip21:
   mov cx,trackwidth-1  ;horizontal line of length "track width"
   rep stosb
   skip22:
   jmp skip103
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   skip102:
   jmp drawdownpixel
   skip103:
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   push si 
   mov si,di 
   inc si 
   cmp es:[si],00h 
   pop si 
   je borderrr
   mov al,trackcolor
   jmp skip51
   borderrr:
   mov al,outlinecolor
   skip51:
   mov es:[di], al 
   mov lastmove,3
   inc currenty   ;move 1 step down
   inc si
   cmp si,sectionlength  ;repeat 40 times to generate a vertical track section of width "track width"   
   jnz skip102  
   inc numsectionsmoved
   ;add currentx,trackwidth 
   terminatedown:
   ret 
   drawdown endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
   drawright proc far
      
      cmp lastmove,2
      je skip106
     
      ;;;;;;;;;;;cmp if last move is up
     
      cmp lastmove,0 
      jne skip
      add currentx,trackwidth
      inc currenty
      skip:
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;if lastmove is down draw over border 
      cmp lastmove ,3 
      jne skip50
      dec currenty
      mov cx,trackwidth
      mov al,trackcolor
      ;;;;;;;;;;;;;;;;;;;;di calculation;;;;;;;;;;;;;;;
     call calc_di
     mov al,trackcolor
   rep stosb ;;;;;;;;;;;border adjusts
     inc currenty
   skip50:
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      jmp skip107
      skip106:
      jmp terminateright
      skip107:
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   push ax 
   mov ax, currenty
   add currenty,trackwidth
   cmp currenty, downlimit
   jle skip12
   mov currenty,ax
   pop ax
   jmp terminateright
   skip12:
   mov currenty,ax
   pop ax
     
      mov si,0
    drawrightpixel: 
 
    ;;;;;;;;;;;;;;;;;;;;di calculation;;;;;;;;;;;;;;;
    call calc_di

     mov al,outlinecolor
     mov cx,0 
   
    repeatR:
   ;;;;;;;;;;;;;;check if up is colored
   push ax 
   mov ax ,currenty
   dec currenty
   mov trackcheck,0
   call checktrack
   cmp trackcheck,1
   mov currenty,ax 
   pop ax
   jne skip19
   
   push ax 
   mov ax, currentx
   dec currentx
   mov trackcheck,0
   call checktrack
   cmp trackcheck,1
   mov currentx,ax 
   pop ax 
   jne skip19
   ;;;;;;;;;;;;;;;;;;;;;;;;;
   ;jmp break
   jmp skip105 
   skip104:
   jmp drawrightpixel
   skip105:
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;checkbounds  
      cmp currentx,rightlimit
      jge terminateright
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      mov trackcheck,0
      call checktrack
      cmp trackcheck,1
      je terminateright
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;check if the last row
      cmp cx ,trackwidth-1
     je skip19
     mov ax ,trackcolor
     jmp skip25
     skip19:
     mov ax,outlinecolor
   skip25:
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     jmp skip109
     skip108:
     jmp repeatR
     skip109:
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     stosb       ;draw  
     mov lastmove,1
     inc cx     
     inc currenty  
     mov ax,currenty  ;y coordinate is row
      mov bx,320d
     mul bx
     add ax,currentx    ;x coordinate is column 
     mov di,ax    ;di=(row*320)+column
     
     cmp cx,trackwidth
      jnz skip108

   inc currentx     
   sub currenty,trackwidth
   
   inc si
   cmp si,sectionlength  
   
   jnz skip104
   inc numsectionsmoved
   terminateright:
   ret

drawright endp


drawleft proc far
 
  mov si,0
  cmp lastmove,1
  je skip110
  cmp lastmove,0
   jnz skip4
   add currentx,trackwidth
   skip4:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   push ax 
   mov ax, currenty
   add currenty,trackwidth
   cmp currenty, downlimit
   jle skip11
   mov currenty,ax
   pop ax
   jmp terminateleft
   skip11:
   mov currenty,ax
   pop ax
    ;checkbounds  
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jmp skip111
    skip110:
    jmp terminateleft
    skip111: 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cmp currentx,leftlimit
    jle skip112
    mov trackcheck,0
    call checktrack
    cmp trackcheck,1
    je skip112

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; shaka eno bybwaz haga
     cmp lastmove,3 ;if last move is down,adjust x        ; its functionality is en ba3d el down yzbat el x
     jnz skipL
     sub currenty,trackwidth 
     push cx 
     mov cx, 0
     
   repeatLs:                                          ;
     mov ax,trackcolor 
       stosb       ;draw 
       mov bx,320d 
     mov lastmove,2
     inc cx     
     inc currenty  
    call calc_di
     cmp cx,trackwidth

    jnz repeatLs;drawover unwanted border
    pop cx
   sub currenty,trackwidth
   dec currentx                           ;
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     skipL:
     ;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;
   jmp skip113
   skip112:
      jmp terminateleft
      skip113:


    drawleftpixel: 
    ;;;;;;;;;;;;;;;;;;;;di calculation;;;;;;;;;;;;;;;
     mov ax,currenty  ;y coordinate is row
     mov bx,320d
     mul bx
     add ax,currentx    ;x coordinate is column 
     mov di,ax    ;di=(row*320)+column

     mov al,trackcolor 
     mov cx,0 
   
    repeatL:

       ;checkbounds  
      cmp currentx,leftlimit
      jle skip112
       push ax 
       mov ax , currentx 
       sub currentx,trackwidth 
       mov trackcheck,0
       call checktrack
       mov currentx,ax 
       pop ax
       cmp trackcheck,1
       je terminateleft
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      mov trackcheck,0
      call checktrack
      cmp trackcheck,1
      je terminateleft
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;;;;;;;;;;;;;;;;;;;;;;border validation
   push ax 
   mov ax ,currenty
   dec currenty
   mov trackcheck,0
   call checktrack;
   cmp trackcheck,1
   mov currenty,ax 
   pop ax
   jne skip40
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  jmp skip115
  skip114:
  jmp drawleftpixel
  skip115:
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   cmp cx,trackwidth-1
   je skip40 
   mov al,trackcolor
   jmp skip41
   skip40:
   mov al,outlinecolor
   skip41:
     stosb       ;draw  
     mov lastmove,2
     inc cx     
     inc currenty  
    call calc_di
    
     cmp cx,trackwidth

    jnz repeatL

   dec currentx     
   sub currenty,trackwidth
   
   inc si
   cmp si,sectionlength
  
   jnz skip114 
   inc numsectionsmoved

   terminateleft:
   ret
  

   drawleft endp


   drawup proc far

   cmp lastmove,3
   jz skip116
   cmp sectionsupcount,0
   je skip116
   cmp currenty,uplimit
   jle skip116
   cmp lastmove,1
   jnz skip1
   
   add currenty,trackwidth-1
   skip1:
   cmp lastmove,2
   jz skip116 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   push ax 
   mov ax, currenty
   sub currenty,trackwidth 
   mov trackcheck,0
   call checktrack
   cmp trackcheck,1

   mov currenty,ax 
   pop ax
   je skip116
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   push ax 
   mov ax, currentx
   add currentx,trackwidth
   cmp currentx,rightlimit
   jle skip13
   mov currentx,ax 
   pop ax
   jmp terminateup
   skip13:
   mov currentx,ax 
   pop ax
    dec sectionsupcount
   ;;;;;;;;;;;;;;;calculate di (memory offset);;;;;;;;;;;;
   drawuppixel:
   call calc_di
   mov al,trackcolor ;;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   jmp skip117
   skip116:
   jmp terminateup
   skip117:
   ;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;checkbounds 
       cmp currenty,uplimit
       jle skip116
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       push ax
       mov ax,currenty
      sub currenty,trackwidth*2
      mov trackcheck,0
      call checktrack
      mov currenty,ax
      pop ax 
      cmp trackcheck,1
      je skip116 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;check if down is colored
   cmp si,sectionlength-1
   je skip31
   push ax 
   mov ax ,currenty
   inc currenty
   mov trackcheck,0
   call checktrack 
   cmp trackcheck,1 
   mov currenty,ax 
   pop ax 
   jne skip31

   skip29:
   mov ax,trackcolor

   mov es:[di],al 
   jmp skip30
   skip31:
   mov ax, outlinecolor
   jmp skip35
   skip30:
   
   push si 
   mov si,di 
   dec si
   mov al, es:[si]
   cmp al ,00h ;black 
   pop si 
   jne here 
   mov al ,outlinecolor
   jmp skip33
   here:
   mov al,trackcolor
   skip33:
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov es:[di],al 
  inc di
   
  ; checktrack  
  mov al,trackcolor
  skip35:
   mov cx,trackwidth-2 ;horizontal line of length "track width"
   rep stosb
   ;;;;;;;;;;;;;;;;;;;;;;;
   jmp skip119 
   skip118:
   jmp drawuppixel
   skip119:

   ;;;;;;;;;;;;;;;;;;;;;;;;;;
   push si 
   mov si,di
   inc si  
   mov al, es:[si]
   cmp al ,00h ;black
   pop si 
   jne here1 
   cmp si, sectionlength-trackwidth
   jge here1
   mov al ,outlinecolor
   jmp skip34
   here1:
   mov al,trackcolor
   skip34:
   
   mov es:[di],al 
   mov lastmove,0
   dec currenty   ;move 1 step up
   
    push ax
       mov ax,currenty
      sub currenty,trackwidth*2
      mov trackcheck,0
      call checktrack
   mov currenty,ax
   pop ax 
   cmp trackcheck,1
   je terminateup
   inc si
   cmp si,sectionlength  ;repeat 40 times to generate a vertical track section of width "track width"   
   jnz skip118
   push si 
   mov si,di 
   inc si
   mov es:[si],outlinecolor
   pop si 
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
mov currentx,rightoffsetstart
mov currenty,topoffsetstart
mov numrands,40d
mov ax,0600h
mov bh,07
mov cx,0
mov dx,184FH
int 10h
mov numsectionsmoved,0
mov sectionsupcount,1
;graphics mode
mov ah,0
mov al,13h
int 10h

mov di,(downlimit+1)*320     ;;horizontal line to seperate chatting and track
mov al,0ah      
mov cx,320
rep stosb   
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
   
   mov si,200h
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
  genRandomX proc far
    push ax
  push bx
  push cx
      mov ah, 2ch
       int 21h
        mov ah, 0
        mov dh,0
        mov ax, dx  ;;micro seconds? dl mn 0 l 99
        mov bx, 4d
        mul bx   
        mov currentx,ax
        pop cx
        pop bx
        pop ax
        ret
  genRandomX endp

  genRandomY proc far ;from 0 to 200
  push ax
  push bx
  push cx
      mov ah, 2ch
       int 21h
        mov ah, 0
        mov dh,0
        mov ax, dx  ;;micro seconds?
        mov bx, 2d
        mul bx  
        mov currenty,ax 
        pop cx
        pop bx
        pop ax
       ret
    genRandomY endp

generateObstacles proc far 

     ret
  generateObstacles endp
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;


main proc far

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
      cmp numsectionsmoved,8
      jl drawagainbreak
      ;;;;;;;;;;;;;;;;;;;draw last line
      cmp lastmove,3 ;;;if last move is down 
      jne checkother
      dec currenty
      ;;;;;;;;;;;;;;;calculate di (memory offset);;;;;;;;;;;;
      mov ax,currenty
      mov bx,320d
      mul bx
      add ax,currentx
      mov di,ax      ;di=(row*320)+column
      mov al,bordercolor
      mov cx,trackwidth  ;horizontal line of length "track width"
      rep stosb
      checkother:
       cmp lastmove,1
       jne checkother2
       dec currentx
       mov ax,currenty  ;y coordinate is row
       mov bx,320d
       mul bx
       add ax,currentx    ;x coordinate is column 
       mov di,ax    ;di=(row*320)+column
       mov al,bordercolor
       mov cx,0 
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      jmp skipdrawagain
      drawagainbreak:
      jmp drawagain 
      skipdrawagain:
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    repeatRfin:

     stosb       ;draw  
     mov lastmove,1
     inc cx     
     inc currenty  
     mov ax,currenty  ;y coordinate is row
      mov bx,320d
     mul bx
     add ax,currentx    ;x coordinate is column 
     mov di,ax    ;di=(row*320)+column
     mov al,bordercolor
     cmp cx,trackwidth
     jnz repeatRfin
     checkother2:
       cmp lastmove,0
       jne endtrack
       inc currenty
       mov ax,currenty
       mov bx,320d
       mul bx
       add ax,currentx
       mov di,ax      ;di=(row*320)+column
       mov al,bordercolor;;
      ; checktrack  
       mov cx,trackwidth  ;horizontal line of length "track width"
       rep stosb
      drawagain:
       jmp init
       ;mark end of track

   ;;;;;;;;;;;;;;;;;;;;;;obstacles;;;;;;;;;;
   endtrack:
   

  mov si,0fffh ;100 trial to draw an obstacle
  genObstacles:
  call genRandomX
  ;;;;;;;;;;;;;;
  call genRandomY
  checkPossible: ;;check the square will be in an all yellow area
  mov cx,4
  checkOuterLoop:
  mov dx,4
  checkInnerLoop:
  call calc_di
  mov al,es:[di]
  cmp al,trackcolor
  jne skipITERATION
  inc currentx
  dec dx 
  cmp dx,0
  jnz checkInnerLoop
  sub currentx,4
  inc currenty
  dec cx 
  cmp cx,0
  jnz checkOuterLoop
  sub currenty,4
  mov cx,4
  drawsquareOUTER:
  mov dx,4
  drawsquareINNER:
  mov al,1
  call calc_di
  stosb
  inc currentx
  dec dx 
  cmp dx,0 
  jnz drawsquareINNER
  sub currentx,4
  inc currenty
  dec cx
  cmp cx,0
  jnz drawsquareOUTER

skipITERATION:
  dec si 
  cmp si,0
  jnz genObstacles
  ret

 main endp
 end main