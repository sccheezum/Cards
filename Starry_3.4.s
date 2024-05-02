; IPA 4: 3.4 of Final Project
;
; CS 274
; Eugene Thompson
; Implementing a Text Interface for Playing Blackjack

; Configuration Buffers
bet_buffer:
    db 0x00
    db [0x00, 0x04]
    
num_decks_buffer:
    db 0x00
    db [0x00, 0x01]
    
c_bet_mode:
    db 0x00
    db [0x00, 0x01]
    
comp_keep_hand_buffer:
    db 0x00
    db [0x00, 0x04]
    
comp_add_card_buffer:
    db 0x00
    db [0x00, 0x04]
    
comp_forfeit_turn_buffer:
    db 0x00
    db [0x00, 0x04]
    
difficulty_level_buffer:
    db 0x00
    db [0x00, 0x01]
    
current_bet_buffer:
    db 0x00
    db [0x00, 0x04]
    
continue_game_buffer:
    db [0x00, 0x01]

user_choice_buffer:
    db [0x00, 0x01]

; Prompt Messages
    
initial_bet_msg:
    db "Place your initial bet between $10 and $1000 above"
    
try_again_bet_msg:
    db "Try again! Please make sure your bet is between $10 and $1000"
    
select_num_decks_msg:
    db "Select how many decks you would like: (Choose between 1, 2, and 3)"
    
try_again_choice_msg:
    db "Sorry, your response was incorrect, try again! Remember to choose 1, 2, or 3." 
    
choose_comp_bet_mode_msg:
    db "Choose the Computer's Betting Mode from the following options:"

conservative_option_msg:
    db "Press '1' if you would like Conservative, the Computer bets 20% lower than you"
    
normal_option_msg:
    db "Press '2' if you would like Normal, the Computer matches your bet"
    
aggressive_option_msg:
    db "Press '3' if you would like Aggressive, the Computer outbets you by 30%"
    
choose_comp_risk_lvl_msg:
    db "Choose the Computer's Risk Levels below:"

comp_keep_hand_lvl_msg:
    db "Input a number between 0-100, enter how likely the computer should keep its hand"
    
comp_add_card_lvl_msg:
    db "Input a number between 0-100, enter how likely the computer should add a card"
    
comp_forfeit_turn_msg:
    db "Input a number between 0-100, enter how likely the computer will forfeit a turn"
    
difficulty_mode_msg:
    db "Choose the Game Difficulty Mode from the following options:"
    
easy_mode_msg:
    db "Press '1' if you would like Easy, the Computer has 50% less money than you"
    
normal_mode_msg:
    db "Press '2' if you would like Normal, the Computer has the same money as you"
    
hard_mode_msg:
    db "Press '3' if you would like Hard, the Computer has 50% more money than you"
    
ask_bet_msg:
    db "Place your Bets! Make sure you are betting how much you have left..."

user_choice_msg:
    db "Please indicate which choice you would like to make from the following options:

player_keep_hand_msg:
    db "Press '1' if you would like to keep your current Hand!"

player_add_card_msg:
    db "Press '2' if you would like to add a card to your current Hand!"

player_forfeit_card_msg:
    db "Press '3' if you would like to forfeit your turn..."
    
winning_msg:
    db "Congratulations, you won the bet!""
    
losing_msg:
    db "Unfortunately, you lost the bet..."

neither_won_message:
    db "Neither side has won yet, there's still time to win!"
    
ask_another_turn_msg:
    db "If you would like to continue, press '1' otherwise press '0' to quit"

; Easter Egg for Later...    
insufficient_funds_msg:
    db "Insufficient Fundssssss YOU AIN'T GOT NO MONEY... oooohh"
    
