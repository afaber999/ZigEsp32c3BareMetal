const c3 = @import("c3.zig");

const uart = c3.Reg.uart0;

pub fn print_new_line() void {
    uart[0] = 0x0A;
    uart[0] = 0x0D;
}

pub inline fn print_nibble(val: u8) void {
    if (val < 10) {
        uart[0] = ('0' + val);
    } else {
        uart[0] = ('A' + val - 10);
    }
}

pub fn printhex_u32(value: u32) void {
    // Iterate over each nibble (4 bits) of the u32, starting from the most significant nibble
    for (0..8) |i| {
        const shift: u5 = @intCast((7 - i) * 4); // Calculate the bit shift for the nibble
        const nibble: u8 = @truncate((value >> shift) & 0xF); // Extract the nibble
        print_nibble(nibble);
    }
}

pub fn printhex_u8(val: u8) void {
    print_nibble((val >> 4) & 0xF);
    print_nibble(val & 0xF);
}

// dumping memory, when using to dump flash data, use drom address area
// in order to allow byte alignment memory access
pub fn dump_mem(ptr: [*]const u8, len: usize) void {
    var i: usize = 0;
    while (i < len) {
        const addr = @as(u32, @intFromPtr(&ptr[i]));
        printhex_u32(addr);
        uart[0] = ' ';

        for (0..16) |j| {
            printhex_u8(ptr[i + j]);
            uart[0] = ' ';
        }
        uart[0] = ' ';
        uart[0] = '-';
        uart[0] = ' ';

        c3.spin(50000);

        for (0..16) |j| {
            const v = ptr[i + j];
            if (v >= 32 and v < 127) {
                uart[0] = v;
            } else {
                uart[0] = '.';
            }
        }
        i += 16;
        print_new_line();
    }
}
