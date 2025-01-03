@REM echo on 
@REM echo %1

@REM cls
REM clear
REM zig build
REM esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/zfirmware.elf 
esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/%1.elf 
esptool.exe  write_flash 0 ./zig-out/bin/%1.bin


