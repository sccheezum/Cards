; Randomly Card Picking and Tracking (3.2)

cards: 
    db 0x00 ; Buffer
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


x_0: 
    dw 0x1563   ; seed/current val
a: 
    dw 0x05       ; factor
m: 
    dw 0x315d     ; prime number
x_k: 
    dw 0x00     ; current iteration
decks: 
    db 0x02   ; number of decks being used, up to 3
current_deck:
    db 0x01
cards_used: 
    db 0x00
    db [0x00, 0x9C] ; stores times cards used


def _lehmer_ {
    mov bx, word a      ; loads regs bx and cx
    mov cx, word m  
    mul bx      ; ax * bx
    div cx      ; ax mod cx, res to dx
    mov ax, dx
    mov word x_k, dx
    mov bx, 52
    div bx      ; ax mod bx, res to dx
    ret
}

start:
    mov ax, word x_0    ; loads seed
    
serve_player_cards:
    cmp di, 2
    je reset_counter
; Choose a Card:
    call _lehmer_        ; gives random number
    mov si, OFFSET cards ; load array of cards
    add si, dx           ; Finds the card in the card array
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
    je end_of_turn
; Choose a Card:
    call _lehmer_        ; gives random number
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
; Loads Card to Player's Hand
    mov si, OFFSET comp_hand
    add si, di
    mov byte [si], al
    inc di
    mov ax, word x_k
    jmp serve_computer_cards
    
end_of_turn:
    mov di, 0
    jmp _check_no_cards_left_loop
    
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
    je continue_game            ; If not, then continue game 
    jmp _continue_loop          ; If used, continue loop    

_continue_loop:
    inc si                      ; Increment to Next Card
    cmp si, cx                  ; If at end of the array, go to next deck
    je _goto_next_deck          
    jmp _loop_body              ; Otherwise, continue looping
    
_goto_next_deck:
    cmp bl, byte decks          ; Checks Current Deck with Total Decks
    je end_game                 ; No more Decks? End the Game!
    add bl, 1
    mov byte current_deck, bl
    jmp continue_game
    
continue_game:
    jmp serve_player_cards
    
end_game:

    
    


