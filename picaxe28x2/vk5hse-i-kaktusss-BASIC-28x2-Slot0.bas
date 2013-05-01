REM i-kaktusss morse keyer, beacon and morse trainer, PicAXE BASIC version
REM program slot 0 code for 28x2 PicAXE
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


REM Slot 0 will contain the main menu system
REM and the default operation iambic keyer code 
REM Slots share EEPROM but not Table data
REM or subroutines.
REM So, we need a copy of the Table in each Slot
REM and also copies of the necessary subroutines
REM in each slot


#slot 0

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
 TABLE 140,(%01011010,%00100111,%11100011,%10101111)  REM 9 to here n+3 3MSB=length
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


REM The EEPROM data storage follows. It is used for our iambic keyer
REM morse lookup table, and is a shared resource across slots.
REM 
REM We also use the EEPROM to store the Koch Method sequence in which
REM the characters are taught
REM 
REM We populate EEPROM with a lookup table which gives us the location in
REM the table above of the character encoded by:
REM 2^(number of elements in morse charactert)
REM 	- 2
REM 	+ (morse character encoded in 8 bit binary)
REM This gives us a fairly compact lookup table to allow us to find the data to
REM display the morse that the user has keyed in on the paddles
REM So we get E,T,  I,A,N,M,  S,D,R,G,U,K,W,O, H,B,L,Z,F,C,P,#,V,X,#,Q,#,Y,J,#
REM ...5,6,#,7,#,#,#,8,#,#,.,#,#,#,#,9, 4,#,#,#,#,#,#,3,#,#,#,2,#,#,1,0
REM this approach becomes less efficient as the morse characters get longer (>4)
REM but it makes the look up much faster than a bunch of nested if-thens


DATA 0,(16,76)				REM E,T
 						REM single element morse starting at 0
DATA (32,52,0,48) 			REM I,N,A,M,
 						REM double element morse starting at 2
DATA (72,12,68,24,80,40,88,56)	REM S,D,R,G,U,K,W,O
 						REM triple element morse starting at 6 
DATA (28,4,44,100,20,8,60,252,84,92,252,64,252,96,36,252)
 						REM H,B,L,Z,F,C,P,#,V,X,#,Q,#,Y,J,#
 						REM quadruple element morse starting at 14
DATA (124,128,156,132,252,252,252,136,252,188,172,252,252,164,252,140)
 						REM 5,6,&,7,#,#,#,8,#,/,+,#,#,(,#,9
 						REM pentuple elements morse starting at 30
DATA (120,200,252,252,252,252,252,252,116,252,252,252,112,252,108,104)
 						REM 4,=,#,#,#,#,#,#,3,#,#,#,2,#,1,0
 						REM remaining 16 of 32 starting at 30 + 16 = 46
DATA (252,252,252,252,252,252,252,192,252,252,184,252,252,252,252,252)
 				REM #,#,#,#,#,#,#,:,#,#,#,#,?,#,#,#
 				REM hextuple element morse starting at 62
DATA (252,252,148,252,252,196,208,252,252,252,252,252,252,252,160,252)
 				REM #,#,",#,#,;,@,#,#,#,#,#,#,#,',#
DATA (252,180,252,252,252,252,252,252,252,252,184,252,212,168,252,252)
 				REM #,-,#,#,#,#,#,#,#,#,.,#,_,),#,#
DATA (252,252,252,176,252,144,252,252,252,252,252,252,204,252,252,252)
 				REM #,#,#,,,#,!,#,#,#,#,#,#,#,#,#,#
 				REM and hextuples finish at 125
REM morse character storage efficiency starts to drop off at 6 bits,
REM hence all the 252's for non valid morse sequences. So, we don't bother
REM with storing seven or eight digit morse chars as there is only the 7
REM bit $, which would need another 128 bytes to store(!), and error
REM (........) which would need another 256 bytes to store with this method 


