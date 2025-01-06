const std = @import("std");
const Uart = @import("Uart.zig");

pub const Uart0 = Uart.Uart0;
pub const Uart1 = Uart.Uart1;

pub const uart0 = Uart0{};
pub const uart1 = Uart1{};

pub const logWriter = uart0.writer();

pub fn Bit(comptime x: u5) u32 {
    return 1 << x;
}

pub const Reg = struct {
    pub const C3_SYSTEM = 0x600c0000;
    pub const C3_SENSITIVE = 0x600c1000;
    pub const C3_INTERRUPT = 0x600c2000;
    pub const C3_EXTMEM = 0x600c4000;
    pub const C3_MMU_TABLE = 0x600c5000;
    pub const C3_AES = 0x6003a000;
    pub const C3_SHA = 0x6003b000;
    pub const C3_RSA = 0x6003c000;
    pub const C3_HMAC = 0x6003e000;
    pub const C3_DIGITAL_SIGNATURE = 0x6003d000;
    pub const C3_GDMA = 0x6003f000;
    pub const C3_ASSIST_DEBUG = 0x600ce000;
    pub const C3_DEDICATED_GPIO = 0x600cf000;
    pub const C3_WORLD_CNTL = 0x600d0000;
    pub const C3_DPORT_END = 0x600d3FFC;
    pub const C3_UART0 = 0x60000000;
    pub const C3_SPI1 = 0x60002000;
    pub const C3_SPI0 = 0x60003000;
    pub const C3_GPIO = 0x60004000;
    pub const C3_FE2 = 0x60005000;
    pub const C3_FE = 0x60006000;
    pub const C3_RTCCNTL = 0x60008000;
    pub const C3_IO_MUX = 0x60009000;
    pub const C3_RTC_I2C = 0x6000e000;
    pub const C3_UART1 = 0x60010000;
    pub const C3_I2C_EXT = 0x60013000;
    pub const C3_UHCI0 = 0x60014000;
    pub const C3_RMT = 0x60016000;
    pub const C3_LEDC = 0x60019000;
    pub const C3_EFUSE = 0x60008800;
    pub const C3_NRX = 0x6001CC00;
    pub const C3_BB = 0x6001D000;
    pub const C3_TIMERGROUP0 = 0x6001F000;
    pub const C3_TIMERGROUP1 = 0x60020000;
    pub const C3_SYSTIMER = 0x60023000;
    pub const C3_SPI2 = 0x60024000;
    pub const C3_SYSCON = 0x60026000;
    pub const C3_APB_CTRL = 0x60026000;
    pub const C3_TWAI = 0x6002B000;
    pub const C3_I2S0 = 0x6002D000;
    pub const C3_APB_SARADC = 0x60040000;
    pub const C3_AES_XTS = 0x600CC000;
    pub const C3_USB_JTAG = 0x60043000;

    pub const uart0 = @as([*]volatile u32, @ptrFromInt(C3_UART0));
    pub const uart1 = @as([*]volatile u32, @ptrFromInt(C3_UART0));

    pub const gpio = @as([*]volatile u32, @ptrFromInt(C3_GPIO));
    pub const io_mux = @as([*]volatile u32, @ptrFromInt(C3_IO_MUX));
    pub const rtcCntl = @as([*]volatile u32, @ptrFromInt(C3_RTCCNTL));
    pub const timerGroup0 = @as([*]volatile u32, @ptrFromInt(C3_TIMERGROUP0));
    pub const timerGroup1 = @as([*]volatile u32, @ptrFromInt(C3_TIMERGROUP1));
    pub const systimer = @as([*]volatile u32, @ptrFromInt(C3_SYSTIMER));
    pub const system = @as([*]volatile u32, @ptrFromInt(C3_SYSTEM));
    pub const ledc = @as([*]volatile u32, @ptrFromInt(C3_LEDC));

    pub inline fn setOrClearBit(ptr: *volatile u32, pin: usize, enable: bool) void {
        if (enable) ptr.* |= Bit(pin) else ptr.* &= ~Bit(pin);
    }
};

