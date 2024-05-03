; Final Project: Blackjack
;
; CS 274
; Susannah Cheezum and Eugene Thompson 
; Implementing Blackjack in Assembly


; Configuration Buffers
initial_money_buffer:
    db 0x00
    db [0x00, 0x04]
c_bet_mode: 
    db 0x00 ; computer betting mode (1 - conservative, 2 - normal, 3 - aggressive)
c_total: 
    dw 0x0000  ; total amount of money available for the computer
difficulty_level_buffer:
    db 0x00  
num_decks_buffer:
    db 0x00   
comp_keep_hand_buffer:
    db 0x00
    db [0x00, 0x04]  
comp_add_card_buffer:
    db 0x00
    db [0x00, 0x04]   
comp_forfeit_turn_buffer:
    db 0x00
    db [0x00, 0x04]   
  
continue_game_buffer:
    db 0x00

user_choice_buffer:
    db 0x00

; Card and Deck Variables
cards: 
; Cards Numbered between 1 and 13 are in the Suit of Diamonds
    db 0x01 db 0x02 db 0x03 db 0x04 db 0x05 db 0x06 db 0x07 
    db 0x08 db 0x09 db 0x0A db 0x0B db 0x0C db 0x0D 

; Cards Numbered between 14 and 26 are in the Suit of Hearts
    db 0x0E db 0x0F db 0x10 db 0x11 db 0x12 db 0x13 db 0x14 
    db 0x15 db 0x16 db 0x17 db 0x18 db 0x19 db 0x1A 

; Cards Numbered between 27 and 39 are in the Suit of Clubs
    db 0x1B db 0x1C db 0x1D db 0x1E db 0x1F db 0x20 db 0x21 
    db 0x22 db 0x23 db 0x24 db 0x25 db 0x26 db 0x27 

; Cards Numbered between 40 and 52 are in the Suit of Spades
    db 0x28 db 0x29 db 0x2A db 0x2B db 0x2C db 0x2D db 0x2E 
    db 0x2F db 0x30 db 0x31 db 0x32 db 0x33 db 0x34

player_hand:
    db [0x00, 0x03]
comp_hand:
    db [0x00, 0x03]
decks: 
    db 0x02   ; number of decks being used, up to 3
current_deck:
    db 0x01
cards_used: 
    db 0x00
    db [0x00, 0x9C] ; stores times cards used

ace:
    db "Ace!"
ten:
    db "10!"
jack:
    db "Jack!"
queen:
    db "Queen!"
king:
    db "King!"
diamond:
    db " of Diamonds!" 
heart:
    db " of Hearts!"
club: 
    db " of Clubs!"
spade:
    db " of Spades!"
card_name:
    db [0x00,0x11]

; Random Number Generator Variables

x_0: 
    dw 0x1563      ; current val, init as seed (x_0)
a: 
    dw 0x05        ; multiplier (a)
m: 
    dw 0x315d      ; large prime (m)
x_k: 
    dw 0x00        ; current iteration


; Tracking Bets and Wins Variables:

p_sum: 
    db 0x00      ; keeping track of current player card sum / score
c_sum: 
    db 0x00      ; these values are currently assigned due to the IPA's isolation
p_bet: 
    db 0x00      ; player & computer bet stores
c_bet: 
    dw 0x0000
p_wins: 
    db 0x00     ; total wins for player and computer
c_wins: 
    db 0x00

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
    db "Please indicate which choice you would like to make from the following options:"

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
    
computer_won_game_msg:
    db "You have lost to the computer... better luck next time!"
player_won_game_msg:
    db "Congratulations, you have won the game!"

; Universal Procedures:

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
    

def convertStringtoVal{
; Converts Strings to Values for use in interface
    mov ah, 0
    add di, ax      ; Adds the 1st Place to Count
    
    dec si              ; Proceed to Seconds Place
    mov al, byte [si]   ; Obtains the Second Place Value
    mov bl, 0x0A        ; Sets up the Hexadecimal Conversion
    mul bl              ; Multiplies by Hexadecimal
    add di, ax          ; Adds it to Count
    
    dec si              ; Proceed to Thirds Place
    mov al, byte [si]   ; Obtains the Thirds Place Value
    mov bl, 0x64        ; Sets up the 100s Hexadecimal Place
    mul bl              ; Multiplies by Hexadecimal
    add di, ax          ; Adds to Count

    mov byte [si], ah
    inc si
    mov byte [si], al

	ret
}

