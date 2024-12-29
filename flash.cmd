@REM echo on 
@REM echo %1
@REM echo %2
@REM echo %3
@REM echo %4
@REM echo %5
@REM echo %6
@REM echo %7
@REM echo %8
@REM echo %9

cls
clear
zig build
esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/zfirmware.elf 
esptool.exe  write_flash 0 ./zig-out/bin/zfirmware.bin