def convertCharToNum {
    mov ah, 0
    add di, ax      ; Adds the 1st Place to Count
    
    dec si          ; Proceed to Seconds Place
    mov al, byte [si]   ; Obtains the Second Place Value
    mov bl, 0x0A        ; Sets up the Hexadecimal Conversion
    mul bl              ; Multiplies by Hexadecimal
    add di, ax          ; Adds it to Count
    
    dec si          ; Proceed to Thirds Place
    mov al, byte [si]   ; Obtains the Thirds Place Value
    mov bl, 0x64        ; Sets up the 100s Hexadecimal Place
    mul bl              ; Multiplies by Hexadecimal
    add di, ax          ; Adds to Count
    
    mov ah, 0
    dec si              ; Proceed to Fourths Place
    mov al, byte [si]   ; Obtains the Fourth Place Value
    mov bh, 0x03        ; Sets up the 1000ths Hexadecimal Place
    mov bl, 0xE8
    mul bx              ; Multiplies by Hexadecimal
    add di, ax          ; Adds to Count
    

    ret
}
    
def checkASCIIValue {
    cmp al, 0x30
    jge update_val_to_ascii
    cmp di, 2
    je account_thousand_diff
    cmp di, 1
    je account_hundred_diff
    cmp di, 3
    je account_hundred_diff
    cmp al, 0x00
    je check_next
    call convertCharToNum
    ret
}
    
; Supplementary Procedures for User Config

def askForInitialBet {
; User Inputs a number between 10-1000
    ; System asks user for response
    mov ah, 0x13
    mov cx, 50
    mov bx, 0
    mov es, bx
    mov bp, OFFSET initial_bet_msg
    mov dl, 0
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word bet_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET bet_buffer
    add si, 2
    mov bl, 0x30
    
; Once user inputs value, system checks if it is a valid
; Jumps to invalid_initial_wager if above or below number
    ; Checks First place to see if the value is in range
    mov al, byte [si]
    cmp al, 0x31
    jl invalid_initial_wager
    cmp al, 0x39
    jg invalid_initial_wager
    sub al, bl
    mov byte [si], al
    
    ; Checks second place to see if the value is in range
    inc si
    mov al, byte [si]
    cmp al, 0x30
    jl invalid_initial_wager
    cmp al, 0x39
    jg invalid_initial_wager
    sub al, bl
    mov byte [si], al
    
    ; Checks third place to see if the value is in range 
    inc si
    mov al, byte [si]
    cmp al, 0x39
    jg invalid_initial_wager
    
    ; Check fourth place to see if it is zero or no input
    inc si
    mov al, byte [si]
    cmp al, 0x30
    jg invalid_initial_wager
    
	ret
}

def askForNumDecks {
; User will choose to use between 1 to 3 decks of cards
    ; System asks user for response
    mov ah, 0x13
    mov cx, 66
    mov bx, 0
    mov es, bx
    mov bp, OFFSET select_num_decks_msg
    mov dl, 0
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word num_decks_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET num_decks_buffer
    add si, 2
    mov bl, 0x30

; System checks if number of decks requested is valid
; Otherwise, jumps to invalid_deck_selection
    mov al, byte [si]
    cmp al, 0x31
    jl invalid_deck_selection
    cmp al, 0x33
    jg invalid_deck_selection
    sub al, bl
    mov byte [si], al
	ret
}

def askForCompBetMode {
; User can choose between three computer betting modes:
; Conservative, Normal, or Aggressive (1,2,3)
    ; System asks user for response
    mov ah, 0x13
    mov cx, 62
    mov bx, 0
    mov es, bx
    mov bp, OFFSET choose_comp_bet_mode_msg
    mov dl, 0
    int 0x10
    
    mov cx, 78
    mov bp, OFFSET conservative_option_msg
    int 0x10
    
    mov cx, 65
    mov bp, OFFSET normal_option_msg
    int 0x10
    
    mov cx, 71
    mov bp, OFFSET aggressive_option_msg
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word comp_bet_mode_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET comp_bet_mode_buffer
    add si, 2
    mov bl, 0x30

; System checks if the response is valid
; If so, configures the multiplier based on the betting modes
; Otherwise, jumps to invalid_comp_bet_mode
    mov al, byte [si]
    cmp al, 0x31
    jl invalid_deck_selection
    cmp al, 0x33
    jg invalid_deck_selection
    sub al, bl
    mov byte [si], al

	ret
}