REM The following is the recommended Koch learning sequence
REM 
REM K,M,R,S,U,A,P,T,L,O
REM W,I,.,N,J,E,F,0,Y,,
REM V,G,5,/,Q,9,Z,H,3,8
REM B,?,4,2,7,C,1,D,6,X
REM <BT>  SK>  <AR>
REM 
REM like the morse decoding table, they are encoded as indices into the char data
REM 

DATA (40,48,68,72,80,0,60,76,44,56)			REM starts at 126
DATA (88,32,184,52,36,16,20,104,96,176)
DATA (84,24,124,188,64,140,100,28,116,136)
DATA (4,204,120,112,132,8,108,12,128,92)		REM finishes at 165


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
symbol WPM_12_DIT = 10 '100
symbol WPM_15_DIT = 8  '80  REM a crystal oscillator - actually no - nothing
symbol WPM_17_DIT = 7  '70  REM changed - seems to default to RC oscillator 
symbol WPM_20_DIT = 6  '60  REM for sound, pause etc... commands
symbol WPM_25_DIT = 5  '48
symbol WPM_30_DIT = 4  '40
symbol FARNSWORTH_FACTOR = 10   REM 10 is minimum value for normal letter spacing

symbol SOUND_THEN_DRAW_DELAY = 500  REM how long between hearing it and seeing it
symbol MORSE_PITCH = 115  	REM 120~1000Hz 117~519 116~?
 					REM 115~782 114~1300 Hz 110~680 Hz 100~670


main:
	if KEYER_MODE = 0 then	REM have we just powered up?
		let MENU_BUTTON_FLAG = 1   REM if it becomes 0 it means it has been pressed
		let KEYER_MODE = 1	REM this is the default keyer mode, can be changed
						REM 1 = keyer, 2 = random, 3 = text, 4 = koch
 						REM 5 = flash and test, 6 = quickbrown fox
 						REM 7 = PS/2  8 = display/sound all chars
 		let SOUNDING = 1		REM 1 = sounding, 0 = mute
 		let WPM = WPM_17_DIT	REM the default starting speed; can be changed
 		gosub SetMorseCharTimings
	endif
'	gosub TestAllLeds
	gosub ClearDisplay

mainloop:
	if MENU_BUTTON_FLAG = 0 then
		let MENU_BUTTON_FLAG = 1
	endif
	pause 250 REM wait for the button press to finish before deciding what next
	if MENU_BUTTON = 1 then
		gosub MenuSystem REM menu button not held down
	endif

WPMadjust:
	if MENU_BUTTON = 0 then 		REM menu button still held down
		if PADDLE_1 = 0 then
			WPM = WPM - 1
			low B.1
			low A.3
			pause 150		REM show an up "^"
			high B.1
			high A.3
		elseif PADDLE_2 = 0 then
			WPM = WPM + 1
			low C.1
			low B.5
			pause 150		REM show a "down" carat
			high C.1
			high B.5
		endif
	endif

	pause 250

	if WPM < 4 then let WPM = 4 endif	REM 30 WPM dit length minimum in ms
	if WPM > 24 then let WPM = 24 endif REM 5  WPM dit length maximum in ms

	if MENU_BUTTON = 0 then goto WPMadjust REM loop if still holding menu button

	gosub WPMdisplay REM now display the newly selected WPM

	REM we now implement and propogate any changes made to WPM
	gosub SetMorseCharTimings

	REM and now we move to the selected mode
	select case KEYER_MODE
		case 1
			FROM_SLOTX = 0
			gosub IambicKeyer
		case 2
			run 1 REM SeeminglyRandom54Chars in slot 1
		case 3
			run 2 REM PlayQSOtext in slot 2
		case 4
			run 1	REM KochMethodCharSequence in slot 1
		case 5
			run 1 REM maybe do this as a random thing FlashCharAwaitMorse
		case 6
			run 1 REM quickbrownfox or other beaconing DrawStoredArrayText
		case 7
			run 3 REM the PS/2 keyboard stuff
		case 8
			run 1 REM gosub DrawAllCharacters in slot 1
	endselect
	goto mainloop


