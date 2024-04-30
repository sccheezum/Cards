; TODO: 


; Universal Procedures:
def convertValToString{
; Converts Values to Strings for use in interface
	ret
}

def chooseRandomCard {
; Using Lehmer’s Algorithm to choose a card
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

start_turn:
	call askUserForBet

ask_for_bet_again:
; Add additional information to guide user, then asks them again
	call askUserForBet
	call convertValToString

computer_place_bet:
; Computer places bet based off of the multiplier set by the betting mode

receive_cards:
; Calls the random card procedure twice per each opponent

display_cards:
; Displays for the sets per opponents with the computer’s obscured

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
	call askUserForNextTurn

game_end:
; Displays Wins and which Player that Won