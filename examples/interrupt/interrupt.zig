const std = @import("std");
const c3 = @import("c3");

const LED_PIN = 9;

// get the counters from the interrupt.S functions
extern var num_ints: [32]u32;

//var zig_isrs: usize = 0;

export fn cpu0_isr_handler() callconv(.C) void {
    //std.log.debug("CPU 0 ISR", .{});
    c3.System.setCpuIntr0(0);
    c3.System.setCpuIntr1(0);
    num_ints[3] += 1;
    //    setup_timer_interrupt(1400 * 10 * 1000);
}

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

    _ = c3.Interrupt.make_isr_handler(3, cpu0_isr_handler);

    // setup interrupt 1
    const int_1 = 1;
    c3.Interrupt.enableCor0(int_1); // Enable the interrupt 1
    c3.Interrupt.setIntType(int_1, 0); // level interrupt for int 1
    c3.Interrupt.setIntPri(int_1, 2); // priority 2 for int 1
    c3.Interrupt.map_core0_cpu_intr_0(int_1); // map cpu intr 0 to interrupt 1

    // setup interrupt 2
    const int_2 = 2;
    c3.Interrupt.enableCor0(int_2); // Enable the interrupt 2
    c3.Interrupt.setIntType(int_2, 0); // level interrupt for int 2
    c3.Interrupt.setIntPri(int_2, 2); // priority 2 for int 2
    c3.Interrupt.map_core0_systimer_target0(int_2); // map systimer target 0 to interrupt 2

    // setup interrupt 1
    const int_3 = 3;
    c3.Interrupt.enableCor0(int_3); // Enable the interrupt 3
    c3.Interrupt.setIntType(int_3, 0); // level interrupt for int 3
    c3.Interrupt.setIntPri(int_3, 2); // priority 2 for int 3
    c3.Interrupt.map_core0_cpu_intr_1(int_3); // map cpu intr 1 to interrupt 3

    c3.Interrupt.setPrioThreshold(1); // priority threshold 1
    c3.Riscv.enable_interrupts();

    // setup system timer
    c3.SysTimer.setPeriodicTimeAlarmTarget(0, 0, 16_000_000 * 3); // 16 ticks per us, so 3 seconds

    var lp: u32 = 0;

    while (true) {
        lp += 1;
        try c3.logWriter.print("num_isrs[1]: {d} num_isrs[2]: {d} num_isrs[3]: {d} loops: {d}\r\n", .{ num_ints[int_1], num_ints[int_2], num_ints[int_3], lp });
        //try c3.logWriter.print("INTSTATUS 1:{x} 0:{x}\r\n", .{ c3.Interrupt.getIntrStatus1(), c3.Interrupt.getIntrStatus0() });

        // start genering software interrupts after 4 loops
        if (lp >= 4) {
            c3.System.setCpuIntr1(1);
        }
        c3.delay_ms(700);
        c3.System.setCpuIntr0(1);

        c3.Gpio.write(LED_PIN, false);
        c3.delay_ms(300);
    }
}