MenuSystem:
	let SOUNDING = 0
	let ASCII_CHAR = "&"
	gosub SoundThenDrawASCIIchar
	goto MenuSystem
	
	for b9 = 0 to 15    REM equals length-1 of text string being generated
		lookup b9,("Keyer mode is:  "),ASCII_CHAR
		gosub SoundThenDrawASCIIchar
	next b9
	select case KEYER_MODE		REM now we show what the current mode is
		case 1
			for b9 = 0 to 11
				lookup b9,("Iambic Keyer"),ASCII_CHAR
				gosub SoundThenDrawASCIIchar
			next b9			
		case 2
			for b9 = 0 to 10
				lookup b9,("Random Code"),ASCII_CHAR
				gosub SoundThenDrawASCIIchar
			next b9			
		case 3
			for b9 = 0 to 7
				lookup b9,("QSO Text"),ASCII_CHAR
				gosub SoundThenDrawASCIIchar
			next b9			
		case 4
			for b9 = 0 to 10
				lookup b9,("Koch Method"),ASCII_CHAR
				gosub SoundThenDrawASCIIchar
			next b9			
		case 5
			for b9 = 0 to 10
				lookup b9,("Flash + Key"),ASCII_CHAR
				gosub SoundThenDrawASCIIchar
			next b9			
		case 6
			for b9 = 0 to 5
				lookup b9,("TQBFox"),ASCII_CHAR
				gosub SoundThenDrawASCIIchar
			next b9			
		case 7
			for b9 = 0 to 12
				lookup b9,("PS/2 to Morse"),ASCII_CHAR
				gosub SoundThenDrawASCIIchar
			next b9			
		case 8
			for b9 = 0 to 9
				lookup b9,("Draw  All "),ASCII_CHAR
				gosub SoundThenDrawASCIIchar
			next b9			
	end select
	REM now we see if we want to change the current mode
	let MENU_BUTTON_FLAG = 1
	let MENU_BUTTON_FLAG = MENU_BUTTON_FLAG and MENU_BUTTON 
	pause 500
	let MENU_BUTTON_FLAG = MENU_BUTTON_FLAG and MENU_BUTTON 
	if MENU_BUTTON_FLAG = 0 then   REM menu button was pressed, so
		gosub AnimatedTick
		let MENU_BUTTON_FLAG = 1
		inc KEYER_MODE
		if KEYER_MODE = 9 then let KEYER_MODE = 1 endif
		goto Menusystem	REM go and display new keyer mode
	endif
	let SOUNDING = 1 REM unmute	
	REM now that we have shown and/or changed the Keyer Mode, return
	return

WPMdisplay:
	let SOUNDING = 0
	for b9 = 0 to 3    REM 3 equals length-1 of text string being generated
		lookup b9,("WPM:"),ASCII_CHAR
		gosub SoundThenDrawASCIIchar
	next b9
	pause 1000

	select case WPM
		case 4
			WPM = WPM_30_DIT
			let ASCII_CHAR = "3"
			gosub SoundThenDrawASCIIchar
			pause 300
			let ASCII_CHAR = "0"
			gosub SoundThenDrawASCIIchar
			pause 300
		case 5
			WPM = WPM_25_DIT
			let ASCII_CHAR = "2"
			gosub SoundThenDrawASCIIchar
			pause 300
			let ASCII_CHAR = "5"
			gosub SoundThenDrawASCIIchar
			pause 300
		case 6
			WPM = WPM_20_DIT
			let ASCII_CHAR = "2"
			gosub SoundThenDrawASCIIchar
			pause 300
			let ASCII_CHAR = "0"
			gosub SoundThenDrawASCIIchar
			pause 300
		
		case 7
			WPM = WPM_17_DIT
			let ASCII_CHAR = "1"
			gosub SoundThenDrawASCIIchar
			pause 300
			let ASCII_CHAR = "7"
			gosub SoundThenDrawASCIIchar
			pause 300
		case 8,9
			WPM = WPM_15_DIT
			let ASCII_CHAR = "1"
			gosub SoundThenDrawASCIIchar
			pause 300
			let ASCII_CHAR = "5"
			gosub SoundThenDrawASCIIchar
			pause 300
		case 10
			WPM = WPM_12_DIT
			let ASCII_CHAR = "1"
			gosub SoundThenDrawASCIIchar
			pause 300
			let ASCII_CHAR = "2"
			gosub SoundThenDrawASCIIchar
			pause 300
		case 11,12
			WPM = WPM_10_DIT
			let ASCII_CHAR = "1"
			gosub SoundThenDrawASCIIchar
			pause 300
			let ASCII_CHAR = "0"
			gosub SoundThenDrawASCIIchar
			pause 300
		case 13 to 20
			WPM = WPM_5_DIT
			let ASCII_CHAR = "5"
			gosub SoundThenDrawASCIIchar
			pause 300

	endselect			
	let SOUNDING = 1 REM unmute sounding			
	REM having displayed WPM, return 
