riscv64-unknown-elf-objdump  -D ./zig-out/bin/zfirmware.elf > firmware.dis


./esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/firmware.elf



esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/zfirmware.elf 
esptool.exe  write_flash 0 ./zig-out/bin/zfirmware.bin


//esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB $(PROG).elf
