; ============================================================
; Interactive Quiz System - Main Program
; Assembly Language: 8086
; Environment: EMU8086 DOS
; ============================================================

.MODEL SMALL                ; Memory model: Small (64K code, 64K data)
.STACK 100h                 ; Stack size: 256 bytes

; ============================================================
; DATA SEGMENT - Define all messages and variables here
; ============================================================
.DATA
    msg1 db "Welcome to Interactive Quiz System$"
    msg2 db "Press any key to start...$"
    msg3 db "Quiz Starting...$"
    newline db 13, 10, "$"  ; Carriage return + Line feed for new line

; ============================================================
; CODE SEGMENT - Program logic and procedures
; ============================================================
.CODE

main PROC
    ; ========================================
    ; Initialize Data Segment Register
    ; ========================================
    mov ax, @DATA           ; Load address of data segment into AX
    mov ds, ax              ; Move it to DS register for string access
    
    ; ========================================
    ; Display Message 1: Welcome message
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, msg1            ; Load effective address of msg1 into DX
    int 21h                 ; Call DOS interrupt to display string
    
    ; Display newline after message 1
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Message 2: Prompt for key press
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, msg2            ; Load address of msg2 into DX
    int 21h                 ; Call DOS interrupt to display string
    
    ; Display newline after message 2
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Wait for user key press
    ; ========================================
    mov ah, 01h             ; Function 01h: Read character from input
    int 21h                 ; Call DOS interrupt (stores key in AL register)
    
    ; Display newline after key press
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Message 3: Quiz Starting
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, msg3            ; Load address of msg3 into DX
    int 21h                 ; Call DOS interrupt to display string
    
    ; Display newline after message 3
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Terminate the program
    ; ========================================
    mov ah, 4Ch             ; Function 4Ch: Terminate program
    mov al, 0               ; Exit code: 0 (indicates successful execution)
    int 21h                 ; Call DOS interrupt to exit
    
main ENDP

END main                    ; End of program, specify main as entry point

