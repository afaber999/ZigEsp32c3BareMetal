const std = @import("std");
const rv32 = @import("rv32");



const shell = @import("shell.zig");

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    main() catch {};
    rv32.hang();
}

pub fn main() !void {


    rv32.delay_ms(3000);
    try rv32.logWriter.print("SHELL example app v002 \r\n", .{});

    try shell.init();
    while (true) {
        try shell.loop();
    }
}
