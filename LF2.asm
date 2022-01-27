INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data
titleStr BYTE "LOWER FLOOR 2",0	 ; 設置標題
lift_count BYTE 0 				 ; lift的控制

;模式一地圖
ceilings BYTE "VVVVVVVVVVVVVVVVVVVVVVVVVV|",0
voids BYTE "oooooooooooooooooooooooooo|",0
erasers BYTE "                          |",0
;地板長26格[0-25] 1 間格10格[0-9] 1 地板長26格[0-26](單人模式)
floor_1s BYTE "    TTT            TTT    |",0	;地板
floor_2s BYTE " TTT       TTT            |",0
floor_3s BYTE "       TTTTTTTT           |",0

type_0s BYTE  "    TTT            TTT    |",0	;範本
type_1s BYTE  " TTT       TTT            |",0
type_2s BYTE  "                 TTTTT    |",0
type_3s BYTE  " TT       TT         TT   |",0
type_4s BYTE  "       TTTTTTTT           |",0

strScore BYTE "Your score is: ",0
return_to_menu BYTE "Press any button to return to menu ...",0
score BYTE 0h

;模式二地圖
ceiling BYTE "VVVVVVVVVVVVVVVVVVVVVVVVVV|          |VVVVVVVVVVVVVVVVVVVVVVVVVV|",0 ;天花板，碰到就掛掉   遊戲框大小:26*13(高)
void BYTE "oooooooooooooooooooooooooo|          |oooooooooooooooooooooooooo|",0    ;虛空，掉下去就掛掉
eraser BYTE "                          |          |                          |",0  ;白板
;地板長26格[0-25] 1 間格10格[0-9] 1 地板長26格[0-26](雙人模式)
floor_1 BYTE "    TTT            TTT    |          |    TTT            TTT    |",0 ;地板，可以踩
floor_2 BYTE " TTT       TTT            |          | TTT       TTT            |",0
floor_3 BYTE "       TTTTTTTT           |          |       TTTTTTTT           |",0

type_0 BYTE  "    TTT            TTT    |          |    TTT            TTT    |",0  ;地板的範本
type_1 BYTE  " TTT       TTT            |          | TTT       TTT            |",0
type_2 BYTE  "                 TTTTT    |          |                 TTTTT    |",0
type_3 BYTE  " TT       TT         TT   |          | TT       TT         TT   |",0
type_4 BYTE  "       TTTTTTTT           |          |       TTTTTTTT           |",0

;模式三地圖


Arrow BYTE "=>",0
empty_arrow BYTE "  ",0

player1 BYTE "X",0
player2 BYTE "X",0

bullet1_flag BYTE 0
bullet2_flag BYTE 0

bullet1x BYTE 0
bullet1y BYTE 0
bullet1_count BYTE 0

bullet2x BYTE 0
bullet2y BYTE 0
bullet2_count BYTE 0


splitline BYTE      "===============================================",0
;開頭畫面
welcome_screen BYTE "     ##     #####  ##  ##  ##  ######  #####   "
			   BYTE "    ##     ##  #  ##  ##  ##  ##      ##  ##   "
			   BYTE	"   ##     ##  #  ##  ##  ##  ####    #####     "
			   BYTE	"  ##     ##  #  ##  ##  ##  ##      ##   #     "
			   BYTE	" #####  #####   ########   ######  ##   #      "
			   BYTE "                                               "
			   BYTE "     #####  ##    #####  #####  #####    ##### "
			   BYTE "    ##     ##    ##  #  ##  #  ##  ##      ##  "
			   BYTE "   #####  ##    ##  #  ##  #  #####     ####   "
			   BYTE "  ##     ##    ##  #  ##  #  ##   #    ##      "
			   BYTE " ##     ####  #####  #####  ##   #    #####    ",0

;選單製作
Option_screen BYTE "   ***   ====  Please Select Mode  ====   ***  "
			  BYTE "   ***      ###  Classic  Mode  ###       ***  "
		      BYTE "   ***       ###  Battle Mode  ###        ***  "
			  BYTE "   ***        ###   BNB Mode  ###         ***  ",0
