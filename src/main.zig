const std = @import("std");
const c3 = @import("c3.zig");
var tw = c3.getWriter().writer();

const PIN = 9;

export fn _start() linksection(".text.start") callconv(.Naked) noreturn {
    asm volatile ("la sp, __stack_top");
    asm volatile (
        \\.option push
        \\.option norelax
        \\la gp, __global_pointer$
        \\.option pop
    );

    asm volatile ("jal zero, _start2");
}

export fn _start2() noreturn {
    c3.wdt_disable();
    setup();
    while (true) {
        loop() catch {};
    }
}

pub fn setup() void {
    c3.Gpio.output_enable(PIN, true);
    c3.Gpio.output(PIN);
    c3.Gpio.write(PIN, true);
    c3.delay_ms(1000);
    c3.Gpio.write(PIN, false);

    for ("Setup completed version 0.000001 test code long string see if it does not miss any characters!\n") |ch| {
        c3.Uart0.write(@intCast(ch));
    }
}

var loops: u32 = 0;

pub fn loop() !void {
    for ('A'..'Z') |ch| {
        c3.Gpio.write(PIN, true);
        c3.delay_ms(50);
        c3.Gpio.write(PIN, false);
        c3.delay_ms(50);

        //Reg.write(Reg.C3_UART, @intCast(ch));
        c3.Reg.uart[0] = @intCast(ch);
    }

    c3.Gpio.write(PIN, true);
    c3.Gpio.write(PIN, false);
    c3.delay_ms(2000);

    loops += 1;
    _ = try tw.print("Another loop bytes the dust, count so far {d}\r\n", .{loops});

    // for ("Another loop bytes the dust again .................!!!\n") |ch| {
    //     c3.Uart0.write(@intCast(ch));
    // }
}
