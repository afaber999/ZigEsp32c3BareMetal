const std = @import("std");
const rv32 = @import("rv32");
const ascii = std.ascii.control_code;

const tr = rv32.Uart0.read;
const tw = rv32.uart0.writer();

var cmdbuf = std.mem.zeroes([128]u8);
var cmdbuf_len: usize = 0;

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    _ = tw.write("Monitor example v001\r\n") catch unreachable;
    main() catch {};
    rv32.hang();
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
            try rv32.showTextInfo();
            try rv32.showDataInfo();
            try rv32.showBssInfo();
            try rv32.showStackInfo();
            try rv32.showHeapInfo();
        }
        cmdbuf_len = 0;
    }
}