;規則
rule1	BYTE "                                              "
		BYTE "                                              "
		BYTE "                                              "
		BYTE "                                              "
		BYTE "     # Use A to go left, D to go right        "
		BYTE "                                              "
		BYTE " # The ceiling is dangerous, don't reach it ! "
		BYTE "                                              "
		BYTE " # Gravity is activated, watch your steps !   "
		BYTE "                                              "
		BYTE "         Press any key to start ...           ",0

rule2	BYTE "                                              "
		BYTE "     # For Player1, use A & D to move         "
		BYTE "  # Use W to shoot a bullet to your opponent  "
		BYTE "                                              "
		BYTE "     # For Player2, use 4 & 6 to move         "
		BYTE "  # Use 8 to shoot a bullet to your opponent  "
		BYTE "                                              "
		BYTE "    # You are not able to cross the map !     "
		BYTE "                                              "
		BYTE " # If you touch the ceiling or abyss, you die!"
		BYTE " # Gravity is activated, watch your steps !   "
		BYTE "                                              "
		BYTE "         Press any key to start ...           ",0




;結束訊息
DeadMsg_1 BYTE "HA.. HA.. Player2 Win!",0
DeadMsg_2 BYTE "HA.. HA.. Player1 Win!",0
dead_flag BYTE 0

bullet1 BYTE "-",0
bullet2 BYTE "-",0



;Hello Initialization
game_flag BYTE 0

;Arrow Initialization
arrowx BYTE 0
arrowy BYTE 14

;Player Initialization
player1x BYTE 5
player1y BYTE 3
player2x BYTE 43
player2y BYTE 3

;Ceil Initialization
ceilposx BYTE 0
ceilposy BYTE 0

;Ground Initialization
voidposx BYTE 0
voidposy BYTE 13

f1_posx BYTE 0
f1_posy BYTE 4

f2_posx BYTE 0
f2_posy BYTE 8

f3_posx BYTE 0
f3_posy BYTE 12

gravity_bool BYTE 0 	;單人模式
gravity_bool_1 BYTE 0	;雙人模式
gravity_bool_2 BYTE 0
gravity_count BYTE 0

.code
;========================================這裡是模式一:單人模式===============================================

write_screen_s PROC
	mov ecx,12
	L1s:
		mov dl, 0
		mov dh, cl
		call Gotoxy
		mov edx, OFFSET erasers
		call WriteString
	LOOP L1s

;There is for Floor-GOTO<dl,dh>
	mov dl,f1_posx
	mov dh,f1_posy
	call Gotoxy
	mov edx, OFFSET floor_1s
	call WriteString

	mov dl,f2_posx
	mov dh,f2_posy
	call Gotoxy
	mov edx, OFFSET floor_2s
	call WriteString

	mov dl,f3_posx
	mov dh,f3_posy
	call Gotoxy
	mov edx, OFFSET floor_3s
	call WriteString

;There is for Player1(Green)-GOTO<dl,dh>
	mov   eax , green + ( black*16 )
    call    SetTextColor

	mov dl, player1x
	mov dh, player1y
	call Gotoxy
	mov edx, OFFSET player1
	call WriteString

;There is for Ceil(Red)-GOTO<dl,dh>
	mov   eax , red + ( black*16 )
    call    SetTextColor

	mov dl, ceilposx
	mov dh, ceilposy
	call Gotoxy
	mov edx, OFFSET ceilings
	call WriteString

;There is for Void(Purple)-GOTO<dl,dh>
	mov   eax , 5
    call    SetTextColor

	mov dl,voidposx
	mov dh,voidposy
	call Gotoxy
	mov edx, OFFSET voids
	call WriteString
;Other Score
	mov   eax , white + ( black*16 )
    call    SetTextColor

	mov dl,30
	mov dh,5
	call Gotoxy
	mov edx,OFFSET strScore
	call WriteString
	movzx eax, score
	call WriteDec

	ret
write_screen_s ENDP

areyoudead_s PROC
	mov al, player1y
	cmp al, 0
	je DEADs
	cmp al, 13
	je DEADs
	ret
	DEADs:
		mov dl,3
		mov dh,15
		call Gotoxy
		mov edx, OFFSET return_to_menu
		call WriteString
		call ReadChar
		call Clrscr
		mov dead_flag, 1
		ret
		
areyoudead_s ENDP

scroll_down_s PROC
	mov bl, 30
	mov bh, score
	cmp bh, 27  			;設定最高難度
	jb NORMALs
	mov bl,3
	jmp NEXTs
	NORMALs:
	sub bl, bh				;調整難度提升
	jmp NEXTs
	NEXTs: 
	mov al, lift_count
	cmp al, bl
	ja GOs
	inc al
	mov lift_count, al
	ret

	GOs:
	mov al, 0
	mov lift_count, al 		;reset lift count
	mov ah, 1

	call floor_RD

	cmp ah,f1_posy
	je newf1s

	cmp ah, f2_posy
	je newf2s

	cmp ah, f3_posy
	je newf3s

	jmp lifts

	newf1s:
		mov al, score	; update score
		add al, 1
		mov score, al
		mov al, 13
		mov f1_posy, al
		mov ecx, 26
		mov esi, edi
		mov edi, OFFSET floor_1s  ;隨機選取新的地板樣式
		
		cld
		rep movsb

		jmp lifts
	newf2s:
		mov al, score	; update score
		add al, 1
		mov score, al
		mov al, 13
		mov f2_posy, al
		mov ecx, 26
		mov esi, edi
		mov edi, OFFSET floor_2s ;隨機選取新的地板樣式

		cld
		rep movsb

		jmp lifts
	newf3s:
		mov al, score	; update score
		add al, 1
		mov score, al
		mov al, 13
		mov f3_posy, al
		mov ecx, 26
		mov esi, edi
		mov edi, OFFSET floor_3s  ;隨機選取新的地板樣式

		cld
		rep movsb

		jmp lifts
	
	lifts:
		mov al, gravity_bool
		cmp al, 0
		je FLOOR_UPs
		mov al, player1y
		dec al
		mov player1y, al

		FLOOR_UPs:
			mov al,f1_posy
			sub al,1
			mov f1_posy,al
			mov al,f2_posy
			sub al,1
			mov f2_posy,al
			mov al,f3_posy
			sub al,1
			mov f3_posy,al
			ret

scroll_down_s ENDP

gravity_s PROC
	mov al, player1y
	inc al
	cmp al, f1_posy
	je ON1s
	cmp al, f2_posy
	je ON2s
	cmp al, f3_posy
	je ON3s
	mov ah, 0
	mov gravity_bool, ah
	jmp NORMALs

	ON1s:
		movzx eax, player1x
		mov bh, floor_1s[eax]
		.IF bh == 54h
			mov ah, 1
			mov gravity_bool, ah
		.ELSE
			jmp NORMALs
		.ENDIF
		ret
	ON2s:
		movzx eax, player1x
		mov bh, floor_2s[eax] 
		.IF bh == 54h
			mov ah, 1
			mov gravity_bool, ah
		.ELSE
			jmp NORMALs
		.ENDIF
		ret
	ON3s:
		movzx eax, player1x
		mov bh, floor_3s[eax] 
		.IF bh == 54h
			mov ah, 1
			mov gravity_bool, ah
		.ELSE
			jmp NORMALs
		.ENDIF
		ret

	NORMALs:
		mov al, gravity_count
		cmp al, 7  				;落下速度
		je GOs
		inc al
		mov gravity_count, al
		ret

		GOs:
			mov al, 0
			mov gravity_count, al
			mov al, player1y
			inc al
			mov player1y, al
			ret

gravity_s ENDP

action_s PROC
	mov eax,2h
	call delay

	mov al,0
	call ReadKey
	cmp al, 61h        
    je LEFTs
	cmp al, 64h
	je RIGHTs
	ret

	LEFTs:
		mov al, player1x
		cmp al, 0
		je LWALLs
		dec player1x
		ret
		LWALLs:
			ret
		
	RIGHTs:
		mov al, player1x
		cmp al, 26
		je RWALLs
		inc player1x
		ret
		RWALLs:
			ret

action_s ENDP


;========================================這裡是模式二:雙人模式===============================================

floor_RD PROC
;Random the floor
	call Randomize
	mov  eax,5     	 ;get random 0 to 4
	call RandomRange
	.IF eax == 0
		mov edi, OFFSET type_0
	.ELSEIF eax == 1
		mov edi, OFFSET type_1
	.ELSEIF eax == 2
		mov edi, OFFSET type_2
	.ELSEIF eax == 3
		mov edi, OFFSET type_3
	.ELSEIF eax == 4
		mov edi, OFFSET type_4
	.ENDIF
	ret
	
