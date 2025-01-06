const std = @import("std");
const c3 = @import("c3");

// this requires a LED is connect to GPIO pin 9
// note: this is not the default WS2812 LED that is a DEVKIT board
const PIN = 9;

const HW = " BLINK\r\n";

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.Gpio.output_enable(9, true);
    c3.Gpio.output(9);

    //c3.logWriter.print("Blink example test app v001 \r\n", .{}) catch unreachable;
    main();
    c3.hang();
}

pub fn new_line() void {
    c3.Uart0.write(0x0A);
    c3.Uart0.write(0x0D);
}

pub fn printhex(value: u32) void {
    const hex_digits = "0123456789abcdef";

    // Iterate over each nibble (4 bits) of the u32, starting from the most significant nibble
    for (0..8) |i| {
        const shift: u5 = @intCast((7 - i) * 4); // Calculate the bit shift for the nibble
        const nibble = (value >> shift) & 0xF; // Extract the nibble
        c3.Uart0.write(hex_digits[nibble]); // Convert nibble to hex digit
    }
}

// pub fn print_val(msg: []const u8, val: u32) void {
//     for (msg) |ch| {
//         //c3.Uart0.write(@intCast(ch));
//         //c3.Reg.uart0[0] = ch;
//     }
//     printhex(val);
//     new_line();
// }

pub fn main() void {
    c3.Gpio.output_enable(PIN, true);
    c3.Gpio.output(PIN);

    while (true) {
        c3.Gpio.write(PIN, true);
        c3.delay_ms(300);
        c3.Gpio.write(PIN, false);
        c3.delay_ms(700);
        printhex(0xCAFE_BABE);
        new_line();
        printhex(@as(u32, @intFromPtr(&c3.sections._c3_global_pointer)));
        new_line();
        // print_val("TEST         : ", 0xCAFE_BABE);
        // print_val("BSS start    : ", @as(u32, @intFromPtr(&c3.sections._c3_bss_start)));

        //c3.Reg.uart0[0] = 'B';

    }
}
