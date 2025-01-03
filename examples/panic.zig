const std = @import("std");
const c3 = @import("c3");

// setup out log functions and log level
// has to be in the root file
pub const std_options = std.Options{
    .log_level = std.log.Level.debug,
    .logFn = c3.logFn,
};

// Custom panic handler, should be in the root file
pub fn panic(message: []const u8, _: ?*std.builtin.StackTrace, addr: ?usize) noreturn {
    std.log.err("PANIC: {s} at {any} \r\n", .{ message, addr });
    @breakpoint();
    c3.hang();
}

export fn _c3Start() noreturn {
    c3.wdt_disable();
    std.log.info("Panic example v001\r\n", .{});
    c3.delay_ms(5000);
    main();
    c3.hang();
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
        c3.delay_ms(1000);
    }
}
