; Final Project: Blackjack
;
; CS 274
; Susannah Cheezum and Eugene Thompson 
; Implementing Blackjack in Assembly

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

p_sum: db 0x14      ; keeping track of current player card sum / score
c_sum: db 0x15      ; these values are currently assigned due to the IPA's isolation

p_bet: db 0x00      ; player & computer bet stores
c_bet: db 0x00
c_bet_mode: db 0x02 ; computer betting mode (0 - conservative, 1 - normal, 2 - aggressive)
p_total: dw 0x00c8  ; total amount of money available for the player and computer
c_total: dw 0x00c8  ; 200 for testing purposes
p_wins: db 0x00     ; total wins for player and computer
c_wins: db 0x00



; Universal Procedures:
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
    cmp al, 0x01
    je ace_card
    
    cmp al, 0x0A
    je ten_card
    
    cmp al, 0x0B
    je jack_card
    
    cmp al, 0x0C
    je queen_card

    cmp al, 0x0D
    je king_card
    
    jmp assign_num
    ret
}

def areCardsLeft {
; Checks if there are no cards left
; If there are cards, continue
; Otherwise, jmp game_end:
	ret
}

def chooseCompAction {
; Based on the Risk Level, choose computer action
; Ex. Keep set at 20, Add set to 50, and Forfeit to 30
	; Keep: 0-20, Add: 20-70, Forfeit: 70-100
; Then, use Lehmer’s Algorithm (mod 100) to choose 
; Within those ranges, decide on the action
; Jumps to appropriate ranges within range
	ret
}
; Supplementary Procedures for User Config

def askForInitialBet {
; User Inputs a number between 10-1000
; System waits for response


;  Once user inputs value, system checks if it is a valid
; Jumps to invalid_initial_wager if above or below number
	ret
}

def askForNumDecks {
; User will choose to use between 1 to 3 decks of cards
; System waits for response 

; System checks if number of decks requested is valid
; Otherwise, jumps to invalid_deck_selection
	ret
}
; add in three mode definitions
def _conservative{ ; 20% smaller bet from computer
    mov al, byte p_bet
    mov bl, 0x04
    mul bl
    mov bl, 0x05
    div bl
    mov byte c_bet, al
    ret
}

def _normal{ ; computer bet matches player
    mov al,  byte p_bet
    mov byte c_bet, al
    ret
}

def _aggressive{ ; 30% larger bet from computer
    mov al, byte p_bet
    mov bl, 0x0d
    mul bl
    mov bl, 0x0a
    div bl
    mov byte c_bet, al
    ret
}

def askForCompBetMode {
; User can choose between three computer betting modes:
; Conservative, Normal, or Aggressive

; System checks if the response is valid
; If so, configures the multiplier based on the betting modes
; Otherwise, jumps to invalid_comp_bet_mode
	ret
}


def askForCompRiskLevel {
; User can choose between three computer risk levels:
; Keep current hand, Add another Card, Forfeit current hand

; System checks if the response is valid
; Otherwise, jumps to invalid_comp_risk_level
	ret
}

def askDifficultyMode {
; User can choose between three computer difficulty levels:
; Easy, Normal, Hard

; System checks if the response is valid
; If so, configures the multiplier based on the difficulty for the computer’s money
; Otherwise, jumps to invalid_difficulty
	ret
}

; Supplementary Procedures for Turns
def askUserForBet {
; Asks User how much they want to bet from their pool
; System checks if the bet is valid
; Otherwise, jumps to ask_for_bet_again
	ret
}

def displayCard {
; Displays player card
    ret
}

def checkAvailableFunds {
; If available funds for both opponents
; If yes, continue turn
; if no, end game, and indicate who lost
	ret
}

def displayUserWon {
; Displays to the User that they won 
    ret
}

def displayUserLost {
; Displays to the User that they lost
    ret
}


def checkIfCompAll_In {
; Checks if the computer has funds
; If it is lower than the human bet adjusted by its policy,
; then the Computer goes All In!
	ret
}

def askUserForNextTurn {
; System asks user if they want to play another turn
; if yes, jump to check_turn_requirements
; if no, go to the game_end, and displays winnings
	ret
}



start:
    mov al, byte p_bet
    mov bl, byte c_bet
    add al, 0x32       ; player bets 50 (NEED TO CHANGE VALUE TO INTERACT WITH USER)
    mov byte p_bet, al
; Error here, Comparison Arguments cannot be sent to procedures
    ;cmp byte c_bet_mode, 0x01 ; comparing to determine what bet mode comp is in
    ;jl _call_conservative 
    ;je _call_normal
    ;jg _call_aggressive
_continue:
    mov al, byte p_sum
    mov bl, byte c_sum
    cmp al, 0x15 ; testing to see if player has reached 21
    je _p_win
    jg _c_win
    cmp bl, 0x15
    je _c_win
    jg _p_win
    cmp al, bl
    je _tie
    jg _p_win
    jl _c_win

_tie:
    jmp _end
    ; Display to the user that the round ended in a tie so no one won
    ; (to be completed later with the rest of the front end work)

