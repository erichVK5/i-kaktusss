REM i-kaktusss morse keyer, beacon and morse trainer, PicAXE BASIC version
REM program slot 1 code for 28x2 PicAXE
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

REM Slot 1 will contain Koch Training and Random Char training content
REM Slots share EEPROM but not Table data
REM or subroutines.
REM So, we need a copy of the Table in each Slot
REM and also copies of the necessary subroutines
REM in each slot


#slot 1
#no_data	REM we don't want to blitz slot 0's EEPROM

REM Slot 1 requires its own copy of the table, but EEPROM is shared from slot 0
REM 
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


symbol KOCH_ELEMENTS = b50	REM how many elements
symbol KOCH_MORSE = b49		REM what got keyed in
symbol KOCH_RIGHT = b48		REM for calculating success stats with Koch Method
symbol KOCH_WRONG = b47
symbol KOCH_NUMBER = b46	REM the number of chars being used for Koch training
symbol FROM_SLOTX = b45
symbol DISPLAY_DURATION = b44		REM how long to display a char/tick/cross
symbol PIEZO = A.4
symbol MENU_BUTTON = pinC.5
symbol PADDLE_1 = pinC.6	REM can double as PS2 - also touch without pullup
					REM left paddle = DIT for R handed people
symbol PADDLE_2 = pinC.7	REM can double as PS2 - also touch without pullup
					REM right paddle = DAH for R handed people
symbol WPM = b43
symbol SOUNDING = b42
symbol KEYER_MODE = b41
symbol MENU_BUTTON_FLAG = b40
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

symbol MORSE_BIT_MASK = b34
symbol ELEMENTS = b29		REM holds # of morse elements for a given char
symbol ASCII_CHAR = b6		REM for ASCII in text to be played
symbol LAST_CHAR = b5		
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
symbol FARNSWORTH_FACTOR = 10 	REM 10 is the minimum for normal letter 

symbol SOUND_THEN_DRAW_DELAY = 500  REM how long between hearing it and seeing it
symbol MORSE_PITCH = 115  	REM 120~1000Hz 117~519 116~?
 					REM 115~782 114~1300 Hz 110~680 Hz 100~670


main:
	select case KEYER_MODE
	case 2
		gosub SeeminglyRandom54Chars
	case 4
		gosub KochMethodCharSequence
	case 5
		gosub FlashCharAwaitMorse

	case 6
		gosub DrawStoredArrayText
	case 8
		gosub DrawAllCharacters

	endselect
	if MENU_BUTTON_FLAG = 0 then
		let FROM_SLOTX = 1	REM menu button was pressed
		run 0
	endif
	goto main

KochMethodCharSequence:   REM ******** LOGIC seems OK AT PRESENT ********
	let KOCH_NUMBER = 126	REM start with first Koch character
	let KOCH_RIGHT = 0	REM success stats start at zero
	let KOCH_WRONG = 0	REM success stats start at zero
	let NEXT_DIT_FLAG = 1			REM 1 = no dit
	let NEXT_DAH_FLAG = 1			REM 1 = no dah
						REM really, need an outer control loop
						REM doing koch char selection which can
						REM then call the iambic reader
						REM can then re-use iambic reader module with
						REM random out control loop char selector
	
outertestingloop:
	for COUNTERVAR1 = 126 to 165
		read COUNTERVAR1,CHAR_INDEX REM put letter's index into table in b0
		gosub GetCharacterData  REM retrieve the character data into b1/2/3/4
		pause 500
		gosub SoundCharacter	REM give us a one off listen to the character
		gosub DrawCharacter   	REM and draw test char again
		gosub GetCharacterData  REM retrieve the character data into b1/2/3/4
						REM have to do this because sounding it
						REM munges the morse data

		let MORSE = MORSE and %00011111   REM temporary kludge to make it work
						REM on account of impure morse table data
						REM 3 MSB used for length in original code
						REM now 4 MSB of portA data used for length
						REM 3MSB of morse not used for length anymore
						REM since international characters added
