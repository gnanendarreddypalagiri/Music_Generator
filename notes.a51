
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
	


ORG 00H
	LJMP MAIN
ORG 000BH
	CPL P0.7;SQ_WAVE
	MOV TH0,@R0
	MOV TL0,@R1
	RETI
ORG 100H
	MAIN:
	 acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay
	  
	MOV A,#10000000B ;LINE1
	  ACALL lcd_command
	  ACALL delay
	  MOV   dptr,#my_string1
	  ACALL lcd_sendstring
	  ACALL delay
	  
	  
	MOV 40H,#0EEH
	MOV 30H,#3FH
	MOV 41H,#0F0H
	MOV 31H,#30H
	MOV 42H,#0F2H
	MOV 32H,#0B7H
	MOV 43H,#0F5H
	MOV 33H,#72H
	MOV 44H,#0F4H
	MOV 34H,#2AH
	AGAIN:
	MOV R0,#40H
	MOV R1,#30H
	SETB EA
	SETB ET0
	MOV TMOD,#00010001B;TIMER INITIAL
	;NOTE1 4545.45mc EE3F
	MOV TH0,@R0
	MOV TL0,@R1
	SETB TR0
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	
	INC R0;NOTE2
	INC R1
	MOV TH0,@R0
	MOV TL0,@R1
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	
	INC R0;NOTE3
	INC R1
	MOV TH0,@R0
	MOV TL0,@R1
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	
	DEC R0;NOTE2
	DEC R1
	MOV TH0,@R0
	MOV TL0,@R1
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	
	INC R0;NOTE4
	INC R0
	INC R1
	INC R1
	MOV TH0,@R0
	MOV TL0,@R1
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	
	CLR TR0;SILENCE
	CLR P0.7
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	
	MOV TH0,@R0;NOTE4
	MOV TL0,@R1
	SETB TR0
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	
	INC R0;NOTE5
	INC R1
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	ACALL DELAY_250MS
	
	SJMP AGAIN
	
	DELAY_250MS:
	MOV A,#10
	TP:
	MOV TH1,#3CH
	MOV TL1,#0B0H
	SETB TR1
	L12:JNB TF1,L12
	CLR TR1
	CLR TF1
	DEC A
	JNZ TP
	RET
	
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "  ROLLING TIME  ", 00H

	END