REM i-kaktusss morse keyer, beacon and morse trainer, PicAXE BASIC version
REM program slot 3 code for 28x2 PicAXE
REM Copyright (C) 2012  Erich Heinzle VK5HSE

REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU Affero General Public License as
REM published by the Free Software Foundation, either version 3 of the
REM License, or (at your option) any later version.

REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU Affero General Public License for more details.

REM You should have received a copy of the GNU Affero General Public License
REM along with this program.  If not, see <http://www.gnu.org/licenses/>.

REM Slot 3 will contain PS/2 keyboard related code
REM Slots share EEPROM but not Table data
REM or subroutines.
REM So, we need a copy of the Table in each Slot
REM and also copies of the necessary subroutines
REM in each slot


#slot 3
#no_data	REM we don't want to blitz slot 0's EEPROM

REM the table stores characters, with sets of 4 table bytes allocated as follows
REM  
REM   for character number n in the array, where n = 0,4,8,....,212
REM 
REM   location n: 	XXXXaaaa	LSB aaaa define portA outputs (low = LED on)
REM   					MSB XXXX gives number of morse elements
REM   						i.e. %01000000 = 4 = dah-di-di-dit = B
REM   						i.e. %00100000 = 2 = dah-dit = N
REM   						i.e. %00010000 = 1 = dah = T
REM 						we can use the 4 MSB for this as portA only
REM 						needs the 4 LSB for its 4 output pins
REM   location n+1:	bbbbbbbb	all 8 bits define portB outputs (low = LED on)
REM   location n+2:	XXXccccc	5 LSB define portC outputs (low = LED on)
REM   					3 MSB XXX unused for now
REM   location n+3:	YYYYYYYY    8 bits YYYYYYYY define sequence, LSB->MSB
REM   						0 = dit
REM   						1 = dah
REM   					i.e 00000001 = dah-di-di-di-di-di-di-dit
REM 
REM  						for shorter chars, MSB 3 bits contain length
REM 						as well
REM 
REM Pin allocations from 28X2 to AUR20A common anode display are shown below
REM These came about as a result of what seemed easiest to route on the PCB
REM Pin allocation changes would necessitate appropriate bit swapping 
REM in the character allocation table
REM Use of a common cathode display would simply require inversion of the bits
REM such that high = LED on rather than low = LED on
REM Probably best to sink rather than source current however, so common anode
REM alphanumeric display preferable.
REM 
REM        XXc4XX XXb4XX
REM       XX     X     XX
REM       X	X    X    X X
REM       X	 X   c0  X  X
REM       c2  c1 X  b5  b6
REM       X	   X X X    X
REM       X	    XXX     X
REM        XXc3XX XXb7XX
REM       X	    XXX     X
REM       X	   X X X    X
REM       b2  b1 X  a3  a2
REM       X	 X   b0  X  X
REM       X	X    X    X X
REM       XX     X     XX
REM        XXb3XX XXa0XX    Xa1X
REM 
REM 
REM Pin allocations chosen to preserve digital IO/touch/PS2 keyboard options
REM on portC6 and portC7 pins for easy iambic keyer/straight keyer/touch keyer
REM or PS2 keyboard use for morse input
REM Pin portc5 used for menu button
REM Pin porta4 (serial out) used for piezo speaker
REM 16MHz Crystal fitted.
REM 
REM Table entries from 216... 251 contain a squence of 8 bit binary value,
REM which are the index into the preceding character table of each letter
REM in the stored message:
REM 
REM "THEQUICKBROWNFOXJUMPSOVERTHELAZYDOGS'
REM 
REM 

 TABLE 0,(%00101011,%00101011,%11100011,%01000010)    REM A
 TABLE 4,(%01001010,%00100110,%11101110,%10000001)    REM B
 TABLE 8,(%01001110,%11100011,%11101011,%10000101)    REM C
 TABLE 12,(%00111010,%10100110,%11101110,%01100001)   REM D
 TABLE 16,(%00011110,%11100011,%11100011,%00100000)   REM E
 TABLE 20,(%01001111,%11101011,%11100011,%10000100)   REM F
 TABLE 24,(%00111010,%01100011,%11101011,%01100011)   REM G
 TABLE 28,(%01001011,%00111011,%11110011,%10000000)   REM H
 TABLE 32,(%00101110,%11100110,%11101110,%01000000)   REM I
 TABLE 36,(%01001111,%11100010,%11101110,%10001110)   REM J
 TABLE 40,(%00110111,%11011011,%11110011,%01100101)   REM K
 TABLE 44,(%01001110,%11110011,%11111011,%10000010)   REM L
 TABLE 48,(%00101011,%10011011,%11111001,%01000011)   REM M
 TABLE 52,(%00100011,%10111011,%11111001,%01000001)   REM N
 TABLE 56,(%00111010,%10100011,%11101011,%01100111)   REM O
 TABLE 60,(%01001111,%00101011,%11100011,%10000110)   REM P 
 TABLE 64,(%01000010,%10100011,%11101011,%10001011)   REM Q
 TABLE 68,(%00110111,%11001011,%11100011,%01100010)   REM R
 TABLE 72,(%00111010,%01100111,%11100011,%01100000)   REM S
 TABLE 76,(%00011111,%11101110,%11101110,%00100001)   REM T
 TABLE 80,(%00111010,%10110011,%11111011,%01100100)   REM U
 TABLE 84,(%01001111,%11011001,%11111011,%10001000)   REM V
 TABLE 88,(%00110011,%10111001,%11111011,%01100110)   REM W
 TABLE 92,(%01000111,%11011101,%11111101,%10001001)   REM X
 TABLE 96,(%01001111,%11011110,%11111101,%10001101)   REM Y 
 TABLE 100,(%01001110,%11000101,%11101111,%10000011)  REM Z
 TABLE 104,(%01011010,%10000001,%11101011,%10111111)  REM 0
 TABLE 108,(%01011011,%10111111,%11111111,%10111110)  REM 1
 TABLE 112,(%01011110,%00100011,%11100111,%10111100)  REM 2
 TABLE 116,(%01011010,%00100111,%11101111,%10111000)  REM 3 
 TABLE 120,(%01011011,%00111111,%11110011,%10110000)  REM 4
 TABLE 124,(%01010110,%11100111,%11100011,%10100000)  REM 5
 TABLE 128,(%01011010,%01100011,%11100011,%10100001)  REM 6
 TABLE 132,(%01011011,%10101111,%11101111,%10100011)  REM 7
 TABLE 136,(%01011010,%00100011,%11100011,%10100111)  REM 8
 TABLE 140,(%01011010,%00100111,%11100011,%10101111)  REM 9
 TABLE 144,(%01101101,%10111111,%11111111,%00110101)  REM ! "KW" using DP for dot
