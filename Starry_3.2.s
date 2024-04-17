; Randomly Card Picking and Tracking (3.2)

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
curr: 
    db [0x00, 0x04]  ; stores in use cards
cards: 
    db [0x00, 0x34] ; stores times cards used

def _lehmer_ {
    mul bx      ; ax * bx
    div cx      ; ax mod cx, res to dx
    mov ax, dx
    mov word x_k, dx
    inc si
    mov bx, 52
    div bx      ; ax mod bx, res to dx
    ret
}

start:
    mov ax, word x_0    ; loads seed
    mov bx, word a      ; loads regs bx and cx
    mov cx, word m
    mul bx              ; ax * bx
    div cx              ; ax mod cx, res to dx
    mov ax, dx
    mov word x_k, dx
    
_loop_sel:
    cmp di, 0x04         ; loop to select 4 cards (2 for user, 2 for computer)
    je _exit_loop
    call _lehmer_        ; gives random number
    mov si, OFFSET cards ; load array of used cards
    add si, dx
    mov al, byte[si]     ; move uses to al
    mov bl, byte decks
    cmp al, bl           ; check to see if it's been used
    jge _loop_sel        ; select again if can't be used
    inc al               ; inc uses
    mov byte[si], al
    mov si, OFFSET curr
    inc si
    add si, di
    mov word[si], dx  ; load the current card into the 4 cards in play
    inc di
    jmp _loop_sel
    
_exit_loop: