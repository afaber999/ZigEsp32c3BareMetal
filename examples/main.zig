const std = @import("std");
const c3 = @import("c3");
var term = c3.uart0.writer();

const PIN = 9;

pub const std_options = std.Options{
    .log_level = std.log.Level.debug,
    .logFn = c3.logFn,
};

export fn _c3Start() noreturn {
    c3.wdt_disable();
    setup();
    while (true) {
        loop() catch {};
    }
}

pub fn setup() void {
    c3.Gpio.output_enable(PIN, true);
    c3.Gpio.output(PIN);
    c3.Gpio.write(PIN, true);
    c3.delay_ms(5000);
    c3.Gpio.write(PIN, false);

    c3.logWriter.print("Starting test app v001 \r\n", .{}) catch unreachable;
    // for ("Setup completed version 0.000001 test code long string see if it does not miss any characters!\n") |ch| {
    //     c3.Uart0.write(@intCast(ch));
    // }
}

var loops: u32 = 0;
var test_data: u32 = 0xBABEFACE;

pub fn panic(message: []const u8, _: ?*std.builtin.StackTrace, addr: ?usize) noreturn {
    std.log.err("PANIC: {s} at {any} \r\n", .{ message, addr });
    @breakpoint();
    c3.hang();
}

pub fn loop() !void {
    std.log.debug("LOGGING FROM STD LOG DEBUG V {}", .{0});
    try c3.showTextInfo();
    try c3.showDataInfo();
    try c3.showBssInfo();
    try c3.showStackInfo();
    try c3.showHeapInfo();

    _ = try term.write("\r\n");
    for ('A'..'Z') |ch| {
        c3.Gpio.write(PIN, true);
        c3.delay_ms(50);
        c3.Gpio.write(PIN, false);
        c3.delay_ms(50);

        _ = ch;
        //Reg.write(Reg.C3_UART, @intCast(ch));
        //c3.Reg.uart[0] = @intCast(ch);
    }
    // _ = try tw.write("-------------------------\r\n");

    c3.Gpio.write(PIN, true);
    c3.Gpio.write(PIN, false);
    c3.delay_ms(2000);

    loops += 1;

    //if (loops > 2) @panic("NOOOOONONO");
    var slc = std.mem.zeroes([3]u8);
    slc[loops] = 0x00;

    // //if ((loop % 5) == 0) {
    // _ = try tw.write("TEST ALLOCATOR \r\n");
    // var allocator = c3.heapAllocator();
    // _ = try tw.write("OK \r\n");
    // var buf = try allocator.alloc(u8, 0x100);
    // defer allocator.free(buf);
    // buf[0] = 0xFF;
    // _ = try tw.print(" ALLOC NEW BUFFER ADDR {any}\r\n", .{buf.ptr});
    // //}
    // //test_data += 0x10;
}