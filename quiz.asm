.MODEL SMALL
.STACK 100h

.DATA
    total_questions db 10
    current_question db 0
    score db 0

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
    invalidMsg db "Invalid choice! Enter A, B, C, or D only.$"

    q1_text db "What is the capital of Pakistan?$"
    q1_optA db "A) Lahore$"
    q1_optB db "B) Karachi$"
    q1_optC db "C) Islamabad$"
    q1_optD db "D) Peshawar$"
    q1_answer db 67

    q2_text db "Which language is used for 8086 programming?$"
    q2_optA db "A) Python$"
    q2_optB db "B) Assembly$"
    q2_optC db "C) Java$"
    q2_optD db "D) C++$"
    q2_answer db 66

    q3_text db "Which of these is a CPU register?$"
    q3_optA db "A) AX$"
    q3_optB db "B) RAM$"
    q3_optC db "C) Disk$"
    q3_optD db "D) Cache$"
    q3_answer db 65

    q4_text db "Which memory model has most code/data space?$"
    q4_optA db "A) Tiny$"
    q4_optB db "B) Small$"
    q4_optC db "C) Medium$"
    q4_optD db "D) Large$"
    q4_answer db 68

    q5_text db "Which INT 21h function reads a character?$"
    q5_optA db "A) 09h$"
    q5_optB db "B) 02h$"
    q5_optC db "C) 01h$"
    q5_optD db "D) 4Ch$"
    q5_answer db 67

    q6_text db "What is the ASCII value of uppercase 'A'?$"
    q6_optA db "A) 61$"
    q6_optB db "B) 65$"
    q6_optC db "C) 97$"
    q6_optD db "D) 101$"
    q6_answer db 66

    q7_text db "Which interrupt number is for DOS services?$"
    q7_optA db "A) 21h$"
    q7_optB db "B) 10h$"
    q7_optC db "C) 13h$"
    q7_optD db "D) 25h$"
    q7_answer db 65

    q8_text db "What does segment:offset address mean?$"
    q8_optA db "A) 8-bit:8-bit$"
    q8_optB db "B) 32-bit:32-bit$"
    q8_optC db "C) 16-bit:16-bit$"
    q8_optD db "D) Variable$"
    q8_answer db 67

    q9_text db "In which direction does the stack grow?$"
    q9_optA db "A) Upward$"
    q9_optB db "B) Forward$"
    q9_optC db "C) Backward$"
    q9_optD db "D) Downward$"
    q9_answer db 68

    q10_text db "MOV cannot directly move data...?$"
    q10_optA db "A) Register to Register$"
    q10_optB db "B) Memory to Memory$"
    q10_optC db "C) Register to Memory$"
    q10_optD db "D) Memory to Register$"
    q10_answer db 66

    q_texts dw q1_text, q2_text, q3_text, q4_text, q5_text, q6_text, q7_text, q8_text, q9_text, q10_text
    q_optAs dw q1_optA, q2_optA, q3_optA, q4_optA, q5_optA, q6_optA, q7_optA, q8_optA, q9_optA, q10_optA
    q_optBs dw q1_optB, q2_optB, q3_optB, q4_optB, q5_optB, q6_optB, q7_optB, q8_optB, q9_optB, q10_optB
    q_optCs dw q1_optC, q2_optC, q3_optC, q4_optC, q5_optC, q6_optC, q7_optC, q8_optC, q9_optC, q10_optC
    q_optDs dw q1_optD, q2_optD, q3_optD, q4_optD, q5_optD, q6_optD, q7_optD, q8_optD, q9_optD, q10_optD
    q_answers db 67, 66, 65, 68, 67, 66, 65, 67, 68, 66

.CODE

DISPLAY_STRING PROC
    push ax
    mov ah, 09h
    int 21h
    pop ax
    ret
DISPLAY_STRING ENDP

WAIT_ANY_KEY PROC
    mov ah, 00h
    int 16h
    ret
WAIT_ANY_KEY ENDP

GET_INPUT PROC
    push cx
READ_CHAR:
    mov ah, 01h
    int 21h
    cmp al, 13
    je READ_CHAR
    mov cl, al
    cmp cl, 65
    jb NOT_UPPERCASE
    cmp cl, 68
    ja NOT_UPPERCASE
    mov al, cl
    jmp INPUT_DONE
