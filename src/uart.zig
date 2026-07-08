const Writer = std.Io.Writer;
const std = @import("std");
const rv32 = @import("rv32.zig");
const chip = @import("chip.zig");

const peripherals = chip.devices.@"ESP32-C3".peripherals;

pub const Uart0 = Uart(0);
pub const Uart1 = Uart(1);

pub const uart0 = Uart0{};
pub const uart1 = Uart1{};

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

        fn drain(_: *Writer, data: []const []const u8,
                 splat: usize) Writer.Error!usize {
            var count: usize = 0;
            for (data) |slice| {
                for (slice) |c|
                    write(c);
                count += slice.len;
            }
            for (0..splat) |_| {
                for (data[data.len-1]) |c|
                    write(c);
                count += data[data.len-1].len;
            }
            return count;
        }

        pub fn writer(_: Self) Writer {
            return .{ .vtable = &.{ .drain = drain }, .buffer = &.{} };
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