KochRepetitionLoop: REM maybe try a for/next loop up to number of repetitions
			  REM plus/minus ? have a "koch target" number of goes needed
			  REM to progress

		gosub ModifiedIambicKeyer
		
		REM so, we have detected a character with our iambic keyer subroutine
		if ELEMENTS > 8 then	
			gosub AnimatedCross  REM more than eight elements is wrong
			inc KOCH_WRONG
		else let KOCH_ELEMENTS = ELEMENTS  REM make sure length is right
			let ELEMENTS = PORT_A_LEDS / 16
			if ELEMENTS = KOCH_ELEMENTS then REM compare length
				if KOCH_MORSE = MORSE then REM compare morse
				 	gosub AnimatedTick
		 			inc KOCH_RIGHT
				else gosub AnimatedCross
					inc KOCH_WRONG
				endif
			else gosub AnimatedCross
				inc KOCH_WRONG
				let b10 = 12  REM wrap up keying input loop		
			endif
		endif
		pause 300 REM wait a bit after the tick/cross

		REM we have finished detecting a sequence of keyed morse
		REM time to see if we have had enough correct responses or not
		REM and if so, move to the next char in the Koch Method list
		if KOCH_RIGHT > KOCH_WRONG then	REM avoid negatives this way 
			let b10 = KOCH_RIGHT - KOCH_WRONG	REM need to get 10 right
			if b10 > 10 then			REM before moving onto next char
				gosub AnimatedTick	REM indicate series done OK
				let KOCH_WRONG = 0
				let KOCH_RIGHT = 0	REM reset right and wrong for next char
				if KOCH_NUMBER = 165 then   REM if we're at the final koch char
					let KOCH_NUMBER = 126	REM start again at the beginning
				endif
				if COUNTERVAR1 = KOCH_NUMBER then REM if we're at the first char
					inc KOCH_NUMBER			REM move onto the second
				endif
			else 	pause 200   REM wait a touch before drawing character
				gosub DrawCharacter   	REM draw test char again
				goto KochRepetitionLoop  REM not enough right, keep testing
			endif
		else  pause 200	REM wait a touch before drawing character
			gosub DrawCharacter   	REM draw test char again
			goto KochRepetitionLoop REM not enough right yet, keep testing
		endif		REM gee this is messy. Loops could be tidied up

 		next COUNTERVAR1 	REM we got 10 more right than wrong, move onto next
	goto outertestingloop	
				
		

	ModifiedIambicKeyer:
		let MORSE_BIT_MASK = %00000001	REM get mask ready for first character
		let KOCH_MORSE = 0			REM zero the KOCH_MORSE variable
		let ELEMENTS = 0				REM zero the morse char length
		let NEXT_DIT_FLAG = 1		REM 1 = no dit
		let NEXT_DAH_FLAG = 1		REM 1 = no dah
							REM without these we can inadvertantly
							REM queue an extra dit or an extra dah
							REM to be sounded
		let LAST_DAH_FLAG = 1			REM 1 = was a dah
								REM this starts the iambic logic,
								REM quicker than testing in main
								REM loop, see slot 0 for details
		let LAST_DIT_FLAG = 0			REM 1 = was a dit

		for b10 = 1 to 10  REM we make it go to 10; no more than 8 needed
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
					let KOCH_MORSE = KOCH_MORSE or MORSE_BIT_MASK  REM 1 for a dah
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
					let KOCH_MORSE = KOCH_MORSE or MORSE_BIT_MASK  REM 1 for a dah
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
			REM alternatively, paddle pressed in tha past but not in the
			REM last paddle detection loop, indicated by ELEMENTS > 0
			elseif ELEMENTS > 0 then
				return REM wrap up keyer input loop
			REM  or, no key pressed at all
			else					REM reset things for the next
				let MORSE_BIT_MASK = %00000001 REM character to be keyed
				let b10 = 12  REM let's reset the main morse identifying loop
			endif
			let MENU_BUTTON_FLAG = MENU_BUTTON_FLAG and MENU_BUTTON
			if MENU_BUTTON_FLAG = 0 then run 0 endif REM check for menu
		next b10
		goto ModifiedIambicKeyer
		
						
	