def askForCompRiskLevel {
; User can choose between three computer risk levels:
; Keep current hand, Add another Card, Forfeit current hand
    mov ah, 0x13
    mov cx, 40
    mov bx, 0
    mov es, bx
    mov bp, OFFSET choose_comp_risk_lvl_msg
    mov dl, 0
    int 0x10
    
    mov cx, 80
    mov bp, OFFSET comp_keep_hand_lvl_msg
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word comp_keep_hand_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET comp_keep_hand_buffer
    add si, 5
    mov al, byte [si]
    
    
    mov ah, 0x13
    mov cx, 77
    mov bp, OFFSET comp_add_card_lvl_msg
    mov dl, 0
    int 0x10
    
    mov ah, 0x0a
    lea dx, word comp_add_card_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET comp_add_card_buffer
    add si, 4
    mov al, byte [si]
    
    
    mov ah, 0x13
    mov cx, 79
    mov bp, OFFSET comp_forfeit_turn_msg
    mov dl, 0
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word comp_forfeit_turn_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET comp_forfeit_turn_buffer
    add si, 4
    mov al, byte [si]
    
    

; System checks if the response is valid
; Otherwise, jumps to invalid_comp_risk_level


	ret
}

def askDifficultyMode {
; User can choose between three computer difficulty levels:
; Easy, Normal, Hard (1,2,3)
    mov ah, 0x13
    mov cx, 62
    mov bx, 0
    mov es, bx
    mov bp, OFFSET difficulty_mode_msg
    mov dl, 0
    int 0x10
    
    mov cx, 78
    mov bp, OFFSET easy_mode_msg
    int 0x10
    
    mov cx, 65
    mov bp, OFFSET normal_mode_msg
    int 0x10
    
    mov cx, 71
    mov bp, OFFSET hard_mode_msg
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word difficulty_level_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET difficulty_level_buffer
    add si, 2
    mov bl, 0x30

; System checks if the response is valid
; If so, configures the multiplier based on the difficulty for the computer’s money
; Otherwise, jumps to invalid_difficulty
    mov al, byte [si]
    cmp al, 0x31
    jl invalid_difficulty
    cmp al, 0x33
    jg invalid_difficulty
    sub al, bl
    mov byte [si], al

	ret
}

; Supplementary Procedures for Turns


def askUserForBet {
; Asks User how much they want to bet from their pool
    mov ah, 0x13
    mov cx, 62
    mov bx, 0
    mov es, bx
    mov bp, OFFSET ask_bet_msg
    mov dl, 0
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word current_bet_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 

	ret
}

def askUserForChoice {
    ; Ask User to Keep Hand, or
    ; Add One More Card, jumping to add_card
    ; Forfeit Turn and lose their current bet to the computer,
    mov ah, 0x13
    mov cx, 62
    mov bx, 0
    mov es, bx
    mov bp, OFFSET user_choice_msg
    mov dl, 0
    int 0x10
    
    mov cx, 78
    mov bp, OFFSET player_keep_hand_msg
    int 0x10
    
    mov cx, 65
    mov bp, OFFSET player_add_card_msg
    int 0x10
    
    mov cx, 71
    mov bp, OFFSET player_forfeit_card_msg
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word user_choice_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET user_choice_buffer
    add si, 2
    mov bl, 0x30

; System checks if the response is valid
    mov al, byte [si]
    cmp al, 0x31
    jl user_choice
    cmp al, 0x33
    jg user_choice
    cmp al, 0x31
    je keep_hand
    cmp al, 0x32
    je add_card
    cmp al, 0x33
    je player_forfeit_turn
}



def displayUserWon {
; Displays to the User that they won 
    mov ah, 0x13
    mov cx, 62
    mov bx, 0
    mov es, bx
    mov bp, OFFSET winning_msg
    mov dl, 0
    int 0x10
    ret
}

