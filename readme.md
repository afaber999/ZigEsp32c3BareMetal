# Zig Baremetal Library for ESP32-C3 (RISC-V)

Welcome to my experimental **Zig baremetal library** for the **ESP32-C3**, based on the **RISC-V** architecture. This library is a personal project created for experimentation and learning, providing a minimalistic environment for running baremetal applications on the ESP32-C3 without relying on an RTOS like ESP-IDF. 

Although still in its early stages, the library includes several core features and sample programs, making it a great starting point for exploring the ESP32-C3 and the RISC-V architecture using Zig.

---

## Features

- **Minimal Baremetal Environment**: Stripped down to essentials, focusing on low-level hardware interaction.
- **RISC-V Assembly Integration**: Inline assembly examples for low-level customization.
- **Basic Peripherals Support**:
  - UART for serial communication.
  - GPIO for basic input/output.
  - Panic handling.
- **Logging Framework**: Custom logging for debugging and experimentation.
- **Sample Programs**:
  - UART echo.
  - Logging with different verbosity levels.
  - Panic handling demonstration.

---

## Getting Started

### Prerequisites

- **Zig**: Install the Zig compiler (v0.10.0 or later recommended).
  - [Download Zig](https://ziglang.org/download/)
- **ESP32-C3 Development Board**: Ensure your hardware is ready for programming.

### Setting Up the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/zig-esp32c3-baremetal.git
   cd zig-esp32c3-baremetal

2. run zig_build to compile all examples
3. flash an example project using zig build run_xxxxx where xxxx is the sample name, following samples are included
    blink
    panic
    logger
    uart_echo


# my notes, TODO remove, please ignore
riscv64-unknown-elf-objdump  -D ./zig-out/bin/zfirmware.elf > firmware.dis
./esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/firmware.elf


esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB ./zig-out/bin/zfirmware.elf 
esptool.exe  write_flash 0 ./zig-out/bin/zfirmware.bin

//esptool.exe --chip esp32c3 elf2image --flash_mode dio --flash_freq 80m --flash_size 4MB $(PROG).elf
$ riscv64-unknown-elf-objdump.exe  -t -h ./zig-out/bin/zfirmware.elf 
