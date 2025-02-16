const std = @import("std");
const rv32 = @import("rv32");

// a LED is attached to pin 9
const LED_PIN = 9;

const PIN = 9;

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    main() catch {};
    rv32.hang();
}

pub fn print_intstatus() !void {
    try rv32.logWriter.print("TIME: [{:0>12}]\r\n", .{rv32.uptime_us()});

    try rv32.logWriter.print("INTSTATUS 1: 0x{x} 0: 0x{x}\r\n", .{ rv32.Interrupt.getIntrStatus0(), rv32.Interrupt.getIntrStatus1() });
    try rv32.logWriter.print("CONF 0x{x}\r\n", .{rv32.SysTimer._regs[rv32.SysTimer.CONF / 4]});
    try rv32.logWriter.print("TARGET0_CONF 0x{x}\r\n", .{rv32.SysTimer._regs[rv32.SysTimer.TARGET0_CONF / 4]});
    //try rv32.logWriter.print("INT_ENA 0x{x}\r\n", .{rv32.SysTimer._regs[rv32.SysTimer.INT_ENA / 4]});
    //try rv32.logWriter.print("INT_RAW 0x{x}\r\n", .{rv32.SysTimer.readRawInterruptStatus()});
    try rv32.logWriter.print("INT_ST 0x{x}\r\n", .{rv32.SysTimer.readMaskedInterruptStatus()});
}

pub fn main() !void {
    rv32.delay_ms(3000);
    try rv32.logWriter.print("System timer example app v001 \r\n", .{});

    rv32.Gpio.output(LED_PIN);

    rv32.SysTimer.setPeriodicTimeAlarmTarget(0, 0, 16_000_000 * 3); // 16 ticks per us, so 3 seconds

    var val = false;
    while (true) {
        val = !val;
        rv32.Gpio.write(LED_PIN, val);

        if ((rv32.Interrupt.getIntrStatus1() & 0x20) == 0x20) {
            rv32.SysTimer.clearTargetInterrupt(0);
            rv32.Interrupt.clearAllPendingInterrupts();
            try rv32.logWriter.print("=============================== Timer interrupt\r\n", .{});
            try print_intstatus();
        }
        rv32.delay_ms(100);
    }
}