'TABLE 144,(%01101101,%10111111,%11111111,%00000111)  REM ! using landline US "MN"
 TABLE 148,(%01101111,%10111111,%11111110,%00010010)  REM "
 TABLE 152,(%01111010,%01100110,%11100010,%01001000)  REM $ (evolved from SX)
 TABLE 156,(%01011010,%11000100,%11111110,%00000010)  REM & (ampersand AS not US ES)
 TABLE 160,(%01101111,%11011111,%11111111,%00011110)  REM ' (apostrophe)
 TABLE 164,(%01010111,%11011111,%11111111,%00001101)  REM ( (open bracket)
 TABLE 168,(%01101111,%11111101,%11111101,%00101101)  REM ) (close bracket)
 TABLE 172,(%01011111,%01111110,%11110110,%00001010)  REM + (plus)
 TABLE 176,(%01101111,%11111101,%11111111,%00110011)  REM , (comma)
 TABLE 180,(%01101111,%01111111,%11110111,%00100001)  REM - (hyphen or minus) 
 TABLE 184,(%01101101,%11111111,%11111111,%00101010)  REM . (period uses DP for dot)
 TABLE 188,(%01011111,%11011101,%11111111,%00001001)  REM / (slash or fraction)
 TABLE 192,(%01101111,%11111110,%11111110,%00000111)  REM : (colon)
 TABLE 196,(%01101111,%11111101,%11111110,%00010101)  REM ; (semicolon)
 TABLE 200,(%01011110,%01110111,%11110111,%00010001)  REM = (double dash)
 TABLE 204,(%01101101,%00101110,%11101111,%00111100)  REM ? (with DP)
 TABLE 208,(%01101110,%00100011,%11101010,%00010110)  REM @ (at)
 TABLE 212,(%01101110,%11110111,%11111111,%00101100)  REM _ (underscore)

