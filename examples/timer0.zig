const std = @import("std");
const rv32 = @import("rv32");

pub const std_options = std.Options{
    .log_level = std.log.Level.debug,
    .logFn = rv32.logFn,
};

pub fn panic(message: []const u8, _: ?*std.builtin.StackTrace, addr: ?usize) noreturn {
    std.log.err("PANIC: {s} at {any} \r\n", .{ message, addr });
    @breakpoint();
    rv32.hang();
}

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    setup();
    while (true) {
        loop() catch {};
    }
}

var loops: u32 = 0;

pub fn setup() void {
    rv32.Timer0.setup_repeat(1);
    rv32.system.ptr.PERIP_CLK_EN0.modify(.{ .TIMERGROUP_CLK_EN = 1 });
}

pub fn loop() !void {
    try rv32.logWriter.print("TIMER0 {any}\r\n", .{rv32.Timer0.count()});
    //try rv32.logWriter.print("TIMER {any}\r\n", .{rv32.Timer0._ptr});
    if ((loops % 2) == 0) {
        rv32.Timer0.enable();
    } else {
        rv32.Timer0.disable();
    }

    rv32.delay_ms(1000);
    loops += 1;
}
