# Cajun

This is a very small example of how to configure a [**GDT**](https://wiki.osdev.org/Global_Descriptor_Table) and loading a kernel with [**BIOS**](https://wiki.osdev.org/BIOS) interrupts:

1. Setup the segments registers
    - The way the addressing in 16-bit mode works is interesting, the engineers who did the design were very creative. The address bus is 20 bits in size, giving us 1MB of total space, which is addressed via the segment registers and an offset, giving a window of 64KB per segment, with the same segment being adjustable for another window.
    - `final_addr = (segment << 4) + offset`
2. The GDT itself deserves a thorough explanation of how it works. In general, it's the mechanism that allows us to configure the memory model for switching to 32-bit mode.
3. In kernel, we use the memory buffer, which is a [**Memory Mapped I/O**](https://en.wikipedia.org/wiki/Memory-mapped_I/O_and_port-mapped_I/O) corresponding to the VGA Text Mode buffer. In pratice, we print to the screen by writing to that buffer.

## Compiling and running
```bash
make && make run
```

## References
- https://wiki.osdev.org/Expanded_Main_Page
- http://vitaly_filatov.tripod.com/ng/asm/asm_001.html
- https://en.wikipedia.org/wiki/VGA_text_mode