_p_win:
    mov al, byte p_wins
    inc al
    mov byte p_wins, al
    mov al, byte c_bet
    mov bl, byte p_total
    mov cl, byte c_total
    add bl, al
    sub cl, al
    cmp cl, 0x00
    jle _p_game_win      ; if the computer has no money left, player wins
    mov byte p_total, bl
    mov byte c_total, cl
    jmp _end

_c_win:
    mov al, byte c_wins
    inc al
    mov byte c_wins, al
    mov al, byte p_bet
    mov bl, byte c_total
    mov cl, byte p_total
    add bl, al
    sub cl, al
    cmp cl, 0x00
    jle _c_game_win   ; if the player has no money left, computer wins
    mov byte c_total, bl
    mov byte p_total, cl
    jmp _end

_end:
    ; if ending due to no more cards or players choice then compare total wins
    ; If losing a bet results in no money then the player with money remaining wins 
    mov al, byte p_wins
    mov bl, byte c_wins
    cmp al, bl
    jg _p_game_win
    jl _c_game_win
    
_p_game_win:
    ; display that the player won
    mov al, 0x11            ; placeholder val for testing (NEED TO CHANGE W/ USER INTERACT)

_c_game_win:
    ; Display that the computer won
    mov al, 0xcc            ; placeholder val for testing (NEED TO CHANGE W/ USER INTERACT)

    
    
; Initializes Key Variables used

; User Configuration:


user_config:
	call askForInitialBet
	call askForNumDecks
	call askForCompBetMode
	call askForCompRiskLevel
	call askDifficultyMode

invalid_initial_wager:
; Add additional information to guide user, then asks them again
	call askForInitialBet

invalid_deck_selection:
; Provides information to help guide user with question, then asks again
	call askForNumDecks

invalid_comp_bet_mode:
; Add additional information to guide user, then asks them again
	call askForCompBetMode

invalid_comp_risk_level:
; Add additional information to guide user, then asks them again
	call askForCompRiskLevel

invalid_difficulty:
; Add additional information to guide user, then asks them again
	call askDifficultyMode

; Turns and Player Actions:


check_turn_requirements:
	call checkAvailableFunds
	call checkIfCompAll_In
    jmp start_turn

start_turn:
	call askUserForBet

ask_for_bet_again:
; Add additional information to guide user, then asks them again
	call askUserForBet
	call convertStringtoVal

computer_place_bet:
; Computer places bet based off of the multiplier set by the betting mode

;
; Dealing Cards Section:
;

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

_check_no_cards_left_loop:
    mov si, OFFSET cards_used   ; Load the array of used cards
    mov bl, byte current_deck   ; Loads current Deck
    mov ax, si                  ; Setting Maximum Cap for Loop
    mul bl                      ; Sets the Cap to the Current Deck
    mov cx, ax                  ; Moves the Cap to CX
    add cx, 52                  ; Move the Cap to the End of the Cards
    jmp _loop_body
    
_loop_body:
    mov al, byte [si]           ; Load Card
    cmp al, 0x00                ; Check if Card has been used
    je display_cards            ; If not, then continue game 
    jmp _continue_loop          ; If used, continue loop    

_continue_loop:
    inc si                      ; Increment to Next Card
    cmp si, cx                  ; If at end of the array, go to next deck
    je _goto_next_deck          
    jmp _loop_body              ; Otherwise, continue looping
    
_goto_next_deck:
    cmp bl, byte decks          ; Checks Current Deck with Total Decks
    je end_game                 ; No more Decks? End the Game!
    add bl, 1                   ; Otherwise, go to next deck
    mov byte current_deck, bl   ; Move next deck to Current Deck Var
    jmp display_cards           ; Display Cards
    
;
; Display Cards Section:
;

display_cards:
    mov dl, 0x0E            ; the Randomly Chosen Card to be printed out 
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
    jmp user_choice

user_choice:
; Ask User to Keep Hand, or
; Add One More Card, jumping to add_card
; Forfeit Turn and lose their current bet to the computer,
; which jumps to comp_choice

comp_choice:
	call chooseCompAction

keep_hand:
; Keeps Current Hand of the Player

add_card:
    call areCardsLeft
	call chooseRandomCard
	call displayCard

comp_forfeit_turn:
	jmp check_win
	
; Checking Winnings and Next Turn:


turn_action:
; Check if a player’s total card value does not exceed 21
; Check if the user decided

check_win:
; Checks if either player has reached 21 in their hand
; If so, that turn is won, and the opponent’s bet value is given
; to that specific player (either win_ to_comp or win_to_player), 
; then jumps to next_turn

; Otherwise, if a player exceeds 21 in their current hand
; that turn is lost to that player, and the wins are given to the 		
; opponent (either win_ to_comp or win_to_player)

check_hold_win:
	; If the player that is closest to 21 wins, and their opponent’s
	; earnings goes to the other player
	; then, jumps to next_turn

no_win:
	jmp user_choice

win_to_comp:
	call displayUserLost
; Transfers User’s Bet to Computer

win_to_player:
	call displayUserWon
; Transfers Computer’s Bet to User

next_turn:
    mov di, 0
	call askUserForNextTurn

end_game:
; Displays Wins and which Player that Won