def chooseRandomCard { 
    ; Before Calling for the first time  (mov ax, word x_0) 
    ; When calling again (mov ax, word_x_k)
; Load Relevant Values
    mov bx, word a    ; load regs bx, cx
    mov cx, word m
    
; Perform Lehmer's Algorithm
    mul bx      ; ax * bx
    div cx      ; ax mod cx, res to dx
    mov ax, dx
    mov word x_k, dx
    mov bx, 52
    div bx      ; ax mod bx, res to dx
    ret
}

def chooseRandomAction { 
    ; Before Calling for the first time  (mov ax, word x_0) 
    ; When calling again (mov ax, word_x_k)
; Load Relevant Values
    mov bx, word a    ; load regs bx, cx
    mov cx, word m
    
; Perform Lehmer's Algorithm
    mul bx      ; ax * bx
    div cx      ; ax mod cx, res to dx
    mov ax, dx
    mov word x_k, dx
    mov bx, 100
    div bx      ; ax mod bx, res to dx
    ret
}

; Card-Related Procedures

def checkSuit {
    cmp dl, 0x0D ; Upper Limit of Diamonds (Adjust if Necessary)
    jbe diamond_card
    cmp dl, 0x1A ; Upper Limit of Hearts (Adjust if Necessary)
    jbe heart_card
    cmp dl, 0x27 ; Upper Limit of Clubs (Adjust if Necessary)
    jbe club_card
    cmp dl, 0x34 ; Upper Limit of Spades (Adjust if Necessary)
    jbe spade_card
    
    ret
}

def checkSpecialValue {
    cmp al, 0x01    ; Checks if current card is Ace
    je ace_card
    
    cmp al, 0x0A    ; Checks if current card is a Ten
    je ten_card
    
    cmp al, 0x0B    ; Checks if current card is a Jack
    je jack_card
    
    cmp al, 0x0C    ; Checks if current card is a Queen
    je queen_card

    cmp al, 0x0D    ; Checks if current card is a King
    je king_card
    
    jmp assign_num  ; Otherwise output a number
    ret
}

def initializeCardsLeft {
; Checks if there are no cards left
; If there are cards, continue
; Otherwise, jmp end_game:
    mov si, OFFSET cards_used   ; Load the array of used cards
    mov bl, byte current_deck   ; Loads current Deck
    mov ax, si                  ; Setting Maximum Cap for Loop
    mul bl                      ; Sets the Cap to the Current Deck
    mov cx, ax                  ; Moves the Cap to CX
    add cx, 52                  ; Move the Cap to the End of the Cards
    jmp _loop_body
	ret
}