floor_RD ENDP

write_screen PROC

	mov ecx,12
	L1:
		mov dl, 0
		mov dh, cl
		call Gotoxy
		mov edx, OFFSET eraser
		call WriteString
	LOOP L1

;There is for Floor-GOTO<dl,dh>
	mov dl,f1_posx					
	mov dh,f1_posy					
	call Gotoxy
	mov edx, OFFSET floor_1
	call WriteString

	mov dl,f2_posx
	mov dh,f2_posy
	call Gotoxy
	mov edx, OFFSET floor_2
	call WriteString

	mov dl,f3_posx
	mov dh,f3_posy
	call Gotoxy
	mov edx, OFFSET floor_3
	call WriteString

;There is for Player1(Green)-GOTO<dl,dh>
	mov   eax , green + ( black*16 )
    call    SetTextColor

	mov dl, player1x
	mov dh, player1y
	call Gotoxy
	mov edx, OFFSET player1
	call WriteString

;There is for Player2(Pink)-GOTO<dl,dh>
	mov   eax , blue + ( black*16 )
    call    SetTextColor

	mov dl, player2x
	mov dh, player2y
	call Gotoxy
	mov edx, OFFSET player2
	call WriteString


;There is for Ceil(Red)-GOTO<dl,dh>
	mov   eax , red + ( black*16 )
    call    SetTextColor

	mov dl, ceilposx
	mov dh, ceilposy
	call Gotoxy
	mov edx, OFFSET ceiling
	call WriteString

;There is for Ground(Purple)-GOTO<dl,dh>
	mov   eax , 5
    call    SetTextColor

	mov dl,voidposx
	mov dh,voidposy
	call Gotoxy
	mov edx, OFFSET void
	call WriteString

;draw the bullets
	.IF bullet1_flag == 1
		mov   eax , green + ( black*16 )
		call    SetTextColor

		mov dl, bullet1x
		mov dh, bullet1y
		call Gotoxy
		mov edx, OFFSET bullet1
		call WriteString
	.ENDIF
	.IF bullet2_flag == 1
		mov   eax , green + ( black*16 )
		call    SetTextColor

		mov dl, bullet2x
		mov dh, bullet2y
		call Gotoxy
		mov edx, OFFSET bullet2
		call WriteString
	
	.ENDIF

;Reset the Text color
	mov   eax , white + ( black*16 )
    call    SetTextColor

	ret
write_screen ENDP


action1 PROC
;Players Controll
	mov eax,2h
	call delay
	mov al,0						 
	call ReadKey

;P1: a/A=Left and d/D=Right					 
	.IF al == 61h || al == 41h		 
		jmp LEFT1        
	.ELSEIF al == 64h || al == 44h
		jmp RIGHT1
	.ELSEIF al ==57h || al == 77h
		jmp BULLET_1
;P2: 4=Left and 6=Right
	.ELSEIF al == 34h
		jmp LEFT2
	.ELSEIF al == 36h
		jmp RIGHT2
	.ELSEIF al == 38h
		jmp BULLET_2
	.ELSE
		ret
	.ENDIF
;There is P1 for move and check bound(WALL)
	LEFT1:
		mov al, player1x
		cmp al, 0
		je LWALL1
		dec player1x
		ret
		LWALL1:
			ret
		
	RIGHT1:
		mov al, player1x
		cmp al, 26
		je RWALL1
		inc player1x
		ret
		RWALL1:
			ret

	BULLET_1:
		.IF bullet1_flag == 0  ;沒有在飛
			mov al, 1
			mov bullet1_flag, al
			mov al, player1x
			inc al
			mov bullet1x, al
			mov al, player1y
			mov bullet1y, al
		.ENDIF
		ret