TABLE 216,(%01001100,%00011100,%00010000,%01000000)  REM "THEQ" these are each
TABLE 220,(%01010000,%00100000,%00001000,%00101000)  REM "UICK" stored as the 
TABLE 224,(%00000100,%01000100,%00111000,%01011000)  REM "BROW" index into the 54
TABLE 228,(%00110100,%00010100,%00111000,%01011100)  REM "NFOX" character table 
TABLE 232,(%00100100,%01010000,%00110000,%00111100)  REM "JUMP" of characters
TABLE 236,(%01001000,%00111000,%01010100,%00010000)  REM "SOVE" immediately
TABLE 240,(%01000100,%01001100,%00011100,%00010000)  REM "RTHE" preceding, i.e.
TABLE 244,(%00101100,%00000000,%01100100,%01100000)  REM "LAZY" A = %00000000
TABLE 248,(%00001100,%00111000,%00011000,%01001000)  REM "DOGS' B = %00000100
TABLE 252,(%10001101,%00101110,%11101111,%00000000)  REM ? with DP + 8 error dits



REM 
REM now we move onto variable definitions; the variablea are a shared resource
REM across slots
REM 

let dirsA=%00001111	REM b0,b1,b2,b3 of PortA drive LEDs
				REM b4 or PortA drives piezo speaker + serial out
let dirsB=%11111111	REM all bits of PortB drive LEDs
let dirsC=%00011111	REM b0 of Port b0,b1,b2,b3,b4 of PortC drive LEDS
				REM and portC b5 for menu button/touch
				REM and portC b6&b7 for keyer/PS2/touch

symbol KOCH_ELEMENTS = b50	REM how many elements
symbol KOCH_MORSE = b49		REM what got keyed in
symbol KOCH_RIGHT = b48		REM for calculating success stats with Koch Method
symbol KOCH_WRONG = b47
symbol KOCH_NUMBER = b46	REM the number of chars being used for Koch training
symbol FROM_SLOTX = b45		REM a flag indicating which slot was just used
symbol DISPLAY_DURATION = b44		REM how long to display a char/tick/cross
symbol PIEZO = A.4
symbol MENU_BUTTON = pinC.5	
symbol PADDLE_1 = pinC.6	REM can double as PS2 - also touch without pullup
					REM left paddle = DIT for R handed people
symbol PADDLE_2 = pinC.7	REM can double as PS2 - also touch without pullup
					REM right paddle = DAH for R handed people
symbol WPM = b43
symbol SOUNDING = b42		REM a flag for muting sound for menu displays
symbol KEYER_MODE = b41
symbol MENU_BUTTON_FLAG = b40	REM has menu button been pressed flag
symbol LAST_DAH_FLAG = b38
symbol LAST_DIT_FLAG = b39
symbol NEXT_DIT_FLAG = b36
symbol NEXT_DAH_FLAG = b37

symbol COUNTERVAR1 = b35

symbol SOUND_FREQ = b33			REM to store the morse tone frequency ~110 OK
symbol INTER_LETTER_DELAY = b30 	REM will usually be a dit +/- farnsworth
symbol INTERWORD_DELAY = b32		REM will usually be seven dits +/- farnsworth
symbol INTER_ELEMENT_DELAY = b31 	REM will usually be a dit 
symbol DIT_SOUND_LENGTH = b28
symbol DAH_SOUND_LENGTH = b27
symbol KB_INPUT = b8			REM for PS2 input byte
symbol SHIFTED = b7			REM for PS2 keyboard shift key flag

