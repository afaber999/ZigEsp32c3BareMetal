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

// /***************************************
//  Group clock
//  ***************************************/

// /* Functions */
const ETS_GET_APB_FREQ = 0x40000580;
const ETS_GET_CPU_FREQUENCY = 0x40000584;
const ETS_UPDATE_CPU_FREQUENCY = 0x40000588;
const ETS_GET_PRINTF_CHANNEL = 0x4000058c;
const ETS_GET_XTAL_DIV = 0x40000590;
const ETS_SET_XTAL_DIV = 0x40000594;
const ETS_GET_XTAL_FREQ = 0x40000598;

pub export fn set_cpu_freq(arg_freq: u32) void {
    var freq = arg_freq;
    _ = &freq;
    @as(?*const fn (u32) callconv(.C) void, @ptrFromInt(@as(c_int, ETS_UPDATE_CPU_FREQUENCY))).?(freq);
}
pub export fn get_cpu_freq() u32 {
    return @as(?*const fn (...) callconv(.C) u32, @ptrFromInt(@as(c_int, ETS_GET_CPU_FREQUENCY))).?();
}

pub export fn get_apb_freq() u32 {
    return @as(?*const fn (...) callconv(.C) u32, @ptrFromInt(@as(c_int, ETS_GET_APB_FREQ))).?();
}

pub fn setup() !void {
    // ABP_CLK is 80 Mhz
    // 80_000_000 / 2 = 40_000_000
    rv32.Timer0.setup_repeat(1);
    rv32.system.ptr.PERIP_CLK_EN0.modify(.{ .TIMERGROUP_CLK_EN = 1 });

}

pub fn loop() !void {
    try rv32.logWriter.print("CPU_CLK {any}\r\n", .{get_cpu_freq()});
    try rv32.logWriter.print("APB_CLK {any}\r\n", .{get_apb_freq()});

    try rv32.logWriter.print("CPU_CLK {any}\r\n", .{rv32.system.ptr.CPU_PER_CONF.read()});

    try rv32.logWriter.print("TIMER0 {any}\r\n", .{rv32.Timer0.count()});
    //try rv32.logWriter.print("TIMER {any}\r\n", .{rv32.Timer0._ptr});
    if ((loops % 2) == 0) {
        rv32.Timer0.enable();
    } else {
        rv32.Timer0.disable();
    }

    rv32.delay_ms(1000);
    loops += 1;
}
