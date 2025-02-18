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

pub fn loop() !void {
    const start = rv32.uptime_us();

    // loop with NOP takes 5 cycles, so 4_000_000 nops takes 20_000_000 cycles
    // at @20Mhz that is 1 second
    // at @160Mhz that is 125 ms
    nnops(4_000_000);

    const stop = rv32.uptime_us();
    const delta = stop - start;
    const est_freq: u64 = @divTrunc(20_000_000 * 1000, delta);
    _ = try rv32.logWriter.print("loop {:>8} time (us):{:>8} estimated frequency:{:>8} KHz\r\n", .{ loops, delta, est_freq });
    rv32.delay_ms(1000);
    //try rv32.logWriter.print("SYSCLK_CONF {any}\r\n", .{rv32.system.ptr.SYSCLK_CONF.read()});
    //try rv32.logWriter.print("CPU_PER_CONF {any}\r\n", .{rv32.system.ptr.CPU_PER_CONF.read()});

    switch (loops) {
        3 => {
            rv32.set_clock_pll(true);
        },
        4 => {
            rv32.set_clock_pll(false);
        },
        else => {
            if ((loops >= 5) and (loops < 1023 + 5))
                rv32.set_clock_xtal(@truncate(loops - 5));
        },
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
