const std = @import("std");
const c3 = @import("c3");

extern fn add_numbers(a: i32, b: i32) callconv(.C) i32;
extern fn led_on() callconv(.C) void;
extern fn led_off() callconv(.C) void;
extern fn inc_glob_counts() callconv(.C) void;

extern var glob_counts: i32;


// this requires a LED is connect to GPIO pin 9
// note: this is not the default WS2812 LED that is a DEVKIT board
const PIN = 9;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.logWriter.print("ASMTESTER v001 \r\n", .{}) catch unreachable;
    main() catch unreachable;
    c3.hang();
}

pub fn main() !void {
    c3.Gpio.output_enable(PIN, true);
    c3.Gpio.output(PIN);

    while (true) {
        const result = add_numbers(10, 20);
        try c3.logWriter.print("Result: {}\n", .{result});
        c3.logWriter.print("ASM TESTER, glob count: {d} \r\n", .{glob_counts}) catch unreachable;

        led_on();
        c3.delay_ms(300);
        led_off();
        c3.delay_ms(700);
        inc_glob_counts();
    }
}
