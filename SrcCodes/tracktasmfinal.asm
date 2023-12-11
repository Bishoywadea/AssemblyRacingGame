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
outbounds dw 0

 ;limits of track  ;;;;;;;;;;;;;;; 
 rightlimit equ 315d
 downlimit equ 160d  
 leftlimit equ 5d
 uplimit equ 5d
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 .code

main proc far

call initialization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
randomfunc:
call genRandom ;returns random from 0-4 in AH

decide:
cmp lastmove,0
jne skip6
mov ah,1
skip6:
;checkY:
;cmp currenty,downlimit
;jb skipchecks

;cmp currentx,rightlimit
;jae final

;cmp currentx,leftlimit
;jbe final

;skipchecks:

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
   jl skip9
   ;;;;;;;;;;;;;;;;;;;draw last line
   cmp lastmove,3 ;;;if last move is down 
   jne skip10
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
   skip10:
   cmp lastmove,1
   jne skip14
   dec currentx
     mov ax,currenty  ;y coordinate is row
     mov bx,320d
     mul bx
     add ax,currentx    ;x coordinate is column 
     mov di,ax    ;di=(row*320)+column
     mov al,bordercolor
     mov cx,0 
   
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
   skip14:
   cmp lastmove,0
   jne skip15
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
   skip15:
     mov ah, 1
    int 21h
   skip9:
   call initialization
   ;mark end of track

    ret

 main endp

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

ret 
initialization endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

genRandom PROC far  ;;generate random number from 0 to 4 and store in ah
   
   cmp numrands,0
   jle final
   
  
   
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
       
        RET
    genRandom ENDP   
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  drawdown proc far
  
   cmp lastmove,0 ;;if last move up
   je terminatedown
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
   mov ax,currenty
   mov bx,320d
   mul bx
   add ax,currentx
   mov di,ax      ;di=(row*320)+column
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
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
   jnz drawdownpixel  
   inc numsectionsmoved
   ;add currentx,trackwidth 
   terminatedown:
   ret 
   drawdown endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
   drawright proc far
      
      cmp lastmove,2
      je terminateright
     
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
     mov ax,currenty  ;y coordinate is row
     mov bx,320d
     mul bx
     add ax,currentx    ;x coordinate is column 
     mov di,ax    ;di=(row*320)+column
     mov al,trackcolor
   rep stosb ;;;;;;;;;;;border adjusts
     inc currenty
   skip50:
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
     mov ax,currenty  ;y coordinate is row
     mov bx,320d
     mul bx
     add ax,currentx    ;x coordinate is column 
     mov di,ax    ;di=(row*320)+column

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

    jnz repeatR

   inc currentx     
   sub currenty,trackwidth
   
   inc si
   cmp si,sectionlength  
   
   jnz drawrightpixel 
   inc numsectionsmoved
   terminateright:
   ret

drawright endp


drawleft proc far
 
  mov si,0
  cmp lastmove,1
  je terminateleft
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
    cmp currentx,leftlimit
    jle terminateleft
    mov trackcheck,0
    call checktrack
    cmp trackcheck,1
    je terminateleft

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
     mov ax,currenty  ;y coordinate is row
     mul bx
     add ax,currentx    ;x coordinate is column 
     mov di,ax    ;di=(row*320)+column
     cmp cx,trackwidth

    jnz repeatLs;drawover unwanted border
    pop cx
   sub currenty,trackwidth
   dec currentx                           ;
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     skipL:
     ;;;;;;;;;;;;;;;;;;;;;;;;;
   


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
      jle terminateleft
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
     mov ax,currenty  ;y coordinate is row
     mul bx
     add ax,currentx    ;x coordinate is column 
     mov di,ax    ;di=(row*320)+column
    
     cmp cx,trackwidth

    jnz repeatL

   dec currentx     
   sub currenty,trackwidth
   
   inc si
   cmp si,sectionlength
  
   jnz drawleftpixel 
   inc numsectionsmoved

   terminateleft:
   ret
  

   drawleft endp


   drawup proc far

   cmp lastmove,3
   jz terminateup
   cmp sectionsupcount,0
   je terminateup
   cmp currenty,uplimit
   jle terminateup
   cmp lastmove,1
   jnz skip1
   
   add currenty,trackwidth-1
   skip1:
   cmp lastmove,2
   jz terminateup
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   push ax 
   mov ax, currenty
   sub currenty,trackwidth 
   mov trackcheck,0
   call checktrack
   cmp trackcheck,1

   mov currenty,ax 
   pop ax
   je terminateup
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
   
   mov ax,currenty
   mov bx,320d
   mul bx
   add ax,currentx;
   mov di,ax      ;di=(row*320)+column
   mov al,trackcolor ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;checkbounds 
       cmp currenty,uplimit
       jle terminateup
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       push ax
       mov ax,currenty
      sub currenty,trackwidth*2
      mov trackcheck,0
      call checktrack
      mov currenty,ax
      pop ax 
      cmp trackcheck,1
      je terminateup
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
   ;;;;;;;;;;;;;;;;;;;;;;;;;;
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
   jnz drawuppixel 
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

       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;procedures done;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 end main

