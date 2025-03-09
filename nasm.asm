
section .data
    prompt db "Enter password: ", 0
    weak_msg db "Weak password!", 0
    medium_msg db "Medium password!", 0
    strong_msg db "Strong password!", 0
    newline db 10, 0

section .bss
    password resb 32  ; Reserve 32 bytes for password

section .text
    global _start
    extern printf, scanf

_start:
    ; Print prompt
    push prompt
    call printf
    add esp, 4

    ; Read password
    push password
    push "%s"
    call scanf
    add esp, 8

    ; Analyze password strength
    mov esi, password
    xor ecx, ecx  ; Character count
    xor edx, edx  ; Uppercase count
    xor ebx, ebx  ; Lowercase count
    xor eax, eax  ; Digit count

password_loop:
    mov al, [esi]
    cmp al, 0
    je check_strength
    inc ecx  ; Total length

    cmp al, 'A'
    jl not_upper
    cmp al, 'Z'
    jg not_upper
    inc edx  ; Uppercase found
not_upper:

    cmp al, 'a'
    jl not_lower
    cmp al, 'z'
    jg not_lower
    inc ebx  ; Lowercase found
not_lower:

    cmp al, '0'
    jl not_digit
    cmp al, '9'
    jg not_digit
    inc eax  ; Digit found
not_digit:

    inc esi
    jmp password_loop

check_strength:
    cmp ecx, 8
    jl weak

    cmp edx, 0
    je medium
    cmp ebx, 0
    je medium
    cmp eax, 0
    je medium

    jmp strong

weak:
    push weak_msg
    call printf
    add esp, 4
    jmp end_program

medium:
    push medium_msg
    call printf
    add esp, 4
    jmp end_program

strong:
    push strong_msg
    call printf
    add esp, 4

end_program:
    push newline
    call printf
    add esp, 4

    mov eax, 1
    xor ebx, ebx
    int 0x80  ; Exit
