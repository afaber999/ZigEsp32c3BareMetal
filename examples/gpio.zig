const std = @import("std");
const rv32 = @import("rv32");

// this example expects that pin 2 and pin3 are shorted together
// a LED is attached to pin 9
const OUT_PIN = 2;
const IN_PIN = 3;
const LED_PIN = 9;

const PIN = 9;

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    rv32.logWriter.print("GPIO example app v001 \r\n", .{}) catch unreachable;
    main() catch {};
    rv32.hang();
}

pub fn main() !void {
    rv32.Gpio.output(OUT_PIN);
    rv32.Gpio.input(IN_PIN);
    rv32.Gpio.output(LED_PIN);

    var val = false;
    while (true) {
        val = !val;
        rv32.Gpio.write(OUT_PIN, val);

        // read the value back, and write it to the LED
        const rval = rv32.Gpio.read(IN_PIN);
        rv32.Gpio.write(LED_PIN, rval);
        try rv32.logWriter.print("GPIO READ {} LED SET TO {}\r\n", .{ val, rval });

        rv32.delay_ms(1000);
    }
}
