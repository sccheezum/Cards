; IPA 3: Represent Cards and Bets and Wins on the Screen (3.2)
;
; CS 274
; Eugene Thompson
;
; Representing Cards and Bets and Wins on the Screen 

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



start:
; TODO: This will be replaced by Lehmer's Algorithm to choose cards in the final code
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

    