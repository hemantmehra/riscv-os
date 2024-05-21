boot.o: boot.S
	riscv64-unknown-elf-as boot.S -o boot.o

kernel.elf: boot.o kernel.lds
	riscv64-unknown-elf-ld -T kernel.lds  boot.o -o kernel.elf

run: kernel.elf
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 4 -m 8192M  -serial mon:stdio -device VGA -bios none -nographic -kernel kernel.elf
