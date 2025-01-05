const std = @import("std");
const c3 = @import("c3");

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.logWriter.print("Sysinfo example v001\r\n", .{}) catch unreachable;
    main() catch {};
    c3.hang();
}

pub fn main() !void {
    while (true) {
        try c3.showTextInfo();
        try c3.showDataInfo();
        try c3.showBssInfo();
        try c3.showStackInfo();
        try c3.showHeapInfo();
        c3.delay_ms(1000);
    }
}
