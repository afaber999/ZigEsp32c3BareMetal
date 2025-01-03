const std = @import("std");
const c3 = @import("c3.zig");

const Self = @This();

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
    return (_regs[STATUS / 4] >> 0) & &0x1FF;
}

pub fn readNonBlocking(c: *u8) bool {
    if (rxFifoLen() == 0) return false;
    c.* = _regs[FIFO] & 255;
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
