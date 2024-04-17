; IPA 3: Represent Cards and Bets and Wins on the Screen (3.2)
;
; CS 274
; Eugene Thompson
;
; Representing Cards and Bets and Wins on the Screen 

ace:
    db "Ace "
jack:
    db "Jack "
queen:
    db "Queen "
king:
    db "King "
diamond:
    db "of Diamonds" 
heart:
    db "of Hearts"
club: 
    db "of Clubs"
spade:
    db "of Spades"
    

def printAce {
    mov cx, 4
    mov SP, OFFSET ace
    int 0x10
    ret
}
def checkAce {
    cmp dh, 0x01
    call printAce
    ret
}
def checkDiamond {
    cmp dh, 0x0D ; Upper Limit of Diamonds (Adjust if Necessary)
    jbe print_diamonds
    ret
}

def checkHeart {
    cmp dh, 0x1A ; Upper Limit of Hearts (Adjust if Necessary)
    jbe print_hearts
    ret
}

def checkClub {
    cmp dh, 0x27 ; Upper Limit of Clubs (Adjust if Necessary)
    jbe print_clubs
    ret
}

def checkSpade {
    cmp dh, 0x34 ; Upper Limit of Spades (Adjust if Necessary)
    jbe print_spades
    call printAce
    ret
}

start:
; TODO: This will be replaced by Lehmer's Algorithm to choose cards in the final code
    mov dh, 0x01            ; the Randomly Chosen Card to be printed out 
    
    mov ah, 0x13            ; move BIOS interrupt number in AH
    mov bx, 0               ; mov 0 to bx, so we can move it to es
    mov es, bx              ; move segment start of string to es, 0
    call checkDiamond
    call checkHeart
    call checkClub
    call checkSpade

print_diamonds:
    call checkAce
    mov cx, 11              ; move length of string in cx
    mov BP, OFFSET diamond   ; move start offset of string in bp
    int 0x10                ; BIOS interrupt
    jmp end
    
print_hearts:
    mov cx, 9              ; move length of string in cx
    mov BP, OFFSET heart   ; move start offset of string in bp
    int 0x10               ; BIOS interrupt
    jmp end
    
print_clubs:
    mov cx, 8              ; move length of string in cx
    mov BP, OFFSET club    ; move start offset of string in bp
    int 0x10               ; BIOS interrupt
    jmp end

print_spades:
    mov cx, 9              ; move length of string in cx
    mov BP, OFFSET spade   ; move start offset of string in bp
    int 0x10               ; BIOS interrupt
    jmp end
    
end:


    