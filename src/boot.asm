[bits 16]
org 0x7c00

mov [drive_number], dl
jmp boot_main

CODE_OFFSET equ 0x8
DATA_OFFSET equ 0x10
KERNEL_BASE_ADDR equ 0x7e00

clear_screen:
  mov ah, 6 
  mov al, 0
  mov bh, 7
  mov ch, 0
  mov cl, 0
  mov dh, 24
  mov dl, 79

  int 0x10

  mov ah, 2
  mov bh, 0
  mov dh, 0
  mov dl, 0

  int 0x10

print:
  mov ah, 0x0e
  mov bx, si
  xor si, si
.loop:
  cmp byte [bx + si], 0
  je .end

  mov al, byte [bx + si]
  int 0x10
  inc si

  jmp .loop
.end:
  ret

load_kernel:
  mov ah, 2
  mov al, 1
  mov ch, 0
  mov cl, 2
  mov dh, 0
  mov dl, [drive_number]
  mov bx, KERNEL_BASE_ADDR

  int 0x13
  jc .error
  jmp .end
.error:
  mov si, disk_error_msg
  call print
  jmp $
.end:
  ret

boot_main:
  xor ax, ax
  mov ds, ax
  mov ss, ax
  mov cs, ax
  mov es, ax

  mov bp, 0x7c00
  mov sp, bp

  call load_kernel
  call clear_screen

  cli
  lgdt [gdt_descriptor]
  mov eax, cr0
  or al, 1
  mov cr0, eax

  mov ax, DATA_OFFSET
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x7c00
  mov esp, ebp
  
  jmp CODE_OFFSET:KERNEL_BASE_ADDR

drive_number: db 0
disk_error_msg: db "Error while reading the kernel from disk...", 0

gdt_start:
  null:
    dq 0x0000000000000000
  code:
    dq 0x00cf9a000000ffff
  data:
    dq 0x00cf92000000ffff
gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_start - 1
  dd gdt_start

times 510-($-$$) db 0
dw 0xAA55