pub fn wdt_disable() void {
    Reg.rtcCntl[42] = 0x50d83aa1;
    Reg.rtcCntl[36] = 0; // Disable RTC WDT
    Reg.rtcCntl[35] = 0; // Disable

    // // bootloader_super_wdt_auto_feed()
    Reg.rtcCntl[44] = 0x8F1D312A;
    Reg.rtcCntl[43] = Bit(31);
    Reg.rtcCntl[45] = 0;

    //Reg.write(Reg.C3_TIMERGROUP0 + 63 * 4, Reg.read(Reg.C3_TIMERGROUP0 + 63 * 4) & ~Bit(9)); // TIMG_REGCLK -> disable TIMG_WDT_CLK

    Reg.timerGroup0[63] &= ~Bit(9);
    Reg.timerGroup0[18] = 0; // Disable TG0 WDT
    Reg.timerGroup1[18] = 0; // Disable TG1 WDT
}

// API GPIO
pub const Gpio = struct {
    const GPIO_OUT_EN = 8;
    const GPIO_OUT_FUNC = 341;
    const GPIO_IN_FUNC = 85;

    pub inline fn output_enable(pin: usize, enable: bool) void {
        Reg.setOrClearBit(&Reg.gpio[GPIO_OUT_EN], pin, enable);
    }

    pub inline fn output(pin: usize) void {
        Reg.gpio[GPIO_OUT_FUNC + pin] = Bit(9) | 128; // Simple out, TRM 5.5.3
        Gpio.output_enable(pin, true);
    }

    pub inline fn write(pin: usize, value: bool) void {
        Reg.setOrClearBit(&Reg.gpio[1], pin, value);
    }
    pub inline fn toggle(pin: usize) void {
        Reg.gpio[1] ^= Bit(pin);
    }

    pub inline fn input(pin: usize) void {
        output_enable(pin, 0); // Disable output
        Reg.io_mux[1 + pin] = Bit(9) | Bit(8); // Enable pull-up
    }

    pub inline fn read(pin: usize) bool {
        const v = Reg.gpio[15] & Bit(pin);
        return v != 0;
    }
};

pub inline fn spin(count: u64) void {
    var left = count;
    while (left > 0) {
        left -= 1;
        asm volatile ("nop");
    }
}

pub inline fn systick() u64 {
    // system timer runs on 16 MHZ thus 16 ticks per microsecond
    const SYSTIMER_UNIT0_OP_REG = 0x0004;
    const SYSTIMER_UNIT0_VALUE_HI_REG = 0x0040;
    const SYSTIMER_UNIT0_VALUE_LO_REG = 0x0044;

    Reg.systimer[SYSTIMER_UNIT0_OP_REG / 4] = Bit(30); // TRM 10.5, update Unit0
    spin(1);

    const hi = Reg.systimer[SYSTIMER_UNIT0_VALUE_HI_REG / 4];
    const lo = Reg.systimer[SYSTIMER_UNIT0_VALUE_LO_REG / 4];
    return (@as(u64, hi) << 32) | @as(u64, lo);
}

pub inline fn uptime_us() u64 {
    // convert to microseconds
    return systick() >> 4;
}

pub inline fn delay_us(us: u64) void {
    const until = uptime_us() + us;
    while (uptime_us() < until)
        spin(1);
}

pub fn delay_ms(ms: u64) void {
    delay_us(ms * 1000);
}

/// Contains references to the linker .data and .bss sections, also
/// contains the initial load address for .data if it is in flash.
pub const sections = struct {
    // it looks odd to just use a u8 here, but in C it's common to use a
    // char when linking these values from the linkerscript. What's
    // important is the addresses of these values.
    pub extern var _c3_text_start: u8;
    pub extern var _c3_text_end: u8;

    pub extern var _c3_stack_top: u8;
    pub extern var _c3_stack_bottom: u8;
    pub extern var _c3_stack_size: u8;

    pub extern var _c3_heap_start: u8;
    pub extern var _c3_heap_end: u8;
    pub extern var _c3_heap_size: u8;

    pub extern var _c3_data_start: u8;
    pub extern var _c3_data_end: u8;

    pub extern var _c3_bss_start: u8;
    pub extern var _c3_bss_end: u8;

    pub extern const _c3_data_load_start: u8;
    pub extern const _c3_global_pointer: u8;
};

