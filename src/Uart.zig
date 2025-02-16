const std = @import("std");
const rv32 = @import("rv32.zig");
const chip = @import("chip.zig");

const peripherals = chip.devices.@"ESP32-C3".peripherals;

pub const Uart0 = Uart(0);
pub const Uart1 = Uart(1);

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

        const _ptr = switch (n) {
            0 => peripherals.UART0,
            1 => peripherals.UART1,
            else => @compileError("Unknown UART number"),
        };

        const UART_FIFO_SIZE = 128;
        const UART_FIFO_HIGH = UART_FIFO_SIZE - 4;
        // const FIFO = 0x0;
        // const CLKDIV = 0x14;
        // const STATUS = 0x1C;
        // const CONF0 = 0x20;
        // const CONF1 = 0x24;
        // const CLKCONF = 0x78;
        // const MEM_CONF = 0x60;
        // const MEM_TX_STATUS = 0x64;
        // const MEM_RX_STATUS = 0x68;

        pub const Writer = std.io.GenericWriter(Self, error{}, generic_writer_fn);

        pub fn writer(self: Self) Writer {
            return .{ .context = self };
        }

        fn generic_writer_fn(self: Self, data: []const u8) error{}!usize {
            _ = self;
            for (data) |ch| Self.write(ch);
            return data.len;
        }

        pub inline fn txFifoLen() u32 {
            return _ptr.STATUS.read().TXFIFO_CNT;
        }

        pub inline fn rxFifoLen() u32 {
            return _ptr.STATUS.read().RXFIFO_CNT;
        }

        pub fn readNonBlocking(c: *u8) bool {
            if (rxFifoLen() == 0) return false;
            c.* = _ptr.FIFO.read().RXFIFO_RD_BYTE;
            return true;
        }

        pub fn read() u8 {
            var ret: u8 = 0;
            while (!readNonBlocking(&ret)) {
                rv32.spin(1);
            }
            return ret;
        }

        pub fn writeNonBlocking(c: u8) bool {
            if (txFifoLen() >= UART_FIFO_HIGH) {
                return false;
            }
            _ptr.FIFO.raw = c;
            return true;
        }

        pub fn write(c: u8) void {
            while (!writeNonBlocking(c)) {
                rv32.spin(1);
            }
        }
    };
}
