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

; ============================================================
; PROCEDURE: DISPLAY_STRING
; Purpose: Display a string on screen using INT 21h (AH=09h)
; Input: DX = address of string to display (must be $-terminated)
; Output: None
; Modifies: AH register
; ============================================================
DISPLAY_STRING PROC
    mov ah, 09h             ; Function 09h: Display string
    int 21h                 ; Call DOS interrupt to display string
    ret                     ; Return to caller
DISPLAY_STRING ENDP

; ============================================================
; PROCEDURE: GET_INPUT
; Purpose: Read a single character from input
; Input: None
; Output: AL = character read from input (converted to uppercase if lowercase)
; Modifies: AH, AL registers
; ============================================================
GET_INPUT PROC
    mov ah, 01h             ; Function 01h: Read character from input
    int 21h                 ; Call DOS interrupt (result in AL)
    call CONVERT_TO_UPPERCASE  ; Convert to uppercase if lowercase
    ret                     ; Return to caller with input in AL
GET_INPUT ENDP

; ============================================================
; PROCEDURE: CONVERT_TO_UPPERCASE
; Purpose: Convert lowercase letters to uppercase
; Input: AL = character to convert
; Output: AL = converted character (uppercase if was lowercase)
; Conversion Logic: If character is between 'a'-'z', subtract 20h
; Modifies: AL register
; ============================================================
CONVERT_TO_UPPERCASE PROC
    cmp al, 'a'             ; Check if AL is >= 'a'
    jl NOT_LOWERCASE        ; If less than 'a', not lowercase, skip conversion
    cmp al, 'z'             ; Check if AL is <= 'z'
    jg NOT_LOWERCASE        ; If greater than 'z', not lowercase, skip conversion
    sub al, 20h             ; Convert to uppercase by subtracting 20h (32 decimal)
                            ; 'a' (61h) - 20h = 'A' (41h)
                            ; 'z' (7Ah) - 20h = 'Z' (5Ah)
NOT_LOWERCASE:
    ret                     ; Return to caller with converted character in AL
CONVERT_TO_UPPERCASE ENDP

; ============================================================
; PROCEDURE: CHECK_ANSWER
; Purpose: Check user answer against correct answer
; Input: AL = user's answer
;        BL = correct answer
; Output: None (modifies score and displays result)
; Modifies: AH, AL, DX registers
; ============================================================
CHECK_ANSWER PROC
    cmp al, bl              ; Compare user answer (AL) with correct answer (BL)
    je ANSWER_CORRECT       ; Jump if correct
    jne ANSWER_WRONG        ; Jump if wrong
    
ANSWER_CORRECT:
    ; ========================================
    ; Display Correct Answer Message
    ; ========================================
    lea dx, correctMsg      ; Load address of correct message
    call DISPLAY_STRING     ; Call DISPLAY_STRING procedure
    
    ; Display newline
    lea dx, newline         ; Load address of newline
    call DISPLAY_STRING     ; Call DISPLAY_STRING procedure
    
    ; Increment score for correct answer
    mov al, [score]         ; Load current score into AL
    inc al                  ; Increment score (AL = AL + 1)
    mov [score], al         ; Store updated score back to score variable
    ret                     ; Return to caller
    
ANSWER_WRONG:
    ; ========================================
    ; Display Wrong Answer Message
    ; ========================================
    lea dx, wrongMsg        ; Load address of wrong message
    call DISPLAY_STRING     ; Call DISPLAY_STRING procedure
    
    ; Display newline
    lea dx, newline         ; Load address of newline
    call DISPLAY_STRING     ; Call DISPLAY_STRING procedure
    ret                     ; Return to caller (without incrementing score)
    
CHECK_ANSWER ENDP

