const std = @import("std");
const rv32 = @import("rv32");

// setup out log functions and log level
// has to be in the root file
pub const std_options = std.Options{
    .log_level = std.log.Level.debug,
    .logFn = rv32.logFn,
};

// Custom panic handler, should be in the root file
pub fn panic(message: []const u8, _: ?*std.builtin.StackTrace, addr: ?usize) noreturn {
    std.log.err("PANIC: {s} at {any} \r\n", .{ message, addr });
    @breakpoint();
    rv32.hang();
}

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    std.log.info("Panic example v001\r\n", .{});
    rv32.delay_ms(5000);
    main();
    rv32.hang();
}

pub fn main() void {
    var loops: u32 = 0;
    var slc = std.mem.zeroes([3]u8);

    while (true) {
        std.log.info("Loop {d}\r\n", .{loops});
        if (loops == slc.len) {
            std.log.info("Out of bounds, expect panic\r\n", .{});
        }
        slc[loops] = 0x01;
        loops += 1;
        rv32.delay_ms(1000);
    }
}
