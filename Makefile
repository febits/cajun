ASM=nasm
ASMFLAGS=-fbin
QEMU=qemu-system-i386

BUILDDIR=build

BOOT_SRC=$(wildcard src/*.asm)
BOOT_BIN=$(patsubst %.asm, $(BUILDDIR)/%.bin, $(notdir $(BOOT_SRC)))

CAJUN_BIN=$(BUILDDIR)/cajun.bin

.PHONY: default clean always
default: always $(BOOT_BIN) build_image

$(BUILDDIR)/%.bin: ./src/%.asm
	$(ASM) $(ASMFLAGS) $< -o $@

build_image:
	dd if=/dev/zero of=$(CAJUN_BIN) bs=1024 count=1
	dd if=$(BUILDDIR)/boot.bin of=$(CAJUN_BIN) bs=512 count=1
	dd if=$(BUILDDIR)/kernel.bin of=$(CAJUN_BIN) bs=512 count=1 seek=1

run:
	$(QEMU) -drive format=raw,file=$(CAJUN_BIN)

always:
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)