NOT_UPPERCASE:
    cmp cl, 97
    jb INVALID_INPUT
    cmp cl, 100
    ja INVALID_INPUT
    sub cl, 32
    mov al, cl
    jmp INPUT_DONE
INVALID_INPUT:
    lea dx, newline
    call DISPLAY_STRING
    lea dx, invalidMsg
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING
    lea dx, inputMsg
    call DISPLAY_STRING
    jmp READ_CHAR
INPUT_DONE:
    pop cx
    ret
GET_INPUT ENDP

CHECK_ANSWER PROC
    push ax
    push dx
    cmp al, dl
    je ANSWER_CORRECT
    jne ANSWER_WRONG
ANSWER_CORRECT:
    lea dx, correctMsg
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING
    mov al, [score]
    inc al
    mov [score], al
    jmp END_CHECK
ANSWER_WRONG:
    lea dx, wrongMsg
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING
END_CHECK:
    pop dx
    pop ax
    ret
CHECK_ANSWER ENDP

DISPLAY_QUESTION PROC
    push ax
    push bx
    push dx
    push si

    lea dx, newline
    call DISPLAY_STRING

    mov dl, 'Q'
    mov ah, 02h
    int 21h

    mov ax, bx
    inc ax
    cmp ax, 10
    jne SINGLE_DIGIT

    mov dl, '1'
    mov ah, 02h
    int 21h
    mov dl, '0'
    jmp PRINT_COLON_AND_SPACE

SINGLE_DIGIT:
    add al, '0'
    mov dl, al

PRINT_COLON_AND_SPACE:
    mov ah, 02h
    int 21h

    mov dl, ':'
    mov ah, 02h
    int 21h

    mov dl, ' '
    mov ah, 02h
    int 21h

    mov si, bx
    shl si, 1

    lea bx, q_texts
    mov dx, [bx + si]
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING

    lea bx, q_optAs
    mov dx, [bx + si]
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING

    lea bx, q_optBs
    mov dx, [bx + si]
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING

    lea bx, q_optCs
    mov dx, [bx + si]
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING

    lea bx, q_optDs
    mov dx, [bx + si]
    call DISPLAY_STRING
    lea dx, newline
    call DISPLAY_STRING

    pop si
    pop dx
    pop bx
    pop ax
    ret
DISPLAY_QUESTION ENDP

QUIZ_LOOP PROC
    mov cx, 0
LOOP_QUESTIONS:
    mov ah, 0
    mov al, total_questions
    cmp cx, ax
    jge LOOP_END

    mov bx, cx
    call DISPLAY_QUESTION

    lea dx, inputMsg
    call DISPLAY_STRING

    call GET_INPUT

    push ax
    lea dx, newline
    call DISPLAY_STRING
    pop ax

    mov si, cx
    lea bx, q_answers
    mov dl, [bx + si]

    push dx
    call CHECK_ANSWER
    pop dx

    inc cx
    jmp LOOP_QUESTIONS

LOOP_END:
    ret
QUIZ_LOOP ENDP

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

    mov al, [score]
    cmp al, 10
    jne ONE_DIGIT_SCORE

    mov dl, '1'
    mov ah, 02h
    int 21h
    mov dl, '0'
    int 21h
    jmp SHOW_TOTAL

ONE_DIGIT_SCORE:
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h

SHOW_TOTAL:
    lea dx, slash
    call DISPLAY_STRING

    mov dl, '1'
    mov ah, 02h
    int 21h

    mov dl, '0'
    int 21h

    lea dx, newline
    call DISPLAY_STRING

    pop dx
    pop ax
    ret
DISPLAY_FINAL_SCORE ENDP

main PROC
    mov ax, @DATA
    mov ds, ax

    lea dx, msg_welcome
    call DISPLAY_STRING

    lea dx, newline
    call DISPLAY_STRING

    lea dx, msg_start
    call DISPLAY_STRING

    lea dx, newline
    call DISPLAY_STRING

    call WAIT_ANY_KEY

    lea dx, newline
    call DISPLAY_STRING

    lea dx, msg_quiz_begin
    call DISPLAY_STRING

    lea dx, newline
    call DISPLAY_STRING

    call QUIZ_LOOP

    call DISPLAY_FINAL_SCORE

    mov ah, 4Ch
    mov al, 0
    int 21h
main ENDP

END main