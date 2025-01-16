const std = @import("std");
const c3 = @import("c3");

const LED_PIN = 9;

# get the counters from the interrupt.S functions
extern var num_ints: [32]u32;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.Gpio.output(LED_PIN);
    c3.delay_ms(4000);
    main() catch {};
    c3.hang();
}

pub fn main() !void {
    try c3.logWriter.print("Interrupt example app v003 \r\n", .{});
    try c3.logWriter.print("After 4 loops generate software CPU0 interrupt Interrupt (01) \r\n", .{});
    try c3.logWriter.print("SysTimer 1 fires every 3 seconds an interrupt (02) \r\n", .{});
    c3.Interrupt.setPrioThreshold(1); // priority threshold 1

    // setup interrupt 1
    c3.Interrupt.enableCor0(1); // Enable the interrupt
    c3.Interrupt.setIntType(1, 0); // level interrupt
    c3.Interrupt.setIntPri(1, 2); // priority 2
    c3.Reg.interrupt[c3.Interrupt.CORE0_CPU_INTR_FROM_CPU_0_MAP / 4] = 1; // map to interrupt 1

    // setup interrupt 2
    c3.SysTimer.setPeriodicTimeAlarmTarget(0, 0, 16_000_000 * 3); // 16 ticks per us, so 3 seconds
    c3.Interrupt.enableCor0(2); // Enable the interrupt
    c3.Interrupt.setIntType(2, 0); // level interrupt
    c3.Interrupt.setIntPri(2, 2); // priority 2
    c3.Reg.interrupt[c3.Interrupt.CORE0_SYSTIMER_TARGET0_INT_MAP / 4] = 2; // map to interrupt 2

    c3.Interrupt.setPrioThreshold(1); // priority threshold 1
    c3.Riscv.enable_interrupts();

    var lp: u32 = 0;

    while (true) {
        lp += 1;
        try c3.logWriter.print("num_isrs[1]: {d} num_isrs[2]: {d} loops: {d}\r\n", .{ num_ints[1],num_ints[2], lp });
        //try c3.logWriter.print("INTSTATUS 1:{x} 0:{x}\r\n", .{ c3.Interrupt.getIntrStatus1(), c3.Interrupt.getIntrStatus0() });

        // start genering software interrupts after 4 loops
        if (lp >= 4) {
            c3.System.setCpuIntr0(1);
        }
        c3.delay_ms(700);
        c3.Gpio.write(LED_PIN, false);
        c3.delay_ms(300);
    }
}