return


REM 
REM Some general housekeeping to be called after the menu has been used
REM 

SetMorseCharTimings:
	let DISPLAY_DURATION = 255   REM is shortened during fast iambic keying
	let SOUND_FREQ = MORSE_PITCH
	REM the sound command duration uses a number approx one tenth the ms needed
	let DIT_SOUND_LENGTH = WPM
	REM standard morse requires a dah three times the length of a dit
	let DAH_SOUND_LENGTH = 3 * DIT_SOUND_LENGTH
	REM standard morse requires a delay between elements of one dit
	REM the pause command requires a number in ms, so we multiple by ten
	let INTER_ELEMENT_DELAY = 10 * DIT_SOUND_LENGTH		
	REM standard morse requires a delay between letters of three dits
	REM which would be a delay in ms of 3 x 10 x DIT_SOUND_LENGTH
	REM we can make the ten multiplier our Farnsworth spacing factor
	let INTER_LETTER_DELAY = 3 * DIT_SOUND_LENGTH * FARNSWORTH_FACTOR
	REM standard morse requires an interword delay of seven dits
	REM which would be a delay in ms of 7 x 10 x DIT_SOUND_LENGTH and
	REM again we can make the ten multiplier our Farnsworth spacing factor
	let INTERWORD_DELAY = 7 * DIT_SOUND_LENGTH * FARNSWORTH_FACTOR
	return




REM The Iambic Keyer Code
REM 
REM this assumes pullups on PicAxe Paddle inputs and code
REM needs modifying if touch paddles or Xmit keying
REM or silent mode. Xmit keying may best done with AF
REM triggered transistor to keep things simple
REM Strictly speaking, it is an iambic A keyer, and
REM iambicmyths.pdf by N1FN is worth googling on 
REM the merits (or lack of) of squeeze keying at
REM high speeds
REM 
REM Rob Gurr didn't like my initial implementation so
REM it has been rewritten with flags allowing for
REM asynchronous queuing of one of the opposite paddle
REM 

