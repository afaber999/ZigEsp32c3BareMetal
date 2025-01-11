const std = @import("std");
const c3 = @import("c3");

const LED_PIN = 9;

// External declaration for the interrupt handler assembly hook
extern fn isr_handler() callconv(.C) noreturn;
extern fn sub_handler() callconv(.C) void;
extern var num_isrs: i32;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    main() catch {};
    c3.hang();
}

pub fn fire() void {}

pub fn main() !void {
    c3.Gpio.output(LED_PIN);

    const int_no = 1;
    c3.delay_ms(4000);
    try c3.logWriter.print("Interrupt  example app v001 \r\n", .{});

    const mtvec_addr = c3.Riscv.r_mtvec();
    for (0..32) |i| {
        c3.setInterruptVector(i, isr_handler);
    }
    try c3.showInterruptVectors();

    const mtvec_ptr: [*]const u8 = @ptrFromInt(mtvec_addr & 0xFFFFFF00);
    c3.Debug.dump_mem(mtvec_ptr, 32 * 4);

    c3.Interrupt.setPrioThreshold(1); // priority threshold 1

    var val = false;
    c3.Gpio.write(LED_PIN, false);

    c3.Interrupt.clearAllPendingInterrupts();

    while (true) {
        val = !val;

        try c3.logWriter.print("num_isrs is {d}\r\n", .{num_isrs});
        try c3.logWriter.print("INT STAT 1 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });

        try c3.showInterruptInfo();

        c3.Interrupt.setIntType(int_no, 0); // level interrupt
        c3.Interrupt.setIntPri(int_no, 2); // priority 2
        c3.Interrupt.enableCor0(int_no); // Enable the interrupt

        //c3.Reg.interrupt[c3.Interrupt.CORE0_CPU_INTR_FROM_CPU_0_MAP / 4] = int_no; // map to interrupt 1

        c3.Riscv.enable_interrupts();
        try c3.logWriter.print("INT STAT 3 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });

        // try c3.logWriter.print("XX num_isrs is {d}\r\n", .{num_isrs});
        // try c3.logWriter.print("Interrupt set 0x{x}\r\n", .{c3.Riscv.r_mstatus()});
        // c3.System.setCpuIntr0(1);
        sub_handler();
        try c3.logWriter.print("INT STAT 9 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });

        c3.delay_ms(1000);
    }
}
