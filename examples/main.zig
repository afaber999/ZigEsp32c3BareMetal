const std = @import("std");
const rv32 = @import("rv32");
var term = rv32.uart0.writer();

const PIN = 9;

pub const std_options = std.Options{
    .log_level = std.log.Level.debug,
    .logFn = rv32.logFn,
};

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    setup();
    while (true) {
        loop() catch {};
    }
}

pub fn setup() void {
    rv32.Gpio.output_enable(PIN, true);
    rv32.Gpio.output(PIN);
    rv32.Gpio.write(PIN, true);
    rv32.delay_ms(5000);
    rv32.Gpio.write(PIN, false);

    rv32.logWriter.print("Starting test app v001 \r\n", .{}) catch unreachable;
    // for ("Setup completed version 0.000001 test code long string see if it does not miss any characters!\n") |ch| {
    //     rv32.Uart0.write(@intCast(ch));
    // }
}

var loops: u32 = 0;
var test_data: u32 = 0xBABEFACE;

pub fn panic(message: []const u8, _: ?*std.builtin.StackTrace, addr: ?usize) noreturn {
    std.log.err("PANIC: {s} at {any} \r\n", .{ message, addr });
    @breakpoint();
    rv32.hang();
}

pub fn test_ws2812() void {
    @setRuntimeSafety(false);

    const wsPin = 8;
    rv32.Gpio.output_enable(wsPin, true);
    rv32.Gpio.output(wsPin);
    rv32.Gpio.write(wsPin, false);

    for (0..8) |_| {
        rv32.Gpio.write(wsPin, true);
        rv32.spin(6);
        rv32.Gpio.write(wsPin, false);
        rv32.spin(2);
    }

    rv32.delay_ms(1000);

    // for (0..24) |_| {
    //     rv32.Gpio.write(wsPin, true);
    //     rv32.spin(2);
    //     rv32.Gpio.write(wsPin, false);
    //     rv32.spin(6);
    // }
}

//  // API WS2812
// static inline void ws2812_show(int pin, const uint8_t *buf, size_t len) {
// //   unsigned long delays[2] = {2, 6};
// //   for (size_t i = 0; i < len; i++) {
// //     for (uint8_t mask = 0x80; mask; mask >>= 1) {
// //       int i1 = buf[i] & mask ? 1 : 0, i2 = i1 ^ 1;  // This takes some cycles
// //       gpio_write(pin, 1);
// //       spin(delays[i1]);
// //       gpio_write(pin, 0);
// //       spin(delays[i2]);
// //     }
// //   }
// // }

//     rv32.Gpio.write(PIN, true);
//     rv32.delay_ms(300);
//     rv32.Gpio.write(PIN, false);
//     rv32.delay_ms(700);
// }

pub fn loop() !void {
    std.log.debug("LOGGING FROM STD LOG DEBUG V {}", .{0});

    test_ws2812();

    try rv32.showTextInfo();
    try rv32.showDataInfo();
    try rv32.showBssInfo();
    try rv32.showStackInfo();
    try rv32.showHeapInfo();

    _ = try term.write("\r\n");
    for ('A'..'Z') |ch| {
        rv32.Gpio.write(PIN, true);
        rv32.delay_ms(50);
        rv32.Gpio.write(PIN, false);
        rv32.delay_ms(50);

        _ = ch;
        //Reg.write(Reg.C3_UART, @intCast(ch));
        //rv32.Reg.uart[0] = @intCast(ch);
    }
    // _ = try tw.write("-------------------------\r\n");

    rv32.Gpio.write(PIN, true);
    rv32.Gpio.write(PIN, false);
    rv32.delay_ms(2000);

    // loops += 1;

    // //if (loops > 2) @panic("NOOOOONONO");
    // var slc = std.mem.zeroes([3]u8);
    // slc[loops] = 0x00;

    // //if ((loop % 5) == 0) {
    // _ = try tw.write("TEST ALLOCATOR \r\n");
    // var allocator = rv32.heapAllocator();
    // _ = try tw.write("OK \r\n");
    // var buf = try allocator.alloc(u8, 0x100);
    // defer allocator.free(buf);
    // buf[0] = 0xFF;
    // _ = try tw.print(" ALLOC NEW BUFFER ADDR {any}\r\n", .{buf.ptr});
    // //}
    // //test_data += 0x10;
}
