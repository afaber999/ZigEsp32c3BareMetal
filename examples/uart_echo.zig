const std = @import("std");
const c3 = @import("c3");

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
    var ch: u8 = undefined;
    c3.logWriter.print("Starting test app v001 \r\n", .{}) catch unreachable;
    while (true) {
        if (c3.Uart0.readNonBlocking(&ch)) {
            c3.Uart0.write(ch);
            c3.Uart0.write(ch + 1);
        }
    }
}