;There is P2 for move and check bound(WALL)
	LEFT2:
		mov al, player2x
		cmp al, 38
		je LWALL2
		dec player2x
		ret
		LWALL2:
			ret
		
	RIGHT2:
		mov al, player2x
		cmp al, 63
		je RWALL2
		inc player2x
		ret
		RWALL2:
			ret
	
	BULLET_2:
		.IF bullet2_flag == 0   ;沒有在飛
			mov al, 1
			mov bullet2_flag, al
			mov al, player2x
			dec al
			mov bullet2x, al
			mov al, player2y
			mov bullet2y, al
		.ENDIF
		ret


action1 ENDP

bullet_procedure PROC          ;子彈的飛行判斷
	.IF bullet1_flag == 1
		.IF bullet1x >= 0 && bullet1x <= 63
			mov al, bullet1_count
			inc al
			mov bullet1_count, al
			.IF al >= 5        ;子彈速度
				mov al, 0
				mov bullet1_count, al
				mov al, bullet1x
				inc al
				mov bullet1x, al
			.ENDIF
		.ELSE
			mov al, 0
			mov bullet1_flag, al
		.ENDIF
	.ENDIF
	.IF bullet2_flag == 1
		.IF bullet2x >= 0 && bullet2x <= 63
			mov al, bullet2_count
			inc al
			mov bullet2_count, al
			.IF al >= 5        ;子彈速度
				mov al, 0
				mov bullet2_count, al
				mov al, bullet2x
				dec al
				mov bullet2x, al
			.ENDIF
		.ELSE
			mov al, 0
			mov bullet2_flag, al
		.ENDIF
	.ENDIF
	ret
bullet_procedure ENDP

gravity1 PROC
;Check is on Floor(先看高度)
	mov al, player1y
	inc al
	cmp al, f1_posy
	je ON1
	cmp al, f2_posy
	je ON2
	cmp al, f3_posy
	je ON3
	mov ah, 0
	mov gravity_bool_1, ah
	jmp NORMAL
;ON Floor1(再看有沒有在有的板子上)
	ON1:
		movzx eax, player1x
		mov bh, floor_1[eax]
		.IF bh == 54h			;54h(T)
			mov ah, 1
			mov gravity_bool_1, ah
		.ELSE
			jmp NORMAL
		.ENDIF
		ret
;ON Floor2
	ON2:
		movzx eax, player1x
		mov bh, floor_2[eax] 
		.IF bh == 54h
			mov ah, 1
			mov gravity_bool_1, ah
		.ELSE
			jmp NORMAL
		.ENDIF
		ret
;ON Floor3
	ON3:
		movzx eax, player1x
		mov bh, floor_3[eax] 
		.IF bh == 54h
			mov ah, 1
			mov gravity_bool_1, ah
		.ELSE
			jmp NORMAL
		.ENDIF
		ret
;NOT ON Floor(落下速度在這裡控制)
	NORMAL:
		mov al, gravity_count
		cmp al, 30  					;落下速度
		je GO
		inc al
		mov gravity_count, al
		ret

		GO:
			mov al, 0
			mov gravity_count, al
			mov al, player1y
			inc al
			mov player1y, al
			ret

gravity1 ENDP

gravity2 PROC
;Check is on Floor
	mov al, player2y
	inc al
	cmp al, f1_posy
	je ON1
	cmp al, f2_posy
	je ON2
	cmp al, f3_posy
	je ON3
	mov ah, 0
	mov gravity_bool_2, ah
	jmp NORMAL2
;ON Floor1
	ON1:
		movzx eax, player2x
		mov bh, floor_1[eax]
		.IF bh == 54h
			mov ah, 1
			mov gravity_bool_2, ah
		.ELSE
			jmp NORMAL2
		.ENDIF
		ret
;ON Floor2
	ON2:
		movzx eax, player2x
		mov bh, floor_2[eax] 
		.IF bh == 54h
			mov ah, 1
			mov gravity_bool_2, ah
		.ELSE
			jmp NORMAL2
		.ENDIF
		ret
;ON Floor3
	ON3:
		movzx eax, player2x
		mov bh, floor_3[eax] 
		.IF bh == 54h
			mov ah, 1
			mov gravity_bool_2, ah
		.ELSE
			jmp NORMAL2
		.ENDIF
		ret
;NOT ON Floor(落下速度在這裡控制)
	NORMAL2:
		mov al, gravity_count
		cmp al, 30  					;落下速度
		je GO2
		inc al
		mov gravity_count, al
		ret

		GO2:
			mov al, 0
			mov gravity_count, al
			mov al, player2y
			inc al
			mov player2y, al
			ret

