section .data
number  equ -3
PROT_WRITE  equ 2
MAP_ANON  equ 0x020
SYS_MMAP equ 9
minus db '-'

lock_t db 0

section .text
global  _start

acquire:
  push rbx

  mov bl, 1

.loop:
  xchg bl, [rax]

  cmp bl, 0

  jne .loop

  pop rbx
  ret

release:
  push rbx

  mov bl, 0
  mov [rax], bl

  pop rbx
  ret

print:
  xor r9, r9

  mov r9, 1
  push 0xa

  cmp rax, 0
  jge .loop
  neg rax
  push rax

  mov rdx, 1
  mov rsi, minus
  mov rdi, 1
  mov rax, 0x1
  syscall

  pop rax

.loop:
 
  mov rdx, 0
  mov rbx, 10
  div rbx

  add rdx, 48
  push rdx
  inc r9
  cmp rax, 0
  jz  .next
  jmp .loop

.next:
  cmp r9, 0
  jz  .end
  dec r9

  mov rdx, 1 ; length
  mov rsi, rsp ; address of message
  mov rdi, 1 ; file descriptor
  mov rax, 0x1
  syscall

  add rsp, 8
  jmp .next

.end:
  ret

map_stack:
  ; stack size is in rsi
  xor   rdi, rdi
  mov   rdx, 0x3
  mov   r10, 0x122
  xor   r8, r8
  dec   r8
  xor   r9, r9
  mov   rax, 0x9
  syscall
  ret

func:
  mov rax, lock_t
  call acquire

  mov rax, 342
  call print

  mov rax, 0x3c
  syscall

_start:
  mov rax, lock_t
  call acquire

  mov   r14, func
  mov   r15, rsi
  mov   rsi, 0x1000
  call  map_stack
  mov   rsi, rax
  mov   rdi, 0x10F11
  xor   r10, r10
  xor   r8, r8
  xor   r9, r9
  mov   rax, 0x38
  syscall
  or    rax, 0
  jnz   .parent
  push  r14
  ret

.parent:
  mov rax, 123
  call print

  mov rax, lock_t
  call release

.exit:
  xor rdi, rdi
  mov rax, 0x3c
  syscall

