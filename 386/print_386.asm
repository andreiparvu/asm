section .data
number  equ -3
PROT_WRITE  equ 2
MAP_ANON  equ 0x020
SYS_MMAP equ 9
minus db '-'

section .text
global  _start

print:
  xor esi, esi

  mov esi, 1
  push 0xa

  cmp eax, 0
  jge loop
  neg eax
  push eax

  mov edx, 1
  mov ecx, minus
  mov ebx, 1
  mov eax, 4
  int 0x80

  pop eax

loop:
 
  mov edx, 0
  mov ebx, 10
  div ebx

  add edx, 48
  push edx
  inc esi
  cmp eax, 0
  jz  next
  jmp loop

next:
  cmp esi, 0
  jz  end
  dec esi
  mov eax, 4
  mov ecx, esp
  mov ebx, 1
  mov edx, 1
  int  0x80
  add esp, 4
  jmp next

end:
  ret

_start:
  mov eax, -3
  call print

  mov eax, 1
  int 0x80

