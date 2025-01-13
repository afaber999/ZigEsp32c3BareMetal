const std = @import("std");
const c3 = @import("c3");

// a LED is attached to pin 9
const LED_PIN = 9;

const PIN = 9;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    main() catch {};
    c3.hang();
}

pub fn print_intstatus() !void {
    try c3.logWriter.print("TIME: [{:0>12}]\r\n", .{c3.uptime_us()});

    try c3.logWriter.print("INTSTATUS 1: 0x{x} 0: 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });
    try c3.logWriter.print("CONF 0x{x}\r\n", .{c3.SysTimer._regs[c3.SysTimer.CONF / 4]});
    try c3.logWriter.print("TARGET0_CONF 0x{x}\r\n", .{c3.SysTimer._regs[c3.SysTimer.TARGET0_CONF / 4]});
    //try c3.logWriter.print("INT_ENA 0x{x}\r\n", .{c3.SysTimer._regs[c3.SysTimer.INT_ENA / 4]});
    //try c3.logWriter.print("INT_RAW 0x{x}\r\n", .{c3.SysTimer.readRawInterruptStatus()});
    try c3.logWriter.print("INT_ST 0x{x}\r\n", .{c3.SysTimer.readMaskedInterruptStatus()});
}

pub fn main() !void {
    c3.delay_ms(3000);
    try c3.logWriter.print("System timer example app v001 \r\n", .{});

    c3.Gpio.output(LED_PIN);

    c3.SysTimer.setPeriodicTimeAlarmTarget(0, 0, 16_000_000 * 3); // 16 ticks per us, so 3 seconds

    var val = false;
    while (true) {
        val = !val;
        c3.Gpio.write(LED_PIN, val);

        if ((c3.Interrupt.getIntrStatus1() & 0x20) == 0x20) {
            c3.SysTimer.clearTargetInterrupt(0);
            c3.Interrupt.clearAllPendingInterrupts();
            try c3.logWriter.print("=============================== Timer interrupt\r\n", .{});
            try print_intstatus();
        }
        c3.delay_ms(100);
    }
}
