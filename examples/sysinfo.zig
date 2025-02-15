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
        try c3.showInterruptInfo();
        try c3.showInterruptVectors();

        c3.system.ptr.PERIP_CLK_EN0.modify(.{ .LEDC_CLK_EN = 1 });
        try c3.logWriter.print("getPeriClkEn0 {any}\r\n", .{c3.system.ptr.PERIP_CLK_EN0.read()});

        // const v = c3.system.ptr.*;
        // try c3.logWriter.print("Systemptr: {any}\r\n", .{v});

        c3.delay_ms(1000);
    }
}