def displayUserLost {
; Displays to the User that they lost
    mov ah, 0x13
    mov cx, 62
    mov bx, 0
    mov es, bx
    mov bp, OFFSET losing_msg
    mov dl, 0
    int 0x10
    ret
}


def askUserForNextTurn {
; System asks user if they want to play another turn
    mov ah, 0x13
    mov cx, 62
    mov bx, 0
    mov es, bx
    mov bp, OFFSET ask_another_turn_msg
    mov dl, 0
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word continue_game_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET continue_game_buffer
    add si, 2
    mov bl, 0x30

    ; if yes, jump to check_turn_requirements
    ; if no, go to the game_end, and displays winnings
    mov al, byte [si]
    cmp al, 0x30
    jl next_turn
    cmp al, 0x31
    jg next_turn
    cmp al, 0x30
    je start_turn
    cmp al, 0x31
    je game_end
    
	ret
}



start:
; Initializes Key Variables used



; User Configuration:


initial_user_config:
	call askForInitialBet
    call checkASCIIValue
	

update_val_to_ascii:
    mov bl, 0x30
    sub al, bl
    mov byte [si], al
    dec si
    inc di
    mov al, byte [si]
    call checkASCIIValue
    
check_next:
    dec si
    mov al, byte [si]
    call checkASCIIValue
    
account_hundred_diff:
; Correcting for values of Hundred :)
    add si, 1
    mov di, 0
    call convertCharToNum
    
account_thousand_diff:
; Correct for Thousand Bet :)
    cmp si, 1
    je continue_user_config
    add si, 2
    mov di, 0
    call convertCharToNum

continue_user_config:
; Move the Initial Bet Amount to the Buffer using the New Hexadecimal Values
    mov byte [si], ah
    inc si
    mov byte [si], al
	;call askForNumDecks
	;call askForCompBetMode
	
risk_level_config:
    mov di, 0
	call askForCompRiskLevel
	;call askDifficultyMode
	jmp start_turn
	

invalid_initial_wager:
; Add additional information to guide user, then asks them again
    mov ah, 0x13
    mov cx, 61
    mov bx, 0
    mov es, bx
    mov bp, OFFSET try_again_bet_msg
    mov dl, 0
    int 0x10
	call askForInitialBet

invalid_deck_selection:
; Provides information to help guide user with question, then asks again
    mov ah, 0x13
    mov cx, 77
    mov bx, 0
    mov es, bx
    mov bp, OFFSET try_again_choice_msg
    mov dl, 0
    int 0x10
	call askForNumDecks

invalid_comp_bet_mode:
; Add additional information to guide user, then asks them again
    mov ah, 0x13
    mov cx, 77
    mov bx, 0
    mov es, bx
    mov bp, OFFSET try_again_choice_msg
    mov dl, 0
    int 0x10
	call askForCompBetMode


invalid_difficulty:
; Add additional information to guide user, then asks them again
    mov ah, 0x13
    mov cx, 77
    mov bx, 0
    mov es, bx
    mov bp, OFFSET try_again_choice_msg
    mov dl, 0
    int 0x10
	call askDifficultyMode

; Turns and Player Actions:



start_turn:
	call askUserForBet


user_choice:
    call askUserForChoice


keep_hand:
; Keeps Current Hand of the Player

add_card:
; Implement Adding Cards Later...

player_forfeit_turn:
; Player forfeits turn to computer

no_win_yet:
; Displays a message that neither side won yet:
    mov ah, 0x13
    mov cx, 62
    mov bx, 0
    mov es, bx
    mov bp, OFFSET neither_won_message
    mov dl, 0
    int 0x10
	jmp user_choice

win_to_comp:
	call displayUserLost
; Transfers User’s Bet to Computer

win_to_player:
	call displayUserWon
; Transfers Computer’s Bet to User

next_turn:
	call askUserForNextTurn

game_end:
; Displays Wins and which Player that Won