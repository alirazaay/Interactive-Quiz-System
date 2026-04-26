# Interactive Quiz System - Refactoring Summary

## 🎯 What Changed

### ✅ From Hardcoded to Scalable
**BEFORE:** Separate `Q1` and `Q2` procedures with hardcoded questions
**AFTER:** Single `QUIZ_LOOP` procedure that processes all 10 questions dynamically

### ✅ Data Structure (Arrays/Lookup Tables)
```assembly
; Question Data - All 10 questions defined with options and answers
q1_text, q2_text, ... q10_text       ; Question strings
q1_optA, q2_optA, ... q10_optA       ; Option A strings
q1_optB, q2_optB, ... q10_optB       ; Option B strings
q1_optC, q2_optC, ... q10_optC       ; Option C strings
q1_optD, q2_optD, ... q10_optD       ; Option D strings
q1_answer, q2_answer, ... q10_answer ; Correct answers (ASCII: 65-68)

; Lookup Tables (word arrays - 2 bytes each)
q_texts   dw q1_text, q2_text, ..., q10_text
q_optAs   dw q1_optA, q2_optA, ..., q10_optA
q_optBs   dw q1_optB, q2_optB, ..., q10_optB
q_optCs   dw q1_optC, q2_optC, ..., q10_optC
q_optDs   dw q1_optD, q2_optD, ..., q10_optD
q_answers db 67, 66, 65, 68, 67, 66, 65, 67, 68, 66  ; ASCII values
```

### ✅ Loop-Based Architecture
```assembly
QUIZ_LOOP PROC
    mov bx, 0                      ; Initialize counter
    
    LOOP_QUESTIONS:
    cmp bx, [total_questions]       ; Check if done
    jge LOOP_END
    
    call DISPLAY_QUESTION           ; Display current Q
    call GET_INPUT                  ; Get user answer
    call CHECK_ANSWER               ; Validate
    
    inc bx                          ; Next question
    jmp LOOP_QUESTIONS
    
    LOOP_END:
    ret
QUIZ_LOOP ENDP
```

### ✅ Indexing Strategy
- **BX register** = Question index (0-9)
- **SI register** = Word offset (BX * 2) for lookup tables
- **Accessing**: `mov dx, [q_texts + SI]` gets question text address

Example:
```assembly
mov si, bx          ; SI = question index
shl si, 1           ; SI = SI * 2 (convert to word offset)
lea ax, q_texts     ; AX = table start
mov dx, [ax+si]     ; DX = question address for index BX
```

## 📊 Key Procedures

### 1. **DISPLAY_QUESTION(BX)**
   - Takes question index in BX
   - Uses lookup tables to fetch and display Q + 4 options
   - Automatically handles all 10 questions

### 2. **QUIZ_LOOP()**
   - Main loop: processes questions 0-9
   - Calls DISPLAY_QUESTION for each Q
   - Calls GET_INPUT and CHECK_ANSWER
   - Updates score automatically

### 3. **GET_INPUT()**
   **ENHANCEMENTS:**
   - ✅ Skips Enter key (CR = 13)
   - ✅ Validates A-D only (rejects invalid input)
   - ✅ Converts lowercase to uppercase
   - ✅ Re-prompts if invalid

### 4. **DISPLAY_FINAL_SCORE()**
   - Shows format: `Your Score: X/10`
   - Displays 10 as two digits (ASCII 31h, 30h)
   - Preserves all registers

## 🔒 Register Preservation

**Critical Fixes Applied:**
```assembly
; Before calling DISPLAY_STRING that uses INT 21h
push ax              ; Save user input

lea dx, newline
call DISPLAY_STRING  ; May modify AL

pop ax               ; Restore user input for comparison
```

## 📝 Questions Included (10 Total)

| Q# | Topic | Answer |
|----|-------|--------|
| 1 | Pakistan capital | C (Islamabad) |
| 2 | 8086 programming language | B (Assembly) |
| 3 | CPU register | A (AX) |
| 4 | Memory model | D (Large) |
| 5 | INT 21h input function | C (01h) |
| 6 | ASCII of 'A' | B (65) |
| 7 | DOS interrupt | A (21h) |
| 8 | Segment:Offset format | C (16-bit:16-bit) |
| 9 | Stack direction | D (Downward) |
| 10 | MOV limitation | B (Memory to Memory) |

## ⚡ Performance

- **Scalable**: Add questions by extending arrays
- **Efficient**: Word-based lookups (2 bytes/entry)
- **Simple**: Loop counter approach easy to understand
- **Modular**: Each procedure handles one task

## 🔧 How to Extend to 15+ Questions

1. Define new questions in DATA segment:
   ```assembly
   q11_text db "Q11: ...?$"
   q11_optA db "A) ...$"
   ; ... etc
   q11_answer db 65  ; ASCII 'A'-'D'
   ```

2. Update lookup tables:
   ```assembly
   q_texts dw q1_text, q2_text, ..., q11_text
   q_answers db 67, 66, ..., 65
   ```

3. Update control variable:
   ```assembly
   total_questions db 11  ; or higher
   ```

That's it! No code logic changes needed.

## ✨ Features Implemented

- ✅ 10 questions with 4 options each
- ✅ Loop-based processing
- ✅ Dynamic question numbering (Q1, Q2, etc)
- ✅ Input validation (A/B/C/D only)
- ✅ Invalid input handling with re-prompting
- ✅ Score tracking (0-10)
- ✅ Final score display (X/10 format)
- ✅ Register preservation (PUSH/POP)
- ✅ Enter key skipping
- ✅ Modular, readable code

## 🎓 Suitable for Viva

- Clean architecture
- Well-commented
- Easy to explain
- Demonstrates advanced concepts:
  - Array indexing
  - Lookup tables
  - Loop structures
  - Register preservation
  - DOS interrupts
