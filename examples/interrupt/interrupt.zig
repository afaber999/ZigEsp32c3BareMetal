const std = @import("std");
const c3 = @import("c3");

const LED_PIN = 9;

// External declaration for the interrupt handler assembly hook
extern fn isr_handler() callconv(.C) noreturn;
extern fn sub_handler() callconv(.C) void;
extern var num_isrs: i32;

extern fn set_vector_table() callconv(.C) void;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.delay_ms(4000);
    main() catch {};
    c3.hang();
}

pub fn fire() void {}

pub fn main() !void {
    c3.Gpio.output(LED_PIN);
    //const int_no = 1;
    try c3.logWriter.print("Interrupt example app v002 \r\n", .{});
    try c3.logWriter.print("_vector_table {any}\r\n", .{&c3.sections._vector_table});
    c3.Interrupt.setPrioThreshold(1); // priority threshold 1

    //var val = false;
    c3.Gpio.write(LED_PIN, false);

    c3.Interrupt.clearAllPendingInterrupts();
    c3.Riscv.w_mtvec(@intFromPtr(&c3.sections._vector_table));

    try c3.showInterruptVectors();
    try c3.showDataInfo();

    const int_no = 1;
    c3.Interrupt.enableCor0(int_no); // Enable the interrupt
    c3.Interrupt.setIntType(int_no, 0); // level interrupt
    c3.Interrupt.setIntPri(int_no, 15); // priority 2
    c3.Interrupt.setPrioThreshold(1); // priority threshold 1
    // c3.Riscv.enable_interrupts();
    c3.Reg.interrupt[c3.Interrupt.CORE0_CPU_INTR_FROM_CPU_0_MAP / 4] = int_no; // map to interrupt 1

    while (true) {
        try c3.logWriter.print("num_isrs is {d}\r\n", .{num_isrs});
        try c3.logWriter.print("INT STAT 1 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });
        //try c3.logWriter.print("INT STAT 2 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });

        c3.System.setCpuIntr0(1);
        //try c3.logWriter.print("Interrupt set 0x{x}\r\n", .{c3.Riscv.r_mstatus()});
        //try c3.showInterruptInfo();
        c3.delay_ms(1000);
    }
}
