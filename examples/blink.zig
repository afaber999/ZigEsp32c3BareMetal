const std = @import("std");
const rv32 = @import("rv32");

// this requires a LED is connect to GPIO pin 9
// note: this is not the default WS2812 LED that is a DEVKIT board
const PIN = 9;

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    rv32.logWriter.print("Blink example test app v001 \r\n", .{}) catch unreachable;
    main();
    rv32.hang();
}

pub fn main() void {
    rv32.Gpio.output(PIN);

    while (true) {
        rv32.Gpio.write(PIN, true);
        rv32.delay_ms(300);
        rv32.Gpio.write(PIN, false);
        rv32.delay_ms(700);
    }
}
