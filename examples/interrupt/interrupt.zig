const std = @import("std");
const c3 = @import("c3");

const LED_PIN = 9;

extern var _num_01_ints : u32;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.Gpio.output(LED_PIN);
    //led_on();
    c3.delay_ms(4000);
    //led_off();
    main() catch {};
    c3.hang();
}


pub fn main() !void {
    try c3.logWriter.print("Interrupt example app v003 \r\n", .{});
    try c3.logWriter.print("After 4 loops generate software interrupt Interrupt (CPU0) \r\n", .{});
    c3.Interrupt.setPrioThreshold(1); // priority threshold 1

    const int_no = 1;
    c3.Interrupt.enableCor0(int_no); // Enable the interrupt
    c3.Interrupt.setIntType(int_no, 0); // level interrupt
    c3.Interrupt.setIntPri(int_no, 2); // priority 2
    c3.Interrupt.setPrioThreshold(1); // priority threshold 1
    c3.Riscv.enable_interrupts();

    c3.Reg.interrupt[c3.Interrupt.CORE0_CPU_INTR_FROM_CPU_0_MAP / 4] = int_no; // map to interrupt 1

    var lp: u32 = 0;

    while (true) {
        lp += 1;
        try c3.logWriter.print("num_isrs is {d} loops {d}\r\n", .{ _num_01_ints, lp });
        if (lp >= 4) {
            c3.System.setCpuIntr0(1);
        }
        c3.delay_ms(700);
        c3.Gpio.write(LED_PIN, false);
        c3.delay_ms(300);
    }
}