symbol MORSE_BIT_MASK = b34	REM the bitmask used to encode the morse as binary
symbol ELEMENTS = b29		REM holds # of morse elements for a given char
symbol ASCII_CHAR = b6		REM for ASCII in text to be played
symbol LAST_CHAR = b5		REM in case we want to avoid duplicates
symbol MORSE = b4			REM byte that contains encoded morse elements
symbol PORT_C_LEDS = b3		REM with the 4MSB indicating number of morse chars		
symbol PORT_B_LEDS = b2
symbol PORT_A_LEDS = b1 
symbol CHAR_INDEX = b0		REM index into table storing morse characters

symbol WPM_5_DIT =  24 '240 REM these are the dit lengths in ms divided by 10
symbol WPM_10_DIT = 12 '120 REM would probably need changing if you run with 
symbol WPM_15_DIT = 8  '80  REM a crystal oscillator
symbol WPM_20_DIT = 6  '60
symbol WPM_25_DIT = 5  '48
symbol WPM_30_DIT = 4  '40
symbol FARNSWORTH_FACTOR = 10   REM 10 is minimum value for normal letter spacing

symbol SOUND_THEN_DRAW_DELAY = 500  REM how long between hearing it and seeing it
symbol MORSE_PITCH = 115  	REM 120~1000Hz 117~519 116~?
 					REM 115~782 114~1300 Hz 110~680 Hz 100~670






main:
	keyled %10000000
	select case KEYER_MODE
	case 7
		gosub ConvertPS2toCHAR_INDEX
	endselect

	if MENU_BUTTON_FLAG = 0 then
		let FROM_SLOTX = 3	REM menu button was pressed in slot 3
		run 0
	endif
	goto main


ConvertPS2toCHAR_INDEX:
	SHIFTED = 0
