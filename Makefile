 OBJECTS = loader.o kmain.o drivers/io.o drivers/framebuffer.o drivers/serial_port.o segmentation/gdt.o segmentation/memory_segments.o interrupts/idt.o interrupts/interrupt_handlers.o interrupts/interrupts.o interrupts/keyboard.o interrupts/pic.o user_mode/start_program.o all_paging/paging_enable.o all_paging/paging.o all_paging/kheap.o

    CC = gcc
    CFLAGS = -m32 -nostdlib -fno-builtin -fno-stack-protector \
             -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c -masm=intel
    LDFLAGS = -T link.ld -melf_i386
    AS = nasm
    ASFLAGS = -f elf

    all: kernel.elf

    kernel.elf: $(OBJECTS)
	ld $(LDFLAGS) $(OBJECTS) -o kernel.elf

    os.iso: kernel.elf
	cp kernel.elf iso/boot/kernel.elf
	genisoimage -R                              \
                    -b boot/grub/stage2_eltorito    \
                    -no-emul-boot                   \
                    -boot-load-size 4               \
                    -A os                           \
                    -input-charset utf8             \
                    -quiet                          \
                    -boot-info-table                \
                    -o os.iso                       \
                    iso

    run: os.iso
	bochs -f bochsrc.txt -q

    %.o: %.c
	$(CC) $(CFLAGS)  $< -o $@

    %.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

    clean:
	rm -rf *.o kernel.elf os.iso
