const std = @import("std");
const shell = @import("shell.zig");
const rv32 = @import("rv32");

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
    rv32.Gpio.output(LED_PIN);
    rv32.Gpio.write(LED_PIN, val > 0);
}

fn sysInfoCmd(args: shell.ArgList) shell.CmdErr!void {
    _ = args;
    _ = try tw.print("System Info\n", .{});
    try rv32.showTextInfo();
    try rv32.showDataInfo();
    try rv32.showBssInfo();
    try rv32.showStackInfo();
    try rv32.showHeapInfo();
    try rv32.showInterruptInfo();
    try rv32.showInterruptVectors();
}

// register commands with shell (comptime)
pub const cmdTable = [_]shell.Cmd{
    shell.makeCmd("echo", echoCmd),
    shell.makeCmd("led", ledCmd),
    shell.makeCmd("sysinfo", sysInfoCmd),
};
