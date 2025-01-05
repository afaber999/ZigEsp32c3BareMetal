const std = @import("std");
const c3 = @import("c3.zig");

pub const Uart0 = Uart(0);
pub const Uart1 = Uart(1);

pub const TransmitError = error{
    Timeout,
};

pub const ReceiveError = error{
    OverrunError,
    BreakError,
    ParityError,
    FramingError,
    Timeout,
};

fn Uart(comptime n: usize) type {
    return struct {
        const Self = @This();

        const _regs: [*]volatile u32 = switch (n) {
            0 => c3.Reg.uart0,
            1 => c3.Reg.uart1,
            else => @compileError("Unknown UART number"),
        };

        const UART_FIFO_SIZE = 128;
        const UART_FIFO_HIGH = UART_FIFO_SIZE - 4;
        const FIFO = 0x0;
        const CLKDIV = 0x14;
        const STATUS = 0x1C;
        const CONF0 = 0x20;
        const CONF1 = 0x24;
        const CLKCONF = 0x78;
        const MEM_CONF = 0x60;
        const MEM_TX_STATUS = 0x64;
        const MEM_RX_STATUS = 0x68;

        pub const Writer = std.io.GenericWriter(Self, TransmitError, generic_writer_fn);

        pub fn writer(self: Self) Writer {
            return .{ .context = self };
        }

        fn generic_writer_fn(self: Self, data: []const u8) TransmitError!usize {
            _ = self;
            for (data) |ch| Self.write(ch);
            return data.len;
        }

        pub inline fn txFifoLen() u32 {
            // 9 bits, max 512 FIFO bytes
            return (_regs[STATUS / 4] >> 16) & 0x1FF;
        }

        pub inline fn rxFifoLen() u32 {
            // 9 bits, max 512 FIFO bytes
            return (_regs[STATUS / 4] >> 0) & 0x1FF;
        }

        pub fn readNonBlocking(c: *u8) bool {
            if (rxFifoLen() == 0) return false;
            c.* = @truncate(_regs[FIFO]);
            return true;
        }

        pub fn read() u8 {
            var ret: u8 = 0;
            while (!readNonBlocking(&ret)) {
                c3.spin(1);
            }
            return ret;
        }

        pub fn writeNonBlocking(c: u8) bool {
            if (txFifoLen() >= UART_FIFO_HIGH) {
                return false;
            }
            _regs[FIFO] = c;
            return true;
        }

        pub fn write(c: u8) void {
            while (!writeNonBlocking(c)) {
                c3.spin(1);
            }
        }
    };
}