FlashCharAwaitMorse:

	return


SeeminglyRandom54Chars:			REM a convincing 'random' char mix is 
 						REM hard to achieve with the inbuilt 
 						REM picaxe random function without a good
	let b10 = 32			REM way to seed the random generator. 
	let b11 = 0				REM Arguably, to learn morse, the important
 						REM thing is to hear all the morse
	for b9 = 1 to 100	 		REM characters without an obvious
		let b11 = b11 + 5  	REM pattern and with equal frequency.
		let b2 = b11 // 54	REM This can be achieved with two
		let CHAR_INDEX = b2 * 4		REM parallel char retrieval routines
'		if CHAR_INDEX = LAST_CHAR then REM stepping through the 54 characters
'			let CHAR_INDEX = CHAR_INDEX - 8 ' with different prime step sizes in
 '		endif				REM opposite directions. If you get used
						REM to the pattern, change the steps rainman! 
		gosub GetCharacterData  REM Retrieve the character data into b1/2/3/4
		if MENU_BUTTON_FLAG = 0 then return endif REM check menu button status
		gosub SoundCharacter
		pause SOUND_THEN_DRAW_DELAY
		gosub DrawCharacter   	REM and use these results to draw text
		pause INTER_LETTER_DELAY   REM Here endeth the 1st of the char pickers
		let LAST_CHAR = CHAR_INDEX
		let b10 = b10 - 3		REM we use 5 for the step size here, vs 3
		let b3 = b10 // 54	REM in the preceding routine. 13, 11 & 54 are
		let b2 = 53 - b3		REM not divisible, ensuring all chars get a go
		let CHAR_INDEX = b2 * 4		REM Avoid random/inadvertent duplication
'		if CHAR_INDEX = LAST_CHAR then let CHAR_INDEX = b1 + 4 endif
		  REM of preceding character by checking the previous index LAST_CHAR
		  REM As we are counting downwards, b0 cannot
		  REM exceed 212 i.e. overflow if we add 4 to b0
		  REM In preceding routine, counting upwards
						REM b1 - 8 cannot overflow either.
		gosub GetCharacterData  REM Retrieve the character data into b1/2/3/4
		if MENU_BUTTON_FLAG = 0 then return endif REM check menu button status
		gosub SoundCharacter
		pause SOUND_THEN_DRAW_DELAY
		gosub DrawCharacter   	REM and use these results to draw text
		pause INTER_LETTER_DELAY   REM Here endeth the 2nd of the char pickers
		let LAST_CHAR = CHAR_INDEX
	next b9
	goto SeeminglyRandom54Chars

DrawStoredArrayText:

	for b5 = 216 to 251		REM step through quick brown fox/beacon data
		readtable b5,CHAR_INDEX REM put b5'th letter's index into table in b0
		gosub GetCharacterData  REM retrieve the character data into b1/2/3/4
		if MENU_BUTTON_FLAG = 0 then return endif
		gosub SoundCharacter
		pause SOUND_THEN_DRAW_DELAY
		gosub DrawCharacter   	REM use these results to draw text
	next b5
	goto DrawStoredArrayText

DrawAllCharacters:

	for b8 = 0 to 212 step 4
		let CHAR_INDEX = b8   	REM put b8'th letter's index into table in b0
		gosub GetCharacterData  REM retrieve the character data into b1/2/3/4
		if MENU_BUTTON_FLAG = 0 then return endif
		gosub SoundCharacter
		pause SOUND_THEN_DRAW_DELAY
		gosub DrawCharacter   	REM use these results to draw text
	next b8
	goto DrawAllCharacters





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

	let pinsA=%11111111		REM turn the LEDs off; bit high = LED off
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
