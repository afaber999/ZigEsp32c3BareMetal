const std = @import("std");
const c3 = @import("c3");

const LED_PIN = 9;

// interrupt counters, are incremented in the ISR handlers
var num_ints = std.mem.zeroes([32]u32);

// ISR handler for interrupt 1 (SW interrupt)
// this is a level interrupt, so we have to clear the interrupt
// in the ISR handler
// this is a callconv(.C) function, c3 will take care of the prologue and epilogue and interrupt return
// all registers are saved and restored
export fn cpu0_isr_handler() callconv(.C) void {

    // blink for now
    if ((num_ints[1] % 2) == 0) {
        c3.Gpio.write(LED_PIN, true);
    } else {
        c3.Gpio.write(LED_PIN, false);
    }
    // have to clear the software interrupt
    c3.system.setCpuIntr(0,0);
    num_ints[1] += 1;
}

// ISR handler for interrupt 2 (SysTimer interrupt)
// have to clear the timer interrupt
export fn timer_isr_handler() callconv(.C) void {
    c3.SysTimer.clearTargetInterrupt(0);
    num_ints[2] += 1;
}

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.Gpio.output(LED_PIN);
    c3.delay_ms(4000);
    main() catch {};
    c3.hang();
}

pub fn main() !void {
    try c3.logWriter.print("Interrupt example app v004 \r\n", .{});
    try c3.logWriter.print("After 4 loops generate software CPU0 interrupt Interrupt (01) \r\n", .{});
    try c3.logWriter.print("SysTimer 1 fires every 3 seconds an interrupt (02) \r\n", .{});
    try c3.logWriter.print("The interrupt service routines (ISR) can be written in assembler or Zig \r\n", .{});
    c3.Interrupt.setPrioThreshold(1); // priority threshold 1

    const int_1 = 1;
    const int_2 = 2;

    // setup the ISR handlers
    _ = c3.Interrupt.make_isr_handler(int_1, cpu0_isr_handler);
    _ = c3.Interrupt.make_isr_handler(int_2, timer_isr_handler);

    // setup interrupt 1 (sw interrupt)
    c3.Interrupt.enableCor0(int_1); // Enable the interrupt 1
    c3.Interrupt.setIntType(int_1, 0); // level interrupt for int 1
    c3.Interrupt.setIntPri(int_1, 2); // priority 2 for int 1
    c3.Interrupt.map_core0_cpu_intr_0(int_1); // map cpu intr 0 to interrupt 1

    // setup interrupt 2 (timer interrupt)
    c3.Interrupt.enableCor0(int_2); // Enable the interrupt 2
    c3.Interrupt.setIntType(int_2, 0); // level interrupt for int 2
    c3.Interrupt.setIntPri(int_2, 2); // priority 2 for int 2
    c3.Interrupt.map_core0_systimer_target0(int_2); // map systimer target 0 to interrupt 2

    c3.Interrupt.setPrioThreshold(1); // priority threshold 1
    c3.Riscv.enable_interrupts();

    // setup system timer
    c3.SysTimer.setPeriodicTimeAlarmTarget(0, 0, 16_000_000 * 3); // 16 ticks per us, so 3 seconds

    var lp: u32 = 0;

    while (true) {
        lp += 1;
        try c3.logWriter.print("num_isrs[1]: {d} num_isrs[2]: {d} loops: {d}\r\n", .{ num_ints[int_1], num_ints[int_2], lp });

        // start genering software interrupts after 4 loops
        if (lp >= 4) {
            //c3.System.setCpuIntr1(1);
            c3.system.setCpuIntr(0, 1);
            //c3.System.system.CPU_INTR_FROM_CPU_0;
        }
        c3.delay_ms(700);

        c3.Gpio.write(LED_PIN, false);
        c3.delay_ms(300);
    }
}
