; ============================================================
; INTERACTIVE QUIZ SYSTEM - SCALABLE LOOP-BASED VERSION
; Assembly Language: 8086
; Environment: EMU8086 DOS
; 
; Features:
; - Supports 10 questions (easily extensible to more)
; - Loop-based architecture using arrays and indexing
; - Modular procedures for reusability
; - Input validation (A/B/C/D only)
; - Dynamic question numbering
; - Preserves registers across procedure calls
; ============================================================

.MODEL SMALL                ; Memory model: Small (64K code, 64K data)
.STACK 100h                 ; Stack size: 256 bytes

; ============================================================
; DATA SEGMENT - Questions, Options, and Answers Storage
; ============================================================
.DATA
    ; ========================================
    ; Control Variables
    ; ========================================
    total_questions db 10        ; Total number of questions in quiz
    current_question db 0        ; Current question index (0-9)
    score db 0                   ; Current score
    
    ; ========================================
    ; System Messages
    ; ========================================
    msg_welcome db "Welcome to Interactive Quiz System$"
    msg_start db "Press any key to start...$"
    msg_quiz_begin db "Quiz Starting...$"
    inputMsg db "Enter your choice (A/B/C/D): $"
    correctMsg db "Correct Answer!$"
    wrongMsg db "Wrong Answer!$"
    quizFinished db "Quiz Finished!$"
    scoreMsg db "Your Score: $"
    slash db "/$"
    newline db 13, 10, "$"
    
    ; Invalid input message
    invalidMsg db "Invalid choice! Enter A, B, C, or D only.$"
    
    ; ========================================
    ; QUESTION 1: Capital of Pakistan
    ; ========================================
    q1_text db "Q1: What is the capital of Pakistan?$"
    q1_optA db "A) Lahore$"
    q1_optB db "B) Karachi$"
    q1_optC db "C) Islamabad$"
    q1_optD db "D) Peshawar$"
    q1_answer db 67  ; ASCII 'C'
    
    ; ========================================
    ; QUESTION 2: 8086 Programming Language
    ; ========================================
    q2_text db "Q2: Which language is used for 8086 programming?$"
    q2_optA db "A) Python$"
    q2_optB db "B) Assembly$"
    q2_optC db "C) Java$"
    q2_optD db "D) C++$"
    q2_answer db 66  ; ASCII 'B'
    
    ; ========================================
    ; QUESTION 3: CPU Register
    ; ========================================
    q3_text db "Q3: Which of these is a CPU register?$"
    q3_optA db "A) AX$"
    q3_optB db "B) RAM$"
    q3_optC db "C) Disk$"
    q3_optD db "D) Cache$"
    q3_answer db 65  ; ASCII 'A'
    
    ; ========================================
    ; QUESTION 4: Memory Model
    ; ========================================
    q4_text db "Q4: Which memory model has most code/data space?$"
    q4_optA db "A) Tiny$"
    q4_optB db "B) Small$"
    q4_optC db "C) Medium$"
    q4_optD db "D) Large$"
    q4_answer db 68  ; ASCII 'D'
    
    ; ========================================
    ; QUESTION 5: INT 21h Function
    ; ========================================
    q5_text db "Q5: Which INT 21h function reads a character?$"
    q5_optA db "A) 09h$"
    q5_optB db "B) 02h$"
    q5_optC db "C) 01h$"
    q5_optD db "D) 4Ch$"
    q5_answer db 67  ; ASCII 'C'
    
    ; ========================================
    ; QUESTION 6: ASCII Value of 'A'
    ; ========================================
    q6_text db "Q6: What is the ASCII value of uppercase 'A'?$"
    q6_optA db "A) 61$"
    q6_optB db "B) 65$"
    q6_optC db "C) 97$"
    q6_optD db "D) 101$"
    q6_answer db 66  ; ASCII 'B'
    
    ; ========================================
    ; QUESTION 7: DOS Interrupt Number
    ; ========================================
    q7_text db "Q7: Which interrupt number is for DOS services?$"
    q7_optA db "A) 21h$"
    q7_optB db "B) 10h$"
    q7_optC db "C) 13h$"
    q7_optD db "D) 25h$"
    q7_answer db 65  ; ASCII 'A'
    
    ; ========================================
    ; QUESTION 8: Segment:Offset Format
    ; ========================================
    q8_text db "Q8: What does segment:offset address mean?$"
    q8_optA db "A) 8-bit:8-bit$"
    q8_optB db "B) 32-bit:32-bit$"
    q8_optC db "C) 16-bit:16-bit$"
    q8_optD db "D) Variable$"
    q8_answer db 67  ; ASCII 'C'
    
    ; ========================================
    ; QUESTION 9: Stack Growth Direction
    ; ========================================
    q9_text db "Q9: In which direction does the stack grow?$"
    q9_optA db "A) Upward$"
    q9_optB db "B) Forward$"
    q9_optC db "C) Backward$"
    q9_optD db "D) Downward$"
    q9_answer db 68  ; ASCII 'D'
    
    ; ========================================
    ; QUESTION 10: MOV Instruction Limitation
    ; ========================================
    q10_text db "Q10: MOV cannot directly move data...?$"
    q10_optA db "A) Register to Register$"
    q10_optB db "B) Memory to Memory$"
    q10_optC db "C) Register to Memory$"
    q10_optD db "D) Memory to Register$"
    q10_answer db 66  ; ASCII 'B'
    
    ; ========================================
    ; LOOKUP TABLES - Array of Offsets (word = 2 bytes)
    ; Used to access questions by index
    ; ========================================
    
    ; Question text addresses (10 questions)
    q_texts dw q1_text, q2_text, q3_text, q4_text, q5_text, q6_text, q7_text, q8_text, q9_text, q10_text
    
    ; Option A addresses
    q_optAs dw q1_optA, q2_optA, q3_optA, q4_optA, q5_optA, q6_optA, q7_optA, q8_optA, q9_optA, q10_optA
    
    ; Option B addresses
    q_optBs dw q1_optB, q2_optB, q3_optB, q4_optB, q5_optB, q6_optB, q7_optB, q8_optB, q9_optB, q10_optB
    
    ; Option C addresses
    q_optCs dw q1_optC, q2_optC, q3_optC, q4_optC, q5_optC, q6_optC, q7_optC, q8_optC, q9_optC, q10_optC
    
    ; Option D addresses
    q_optDs dw q1_optD, q2_optD, q3_optD, q4_optD, q5_optD, q6_optD, q7_optD, q8_optD, q9_optD, q10_optD
    
    ; Correct answers (single byte: ASCII code 65-68 for A-D)
    q_answers db 67, 66, 65, 68, 67, 66, 65, 67, 68, 66

; ============================================================
; CODE SEGMENT - Program logic and procedures
; ============================================================
.CODE

; ============================================================
; PROCEDURE: DISPLAY_STRING
; Purpose: Display a $-terminated string on screen
; Input: DX = address of string
; Output: None
; Preserves: All registers except used in INT 21h
; ============================================================
DISPLAY_STRING PROC
    mov ah, 09h             ; Function 09h: Display string
    int 21h                 ; Call DOS interrupt
    ret
DISPLAY_STRING ENDP

; ============================================================
; PROCEDURE: GET_INPUT
; Purpose: Read a single character and convert to uppercase
; Input: None
; Output: AL = converted character (A-D uppercase)
;         Repeats if Enter key detected
; ============================================================
GET_INPUT PROC
READ_CHAR:
    mov ah, 01h             ; Function 01h: Read character from input
    int 21h                 ; DOS auto-echoes the character
    
    ; ========================================
    ; Skip Enter key (13 = CR)
    ; ========================================
    cmp al, 13              ; Is it Enter key (carriage return)?
    je READ_CHAR            ; If yes, read next character
    
    ; ========================================
    ; Validate input: must be A-D (uppercase or lowercase)
    ; ========================================
    mov cl, al              ; Save character in CL
    
    ; Check for uppercase A-D (65-68)
    cmp cl, 65              ; >= 'A' (65)?
    jb NOT_UPPERCASE        ; If below, check lowercase
    cmp cl, 68              ; <= 'D' (68)?
    ja NOT_UPPERCASE        ; If above, check lowercase
    mov al, cl              ; Valid uppercase, use it
    jmp INPUT_DONE
    
NOT_UPPERCASE:
    ; Check for lowercase a-d (97-100)
    cmp cl, 97              ; >= 'a' (97)?
    jb INVALID_INPUT        ; If below, invalid
    cmp cl, 100             ; <= 'd' (100)?
    ja INVALID_INPUT        ; If above, invalid
    
    ; Convert lowercase to uppercase
    sub cl, 32              ; 'a'(97)-32='A'(65), 'd'(100)-32='D'(68)
    mov al, cl
    jmp INPUT_DONE
    
INVALID_INPUT:
    ; Display invalid input message
    lea dx, newline
    call DISPLAY_STRING
    lea dx, invalidMsg
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING
    lea dx, inputMsg        ; Re-display input prompt
    call DISPLAY_STRING
    jmp READ_CHAR           ; Read input again
    
INPUT_DONE:
    ret                     ; Return with AL = A-D (uppercase)
GET_INPUT ENDP

; ============================================================
; PROCEDURE: CHECK_ANSWER
; Purpose: Compare user answer with correct answer
; Input: AL = user's answer (A-D)
;        BL = correct answer (A-D)
; Output: Updates score if correct
; Preserves: All registers
; ============================================================
CHECK_ANSWER PROC
    cmp al, bl              ; Compare answers
    je ANSWER_CORRECT       ; If equal, answer is correct
    jne ANSWER_WRONG        ; If not equal, answer is wrong
    
ANSWER_CORRECT:
    lea dx, correctMsg
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING
    
    ; Increment score
    mov al, [score]
    inc al
    mov [score], al
    ret
    
ANSWER_WRONG:
    lea dx, wrongMsg
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING
    ret
    
CHECK_ANSWER ENDP

; ============================================================
; PROCEDURE: DISPLAY_QUESTION
; Purpose: Display a single question with all options
; Input: BX = question index (0-9)
;        Uses lookup tables to fetch question data
; Output: Displays question and options
; ============================================================
DISPLAY_QUESTION PROC
    push ax                 ; Preserve registers
    push bx                 ; CRITICAL: Save BX (will be used as base for indexing)
    push dx
    push si
    
    ; Display newline for spacing
    lea dx, newline
    call DISPLAY_STRING
    
    ; ========================================
    ; Get question text address from lookup table
    ; Use: SI = offset, BX = base address
    ; ========================================
    mov si, bx              ; SI = question index
    shl si, 1               ; SI = SI*2 (convert index to word offset)
    
    ; Get Option A address (q_optAs table)
    lea bx, q_texts         ; BX = address of q_texts array (valid: LEA with offset)
    mov dx, [bx + si]       ; DX = q_texts[index] - VALID: [BX + SI] is allowed
    call DISPLAY_STRING     ; Display question
    
    lea dx, newline
    call DISPLAY_STRING
    
    ; Get Option A address
    lea bx, q_optAs         ; BX = address of q_optAs array
    mov dx, [bx + si]       ; DX = q_optAs[index]
    call DISPLAY_STRING
    
    lea dx, newline
    call DISPLAY_STRING
    
    ; Get Option B address
    lea bx, q_optBs
    mov dx, [bx + si]
    call DISPLAY_STRING
    
    lea dx, newline
    call DISPLAY_STRING
    
    ; Get Option C address
    lea bx, q_optCs
    mov dx, [bx + si]
    call DISPLAY_STRING
    
    lea dx, newline
    call DISPLAY_STRING
    
    ; Get Option D address
    lea bx, q_optDs
    mov dx, [bx + si]
    call DISPLAY_STRING
    
    lea dx, newline
    call DISPLAY_STRING
    
    pop si                  ; Restore registers (in reverse order)
    pop dx
    pop bx
    pop ax
    ret
