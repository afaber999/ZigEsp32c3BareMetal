const std = @import("std");
const rv32 = @import("rv32");

// setup out log functions and log level
// has to be in the root file
pub const std_options = std.Options{
    .log_level = std.log.Level.debug,
    .logFn = rv32.logFn,
};

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    main();
    rv32.hang();
}

pub fn main() void {
    rv32.logWriter.print("Logger example v001\r\n", .{}) catch unreachable;
    while (true) {
        std.log.debug("LOG {s}", .{"debug"});
        std.log.info("LOG {s}", .{"info"});
        std.log.info("LOG {s}", .{"info"});
        std.log.warn("LOG {s}", .{"warn"});
        std.log.err("LOG {s}", .{"err"});
        rv32.delay_ms(1000);
    }
}
