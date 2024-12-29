const std = @import("std");

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
    pub const C3_UART = 0x60000000;
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

    pub const uart = @as([*]volatile u32, @ptrFromInt(C3_UART));
    pub const gpio = @as([*]volatile u32, @ptrFromInt(C3_GPIO));
    pub const io_mux = @as([*]volatile u32, @ptrFromInt(C3_IO_MUX));
    pub const rtcCntl = @as([*]volatile u32, @ptrFromInt(C3_RTCCNTL));
    pub const timerGroup0 = @as([*]volatile u32, @ptrFromInt(C3_TIMERGROUP0));
    pub const timerGroup1 = @as([*]volatile u32, @ptrFromInt(C3_TIMERGROUP1));
    pub const systimer = @as([*]volatile u32, @ptrFromInt(C3_SYSTIMER));

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
    Reg.systimer[1] = Bit(30); // TRM 10.5
    spin(1);
    const hi = Reg.systimer[16];
    const lo = Reg.systimer[17];
    return (@as(u64, hi) << 32) | @as(u64, lo);
}

pub inline fn uptime_us() u64 {
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

pub const Uart0 = struct {
    const UART_FIFO_MAX_SIZE = 4;
    const FIFO = 0x0;
    const CLKDIV = 0x14;
    const STATUS = 0x1C;
    const CONF0 = 0x20;
    const CONF1 = 0x24;
    const CLKCONF = 0x78;

    pub inline fn txFifoLen() u32 {
        return (Reg.uart[STATUS] >> 16) & 127;
    }

    pub inline fn rxFifoLen() u32 {
        return (Reg.uart[STATUS] >> 0) & 127;
    }

    pub fn readNonBlocking(c: *u8) bool {
        if (rxFifoLen() == 0) return false;
        c.* = Reg.uart[FIFO] & 255;
        return true;
    }

    pub fn read() u8 {
        var ret: u8 = 0;
        while (!readNonBlocking(&ret)) {
            spin(1);
        }
        return ret;
    }

    pub fn writeNonBlocking(c: u8) bool {
        if (txFifoLen() >= UART_FIFO_MAX_SIZE) {
            return false;
        }
        Reg.uart[FIFO] = c;
        return true;
    }

    pub fn write(c: u8) void {
        while (!writeNonBlocking(c)) {
            spin(1);
        }
    }
};

// Implement a std.io.Writer backed by uart_write()
const TermWriter = struct {
    const Writer = std.io.Writer(
        *TermWriter,
        error{},
        write,
    );

    fn write(
        self: *TermWriter,
        data: []const u8,
    ) error{}!usize {
        _ = self;
        for (data) |ch| Uart0.write(ch);
        return data.len;
    }

    pub fn writer(self: *TermWriter) Writer {
        return .{ .context = self };
    }
};

var tw = TermWriter{};

pub fn getWriter() *TermWriter {
    return &tw;
}