def chooseCompAction {
; Based on the Risk Level, choose computer action
; Ex. Keep set at 20, Add set to 50, and Forfeit to 30
	; Keep: 0-20, Add: 20-70, Forfeit: 70-100
; Then, use Lehmer’s Algorithm (mod 100) to choose 
; Within those ranges, decide on the action
; Jumps to appropriate ranges within range

    mov si, 0
    mov ax, word x_0
    call chooseRandomAction
    lea ax, word comp_keep_hand_buffer      ; load the keep hand percent
    lea bx, word comp_add_card_buffer       ; load the add card percent
    
    mov si, OFFSET comp_keep_hand_buffer    ; move the index to the keep hand val
    mov di, OFFSET comp_add_card_buffer     ; move the index to the add card val
    
    mov al, byte [si]                       ; moving the keep hand val to al
    mov bl, byte [di]                       ; moving the add card val to bl
    
    add bl, al                              ; add for the upper limit for add card
    mov cl, 100                             ; assign upper limit for forfeit turn
    
    cmp dl, al                              ; checks between random num and keep hand 
    jbe comp_keep_hand                      ; if under upper limit, go to keep hand
    
    cmp dl, bl                              ; check between random num and add card 
    jbe comp_add_card                       ; if under upper limit go to add card
    
    cmp dl, cl                              ; check between random num and forfeit turn 
    jbe comp_forfeit_turn                   ; if under upper limit go to forfeit turn
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
    lea dx, word initial_money_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET initial_money_buffer
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


; add in three mode definitions
def _conservative{ ; 20% smaller bet from computer
    mov ah, 0x00
    mov al, byte p_bet
    mov bl, 0x04
    mul bl
    mov bl, 0x05
    div bl
    mov word c_bet, ax
    ret
}

def _normal{ ; computer bet matches player
    mov ah, 0x00
    mov al,  byte p_bet
    mov word c_bet, ax
    ret
}

def _aggressive{ ; 30% larger bet from computer
    mov ah, 0x00
    mov al, byte p_bet
    mov bl, 0x0d
    mul bl
    mov bl, 0x0a
    div bl
    mov word c_bet, ax
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
    lea dx, word c_bet_mode
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET c_bet_mode
    add si, 2
    mov bl, 0x30

; System checks if the response is valid
; If so, configures the multiplier based on the betting modes
; Otherwise, jumps to invalid_comp_bet_mode
    mov al, byte [si]
    cmp al, 0x31
    jl invalid_comp_bet_mode
    cmp al, 0x33
    jg invalid_comp_bet_mode
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


	ret
}

def askDifficultyMode {
; User can choose between three computer difficulty levels:
; Easy, Normal, Hard (1,2,3)
    mov ah, 0x13
    mov cx, 59
    mov bx, 0
    mov es, bx
    mov bp, OFFSET difficulty_mode_msg
    mov dl, 0
    int 0x10
    
    mov cx, 74
    mov bp, OFFSET easy_mode_msg
    int 0x10
    
    mov cx, 74
    mov bp, OFFSET normal_mode_msg
    int 0x10
    
    mov cx, 74
    mov bp, OFFSET hard_mode_msg
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word difficulty_level_buffer
    ; Using interrupt (0x21) here to read input
    int 0x21 
    
    mov si, OFFSET difficulty_level_buffer
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
    mov cx, 68
    mov bx, 0
    mov es, bx
    mov bp, OFFSET ask_bet_msg
    mov dl, 0
    int 0x10
    
    ; System waits for response
    mov ah, 0x0a
    lea dx, word p_bet
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
    je p_keep_hand
    cmp al, 0x32
    je p_add_card
    cmp al, 0x33
    je p_forfeit_turn
}



def checkAvailableFunds {
; If available funds for both opponents
; If yes, continue turn
; if no, end game, and indicate who lost
    mov si, OFFSET c_total
    dec si
    mov ah, byte [si]
    inc si
    mov al, byte [si]
    mov si, OFFSET initial_money_buffer
    mov bh, byte [si]
    inc si
    mov bl, byte [si]
    cmp ax, 0
    je end_game
    cmp bx, 0
    je end_game

	ret
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

def print_tie_msg {
    mov ah, 0x13
    mov cx, 50
    mov bx, 0
    mov es, bx
    mov bp, OFFSET neither_won_message
    mov dl, 0
    int 0x10
    ret
}


def setCompInitialMoney {
    mov si, OFFSET initial_money_buffer
    add si, 2
    mov ah, byte [si]
    inc si
    mov al, byte [si]

    mov si, OFFSET difficulty_level_buffer
    dec si
    mov bl, byte [si]
    sub bl, 1
    
    cmp bl, 0
    je set_easy_money

    cmp bl, 2
    je set_hard_money

    mov si, OFFSET c_total
    dec si
    mov byte [si], ah
    inc si
    mov byte [si], al

    jmp start_turn
    ret
}

def checkIfCompAll_In {
; Checks if the computer has funds
; If it is lower than the human bet adjusted by its policy,
; then the Computer goes All In!
    mov ax, word c_total
    mov bx, word c_bet
    cmp ax, bx
    jbe go_all_in
    jmp initialize
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
    ; if no, go to the end_game, and displays winnings
    mov al, byte [si]
    cmp al, 0x30
    jl next_turn
    cmp al, 0x31
    jg next_turn
    cmp al, 0x30
    je start_turn
    cmp al, 0x31
    je end_game
    
	ret
}

def displayPlayerWonGame {
    mov ah, 0x13
    mov cx, 50
    mov bx, 0
    mov es, bx
    mov bp, OFFSET player_won_game_msg
    mov dl, 0
    int 0x10
    jmp _terminate
}

def displayCompWonGame {
    mov ah, 0x13
    mov cx, 50
    mov bx, 0
    mov es, bx
    mov bp, OFFSET computer_won_game_msg
    mov dl, 0
    int 0x10
    jmp _terminate
}
    
; User Configuration:


start:
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
; Correcting for values of Hundred 
    add si, 1
    mov di, 0
    call convertCharToNum
    
account_thousand_diff:
; Correct for Thousand Bet 
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
	call askForNumDecks
	call askForCompBetMode
	
risk_level_config:
    mov di, 0
	call askForCompRiskLevel
    call askDifficultyMode
    call setCompInitialMoney

set_easy_money:
    mov di, ax
    mov bx, 2
    div bx
    sub di, ax
    mov ax, di
    mov si, OFFSET c_total
    mov byte [si], ah
    inc si
    mov byte [si], al

	jmp start_turn
	
set_hard_money:
    mov di, ax
    mov bx, 2
    div bx
    add di, ax
    mov ax, di
    mov si, OFFSET c_total
    mov byte [si], ah
    inc si
    mov byte [si], al

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
	call convertStringtoVal
	jmp place_bet

ask_for_bet_again:
; Add additional information to guide user, then asks them again
	call askUserForBet
	call convertStringtoVal

place_bet:
; Player placed bet based on the previous labels
; Computer places bet based off of the multiplier set by the betting mode
    mov al, byte p_bet
    mov bx, word c_bet
    mov byte p_bet, al
    cmp byte c_bet_mode, 0x01 ; comparing to determine what bet mode comp is in
    jl _call_conservative 
    cmp byte c_bet_mode, 0x01 ; comparing to determine what bet mode comp is in
    je _call_normal
    cmp byte c_bet_mode, 0x01 ; comparing to determine what bet mode comp is in
    jg _call_aggressive

_call_conservative:
    call _conservative
    jmp check_turn_requirements
    
_call_normal:
    call _normal
    jmp check_turn_requirements
    
_call_aggressive:
    call _aggressive
    jmp check_turn_requirements
    

check_turn_requirements:
	call checkAvailableFunds
	call checkIfCompAll_In

go_all_in:
; Computer Goes All In!
    mov word c_bet, ax
    jmp initialize

;
; Dealing Cards Section:
;
initialize:
    mov di, 0
    mov ax, word x_0
serve_player_cards:
    cmp di, 2
    je reset_counter
; Choose a Card:
    call chooseRandomCard ; gives random number
    mov si, OFFSET cards        ; load array of cards
    add si, dx                  ; Finds the card in the card array
    mov bl, byte current_deck   ; Loads current Deck
    
; Checks if Card was used:
    mov ax, dx                  ; Move Card Val to AX
    mul bl                      ; Finds the Indice for Card_Used array    
    mov si, OFFSET cards_used   ; Load the array of used cards
    add si, ax                  ; Finds the Card in the Used Card Array
    cmp al, byte [si]           ; Check if card is already used
    je serve_player_cards       ; If so, pick another card
    mov byte [si], al           ; Store the Current Card in the array
    
; Loads Card to Player's Hand
    mov si, OFFSET player_hand
    add si, di
    mov byte [si], al
    inc di
    mov ax, word x_k
    jmp serve_player_cards

reset_counter:
    mov di, 0
    jmp serve_computer_cards
    
serve_computer_cards:
    cmp di, 2
    je user_choice
; Choose a Card:
    call chooseRandomCard        ; gives random number
    mov si, OFFSET cards ; load array of cards
    add si, dx           ; Finds the card in the card array
    mov bl, byte current_deck   ; Loads current Deck
    
; Checks if Card was used:
    mov ax, dx                  ; Move Card Val to AX
    mul bl                      ; Finds the Indice for Card_Used array    
    mov si, OFFSET cards_used   ; Load the array of used cards
    add si, ax                  ; Finds the Card in the Used Card Array
    cmp al, byte [si]           ; Check if card is already used
    je serve_computer_cards       ; If so, pick another card
    mov byte [si], al           ; Store the Current Card in the array

; Loads Card to Computer's Hand
    mov si, OFFSET comp_hand
    add si, di
    mov byte [si], al
    inc di
    mov ax, word x_k
    jmp serve_computer_cards

_check_no_cards_left:
    call initializeCardsLeft

_loop_body:
    mov al, byte [si]           ; Load Card
    cmp al, 0x00                ; Check if Card has been used
    je display_cards            ; If not, then continue game 
    inc si                      ; Increment to Next Card
    cmp si, cx                  ; If at end of the array, go to next deck
    je _goto_next_deck          
    jmp _loop_body              ; Otherwise, continue looping
    
_goto_next_deck:
    cmp bl, byte decks          ; Checks Current Deck with Total Decks
    je end_game                 ; No more Decks? End the Game!
    add bl, 1                   ; Otherwise, go to next deck
    mov byte current_deck, bl   ; Move next deck to Current Deck Var
    
;
; Display Cards Section:
;

display_cards:
    mov al, dl              ; Assign the value of the card
    mov cl, 0x0D              ; Diviser for Finding Card Value
    mov di, OFFSET card_name
    cmp dl, 0x0D                ; Checks if it is not a diamond
    jae normalize_card_value    ; Normalizes its card value
    call checkSpecialValue

normalize_card_value:
    div cl
    call checkSpecialValue
    
diamond_card:
    mov si, OFFSET diamond
    jmp assign_diamonds_loop
heart_card:
    mov si, OFFSET heart
    jmp assign_hearts_loop
club_card:
    mov si, OFFSET club
    jmp assign_clubs_loop
spade_card:
    mov si, OFFSET spade
    jmp assign_spades_loop
ace_card:
    mov si, OFFSET ace
    jmp assign_ace_loop
ten_card:
    mov si, OFFSET ten
    jmp assign_ten_loop
jack_card:
    mov si, OFFSET jack
    jmp assign_jack_loop
queen_card:
    mov si, OFFSET queen
    jmp assign_queen_loop
king_card:
    mov si, OFFSET king
    jmp assign_king_loop
    
assign_ace_loop:
    mov al, byte [si]
    cmp al, 0x21
    je continue_print
    mov byte [di], al
    inc si
    inc di
    jmp assign_ace_loop
    
assign_ten_loop:
    mov al, byte [si]
    cmp al, 0x21
    je continue_print
    mov byte [di], al
    inc si
    inc di
    jmp assign_ten_loop

assign_jack_loop:
    mov al, byte [si]
    cmp al, 0x21
    je continue_print
    mov byte [di], al
    inc si
    inc di
    jmp assign_jack_loop

assign_queen_loop:
    mov al, byte [si]
    cmp al, 0x21
    je continue_print
    mov byte [di], al
    inc si
    inc di
    jmp assign_queen_loop

assign_king_loop:
    mov al, byte [si]
    cmp al, 0x21
    je continue_print
    mov byte [di], al
    inc si
    inc di
    jmp assign_king_loop

assign_num:
    add al, 0x30
    mov byte [di], al
    inc si 
    inc di
    jmp continue_print
    
continue_print:
    inc di
    call checkSuit

assign_diamonds_loop:
    mov al, byte [si]
    cmp al, 0x21
    je print_card
    mov byte [di], al
    inc si
    inc di
    jmp assign_diamonds_loop
    
assign_hearts_loop:
    mov al, byte [si]
    cmp al, 0x21
    je print_card
    mov byte [di], al
    inc si
    inc di
    jmp assign_hearts_loop
    
assign_clubs_loop:
    mov al, byte [si]
    cmp al, 0x21
    je print_card
    mov byte [di], al
    inc si
    inc di
    jmp assign_clubs_loop
    
assign_spades_loop:
    mov al, byte [si]
    cmp al, 0x21
    je print_card
    mov byte [di], al
    inc si
    inc di
    jmp assign_spades_loop

print_card:
    mov ah, 0x13            ; move BIOS interrupt number in AH
    mov bx, 0               ; mov 0 to bx, so we can move it to es
    mov es, bx              ; move segment start of string to es, 0
    mov cx, 0x11
    mov bp, OFFSET card_name
    mov dl, 0
    int 0x10

user_choice:
; Ask User to Keep Hand, or
; Add One More Card, jumping to add_card
; Forfeit Turn and lose their current bet to the computer,
; which jumps to comp_choice
    call askUserForChoice


p_keep_hand:
; Keeps Current Hand of the Player
    jmp comp_choice


p_add_card:
	call chooseRandomCard
    mov ax, word x_k
    mov si, OFFSET cards        ; load array of cards
    add si, dx                  ; Finds the card in the card array
    mov bl, byte current_deck   ; Loads current Deck
    
; Checks if Card was used:
    mov ax, dx                  ; Move Card Val to AX
    mul bl                      ; Finds the Indice for Card_Used array    
    mov si, OFFSET cards_used   ; Load the array of used cards
    add si, ax                  ; Finds the Card in the Used Card Array
    cmp al, byte [si]           ; Check if card is already used
    je p_add_card       ; If so, pick another card
    mov byte [si], al           ; Store the Current Card in the array
    
; Loads Card to Player's Hand
    mov si, OFFSET player_hand
    add si, 2
    mov byte [si], al
	jmp display_cards


p_forfeit_turn:
; Do Nothing wow....
    jmp comp_choice

comp_choice:
	call chooseCompAction

comp_keep_hand:
    jmp check_win

comp_add_card:
    call chooseRandomCard
    mov ax, word x_k
    mov si, OFFSET cards        ; load array of cards
    add si, dx                  ; Finds the card in the card array
    mov bl, byte current_deck   ; Loads current Deck
    
; Checks if Card was used:
    mov ax, dx                  ; Move Card Val to AX
    mul bl                      ; Finds the Indice for Card_Used array    
    mov si, OFFSET cards_used   ; Load the array of used cards
    add si, ax                  ; Finds the Card in the Used Card Array
    cmp al, byte [si]           ; Check if card is already used
    je comp_add_card       ; If so, pick another card
    mov byte [si], al           ; Store the Current Card in the array
    
; Loads Card to Player's Hand
    mov si, OFFSET comp_hand
    add si, 2
    mov byte [si], al
	jmp display_cards

comp_forfeit_turn:
	jmp check_win


	
; Checking Winnings and Next Turn:


check_win:
; Checks if either player has reached 21 in their hand
; If so, that turn is won, and the opponent’s bet value is given
; to that specific player (either win_ to_comp or win_to_player), 
; then jumps to next_turn

    mov al, byte p_sum
    mov bl, byte c_sum
    cmp al, 0x15 ; testing to see if player has reached 21
    je _p_win
    cmp al, 0x15 ; testing to see if player has greater than 21
    jg _c_win
    cmp bl, 0x15 ; testing to see if comp has reached 21
    je _c_win
    cmp bl, 0x15 ; testing to see if comp has greater than 21
    jg _p_win
    cmp al, bl ; testing to see if there is a tie between player and comp
    je _tie
    cmp al, bl ; testing to see if player won over comp
    jg _p_win
    cmp al, bl ; testing to see if computer won over player
    jl _c_win

; Otherwise, if a player exceeds 21 in their current hand
; that turn is lost to that player, and the wins are given to the 		
; opponent (either win_ to_comp or win_to_player)

_tie:
    jmp check_turn_requirements
    ; Display to the user that the round ended in a tie so no one won
    

_p_win:
    mov al, byte p_wins
    inc al
    mov byte p_wins, al
    mov ax, word c_bet
    mov bl, byte initial_money_buffer
    mov cl, byte c_total
    add bl, al
    sub cl, al
    cmp cl, 0x00
    jle _p_game_win      ; if the computer has no money left, player wins
    mov byte initial_money_buffer, bl
    mov byte c_total, cl
    jmp cleanup_crew

_c_win:
    mov al, byte c_wins
    inc al
    mov byte c_wins, al
    mov al, byte p_bet
    mov bl, byte c_total
    mov cl, byte initial_money_buffer
    add bl, al
    sub cl, al
    cmp cl, 0x00
    jle _c_game_win   ; if the player has no money left, computer wins
    mov byte c_total, bl
    mov byte initial_money_buffer, cl
    jmp cleanup_crew

cleanup_crew:
    mov si, OFFSET player_hand
    add si, 2
    mov byte [si], 0
    mov si, OFFSET comp_hand
    add si, 2
    mov byte [si], 0
    jmp check_turn_requirements

no_win:
	jmp user_choice

_c_game_win:
	call displayUserLost
; Transfers User’s Bet to Computer
    ; INSUFFICIENT FUNDSSSSSSS YAY
    mov bx, 0
    mov es, bx
    mov cx, 71
    mov bp, OFFSET insufficient_funds_msg
    mov dl, 0
    int 0x10


_p_game_win:
	call displayUserWon
; Transfers Computer’s Bet to User

next_turn:
    mov di, 0
	call askUserForNextTurn



end_game:
; Displays Wins and which Player that Won
    ; if ending due to no more cards or players choice then compare total wins
    ; If losing a bet results in no money then the player with money remaining wins 
    mov al, byte p_wins
    mov bl, byte c_wins
    cmp al, bl
    jg player_won_game
    cmp al, bl
    jl comp_won_game
    
player_won_game:
    call displayPlayerWonGame

comp_won_game:
    call displayCompWonGame
    
_terminate: