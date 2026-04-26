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
    q1_text db "What is the capital of Pakistan?$"
    q1_optA db "A) Lahore$"
    q1_optB db "B) Karachi$"
    q1_optC db "C) Islamabad$"
    q1_optD db "D) Peshawar$"
    q1_answer db 67  ; ASCII 'C'
    
    ; ========================================
    ; QUESTION 2: 8086 Programming Language
    ; ========================================
    q2_text db "Which language is used for 8086 programming?$"
    q2_optA db "A) Python$"
    q2_optB db "B) Assembly$"
    q2_optC db "C) Java$"
    q2_optD db "D) C++$"
    q2_answer db 66  ; ASCII 'B'
    
    ; ========================================
    ; QUESTION 3: CPU Register
    ; ========================================
    q3_text db "Which of these is a CPU register?$"
    q3_optA db "A) AX$"
    q3_optB db "B) RAM$"
    q3_optC db "C) Disk$"
    q3_optD db "D) Cache$"
    q3_answer db 65  ; ASCII 'A'
    
    ; ========================================
    ; QUESTION 4: Memory Model
    ; ========================================
    q4_text db "Which memory model has most code/data space?$"
    q4_optA db "A) Tiny$"
    q4_optB db "B) Small$"
    q4_optC db "C) Medium$"
    q4_optD db "D) Large$"
    q4_answer db 68  ; ASCII 'D'
    
    ; ========================================
    ; QUESTION 5: INT 21h Function
    ; ========================================
    q5_text db "Which INT 21h function reads a character?$"
    q5_optA db "A) 09h$"
    q5_optB db "B) 02h$"
    q5_optC db "C) 01h$"
    q5_optD db "D) 4Ch$"
    q5_answer db 67  ; ASCII 'C'
    
    ; ========================================
    ; QUESTION 6: ASCII Value of 'A'
    ; ========================================
    q6_text db "What is the ASCII value of uppercase 'A'?$"
    q6_optA db "A) 61$"
    q6_optB db "B) 65$"
    q6_optC db "C) 97$"
    q6_optD db "D) 101$"
    q6_answer db 66  ; ASCII 'B'
    
    ; ========================================
    ; QUESTION 7: DOS Interrupt Number
    ; ========================================
    q7_text db "Which interrupt number is for DOS services?$"
    q7_optA db "A) 21h$"
    q7_optB db "B) 10h$"
    q7_optC db "C) 13h$"
    q7_optD db "D) 25h$"
    q7_answer db 65  ; ASCII 'A'
    
    ; ========================================
    ; QUESTION 8: Segment:Offset Format
    ; ========================================
    q8_text db "What does segment:offset address mean?$"
    q8_optA db "A) 8-bit:8-bit$"
    q8_optB db "B) 32-bit:32-bit$"
    q8_optC db "C) 16-bit:16-bit$"
    q8_optD db "D) Variable$"
    q8_answer db 67  ; ASCII 'C'
    
    ; ========================================
    ; QUESTION 9: Stack Growth Direction
    ; ========================================
    q9_text db "In which direction does the stack grow?$"
    q9_optA db "A) Upward$"
    q9_optB db "B) Forward$"
    q9_optC db "C) Backward$"
    q9_optD db "D) Downward$"
    q9_answer db 68  ; ASCII 'D'
    
    ; ========================================
    ; QUESTION 10: MOV Instruction Limitation
    ; ========================================
    q10_text db "MOV cannot directly move data...?$"
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
;        DL = correct answer (A-D)
; Output: Updates score if correct
; Preserves: All registers
; ============================================================
CHECK_ANSWER PROC
    cmp al, dl              ; Compare answers
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
    ; Dynamic Question Numbering
    ; ========================================
    mov dl, 'Q'             ; Output 'Q'
    mov ah, 02h
    int 21h
    
    mov ax, bx              ; AX = question index (0-9)
    inc ax                  ; AX = question number (1-10)
    
    cmp ax, 10              ; Is it 10?
    jne SINGLE_DIGIT        ; If not 10, print single digit
    
    ; Print '1'
    mov dl, '1'
    mov ah, 02h
    int 21h
    
    ; Print '0'
    mov dl, '0'
    jmp PRINT_COLON_AND_SPACE
    
SINGLE_DIGIT:
    add al, '0'             ; Convert 1-9 to ASCII
    mov dl, al
    
PRINT_COLON_AND_SPACE:
    mov ah, 02h
    int 21h                 ; Print digit ('0' or 1-9)
    
    mov dl, ':'             ; Output ':'
    mov ah, 02h
    int 21h
    
    mov dl, ' '             ; Output space
    mov ah, 02h
    int 21h
    
    ; ========================================
    ; Get question text address from lookup table
    ; Use: SI = offset, BX = base address
    ; ========================================
    mov si, bx              ; SI = question index
    shl si, 1               ; SI = SI*2 (convert index to word offset)
    
    ; Get Option A address (q_texts table)
    lea bx, q_texts         ; BX = address of q_texts array
    mov dx, [bx + si]       ; DX = q_texts[index]
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
    mov al, total_questions
    cmp cl, al             ; Are we done with all questions?
    jge LOOP_END           ; If CX >= total_questions, exit loop
    
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
    mov dl, [bx + si]      ; DL = correct answer for question CX (prevents BX corruption)
    
    ; ========================================
    ; Check answer (AL = user input, DL = correct answer)
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
