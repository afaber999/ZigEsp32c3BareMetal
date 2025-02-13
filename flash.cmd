@REM echo off 
python -m esptool write_flash 0 .\zig-out\bin\%1.bin