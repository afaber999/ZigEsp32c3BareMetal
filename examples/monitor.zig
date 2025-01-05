const std = @import("std");
const c3 = @import("c3");
const ascii = std.ascii.control_code;

const tr = c3.Uart0.read;
const tw = c3.uart0.writer();

var cmdbuf = std.mem.zeroes([128]u8);
var cmdbuf_len: usize = 0;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    _ = tw.write("Monitor example v001\r\n") catch unreachable;
    main() catch {};
    c3.hang();
}

pub fn main() !void {
    while (true) {
        _ = try tw.writeByte('>');

        while (true) {
            const ch = tr();

            switch (ch) {
                ascii.etx => { // ctrl-c
                    // FIXME, should return error from loop?
                },
                ascii.cr, ascii.lf => {
                    _ = try tw.write("\n");
                    break;
                },
                ascii.del, ascii.bs => {
                    if (cmdbuf_len > 0) {
                        cmdbuf_len = cmdbuf_len - 1;
                        cmdbuf[cmdbuf_len] = 0;
                        _ = try tw.print("{c} {c}", .{ ascii.bs, ascii.bs });
                    }
                },
                else => {
                    // echo
                    if (cmdbuf_len < cmdbuf.len) {
                        cmdbuf[cmdbuf_len] = ch;
                        cmdbuf_len += 1;
                        cmdbuf[cmdbuf_len] = 0;
                        _ = try tw.writeByte(ch);
                    } else {
                        _ = try tw.writeByte(ascii.bel);
                    }
                },
            }
        }
        const cmd = cmdbuf[0..cmdbuf_len];
        _ = try tw.print("buffer: {any}\r\n", .{cmd});

        if (std.mem.startsWith(u8, cmd, "I")) {
            try c3.showTextInfo();
            try c3.showDataInfo();
            try c3.showBssInfo();
            try c3.showStackInfo();
            try c3.showHeapInfo();
        }
        cmdbuf_len = 0;
    }
}
