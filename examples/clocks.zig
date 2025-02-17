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
    setup() catch {};
    while (true) {
        loop() catch {};
    }
}

var loops: u32 = 0;
pub fn setup() !void {
    // ABP_CLK is 80 Mhz
    // 80_000_000 / 2 = 40_000_000
    rv32.Timer0.setup_repeat(1);
    rv32.system.ptr.PERIP_CLK_EN0.modify(.{ .TIMERGROUP_CLK_EN = 1 });
}

pub fn nnops(n: u32) void {
    for (n) |_| {
        asm volatile ("nop");
    }
}

pub fn nadds(n: usize) i32 {
    var sum: i32 = 0x0ABCDEF0;
    for (n) |_| {
        sum = sum +% sum;
    }
    return sum;
}

pub fn set_160() void {
    // Setup clocks, TRM section 6.2.4.1
    rv32.system.ptr.CPU_PER_CONF.modify(.{ .CPUPERIOD_SEL = 0b01, .PLL_FREQ_SEL = 0b1 });

    // prescale to 40, use PLL clock
    // TRM register 14.10, tables 6-2 and 6-4
    rv32.system.ptr.SYSCLK_CONF.modify(.{ .SOC_CLK_SEL = 0b01, .CLK_DIV_EN = 0b1 });
}

pub fn loop() !void {
    _ = try rv32.logWriter.print("LOOP {}\r\n", .{loops});

    const adds = loops * 25_000_000;
    const start = rv32.uptime_us();
    //nnops(10_000_000);
    const rsum = nadds(adds);
    //  2_500_001 us at startup
    // 17490 us after 10_000_000 nops ->
    const stop = rv32.uptime_us();
    const delta = stop - start;
    _ = try rv32.logWriter.print("Dtime start {} stop {} us {}\r\n", .{ start, stop, delta });
    rv32.delay_ms(1000);
    try rv32.logWriter.print("SYSCLK_CONF {any}\r\n", .{rv32.system.ptr.SYSCLK_CONF.read()});
    try rv32.logWriter.print("CPU_PER_CONF {any}\r\n", .{rv32.system.ptr.CPU_PER_CONF.read()});
    try rv32.logWriter.print("rsum {}\r\n", .{rsum});

    switch (loops) {
        0 => {
            set_160();
        },
        else => {},
    }
    // try rv32.logWriter.print("CPU_CLK {any}\r\n", .{get_cpu_freq()});
    // try rv32.logWriter.print("APB_CLK {any}\r\n", .{get_apb_freq()});

    // try rv32.logWriter.print("CPU_CLK {any}\r\n", .{rv32.system.ptr.CPU_PER_CONF.read()});

    // try rv32.logWriter.print("TIMER0 {any}\r\n", .{rv32.Timer0.count()});
    // //try rv32.logWriter.print("TIMER {any}\r\n", .{rv32.Timer0._ptr});
    // if ((loops % 2) == 0) {
    //     rv32.Timer0.enable();
    // } else {
    //     rv32.Timer0.disable();
    // }

    loops += 1;
}
