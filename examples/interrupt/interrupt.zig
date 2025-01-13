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
    c3.delay_ms(4000);
    //var ch: u8 = undefined;

    // try c3.logWriter.print("Starting press q to continue..... \r\n", .{});

    // while (true) {
    //     if (c3.Uart0.readNonBlocking(&ch)) {
    //         c3.Uart0.write(ch);
    //         if (ch == 'q') {
    //             break;
    //         }
    //     }
    // }
    //@breakpoint();

    c3.Gpio.output(LED_PIN);

    //const int_no = 1;
    try c3.logWriter.print("Interrupt example app v001 \r\n", .{});

    for (0..32) |i| {
        c3.setInterruptVector(i, isr_handler);
    }
    //try c3.showInterruptVectors();

    //const mtvec_addr = c3.Riscv.r_mtvec();
    //const mtvec_ptr: [*]const u8 = @ptrFromInt(mtvec_addr & 0xFFFFFF00);
    //c3.Debug.dump_mem(mtvec_ptr, 32 * 4);

    c3.Interrupt.setPrioThreshold(1); // priority threshold 1

    //var val = false;
    c3.Gpio.write(LED_PIN, false);

    c3.Interrupt.clearAllPendingInterrupts();

    // Configure and enable a timer interrupt
    c3.Timer0.setLoadValue(1000000); // Set timer load value for 1 second
    c3.Timer0.enableInterrupt();
    c3.Timer0.start();

    while (true) {
        //val = !val;
        try c3.logWriter.print("num_isrs is {d}\r\n", .{num_isrs});
        try c3.logWriter.print("INT STAT 1 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });
        c3.delay_ms(1200);
        try c3.logWriter.print("INT STAT 2 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });
        // c3.Timer0.clearInterrupt();
        // try c3.logWriter.print("INT STAT 3 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });

        //try c3.showInterruptInfo();
        //c3.Riscv.enable_interrupts();
        //try c3.logWriter.print("INT STAT 3 0x{x} STAT 0 0x{x}\r\n", .{ c3.Interrupt.getIntrStatus0(), c3.Interrupt.getIntrStatus1() });

        // const s0 = c3.Interrupt.getIntrStatus0();
        // const s1 = c3.Interrupt.getIntrStatus1();

        // c3.Debug.print_new_line();
        // c3.Debug.printhex_u32(s0);
        // c3.Debug.print_new_line();
        // c3.Debug.printhex_u32(s1);
        // c3.Debug.print_new_line();

    }
}