IambicKeyer:
	let DISPLAY_DURATION = 100		REM shortened it to allow faster keying
	let MORSE_BIT_MASK = %00000001	REM get mask ready for first character
	let MORSE = 0				REM zero the MORSE variable
	let ELEMENTS = 0				REM zero the morse char length
	let NEXT_DIT_FLAG = 1			REM 1 = no dit
	let NEXT_DAH_FLAG = 1			REM 1 = no dah
	let LAST_DAH_FLAG = 1			REM 1 = was a dah
					REM we set it to one as an initial condition
					REM for char detection otherwise the iambic
					REM logic won't start. We could instead use
					REM if LAST_DAH_FLAG and LAST_DIT_FLAG = 0 then
					REM 			let LAST_DAH_FLAG = 1 endif
					REM in the main loop to get things started but
					REM this might slow things down between element
					REM detection and this can be avoided
	let LAST_DIT_FLAG = 0			REM 1 = was a dit

	for b10 = 1 to 125  REM we make it go to 125 in case keys held for ages
		let NEXT_DIT_FLAG = NEXT_DIT_FLAG and PADDLE_1
			REM quickly tests if DIT paddle pressed
		let NEXT_DAH_FLAG = NEXT_DAH_FLAG and PADDLE_2
			REM quickly tests if DAH paddle pressed	
		if LAST_DAH_FLAG = 1 then
			let LAST_DAH_FLAG = 0  REM reset the flag
			if NEXT_DIT_FLAG = 0 then
				sound PIEZO,(SOUND_FREQ,DIT_SOUND_LENGTH)
				let NEXT_DIT_FLAG = 1
				let LAST_DIT_FLAG = 1  REM flag that last thing was a DIT
				let NEXT_DAH_FLAG = NEXT_DAH_FLAG and PADDLE_2
					REM basically, quickly tests if DAH paddle pressed
				inc ELEMENTS
				let MORSE_BIT_MASK = MORSE_BIT_MASK * 2 REM bitshift left
				pause INTER_ELEMENT_DELAY	REM pause a dit between sounds
				let NEXT_DAH_FLAG = NEXT_DAH_FLAG and PADDLE_2
						REM quickly tests again if DAH paddle pressed	
				let NEXT_DIT_FLAG = NEXT_DIT_FLAG and PADDLE_1
						REM quickly tests if DIT paddle pressed
			elseif NEXT_DAH_FLAG = 0 then
				sound PIEZO,(SOUND_FREQ,DAH_SOUND_LENGTH)
				let NEXT_DAH_FLAG = 1
				let LAST_DAH_FLAG = 1  REM flag that last thing was a DAH			
				let NEXT_DIT_FLAG = NEXT_DIT_FLAG and PADDLE_1
						REM quickly tests if DIT paddle pressed
				pause INTER_ELEMENT_DELAY	REM pause a dit between sounds
				inc ELEMENTS
				let MORSE = MORSE	or MORSE_BIT_MASK  REM 1 for a dah
				let MORSE_BIT_MASK = MORSE_BIT_MASK * 2 REM bitshift left
				let NEXT_DIT_FLAG = NEXT_DIT_FLAG and PADDLE_1
						REM quickly tests if DIT paddle pressed
				let NEXT_DAH_FLAG = NEXT_DAH_FLAG and PADDLE_2
						REM quickly tests again if DAH paddle pressed	
			endif

		elseif LAST_DIT_FLAG = 1 then
			let LAST_DIT_FLAG = 0  REM reset the flag
			if NEXT_DAH_FLAG = 0 then
				sound PIEZO,(SOUND_FREQ,DAH_SOUND_LENGTH)
				let NEXT_DAH_FLAG = 1
				let LAST_DAH_FLAG = 1  REM flag that last thing was a DAH
				let NEXT_DIT_FLAG = NEXT_DIT_FLAG and PADDLE_1
						REM quickly tests if DIT paddle pressed
				pause INTER_ELEMENT_DELAY	REM pause a dit between sounds
				inc ELEMENTS
				let MORSE = MORSE	or MORSE_BIT_MASK  REM 1 for a dah
				let MORSE_BIT_MASK = MORSE_BIT_MASK * 2 REM bitshift left
				let NEXT_DIT_FLAG = NEXT_DIT_FLAG and PADDLE_1
						REM quickly tests if DIT paddle pressed
				let NEXT_DAH_FLAG = NEXT_DAH_FLAG and PADDLE_2
						REM quickly tests again if DAH paddle pressed	
			elseif NEXT_DIT_FLAG = 0 then
				sound PIEZO,(SOUND_FREQ,DIT_SOUND_LENGTH)
				let NEXT_DIT_FLAG = 1
				let LAST_DIT_FLAG = 1  REM flag that last thing was a DIT
				let NEXT_DAH_FLAG = NEXT_DAH_FLAG and PADDLE_2
					REM basically, quickly tests if DAH paddle pressed
				inc ELEMENTS
				let MORSE_BIT_MASK = MORSE_BIT_MASK * 2 REM bitshift left
				pause INTER_ELEMENT_DELAY	REM pause a dit between sounds
				let NEXT_DAH_FLAG = NEXT_DAH_FLAG and PADDLE_2
						REM quickly tests again if DAH paddle pressed
				let NEXT_DIT_FLAG = NEXT_DIT_FLAG and PADDLE_1
						REM quickly tests if DIT paddle pressed
			endif
		REM alternatively, no paddle press now but was pressed
		REM prior to this loop indicated by ELEMENTS > 0
		elseif ELEMENTS > 0 then	
			if ELEMENTS < 7 then
			 	REM now for the commonly used chars				
				REM OK, how to do a small lookup table with an index which
				REM is a function of number of morse elements, 1,2,...,6
				REM and containing non unique morse encoded in 1s and 0s
				REM so we use: char_index = 2^elements - 2
				REM ..				+ binary encoded morse
				REM uses 126 bytes of EEPROM for 53 chars but it's quick
 				REM this routine is quickest for most used characters
 				REM as less exponentiation needed, i.e. for E, T, A, etc...
				let CHAR_INDEX = 1
				for b14 = 1 to ELEMENTS
					let CHAR_INDEX = CHAR_INDEX * 2 
				next b14
				dec CHAR_INDEX
				dec CHAR_INDEX
				let MORSE = MORSE + CHAR_INDEX
	 			read MORSE, CHAR_INDEX	REM retrieve array pointer<-EEPROM
				if CHAR_INDEX = 252 then
					gosub AnimatedCross
				else
	 				gosub GetCharacterData	REM retrieve character bit pattern
		 			gosub DrawCharacter	REM draw the character bit pattern
				endif
			elseif ELEMENTS = 7 then REM only valid 7 element morse is $
				if MORSE = %01001000 then
					let CHAR_INDEX = 152    REM the index of the $ character
					gosub GetCharacterData  REM put character data-> b1/2/3/4
					gosub DrawCharacter	REM let's display $
				else let CHAR_INDEX = 252   REM the morse 8 dit error code
					gosub AnimatedCross	REM error display
					gosub GetCharacterData  REM put character data-> b1/2/3/4