'	keyled %10000000
	let MENU_BUTTON_FLAG = MENU_BUTTON_FLAG and MENU_BUTTON 
		REM check if the menu button was pressed
	if MENU_BUTTON_FLAG = 0 then return endif 
	kbin [1000,ConvertPS2toCHAR_INDEX], KB_INPUT
	shiftcheck:
	if KB_INPUT = $12 or KB_INPUT = $59 then	REM has either shift key been pressed
		kbin [1000,ConvertPS2toCHAR_INDEX], KB_INPUT
		if KB_INPUT = $12 or KB_INPUT = $59 then goto shiftcheck REM debounce shift
		SHIFTED = 1
		let MENU_BUTTON_FLAG = MENU_BUTTON_FLAG and MENU_BUTTON 
			REM check if the menu button was pressed during SHIFT detection
		if MENU_BUTTON_FLAG = 0 then return endif 
	endif
	if KB_INPUT= $1C then let CHAR_INDEX = 0		REM A
	elseif KB_INPUT= $32 then let CHAR_INDEX = 4	REM B
	elseif KB_INPUT= $21 then let CHAR_INDEX = 8	REM C
	elseif KB_INPUT= $23 then let CHAR_INDEX = 12	REM D
	elseif KB_INPUT= $24 then let CHAR_INDEX = 16	REM E
	elseif KB_INPUT= $2B then let CHAR_INDEX = 20	REM F
	elseif KB_INPUT= $34 then let CHAR_INDEX = 24	REM G
	elseif KB_INPUT= $33 then let CHAR_INDEX = 28	REM H
	elseif KB_INPUT= $43 then let CHAR_INDEX = 32	REM I
	elseif KB_INPUT= $3B then let CHAR_INDEX = 36	REM J
	elseif KB_INPUT= $42 then let CHAR_INDEX = 40	REM K
	elseif KB_INPUT= $4B then let CHAR_INDEX = 44	REM L
	elseif KB_INPUT= $3A then let CHAR_INDEX = 48	REM M
	elseif KB_INPUT= $31 then let CHAR_INDEX = 52	REM N
	elseif KB_INPUT= $44 then let CHAR_INDEX = 56	REM O
	elseif KB_INPUT= $4D then let CHAR_INDEX = 60	REM P
	elseif KB_INPUT= $15 then let CHAR_INDEX = 64	REM Q
	elseif KB_INPUT= $2D then let CHAR_INDEX = 68	REM R
	elseif KB_INPUT= $1B then let CHAR_INDEX = 72	REM S
	elseif KB_INPUT= $2C then let CHAR_INDEX = 76	REM T
	elseif KB_INPUT= $3C then let CHAR_INDEX = 80	REM U
	elseif KB_INPUT= $2A then let CHAR_INDEX = 84	REM V
	elseif KB_INPUT= $1D then let CHAR_INDEX = 88	REM W
	elseif KB_INPUT= $22 then let CHAR_INDEX = 92	REM X
	elseif KB_INPUT= $35 then let CHAR_INDEX = 96	REM Y
	elseif KB_INPUT= $1A then let CHAR_INDEX = 100	REM Z

	elseif KB_INPUT= $70 then let CHAR_INDEX = 104	REM 0 KP
	elseif KB_INPUT= $69 then let CHAR_INDEX = 108	REM 1 KP
	elseif KB_INPUT= $72 then let CHAR_INDEX = 112	REM 2 KP
	elseif KB_INPUT= $7A then let CHAR_INDEX = 116	REM 3 KP
	elseif KB_INPUT= $6B then let CHAR_INDEX = 120	REM 4 KP
	elseif KB_INPUT= $73 then let CHAR_INDEX = 124	REM 5 KP
	elseif KB_INPUT= $74 then let CHAR_INDEX = 128	REM 6 KP
	elseif KB_INPUT= $6C then let CHAR_INDEX = 132	REM 7 KP
	elseif KB_INPUT= $75 then let CHAR_INDEX = 136	REM 8 KP
	elseif KB_INPUT= $7D then let CHAR_INDEX = 140	REM 9 KP
	elseif KB_INPUT= $79 then let CHAR_INDEX = 144	REM + KP
	elseif KB_INPUT= $7B then let CHAR_INDEX = 148	REM - KP
	elseif KB_INPUT= $49 or KB_INPUT= $71 then
					let CHAR_INDEX = 184	REM . and . KP
	elseif KB_INPUT= $41 then let CHAR_INDEX = 176	REM ,

	elseif KB_INPUT= $45 then
		if SHIFTED = 0 then let CHAR_INDEX = 104	REM 0
		else let CHAR_INDEX = 168			REM )
		endif
	elseif KB_INPUT= $16 then
		if SHIFTED = 0 then let CHAR_INDEX = 108	REM 1
		else let CHAR_INDEX = 144			REM !
		endif
	elseif KB_INPUT= $1E then
		if SHIFTED = 0 then let CHAR_INDEX = 112	REM 2
		else let CHAR_INDEX = 208 			REM @
		endif		
	elseif KB_INPUT= $26 then let CHAR_INDEX = 116	REM 3
	elseif KB_INPUT= $25 then
		if SHIFTED = 0 then let CHAR_INDEX = 120	REM 4
		else let CHAR_INDEX = 152			REM $
		endif
	elseif KB_INPUT= $2E then let CHAR_INDEX = 124	REM 5
	elseif KB_INPUT= $36 then let CHAR_INDEX = 128	REM 6
	elseif KB_INPUT= $3D then
		if SHIFTED = 0 then let CHAR_INDEX = 132	REM 7
		else let CHAR_INDEX = 156 			REM &
		endif
	elseif KB_INPUT= $3E then let CHAR_INDEX = 136	REM 8
	elseif KB_INPUT= $46 then
		if SHIFTED = 0 then let CHAR_INDEX = 140	REM 9
		else let CHAR_INDEX = 164			REM (
		endif
	elseif KB_INPUT= $55 then
		if SHIFTED = 0 then let CHAR_INDEX = 200	REM =
		else let CHAR_INDEX = 172			REM +
		endif
	elseif KB_INPUT= $4A then
		if SHIFTED = 0 then let CHAR_INDEX = 188	REM /
		else let CHAR_INDEX = 204			REM ?
		endif
	elseif KB_INPUT= $52 then
		if SHIFTED = 0 then let CHAR_INDEX = 160	REM '
		else let CHAR_INDEX = 148			REM "
		endif

	elseif KB_INPUT= $55 then
		if SHIFTED = 0 then let CHAR_INDEX = 200	REM =
		else let CHAR_INDEX = 172			REM +
		endif
	elseif KB_INPUT= $4E then
		if SHIFTED = 0 then let CHAR_INDEX = 180	REM -
		else let CHAR_INDEX = 212			REM _
		endif							
	elseif KB_INPUT= $4C then
		if SHIFTED = 0 then let CHAR_INDEX = 196	REM ;
		else let CHAR_INDEX = 192			REM :
		endif
		
	elseif KB_INPUT= $29 then
		pause INTERWORD_DELAY	REM SPACE = PAUSE
		let CHAR_INDEX = 216
	else let CHAR_INDEX = 216
	endif
	let MENU_BUTTON_FLAG = MENU_BUTTON_FLAG and MENU_BUTTON 
		REM check if the menu button was pressed
	if CHAR_INDEX < 216 then
		gosub GetCharacterData
		if MENU_BUTTON_FLAG = 0 then return endif REM check menu button status
		gosub DrawCharacter
		gosub GetCharacterData
		gosub SoundCharacter
	endif
'	keyled %10000000
'	return			
	goto ConvertPS2toCHAR_INDEX
	

REM the essential subroutines needed to get things done are as follows	

SoundThenDrawASCIIchar:
		REM convert ASCII A,B,...=65,66,.. into 0,1,..
		if ASCII_CHAR > 64 and ASCII_CHAR < 91 then
			let ASCII_CHAR = ASCII_CHAR - 65
		REM convert ASCII a,b,...=97,98,.. into 0,1,..
		elseif ASCII_CHAR > 96 and ASCII_CHAR < 123 then
			let ASCII_CHAR = ASCII_CHAR - 97
		REM if converted text is a number.... convert ASCII 108,... into 27,..
		elseif ASCII_CHAR > 47 and ASCII_CHAR < 58 then
			let ASCII_CHAR = ASCII_CHAR - 22
		REM if converted text is ! convert ASCII 33 ... into 36
		elseif ASCII_CHAR = 33 then
			let ASCII_CHAR = 36
		REM if converted text is " a.k.a. # convert ASCII 35 ... into 37
		REM this is a kludge because " cannot be put in the middle of
		REM a string without prematurely terminating it so we substitute
		REM # in the string for " since # has no morse equivalent
		elseif ASCII_CHAR = 35 then
			let ASCII_CHAR = 37
		REM if converted text is $ convert ASCII 36 ... into 38
		elseif ASCII_CHAR = 36 then
			let ASCII_CHAR = 38
		REM if converted text is & ' ( ) convert ASCII 38.... into 39...
		elseif ASCII_CHAR > 37 and ASCII_CHAR < 42 then
			let ASCII_CHAR = ASCII_CHAR + 1
		REM if converted text is + , - , / convert ASCII 43 ... into 43
		elseif ASCII_CHAR > 42 and ASCII_CHAR < 48 then
			let ASCII_CHAR = ASCII_CHAR  REM array and ascii are the same
		REM if converted text is : ; convert ASCII 58,59 ... into 48,49
		elseif ASCII_CHAR > 57 and ASCII_CHAR < 60 then
			let ASCII_CHAR = ASCII_CHAR - 10
		REM if converted text is = convert ASCII 61 ... into 50
		elseif ASCII_CHAR = 61 then
			let ASCII_CHAR = 50
		REM if converted text is ? @ convert ASCII 63,64 ... into 51,52
		elseif ASCII_CHAR > 62 and ASCII_CHAR < 65 then
			let ASCII_CHAR = ASCII_CHAR - 12
		REM if converted text is _ convert ASCII 95 ... into 53
		elseif ASCII_CHAR = 95 then
			let ASCII_CHAR = 53
		REM if converted text is a space " " then pause
		elseif ASCII_CHAR = 32 then
			let ASCII_CHAR = 54  REM 54 which is larger than the array
		REM all other non morse chars become "?"
		else let ASCII_CHAR = 51   
		endif
		if ASCII_CHAR = 54 then
			pause INTERWORD_DELAY
		else 
			let CHAR_INDEX = ASCII_CHAR * 4 REM convert to index 0,4,8...
			gosub GetCharacterData  REM retrieve character data into b1/2/3/4
			if SOUNDING = 1 then  REM lets us use the subroutine for display only
				gosub SoundCharacter
				pause SOUND_THEN_DRAW_DELAY
			endif
			gosub DrawCharacter   	REM use these results to draw text
		endif
		return
	
GetCharacterData:				REM uses b0=CHAR_INDEX as index into table
	let b21 = CHAR_INDEX		REM and returns portA/B/C outputs in b1/b2/b3 
	readtable b21,PORT_A_LEDS 	REM and morse into b4
	inc b21
	readtable b21,PORT_B_LEDS
	inc b21
	readtable b21,PORT_C_LEDS
	inc b21 
	readtable b21,MORSE
	let MENU_BUTTON_FLAG = MENU_BUTTON_FLAG and MENU_BUTTON 
			REM check if the menu button was pressed
	return

SoundCharacter:
	let ELEMENTS = PORT_A_LEDS / 16	REM bit shift the 4MSB into the 4LSB
    							REM This gives us the number of elements
 							REM from LSB to MSB in the morse byte 
	for b20 = 1 to ELEMENTS
		let b22 = MORSE and %00000001 REM read the LSB of MORSE
		if b22 = 0 then 			REM if LSB 0, then
			sound PIEZO,(SOUND_FREQ,DIT_SOUND_LENGTH)	REM dit if 0, else dah
		else sound PIEZO,(SOUND_FREQ,DAH_SOUND_LENGTH)
		endif
		pause INTER_ELEMENT_DELAY	REM pause a dit between sounds
		MORSE = MORSE/2			REM bitshift MORSE byte to the right
	next b20					REM to get the next element ready
	pause INTER_LETTER_DELAY		REM inter-letter delay of 3 dits
	return

DrawCharacter:

	let PORT_A_LEDS = PORT_A_LEDS OR %11110000 REM this stops piezo blips
	let pinsA=PORT_A_LEDS		REM squirt the data in b1/b2/b3  
	let pinsB=PORT_B_LEDS		REM out onto the port a/b/c pins
	let pinsC=PORT_C_LEDS		REM to turn the LEDs on: bit low = LED on
	pause DISPLAY_DURATION		REM for common anode display AUR 20A
	gosub ClearDisplay
	return

ClearDisplay:

	high A.0
	high A.1
	high A.2
	high A.3
'	let pinsA=%11111111		REM turn the LEDs off; bit high = LED off
	let pinsB=%11111111		REM for common anode display AUR 20A
	let pinsC=%11111111
	return

AnimatedTick:

	low B.2				REM a tick to indicate correct response
	pause 100
	low B.1
	pause 100
	low B.5
	pause 100
	pause DISPLAY_DURATION
	high B.2
	high B.1
	high B.5
	return

AnimatedCross:
	
	low C.1				REM an X to indicate an incorrect response
	pause 75
	low A.3
	pause 75
	low B.5
	pause 75
	low B.1
	pause 75
	pause DISPLAY_DURATION
	high C.1
	high A.3
	high B.5
	high B.1
	return
