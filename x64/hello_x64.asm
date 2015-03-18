section     .text
global      _start                              ;must be declared for linker (ld)

_start:                                         ;tell linker entry point

    mov rdx,len                             ;message length
    mov rsi,msg                             ;message to write
    mov rdi,1                               ;file descriptor (stdout)
    mov rax,0x1                               ;system call number (sys_write)
    syscall

    xor rdi, rdi
    mov rax, 0x3c                               ;system call number (sys_exit)
    syscall

section     .data

msg db  'Hello, world!',0xa                 ;our dear string
len equ $ - msg                             ;length of our dear string