; ============================================================
; PROCEDURE: Q1
; Purpose: Execute Question 1
; Input: None
; Output: None
; Modifies: Multiple registers (uses PUSH/POP to preserve)
; ============================================================
Q1 PROC
    ; ========================================
    ; Display Question 1
    ; ========================================
    lea dx, question1       ; Load address of question1
    call DISPLAY_STRING     ; Display question
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Display Q1 Answer Options
    ; ========================================
    lea dx, q1_optionA      ; Load address of option A
    call DISPLAY_STRING     ; Display option
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    lea dx, q1_optionB      ; Load address of option B
    call DISPLAY_STRING     ; Display option
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    lea dx, q1_optionC      ; Load address of option C
    call DISPLAY_STRING     ; Display option
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    lea dx, q1_optionD      ; Load address of option D
    call DISPLAY_STRING     ; Display option
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Display Input Prompt
    ; ========================================
    lea dx, inputMsg        ; Load address of input prompt
    call DISPLAY_STRING     ; Display prompt
    
    ; ========================================
    ; Get User Input for Q1
    ; ========================================
    call GET_INPUT          ; Call GET_INPUT procedure
                            ; (returns uppercase answer in AL)
    
    ; Display newline after input
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Check Q1 Answer (Correct answer: C)
    ; ========================================
    push ax                 ; Preserve AL register
    mov bl, 'C'             ; Load correct answer 'C' into BL
    pop ax                  ; Restore AL (user's answer, now uppercase)
    call CHECK_ANSWER       ; Call CHECK_ANSWER procedure
    
    ret                     ; Return to caller
Q1 ENDP

; ============================================================
; PROCEDURE: Q2
; Purpose: Execute Question 2
; Input: None
; Output: None
; Modifies: Multiple registers (uses PUSH/POP to preserve)
; ============================================================
Q2 PROC
    ; Display newline for spacing
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Display Question 2
    ; ========================================
    lea dx, question2       ; Load address of question2
    call DISPLAY_STRING     ; Display question
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Display Q2 Answer Options
    ; ========================================
    lea dx, q2_optionA      ; Load address of option A
    call DISPLAY_STRING     ; Display option
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    lea dx, q2_optionB      ; Load address of option B
    call DISPLAY_STRING     ; Display option
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    lea dx, q2_optionC      ; Load address of option C
    call DISPLAY_STRING     ; Display option
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    lea dx, q2_optionD      ; Load address of option D
    call DISPLAY_STRING     ; Display option
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Display Input Prompt
    ; ========================================
    lea dx, inputMsg        ; Load address of input prompt
    call DISPLAY_STRING     ; Display prompt
    
    ; ========================================
    ; Get User Input for Q2
    ; ========================================
    call GET_INPUT          ; Call GET_INPUT procedure
                            ; (returns uppercase answer in AL)
    
    ; Display newline after input
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Check Q2 Answer (Correct answer: B)
    ; ========================================
    push ax                 ; Preserve AL register
    mov bl, 'B'             ; Load correct answer 'B' into BL
    pop ax                  ; Restore AL (user's answer, now uppercase)
    call CHECK_ANSWER       ; Call CHECK_ANSWER procedure
    
    ret                     ; Return to caller
Q2 ENDP

; ============================================================
; PROCEDURE: DISPLAY_FINAL_RESULTS
; Purpose: Display final quiz results and score
; Input: None (accesses score variable)
; Output: None
; Modifies: AH, AL, DL registers
; ============================================================
DISPLAY_FINAL_RESULTS PROC
    ; Display newline for spacing
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Display "Quiz Finished!"
    ; ========================================
    lea dx, quizFinished    ; Load address of quiz finished message
    call DISPLAY_STRING     ; Display message
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Display Score Message
    ; ========================================
    lea dx, scoreMsg        ; Load address of score message
    call DISPLAY_STRING     ; Display message
    
    ; ========================================
    ; Convert Score to ASCII and Display
    ; ========================================
    mov al, [score]         ; Load score value into AL
    add al, 30h             ; Add 30h to convert digit to ASCII
    mov dl, al              ; Move ASCII value to DL for display
    mov ah, 02h             ; Function 02h: Display single character
    int 21h                 ; Call DOS interrupt to display the score
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ret                     ; Return to caller
DISPLAY_FINAL_RESULTS ENDP

; ============================================================
; PROCEDURE: main
; Purpose: Main entry point of the program
; ============================================================
main PROC
    ; ========================================
    ; Initialize Data Segment Register
    ; ========================================
    mov ax, @DATA           ; Load address of data segment into AX
    mov ds, ax              ; Move it to DS register for string access
    
    ; ========================================
    ; Display Welcome Messages
    ; ========================================
    lea dx, msg1            ; Load address of msg1
    call DISPLAY_STRING     ; Display welcome message
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    lea dx, msg2            ; Load address of msg2
    call DISPLAY_STRING     ; Display key press prompt
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Wait for user key press
    ; ========================================
    call GET_INPUT          ; Call GET_INPUT procedure
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Display Quiz Starting Message
    ; ========================================
    lea dx, msg3            ; Load address of msg3
    call DISPLAY_STRING     ; Display quiz starting message
    
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline
    
    ; ========================================
    ; Execute Question 1
    ; ========================================
    call Q1                 ; Call Q1 procedure
    
    ; ========================================
    ; Execute Question 2
    ; ========================================
    call Q2                 ; Call Q2 procedure
    
    ; ========================================
    ; Display Final Results
    ; ========================================
    call DISPLAY_FINAL_RESULTS  ; Call DISPLAY_FINAL_RESULTS procedure
    
    ; ========================================
    ; Terminate the program
    ; ========================================
    mov ah, 4Ch             ; Function 4Ch: Terminate program
    mov al, 0               ; Exit code: 0 (successful execution)
    int 21h                 ; Call DOS interrupt to exit
    
main ENDP

END main                    ; End of program, specify main as entry point

