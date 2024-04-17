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
    mov ah, 0x13            ; move BIOS interrupt number in AH
    mov cx, 4
    mov SP, OFFSET ace
    int 0x10
    jmp check_suits
}

def printJack {
    mov ah, 0x13            ; move BIOS interrupt number in AH
    mov cx, 5
    mov SP, OFFSET jack
    int 0x10
    jmp check_suits
}
def printQueen {
    mov ah, 0x13            ; move BIOS interrupt number in AH
    mov cx, 6
    mov SP, OFFSET queen
    int 0x10
    jmp check_suits
}
def printKing {
    mov ah, 0x13            ; move BIOS interrupt number in AH
    mov cx, 5
    mov SP, OFFSET king
    int 0x10
    jmp check_suits
}

def printNumber {
    mov ax, 0
    mov al, dh
    mov sp, ax
    mov cx, 2
    mov ah, 0x13
    int 0x10
    sub dh, 0x30
    jmp check_suits
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
    mov dh, 0x02            ; the Randomly Chosen Card to be printed out 
    
    mov cx, 13              ; Diviser for Finding Card Value
    mov ah, 0x13            ; move BIOS interrupt number in AH
    mov bx, 0               ; mov 0 to bx, so we can move it to es
    mov es, bx              ; move segment start of string to es, 0
    
checkAce:
    cmp dh, 0x01
    je sendToPrintAce
    cmp dh, 0x0E
    je sendToPrintAce
    cmp dh, 0x1B
    je sendToPrintAce
    cmp dh, 0x28
    je sendToPrintAce
    jmp checkJack
    
checkJack:
    cmp dh, 0x0B
    je sendToPrintJack
    cmp dh, 0x18
    je sendToPrintJack
    cmp dh, 0x25
    je sendToPrintJack
    cmp dh, 0x32
    je sendToPrintJack
    jmp checkQueen
    
checkQueen:
    cmp dh, 0x0C
    je sendToPrintQueen
    cmp dh, 0x19
    je sendToPrintQueen
    cmp dh, 0x26
    je sendToPrintQueen
    cmp dh, 0x33
    je sendToPrintQueen
        
checkKing:
    cmp dh, 0x0D
    je sendToPrintKing
    cmp dh, 0x1A
    je sendToPrintKing
    cmp dh, 0x27
    je sendToPrintKing
    cmp dh, 0x34
    je sendToPrintKing
    
checkNumber:
    add dh, 0x30
    call printNumber
    
    
sendToPrintAce:
    call printAce
    
sendToPrintJack:
    call printJack
    
sendToPrintQueen:
    call printQueen
    
sendToPrintKing:
    call printKing
    
    
check_suits:
    call checkDiamond
    call checkHeart
    call checkClub
    call checkSpade

print_diamonds:
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


    