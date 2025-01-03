const std = @import("std");
const c3 = @import("c3");

// setup out log functions and log level
// has to be in the root file
pub const std_options = std.Options{
    .log_level = std.log.Level.debug,
    .logFn = c3.logFn,
};

export fn _c3Start() noreturn {
    c3.wdt_disable();
    main();
    c3.hang();
}

pub fn main() void {
    c3.logWriter.print("Logger example v001\r\n", .{}) catch unreachable;
    while (true) {
        std.log.debug("LOG {s}", .{"debug"});
        std.log.info("LOG {s}", .{"info"});
        std.log.info("LOG {s}", .{"info"});
        std.log.warn("LOG {s}", .{"warn"});
        std.log.err("LOG {s}", .{"err"});
        c3.delay_ms(1000);
    }
}
