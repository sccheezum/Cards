; IPA 5: 3.5 of Final Project
;
; CS 274
; Susannah Cheezum and Eugene Thompson 
; Implementing Computer Betting Behavior

comp_keep_hand_buffer:
; Adjust the first byte for testing
    db 20
    db [0x00, 0x04]
    
comp_add_card_buffer:
; Adjust the first byte for testing
    db 40
    db [0x00, 0x04]
    
comp_forfeit_turn_buffer:
; Adjust the first byte for testing
    db 40
    db [0x00, 0x04]

x_0: 
    dw 0x1563     ; current val, init as seed (x_0)
a: 
    dw 0x05        ; multiplier (a)
m: 
    dw 0x315d    ; large prime (m)
x_k: 
    dw 0x00    ; current iteration
i: 
    dw 2         ; stores number of iterations

comp_kept_hand_msg:
    db "Computer kept its hand!"

comp_added_card_msg:
    db "Computer added a card to its hand!"

comp_forfeited_turn_msg:
    db "Computer forfeited its turn to player!"
    
choose_comp_risk_lvl_msg:
    db "Choose the Computer's Risk Levels below:"

comp_keep_hand_lvl_msg:
    db "Input a number between 0-100, enter how likely the computer should keep its hand"
    
comp_add_card_lvl_msg:
    db "Input a number between 0-100, enter how likely the computer should add a card"
    
comp_forfeit_turn_msg:
    db "Input a number between 0-100, enter how likely the computer will forfeit a turn"

; TODO: Implement a better version of the ASCII conversion to put the correct value
; at the start of the buffer



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

    ; TODO: Make Check to make sure it adds to 100


	ret
}
def lehmer_algorithm {
    ;compute using Lehmer's Algorithm
    mul bx      ; ax = ax * bx
    div cx      ; ax mod cx, results lie in dx
    mov ax, dx 
    mov word x_k, dx
    ret
}

start:
    ;call askForCompRiskLevel ; ask user for Risk Levels
    mov ax, word x_0    ; load seed
    mov bx, word a      ; load regs bx, cx
    mov cx, word m
    mov si, 0           ; stores number of calls
    
_loop:
    cmp si, word i
    jge _choose_action
    call lehmer_algorithm
    inc si
    jmp _loop

_choose_action:
    mov si, 0
    mov bx, 100 ; modulus by 100 to determine what card between 0-51 is selected
    div bx      ; ax mod bx, result is saved in dx
    lea ax, word comp_keep_hand_buffer
    lea bx, word comp_add_card_buffer
    lea cx, word comp_forfeit_turn_buffer
    
    mov si, OFFSET comp_keep_hand_buffer
    mov di, OFFSET comp_add_card_buffer
    
    mov al, byte [si]
    mov bl, byte [di]
    
    mov si, OFFSET comp_forfeit_turn_buffer
    mov cl, byte [si]
    
    add bl, al
    add cl, bl
    
    cmp dl, al
    jbe comp_keep_hand
    
    cmp dl, bl
    jbe comp_add_card
    
    cmp dl, cl
    jbe comp_forfeit_turn
    
    
comp_keep_hand:
    mov ah, 0x13
    mov cx, 23
    mov bx, 0
    mov es, bx
    mov bp, OFFSET comp_kept_hand_msg
    mov dl, 0
    int 0x10

comp_add_card:
    mov ah, 0x13
    mov cx, 32
    mov bx, 0
    mov es, bx
    mov bp, OFFSET comp_added_card_msg
    mov dl, 0
    int 0x10

comp_forfeit_turn:
    mov ah, 0x13
    mov cx, 38
    mov bx, 0
    mov es, bx
    mov bp, OFFSET comp_forfeited_turn_msg
    mov dl, 0
    int 0x10