gravity2 ENDP


scroll_down PROC
	
	mov bl, 30          ;難度
	mov al, lift_count
	cmp al, bl
	ja GO
	inc al
	mov lift_count, al
	ret

	GO:
	mov al, 0
	mov lift_count, al 		;reset lift count
	mov ah, 1

;隨機地板
	call floor_RD

	cmp ah,f1_posy
	je newf1

	cmp ah, f2_posy
	je newf2

	cmp ah, f3_posy
	je newf3

	jmp lift

	newf1:
		mov al, 13
		mov f1_posy, al
		mov ecx, 65
		mov esi, edi
		mov edi, OFFSET floor_1  ;隨機選取新的地板樣式
		cld
		rep movsb
		jmp lift

	newf2:
		mov al, 13
		mov f2_posy, al
		mov ecx, 65
		mov esi, edi
		mov edi, OFFSET floor_2 ;隨機選取新的地板樣式
		cld
		rep movsb
		jmp lift
		
	newf3:
		mov al, 13
		mov f3_posy, al
		mov ecx, 65
		mov esi, edi
		mov edi, OFFSET floor_3  ;隨機選取新的地板樣式
		cld
		rep movsb

		jmp lift
		
	lift:
		mov al, gravity_bool_1
		cmp al, 0
		je lift2

;p1 up
		mov al, player1y
		dec al
		mov player1y, al

    lift2:
		mov al, gravity_bool_2
		cmp al, 0
		je FLOOR_UP

;p2 up		
		mov al, player2y
		dec al
		mov player2y, al

		FLOOR_UP:
			mov al,f1_posy
			sub al,1
			mov f1_posy,al
			mov al,f2_posy
			sub al,1
			mov f2_posy,al
			mov al,f3_posy
			sub al,1
			mov f3_posy,al
			ret

scroll_down ENDP

areyoudead PROC
;ENDGame Ceil.y=0 void.y=13
	mov al, player1y
	mov dl, player2y
	mov dead_flag, 0
	.IF al == 0 || al == 13
		mov dead_flag, 1
		je DEAD
	.ELSEIF dl == 0 || dl == 13
		mov dead_flag, 2
		je DEAD
	.ENDIF

	mov al, bullet1x         ;子彈1 VS 玩家2
	mov ah, bullet1y
	mov bl, player2x
	mov bh, player2y

	.IF al == bl && ah == bh
		mov dead_flag, 2
		jmp DEAD
	.ENDIF
	
	mov al, bullet2x         ;子彈2 VS 玩家1
	mov ah, bullet2y
	mov bl, player1x
	mov bh, player1y

	.IF al == bl && ah == bh
		mov dead_flag, 1
		jmp DEAD
	.ENDIF

	ret
	DEAD:
		mov dl, 20
		mov dh, 16
		call Gotoxy
		.IF dead_flag == 1
			mov edx, OFFSET DeadMsg_1
		.ELSEIF dead_flag == 2
			mov edx, OFFSET DeadMsg_2
		.ENDIF
		call WriteString
		call Crlf
		call ReadChar
		call Clrscr
		ret
		
areyoudead ENDP


User_motion PROC
	mov eax,2h
	call delay
	mov al,0						 
	call ReadChar

	mov dl, arrowx
	mov dh, arrowy
	call Gotoxy
	mov edx, OFFSET empty_arrow
	call WriteString

	.IF al == 20h && arrowy == 14
		mov game_flag, 1
		ret
	.ELSEIF al == 20h && arrowy == 15
		mov game_flag, 2
		ret
	.ELSEIF al == 20h && arrowy == 16
		mov game_flag, 3
		ret
	.ENDIF
	
;MOVE Arrow
	.IF al == 57h || al == 77h		 
		je UP1        
	.ELSEIF al == 53h || al == 73h
		je DOWN1
	.ELSE
		ret
	.ENDIF

	UP1:
		mov al, arrowy
		cmp al, 14
		je GoTOP
		dec arrowy
		ret
		GoTOP:
			mov arrowy, 16
			ret
		
	DOWN1:
		mov al, arrowy
		cmp al, 16
		je GoDown
		inc arrowy
		ret
		GoDown:
			mov arrowy, 14
			ret
