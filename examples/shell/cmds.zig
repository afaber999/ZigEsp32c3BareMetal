const std = @import("std");
const shell = @import("shell.zig");
const c3 = @import("c3");

const tw = shell.tw;

const LED_PIN = 9;

fn echoCmd(args: shell.ArgList) shell.CmdErr!void {
    _ = try tw.print("You said: {s}\n", .{args});
}

fn ledCmd(args: shell.ArgList) shell.CmdErr!void {
    if (args.len < 2) {
        _ = try tw.print("{s} <0|1>", .{args[0]});
        return shell.CmdErr.BadArgs;
    }

    const val = std.fmt.parseInt(u32, args[1], 10) catch 0; // if it parses and > 0, default to 0
    c3.Gpio.output(LED_PIN);
    c3.Gpio.write(LED_PIN, val > 0);
}

// register commands with shell (comptime)
pub const cmdTable = [_]shell.Cmd{
    shell.makeCmd("echo", echoCmd),
    shell.makeCmd("led", ledCmd),
};
