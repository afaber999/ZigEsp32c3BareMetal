const std = @import("std");
const c3 = @import("c3");



const shell = @import("shell.zig");

export fn _c3Start() noreturn {
    c3.wdt_disable();
    main() catch {};
    c3.hang();
}

pub fn main() !void {


    c3.delay_ms(3000);
    try c3.logWriter.print("SHELL example app v002 \r\n", .{});

    try shell.init();
    while (true) {
        try shell.loop();
    }
}
