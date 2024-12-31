# What is it?
This is a Vvry limites SDK to program the ESP32-C3 using the zig compiler and languge

# Current state?
not working




# my notes, TODO remove
riscv64-unknown-elf-objdump  -D ./zig-out/bin/zfirmware.elf > firmware.dis
./esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/firmware.elf


esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/zfirmware.elf 
esptool.exe  write_flash 0 ./zig-out/bin/zfirmware.bin

//esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB $(PROG).elf


# symbols and sections dump
$ riscv64-unknown-elf-objdump.exe  -t -h ./zig-out/bin/zfirmware.elf 