export fn _start() linksection(".text.start") callconv(.Naked) noreturn {
    asm volatile ("la sp, _c3_stack_top");
    asm volatile (
        \\.option push
        \\.option norelax
        \\la gp, _c3_global_pointer
        \\.option pop
    );

    @setRuntimeSafety(false);

    // fill .bss with zeroes
    {
        const bss_start: [*]u8 = @ptrCast(&sections._c3_bss_start);
        const bss_end: [*]u8 = @ptrCast(&sections._c3_bss_end);
        const bss_len = @intFromPtr(bss_end) - @intFromPtr(bss_start);

        @memset(bss_start[0..bss_len], 0);
    }

    // load .data from flash
    {
        const data_start: [*]u8 = @ptrCast(&sections._c3_data_start);
        const data_end: [*]u8 = @ptrCast(&sections._c3_data_end);
        const data_len = @intFromPtr(data_end) - @intFromPtr(data_start);
        const data_src: [*]const u8 = @ptrCast(&sections._c3_data_load_start);

        if ((data_start != data_src) and (data_len > 0)) {
            @memcpy(data_start[0..data_len], data_src[0..data_len]);
        }
    }

    //setCpuClock(160);
    asm volatile ("jal zero, _c3Start");
}

pub fn sbss() [*]volatile u32 {
    return @ptrCast(&sections._c3_bss_start);
}

pub fn ebss() [*]const u32 {
    return @ptrCast(&sections._c3_bss_end);
}

pub fn setCpuClock(freqInMhz: usize) void {
    _ = freqInMhz;
    // const SYSTEM_CPU_PER_CONF_REG = 0x0008;
    // const system = Reg.system;

    // // don't force WAIT mode
    // system[SYSTEM_CPU_PER_CONF_REG/4] &= ~Bit(3);

    // // set CPU clock
    // system[SYSTEM_CPU_PER_CONF_REG/4] |= 0b11;

    // pub const systimer = @as([*]volatile u32, @ptrFromInt(C3_SYSTIMER));

}

//var c3Allocator: std.heap.FixedBufferAllocator = null;
var c3Allocator: ?std.heap.FixedBufferAllocator = null;

pub fn heapAllocator() std.mem.Allocator {
    if (c3Allocator == null) {
        const heap_len = @intFromPtr(&sections._c3_heap_end) - @intFromPtr(&sections._c3_heap_start);
        const heap_mem = @as([*]u8, @ptrCast(&sections.sections._c3_heap_start))[0..heap_len];
        c3Allocator = std.heap.FixedBufferAllocator.init(heap_mem);
    }
    return c3Allocator.?.allocator();
}

pub fn showStackInfo() !void {
    const sz = @as(u32, @intFromPtr(&sections._c3_stack_top)) - @as(u32, @intFromPtr(&sections._c3_stack_bottom));
    _ = try logWriter.print("STACK: top: {any} bottom: {any} size: {d}\r\n", .{ &sections._c3_stack_top, &sections._c3_stack_bottom, sz });
}

pub fn showDataInfo() !void {
    const sz = @as(u32, @intFromPtr(&sections._c3_data_end)) - @as(u32, @intFromPtr(&sections._c3_data_start));
    _ = try logWriter.print("DATA: top: {any} bottom: {any} size: {d}\r\n", .{ &sections._c3_data_end, &sections._c3_data_start, sz });
}

pub fn showBssInfo() !void {
    const sz = @as(u32, @intFromPtr(&sections._c3_bss_end)) - @as(u32, @intFromPtr(&sections._c3_bss_start));
    _ = try logWriter.print("BSS: top: {any} bottom: {any} size: {d}\r\n", .{ &sections._c3_bss_end, &sections._c3_bss_start, sz });
}

pub fn showTextInfo() !void {
    const sz = @as(u32, @intFromPtr(&sections._c3_text_end)) - @as(u32, @intFromPtr(&sections._c3_text_start));
    _ = try logWriter.print("TEXT: top: {any} bottom: {any} size: {d}\r\n", .{ &sections._c3_text_end, &sections._c3_text_start, sz });
}

pub fn showHeapInfo() !void {
    const sz = @as(u32, @intFromPtr(&sections._c3_heap_size));
    _ = try logWriter.print("HEAP: top: {any} bottom: {any} size: {d}\r\n", .{ &sections._c3_heap_start, &sections._c3_heap_end, sz });
}

//std.options.logFn(comptime message_level: log.Level, comptime scope: @TypeOf(.enum_literal), comptime format: []const u8, args: anytype)
pub fn logFn(
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    const level_prefix = comptime "[{:0>12}] " ++ level.asText();
    const prefix = comptime level_prefix ++ switch (scope) {
        .default => ": ",
        else => " (" ++ @tagName(scope) ++ "): ",
    };
    const up_time = uptime_us();
    logWriter.print(prefix ++ format ++ "\r\n", .{up_time} ++ args) catch {};
}

pub fn hang() noreturn {
    while (true) {
        asm volatile ("wfi");
    }
}