DISPLAY_QUESTION ENDP

; ============================================================
; PROCEDURE: QUIZ_LOOP
; Purpose: Main quiz loop - process all questions
; Input: None
; Output: Updates score variable
; ============================================================
QUIZ_LOOP PROC
    mov cx, 0              ; CX = question counter (0-9)
    
LOOP_QUESTIONS:
    cmp cx, 10             ; Are we done with all 10 questions?
    jge LOOP_END           ; If CX >= 10, exit loop
    
    ; ========================================
    ; Display current question
    ; ========================================
    mov bx, cx             ; BX = question index for DISPLAY_QUESTION
    call DISPLAY_QUESTION  ; BX contains question index
    
    ; ========================================
    ; Get user input and save it
    ; ========================================
    lea dx, inputMsg
    call DISPLAY_STRING
    
    call GET_INPUT         ; AL = user's answer (A-D)
    
    ; CRITICAL: Save AL before calling DISPLAY_STRING
    push ax                ; Save user's answer
    
    lea dx, newline
    call DISPLAY_STRING
    
    pop ax                 ; Restore user's answer
    
    ; ========================================
    ; Get correct answer from lookup table
    ; ========================================
    mov si, cx             ; SI = question index
    lea bx, q_answers      ; BX = address of q_answers array
    mov bl, [bx + si]      ; BL = correct answer for question CX
    
    ; ========================================
    ; Check answer (AL = user input, BL = correct answer)
    ; ========================================
    call CHECK_ANSWER
    
    ; ========================================
    ; Move to next question
    ; ========================================
    inc cx
    jmp LOOP_QUESTIONS
    
LOOP_END:
    ret
QUIZ_LOOP ENDP

; ============================================================
; PROCEDURE: DISPLAY_FINAL_SCORE
; Purpose: Display final results with score (X/10 format)
; Input: score variable
; Output: Displays "Your Score: X/10"
; ============================================================
DISPLAY_FINAL_SCORE PROC
    push ax
    push dx
    
    lea dx, newline
    call DISPLAY_STRING
    
    lea dx, quizFinished
    call DISPLAY_STRING
    
    lea dx, newline
    call DISPLAY_STRING
    
    lea dx, scoreMsg
    call DISPLAY_STRING
    
    ; Display score as digit
    mov al, [score]
    add al, 30h             ; Convert to ASCII digit
    mov dl, al
    mov ah, 02h             ; Function 02h: Display single character
    int 21h
    
    ; Display " / 10"
    lea dx, slash
    call DISPLAY_STRING
    
    mov dl, 31h             ; ASCII '1'
    mov ah, 02h
    int 21h
    
    mov dl, 30h             ; ASCII '0'
    mov ah, 02h
    int 21h
    
    lea dx, newline
    call DISPLAY_STRING
    
    pop dx
    pop ax
    ret
DISPLAY_FINAL_SCORE ENDP

; ============================================================
; PROCEDURE: main
; Purpose: Main entry point
; ============================================================
main PROC
    ; ========================================
    ; Initialize Data Segment
    ; ========================================
    mov ax, @DATA
    mov ds, ax
    
    ; ========================================
    ; Display Welcome Messages
    ; ========================================
    lea dx, msg_welcome
    call DISPLAY_STRING
    
    lea dx, newline
    call DISPLAY_STRING
    
    lea dx, msg_start
    call DISPLAY_STRING
    
    lea dx, newline
    call DISPLAY_STRING
    
    ; ========================================
    ; Wait for key press
    ; ========================================
    call GET_INPUT
    
    lea dx, newline
    call DISPLAY_STRING
    
    ; ========================================
    ; Display Quiz Begin Message
    ; ========================================
    lea dx, msg_quiz_begin
    call DISPLAY_STRING
    
    lea dx, newline
    call DISPLAY_STRING
    
    ; ========================================
    ; Run Quiz Loop (process all questions)
    ; ========================================
    call QUIZ_LOOP
    
    ; ========================================
    ; Display Final Score
    ; ========================================
    call DISPLAY_FINAL_SCORE
    
    ; ========================================
    ; Terminate Program
    ; ========================================
    mov ah, 4Ch             ; Function 4Ch: Terminate
    mov al, 0               ; Exit code: 0
    int 21h
    
main ENDP

END main                    ; End of program

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
; Purpose: Read a single character from input and convert to uppercase
; Input: None
; Output: AL = character read from input (converted to uppercase if lowercase)
; Modifies: AH, AL, CL registers
; ============================================================
GET_INPUT PROC
READ_CHAR:
    mov ah, 01h             ; Function 01h: Read character from input
    int 21h                 ; Call DOS interrupt (result in AL, auto-echoed)
    
    ; ========================================
    ; Skip Enter key (13 = CR) if encountered
    ; ========================================
    cmp al, 13              ; Is it Enter key (carriage return)?
    je READ_CHAR            ; If yes, read next character
    
    ; ========================================
    ; Convert lowercase to uppercase
    ; Explicit logic: if AL is 'a'-'z', subtract 32
    ; ========================================
    mov cl, al              ; Preserve the character in CL
    
    ; Check if it's lowercase 'a' (97)
    cmp cl, 97              ; Is character code 97 or higher?
    jb NOT_LOWERCASE        ; If below 97, it's not lowercase
    
    ; Check if it's lowercase 'z' (122)
    cmp cl, 122             ; Is character code 122 or lower?
    ja NOT_LOWERCASE        ; If above 122, it's not lowercase
    
    ; It's between 'a' (97) and 'z' (122), so convert to uppercase
    sub cl, 32              ; Subtract 32 to convert: 'a'(97)-32='A'(65)
    mov al, cl              ; Move converted character back to AL
    jmp INPUT_DONE
    
NOT_LOWERCASE:
    mov al, cl              ; If no conversion needed, keep original character
    
INPUT_DONE:
    ret                     ; Return to caller with character in AL
GET_INPUT ENDP

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
    call GET_INPUT          ; Call GET_INPUT (returns converted char in AL)
    
    ; Load correct answer immediately (ASCII 67 = 'C')
    mov bl, 67              ; Load correct answer 'C' (ASCII code 67) into BL
    
    ; ========================================
    ; CRITICAL: Save AL before calling DISPLAY_STRING
    ; DISPLAY_STRING uses INT 21h which does NOT preserve AL
    ; ========================================
    push ax                 ; Save AL (user input) on stack
    
    ; Display newline after input
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline (may modify AL)
    
    pop ax                  ; Restore AL with original user input
    
    ; ========================================
    ; Check Q1 Answer (Correct answer: C = ASCII 67)
    ; ========================================
    call CHECK_ANSWER       ; Call CHECK_ANSWER (compares AL with BL)
    
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
    call GET_INPUT          ; Call GET_INPUT (returns converted char in AL)
    
    ; Load correct answer immediately (ASCII 66 = 'B')
    mov bl, 66              ; Load correct answer 'B' (ASCII code 66) into BL
    
    ; ========================================
    ; CRITICAL: Save AL before calling DISPLAY_STRING
    ; DISPLAY_STRING uses INT 21h which does NOT preserve AL
    ; ========================================
    push ax                 ; Save AL (user input) on stack
    
    ; Display newline after input
    lea dx, newline         ; Load newline address
    call DISPLAY_STRING     ; Display newline (may modify AL)
    
    pop ax                  ; Restore AL with original user input
    
    ; ========================================
    ; Check Q2 Answer (Correct answer: B = ASCII 66)
    ; ========================================
    call CHECK_ANSWER       ; Call CHECK_ANSWER (compares AL with BL)
    
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

