const std = @import("std");
const rv32 = @import("rv32");

const LED_PIN = 9;

// interrupt counters, are incremented in the ISR handlers
var num_ints = std.mem.zeroes([32]u32);

// ISR handler for interrupt 1 (SW interrupt)
// this is a level interrupt, so we have to clear the interrupt
// in the ISR handler
// this is a callconv(.C) function, rv32 will take care of the prologue and epilogue and interrupt return
// all registers are saved and restored
export fn cpu0_isr_handler() callconv(.C) void {

    // blink for now
    if ((num_ints[1] % 2) == 0) {
        rv32.Gpio.write(LED_PIN, true);
    } else {
        rv32.Gpio.write(LED_PIN, false);
    }
    // have to clear the software interrupt
    rv32.system.setCpuIntr(0,0);
    num_ints[1] += 1;
}

// ISR handler for interrupt 2 (SysTimer interrupt)
// have to clear the timer interrupt
export fn timer_isr_handler() callconv(.C) void {
    rv32.SysTimer.clearTargetInterrupt(0);
    num_ints[2] += 1;
}

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    rv32.Gpio.output(LED_PIN);
    rv32.delay_ms(4000);
    main() catch {};
    rv32.hang();
}

pub fn main() !void {
    try rv32.logWriter.print("Interrupt example app v004 \r\n", .{});
    try rv32.logWriter.print("After 4 loops generate software CPU0 interrupt Interrupt (01) \r\n", .{});
    try rv32.logWriter.print("SysTimer 1 fires every 3 seconds an interrupt (02) \r\n", .{});
    try rv32.logWriter.print("The interrupt service routines (ISR) can be written in assembler or Zig \r\n", .{});
    rv32.Interrupt.setPrioThreshold(1); // priority threshold 1

    const int_1 = 1;
    const int_2 = 2;

    // setup the ISR handlers
    _ = rv32.Interrupt.make_isr_handler(int_1, cpu0_isr_handler);
    _ = rv32.Interrupt.make_isr_handler(int_2, timer_isr_handler);

    // setup interrupt 1 (sw interrupt)
    rv32.Interrupt.enableCor0(int_1); // Enable the interrupt 1
    rv32.Interrupt.setIntType(int_1, 0); // level interrupt for int 1
    rv32.Interrupt.setIntPri(int_1, 2); // priority 2 for int 1
    rv32.Interrupt.map_core0_cpu_intr_0(int_1); // map cpu intr 0 to interrupt 1

    // setup interrupt 2 (timer interrupt)
    rv32.Interrupt.enableCor0(int_2); // Enable the interrupt 2
    rv32.Interrupt.setIntType(int_2, 0); // level interrupt for int 2
    rv32.Interrupt.setIntPri(int_2, 2); // priority 2 for int 2
    rv32.Interrupt.map_core0_systimer_target0(int_2); // map systimer target 0 to interrupt 2

    rv32.Interrupt.setPrioThreshold(1); // priority threshold 1
    rv32.Riscv.enable_interrupts();

    // setup system timer
    rv32.SysTimer.setPeriodicTimeAlarmTarget(0, 0, 16_000_000 * 3); // 16 ticks per us, so 3 seconds

    var lp: u32 = 0;

    while (true) {
        lp += 1;
        try rv32.logWriter.print("num_isrs[1]: {d} num_isrs[2]: {d} loops: {d}\r\n", .{ num_ints[int_1], num_ints[int_2], lp });

        // start genering software interrupts after 4 loops
        if (lp >= 4) {
            //rv32.System.setCpuIntr1(1);
            rv32.system.setCpuIntr(0, 1);
            //rv32.System.system.CPU_INTR_FROM_CPU_0;
        }
        rv32.delay_ms(700);

        rv32.Gpio.write(LED_PIN, false);
        rv32.delay_ms(300);
    }
}