User_motion ENDP

rule_1 PROC
		mov   eax , white + ( black*16 )
		call    SetTextColor
		mov edi, OFFSET rule1
		mov ecx, 11
			L3:
				push ecx
				mov ecx, 46
				L4:
					mov eax,[edi]
					call WriteChar
					inc edi
					LOOP L4
				pop ecx
				call Crlf
				LOOP L3
		call Crlf
		call ReadChar
		call Clrscr
		ret
rule_1 ENDP

rule_2 PROC
		mov   eax , white + ( black*16 )
		call    SetTextColor
		mov edi, OFFSET rule2
		mov ecx, 13
			La3:
				push ecx
				mov ecx, 46
				La4:
					mov eax,[edi]
					call WriteChar
					inc edi
					LOOP La4
				pop ecx
				call Crlf
				LOOP La3
		call Crlf
		call ReadChar
		call Clrscr
		ret
rule_2 ENDP



start@0 PROC

	BEGIN:
		INVOKE SetConsoleTitle, ADDR titleStr

		call Clrscr
		mov   eax , yellow + ( black*16 )
		call    SetTextColor
		mov edx, OFFSET splitline
		call WriteString
		call Crlf

;Welcome	
		mov   eax , green + ( black*16 )
		call    SetTextColor
		mov edi, OFFSET welcome_screen
		mov ecx, 11
			L1:
				push ecx
				mov ecx, 47
				L2:
					mov eax,[edi]
					call WriteChar
					inc edi
					LOOP L2
				pop ecx
				call Crlf
				LOOP L1
		call Crlf
	
;Option
		mov   eax , cyan + ( black*16 )
		call    SetTextColor
		mov edi, OFFSET Option_screen
		mov ecx, 4
			L5:
				push ecx
				mov ecx, 47
				L6:
					mov eax,[edi]
					call WriteChar
					inc edi
					LOOP L6
				pop ecx
				call Crlf
				LOOP L5
		call Crlf

;Other
		mov   eax , yellow + ( black*16 )
		call    SetTextColor
		mov edx, OFFSET splitline
		call WriteString
		call Crlf

		mov   eax , red + ( black*16 )
		call    SetTextColor

		mov dl, arrowx
		mov dh, arrowy
		call Gotoxy
		mov edx, OFFSET Arrow
		call WriteString

;Choice
		choice:
			call User_motion
			
			mov   eax , red + ( black*16 )
			call    SetTextColor

			mov dl, arrowx
			mov dh, arrowy
			call Gotoxy
			mov edx, OFFSET Arrow
			call WriteString
			
			.IF game_flag == 1
				mov game_flag, 0
				mov player1x, 5
				mov player1y, 3
				call Clrscr
				call rule_1
				jmp game1
			.ELSEIF game_flag ==2
				mov game_flag, 0
				call Clrscr
				mov player1x, 5
				mov player1y, 3
				mov player2x, 43
				mov player2y, 3
				call Clrscr
				call rule_2
				jmp game2
			.ELSEIF game_flag == 3
				mov game_flag, 0
				call Clrscr
				mov player1x, 5
				mov player1y, 3
				mov player2x, 43
				mov player2y, 3
				call Clrscr
				call rule_1
				jmp game3
			.ELSE
				jmp choice
			.ENDIF


;Start Game

		game1:
			call action_s
			call scroll_down_s
			call gravity_s
			call areyoudead_s
			.IF dead_flag != 0
				mov dead_flag, 0
				jmp BEGIN
			.ENDIF
			call write_screen_s
			jmp game1
		
		game2:
			call action1
			call bullet_procedure
			call scroll_down
			call gravity1
			call gravity2
			call areyoudead
			.IF dead_flag != 0
				mov dead_flag, 0
				jmp BEGIN
			.ENDIF
			call write_screen
			jmp game2
		
		game3:
			call action1
			call bullet_procedure
			call scroll_down
			call gravity1
			call gravity2
			call areyoudead
			.IF dead_flag != 0
				mov dead_flag, 0
				jmp BEGIN
			.ENDIF
			call write_screen
			jmp game3
	
start@0 ENDP

END start@0
