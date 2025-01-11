const std = @import("std");
const c3 = @import("c3");

// this example expects that pin 2 and pin3 are shorted together
// a LED is attached to pin 9
const OUT_PIN = 2;
const IN_PIN = 3;
const LED_PIN = 9;

const PIN = 9;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.logWriter.print("GPIO example app v001 \r\n", .{}) catch unreachable;
    main() catch {};
    c3.hang();
}

pub fn main() !void {
    c3.Gpio.output(OUT_PIN);
    c3.Gpio.input(IN_PIN);
    c3.Gpio.output(LED_PIN);

    var val = false;
    while (true) {
        val = !val;
        c3.Gpio.write(OUT_PIN, val);

        // read the value back, and write it to the LED
        const rval = c3.Gpio.read(IN_PIN);
        c3.Gpio.write(LED_PIN, rval);
        try c3.logWriter.print("GPIO READ {} LED SET TO {}\r\n", .{ val, rval });

        c3.delay_ms(1000);
    }
}
