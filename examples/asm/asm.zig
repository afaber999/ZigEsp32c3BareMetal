// This is a simple example of interfacing Zig with assembly.
// The assembly code is in the file `asm.S`
// The assembly code is a simple function that adds two numbers and returns the result.
// In addition, the assembly code also has function that toggles a LED (9) on and off.
// And demonstrates how to share a global variable between asm and zig
const std = @import("std");
const rv32 = @import("rv32");

extern fn add_numbers(a: i32, b: i32) callconv(.C) i32;
extern fn led_on() callconv(.C) void;
extern fn led_off() callconv(.C) void;
extern fn inc_glob_counts() callconv(.C) void;

extern var glob_counts: i32;

// this requires a LED is connect to GPIO pin 9
// note: this is not the default WS2812 LED that is a DEVKIT board
const PIN = 9;

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    rv32.logWriter.print("ASMTESTER v001 \r\n", .{}) catch unreachable;
    main() catch unreachable;
    rv32.hang();
}

pub fn main() !void {
    rv32.Gpio.output_enable(PIN, true);
    rv32.Gpio.output(PIN);

    while (true) {
        const result = add_numbers(10, 20);
        rv32.logWriter.print("ASM TESTER, glob count: {d}, add result - {d} \r\n", .{ glob_counts, result }) catch unreachable;

        led_on();
        rv32.delay_ms(300);
        led_off();
        rv32.delay_ms(700);
        inc_glob_counts();
    }
}
