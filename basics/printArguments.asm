; file: (NASM, Linux x86-64, System V ABI)
; Author: Robin Dost
; This is a simple Linux x86-64 assembly file.
; It accepts an unlimited amount of arguments and prints their value after execution
; Compile:
; nasm -felf64 printArguments.asm -o args.o
; gcc -no-pie -o printArguments args.o

global main
extern printf

section .rodata
fmt: db "Arg %d: %s", 10, 0    ; "Arg %d: %s\n"

section .text
main:
    ; Prolog (Stack ausrichten + callee-saved sichern)
    push rbp
    mov  rbp, rsp
    push r12
    push r13
    push r14                 ; 3*8 = 24 + 8 = 32 Bytes -> 16-Byte aligned

    mov  r12, rdi            ; argc
    mov  r13, rsi            ; argv
    mov  r14, 1              ; i = 1

.loop:
    cmp  r14, r12
    jge  .done

    ; printf("Arg %d: %s\n", i, argv[i])
    lea  rdi, [rel fmt]      ; 1st: format string
    mov  esi, r14d           ; 2nd: int i
    mov  rdx, [r13 + r14*8]  ; 3rd: char* argv[i]
    xor  eax, eax            ; SysV varargs: AL = #vector args -> 0
    call printf

    inc  r14
    jmp  .loop

.done:
    xor  eax, eax            ; return 0

    ; Epilog
    pop  r14
    pop  r13
    pop  r12
    leave
    ret
