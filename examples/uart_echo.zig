const std = @import("std");
const rv32 = @import("rv32");

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
    var ch: u8 = undefined;
    rv32.logWriter.print("Starting test app v001 \r\n", .{}) catch unreachable;
    while (true) {
        if (rv32.Uart0.readNonBlocking(&ch)) {
            rv32.Uart0.write(ch);
            //3.Uart0.write(ch + 1);
        }
    }
}