'					gosub SoundCharacter	REM let's play error beeps
				endif
			elseif ELEMENTS = 8 then REM only 8 bit morse character is error
				let CHAR_INDEX = 252   REM the morse 8 dit error code
				if MORSE = %00000000 then
					gosub AnimatedTick	REM you keyed it correctly!
				endif
				gosub AnimatedCross	REM error display
			elseif ELEMENTS > 8 then REM not a valid morse character, > 7 elements
				gosub AnimatedCross	REM error display
			endif
			let ELEMENTS = 0			REM reset things for the next
			let MORSE_BIT_MASK = %00000001 REM character to be keyed
			let b10 = 127  REM let's reset the main morse identifying loop
		REM  or, no key pressed at all
		else						REM reset things for the next
			let MORSE_BIT_MASK = %00000001 REM character to be keyed
			let b10 = 127  REM let's reset the main morse identifying loop
		endif
		let MENU_BUTTON_FLAG = MENU_BUTTON_FLAG and MENU_BUTTON
		if MENU_BUTTON_FLAG = 0 then
			let DISPLAY_DURATION = 255 REM set display duration back to
			return			   REM normal before jumping back to menu
		endif
	next b10
	goto IambicKeyer




	





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

REM Troubleshooting routines follow

DrawAllCharacters:

	for b8 = 0 to 212 step 4
		let CHAR_INDEX = b8   	REM put b8'th letter's index into table in b0

		gosub GetCharacterData  REM retrieve the character data into b1/2/3/4
		if MENU_BUTTON_FLAG = 0 then return endif
		if SOUNDING = 1 then
			gosub SoundCharacter
		endif
		pause SOUND_THEN_DRAW_DELAY
		gosub DrawCharacter   	REM use these results to draw text
'		pause 20
	next b8
	pause 300
	return
	
TestAllLeds:

	let pinsA=%11110000		REM see if all the leds are wired up OK
	let pinsC=%11111000
	pause 10
	let pinsA=%11111111
	let pinsC=%11100111
	let pinsB=%11110000
	pause 10
	let pinsC=%11111111
	let pinsB=%00001111
	pause 10
	let pinsB=%11111111
	return	