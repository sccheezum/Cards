; cs 274
; ipa 3.3

p_sum: db 0x14      ; keeping track of current player card sum / score
c_sum: db 0x15      ; these values are currently assigned due to the IPA's isolation

p_bet: db 0x00      ; player & computer bet stores
c_bet: db 0x00
c_bet_mode: db 0x02 ; computer betting mode (0 - conservative, 1 - normal, 2 - aggressive)
p_total: dw 0x00c8  ; total amount of money available for the player and computer
c_total: dw 0x00c8  ; 200 for testing purposes
p_wins: db 0x00     ; total wins for player and computer
c_wins: db 0x00

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

start:
    mov al, byte p_bet
    mov bl, byte c_bet
    add al, 0x32        ; player bets 50 
    mov byte p_bet, al
    cmp byte c_bet_mode, 0x01 ; comparing to determine what bet mode comp is in
    jl _call_conservative 
    je _call_normal
    jg _call_aggressive
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
    
_call_conservative:
    call _conservative
    jmp _continue
    
_call_normal:
    call _normal
    jmp _continue
    
_call_aggressive:
    call _aggressive
    jmp _continue
    
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
    mov al, 0x11            ; placeholder val for testing

_c_game_win:
    ; Display that the computer won
    mov al, 0xcc            ; placeholder val for testing


    
