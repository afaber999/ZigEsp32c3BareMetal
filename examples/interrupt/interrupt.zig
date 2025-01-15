const std = @import("std");
const c3 = @import("c3");

const LED_PIN = 9;

// External declaration for the interrupt handler assembly hook
extern fn isr_handler() callconv(.C) noreturn;
extern fn sub_handler() callconv(.C) void;
extern fn led_on() callconv(.C) void;
extern fn led_off() callconv(.C) void;

extern var num_isrs: i32;

extern fn set_vector_table() callconv(.C) void;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.Gpio.output(LED_PIN);
    led_on();
    c3.delay_ms(4000);
    //led_off();
    main() catch {};
    c3.hang();
}

pub fn print_intstatus() !void {
    //try c3.logWriter.print("TIME: [{:0>12}]\r\n", .{c3.uptime_us()});

    try c3.logWriter.print("?INTSTATUS 1: 0x{x} 0: 0x{x} EIP status 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1(), c3.Interrupt.eipStatuCor0() });

    //try c3.logWriter.print("CONF 0x{x}\r\n", .{c3.SysTimer._regs[c3.SysTimer.CONF / 4]});
    //try c3.logWriter.print("TARGET0_CONF 0x{x}\r\n", .{c3.SysTimer._regs[c3.SysTimer.TARGET0_CONF / 4]});
    //try c3.logWriter.print("INT_ENA 0x{x}\r\n", .{c3.SysTimer._regs[c3.SysTimer.INT_ENA / 4]});
    //try c3.logWriter.print("INT_RAW 0x{x}\r\n", .{c3.SysTimer.readRawInterruptStatus()});
    //try c3.logWriter.print("INT_ST 0x{x}\r\n", .{c3.SysTimer.readMaskedInterruptStatus()});
}

pub fn main() !void {
    try c3.logWriter.print("Interrupt example app v002 \r\n", .{});
    try c3.logWriter.print("_vector_table {any}\r\n", .{&c3.sections._vector_table});
    c3.Interrupt.setPrioThreshold(1); // priority threshold 1
    led_off();

    //var val = false;
    //c3.Gpio.write(LED_PIN, false);

    // dump tabel
    c3.Debug.dump_mem(@as([*]const u8, @ptrFromInt(0x3fc80180)), 0x80);

    c3.Interrupt.clearAllPendingInterrupts();
    c3.Riscv.w_mtvec(@intFromPtr(&c3.sections._vector_table));

    try c3.showInterruptVectors();
    try c3.showDataInfo();

    try print_intstatus();
    c3.delay_ms(100);
    c3.SysTimer.setPeriodicTimeAlarmTarget(0, 0, 16_000_000 * 3); // 16 ticks per us, so 3 seconds

    c3.Debug.dump_mem(@as([*]const u8, @ptrFromInt(0x3fc801e0)), 0x40);

    const int_no = 1;
    c3.Interrupt.enableCor0(int_no); // Enable the interrupt
    c3.Interrupt.setIntType(int_no, 0); // level interrupt
    c3.Interrupt.setIntPri(int_no, 2); // priority 2
    c3.Interrupt.setPrioThreshold(1); // priority threshold 1
    c3.Riscv.enable_interrupts();
    //c3.Reg.interrupt[c3.Interrupt.CORE0_SYSTIMER_TARGET0_INT_MAP / 4] = int_no; // map to interrupt 1

    c3.Reg.interrupt[c3.Interrupt.CORE0_CPU_INTR_FROM_CPU_0_MAP / 4] = int_no; // map to interrupt 1

    var lp: u32 = 0;

    while (true) {
        lp += 1;
        try c3.logWriter.print("num_isrs is {d} loops {d}\r\n", .{ num_isrs, lp });

        try print_intstatus();

        //led_on();
        // try c3.logWriter.print("num_isrs is {d}\r\n", .{num_isrs});
        // try c3.logWriter.print("INT STAT 1 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });
        // //try c3.logWriter.print("INT STAT 2 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });

        if (lp == 4) {
            c3.System.setCpuIntr0(1);
        }
        // //try c3.logWriter.print("Interrupt set 0x{x}\r\n", .{c3.Riscv.r_mstatus()});
        // //try c3.showInterruptInfo();
        c3.delay_ms(700);
        //led_off();
        //c3.Gpio.write(LED_PIN, false);
        c3.delay_ms(300);
        //c3.Gpio.write(LED_PIN, false);
    }
}
