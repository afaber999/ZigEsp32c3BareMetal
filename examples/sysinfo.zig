const std = @import("std");
const rv32 = @import("rv32");

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    rv32.logWriter.print("Sysinfo example v001\r\n", .{}) catch unreachable;
    main() catch {};
    rv32.hang();
}

pub fn main() !void {
    while (true) {
        try rv32.showTextInfo();
        try rv32.showDataInfo();
        try rv32.showBssInfo();
        try rv32.showStackInfo();
        try rv32.showHeapInfo();
        try rv32.showInterruptInfo();
        try rv32.showInterruptVectors();

        rv32.system.ptr.PERIP_CLK_EN0.modify(.{ .LEDC_CLK_EN = 1 });
        try rv32.logWriter.print("getPeriClkEn0 {any}\r\n", .{rv32.system.ptr.PERIP_CLK_EN0.read()});

        // const v = rv32.system.ptr.*;
        // try rv32.logWriter.print("Systemptr: {any}\r\n", .{v});

        rv32.delay_ms(1000);
    }
}
