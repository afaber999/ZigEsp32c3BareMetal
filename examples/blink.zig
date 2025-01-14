const std = @import("std");
const c3 = @import("c3");

// this requires a LED is connect to GPIO pin 9
// note: this is not the default WS2812 LED that is a DEVKIT board
const PIN = 9;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.logWriter.print("Blink example test app v001 \r\n", .{}) catch unreachable;
    main();
    c3.hang();
}

pub fn main() void {
    c3.Gpio.output(PIN);

    while (true) {
        c3.Gpio.write(PIN, true);
        c3.delay_ms(300);
        c3.Gpio.write(PIN, false);
        c3.delay_ms(700);
    }
}
