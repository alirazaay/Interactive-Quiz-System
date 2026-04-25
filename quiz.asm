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
    
    ; Question messages
    question db "Q1: What is the capital of Pakistan?$"
    optionA db "A) Lahore$"
    optionB db "B) Karachi$"
    optionC db "C) Islamabad$"
    optionD db "D) Peshawar$"
    
    ; Input prompt
    inputMsg db "Enter your choice (A/B/C/D): $"
    
    ; Result messages
    correctMsg db "Correct Answer!$"
    wrongMsg db "Wrong Answer!$"

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
    ; Display Question
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, question        ; Load address of question into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after question
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Answer Options
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, optionA         ; Load address of option A into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option A
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, optionB         ; Load address of option B into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option B
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, optionC         ; Load address of option C into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option C
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, optionD         ; Load address of option D into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option D
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Input Prompt
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, inputMsg        ; Load address of input prompt into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Get User Input
    ; ========================================
    mov ah, 01h             ; Function 01h: Read character from input
    int 21h                 ; Call DOS interrupt (stores key in AL register)
                            ; AL register now contains user's answer choice
    
    ; Display newline after input
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Check Answer
    ; ========================================
    cmp al, 'C'             ; Compare AL with 'C' (correct answer)
    je CHECK_CORRECT        ; Jump to CHECK_CORRECT if equal (ZF is set)
    jne CHECK_WRONG         ; Jump to CHECK_WRONG if not equal
    
CHECK_CORRECT:
    ; ========================================
    ; Display Correct Answer Message
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, correctMsg      ; Load address of correct message into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; Jump to program termination
    jmp TERMINATE_PROGRAM
    
CHECK_WRONG:
    ; ========================================
    ; Display Wrong Answer Message
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, wrongMsg        ; Load address of wrong message into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
TERMINATE_PROGRAM:
    ; ========================================
    ; Terminate the program
    ; ========================================
    mov ah, 4Ch             ; Function 4Ch: Terminate program
    mov al, 0               ; Exit code: 0 (indicates successful execution)
    int 21h                 ; Call DOS interrupt to exit
    
main ENDP

END main                    ; End of program, specify main as entry point

