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
    
    ; Score variable
    score db 0              ; Initialize score to 0
    
    ; Question 1 messages
    question1 db "Q1: What is the capital of Pakistan?$"
    q1_optionA db "A) Lahore$"
    q1_optionB db "B) Karachi$"
    q1_optionC db "C) Islamabad$"
    q1_optionD db "D) Peshawar$"
    
    ; Question 2 messages
    question2 db "Q2: Which language is used for 8086 programming?$"
    q2_optionA db "A) Python$"
    q2_optionB db "B) Assembly$"
    q2_optionC db "C) Java$"
    q2_optionD db "D) C++$"
    
    ; Input prompt
    inputMsg db "Enter your choice (A/B/C/D): $"
    
    ; Result messages
    correctMsg db "Correct Answer!$"
    wrongMsg db "Wrong Answer!$"
    
    ; Quiz completion messages
    quizFinished db "Quiz Finished!$"
    scoreMsg db "Your Score: $"

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
    ; QUESTION 1
    ; ========================================
    jmp Q1                  ; Jump to Question 1
    
Q1:
    ; ========================================
    ; Display Question 1
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, question1       ; Load address of question1 into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after question
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Q1 Answer Options
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, q1_optionA      ; Load address of option A into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option A
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, q1_optionB      ; Load address of option B into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option B
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, q1_optionC      ; Load address of option C into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option C
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, q1_optionD      ; Load address of option D into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option D
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Input Prompt for Q1
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, inputMsg        ; Load address of input prompt into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Get User Input for Q1
    ; ========================================
    mov ah, 01h             ; Function 01h: Read character from input
    int 21h                 ; Call DOS interrupt (stores key in AL register)
                            ; AL register now contains user's answer choice
    
    ; Display newline after input
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Check Q1 Answer (Correct answer: C)
    ; ========================================
    cmp al, 'C'             ; Compare AL with 'C' (correct answer for Q1)
    je Q1_CORRECT           ; Jump if correct
    jne Q1_WRONG            ; Jump if wrong
    
Q1_CORRECT:
    ; ========================================
    ; Display Correct Answer Message for Q1
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, correctMsg      ; Load address of correct message into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; Increment score for correct answer
    mov al, [score]         ; Load current score into AL
    inc al                  ; Increment score (AL = AL + 1)
    mov [score], al         ; Store updated score back to score variable
    
    ; Jump to Q2
    jmp Q2
    
Q1_WRONG:
    ; ========================================
    ; Display Wrong Answer Message for Q1
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, wrongMsg        ; Load address of wrong message into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; Jump to Q2 (without incrementing score)
    jmp Q2
    
    ; ========================================
    ; QUESTION 2
    ; ========================================
Q2:
    ; Display newline for spacing
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Question 2
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, question2       ; Load address of question2 into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after question
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Q2 Answer Options
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, q2_optionA      ; Load address of option A into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option A
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, q2_optionB      ; Load address of option B into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option B
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, q2_optionC      ; Load address of option C into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option C
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    mov ah, 09h             ; Function 09h: Display string
    lea dx, q2_optionD      ; Load address of option D into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline after option D
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Input Prompt for Q2
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, inputMsg        ; Load address of input prompt into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Get User Input for Q2
    ; ========================================
    mov ah, 01h             ; Function 01h: Read character from input
    int 21h                 ; Call DOS interrupt (stores key in AL register)
                            ; AL register now contains user's answer choice
    
    ; Display newline after input
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Check Q2 Answer (Correct answer: B)
    ; ========================================
    cmp al, 'B'             ; Compare AL with 'B' (correct answer for Q2)
    je Q2_CORRECT           ; Jump if correct
    jne Q2_WRONG            ; Jump if wrong
    
Q2_CORRECT:
    ; ========================================
    ; Display Correct Answer Message for Q2
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, correctMsg      ; Load address of correct message into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; Increment score for correct answer
    mov al, [score]         ; Load current score into AL
    inc al                  ; Increment score (AL = AL + 1)
    mov [score], al         ; Store updated score back to score variable
    
    ; Jump to display final results
    jmp DISPLAY_RESULTS
    
Q2_WRONG:
    ; ========================================
    ; Display Wrong Answer Message for Q2
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, wrongMsg        ; Load address of wrong message into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; Jump to display final results (without incrementing score)
    jmp DISPLAY_RESULTS
    
    ; ========================================
    ; DISPLAY FINAL RESULTS
    ; ========================================
DISPLAY_RESULTS:
    ; Display newline for spacing
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display "Quiz Finished!"
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, quizFinished    ; Load address of quiz finished message into DX
    int 21h                 ; Call DOS interrupt
    
    ; Display newline
    mov ah, 09h             ; Function 09h: Display string
    lea dx, newline         ; Load address of newline into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Display Score Message
    ; ========================================
    mov ah, 09h             ; Function 09h: Display string
    lea dx, scoreMsg        ; Load address of score message into DX
    int 21h                 ; Call DOS interrupt
    
    ; ========================================
    ; Convert Score to ASCII and Display
    ; ========================================
    mov al, [score]         ; Load score value into AL
    add al, 30h             ; Add 30h to convert digit to ASCII (0->30h, 1->31h, etc.)
    mov dl, al              ; Move ASCII value to DL for display
    mov ah, 02h             ; Function 02h: Display single character
    int 21h                 ; Call DOS interrupt to display the score
    
    ; Display newline
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

