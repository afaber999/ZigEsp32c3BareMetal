const std = @import("std");
const c3 = @import("c3");

// this requires a LED is connect to GPIO pin 9
// note: this is not the default WS2812 LED that is a DEVKIT board
const OUT_PIN = 2;
const IN_PIN = 3;

// External declaration for the interrupt handler assembly hook
extern fn isr_handler() callconv(.C) noreturn;
extern var num_isrs: i32;

export fn _c3Start() noreturn {
    c3.wdt_disable();
    c3.logWriter.print("Blink example test app v001 \r\n", .{}) catch unreachable;
    main() catch {};
    c3.hang();
}

export fn _rv32_trap() callconv(.C) noreturn {
    while (true) {}
}

const DEFAULT_MTVEC = 0x00001010;
pub const CSR_MTVEC = 0x305;

pub fn enable_interrupts() void {
    @panic("TODO");
    // asm volatile ("sei");
}

pub fn disable_interrupts() void {
    @panic("TODO");
    // asm volatile ("cli");
}

pub fn wfi() void {
    asm volatile ("wfi");
}

pub fn wfe() void {
    asm volatile ("csrs 0x810, 0x1");
    wfi();
    asm volatile ("csrs 0x810, 0x1");
}

pub fn switch_m2u_mode() void {
    asm volatile ("la x6, 1f    " ::: "x6");
    asm volatile ("csrw mepc, x6");
    asm volatile ("mret");
    asm volatile ("1:");
}

// Machine-mode interrupt vector
pub inline fn r_mtvec() usize {
    return asm volatile ("csrr a0, mtvec"
        : [ret] "={a0}" (-> usize),
    );
}

pub inline fn w_mtvec(mtvec: usize) void {
    asm volatile ("csrw mtvec, a0"
        :
        : [mtvec] "{a0}" (mtvec),
    );
}

pub fn fire() void {}

pub fn main() !void {
    c3.Gpio.output(OUT_PIN);
    c3.Gpio.input(IN_PIN);

    var val = false;

    const int_no = 1;

    while (true) {
        c3.delay_ms(4000);

        try c3.logWriter.print("num_isrs is {d}\r\n", .{num_isrs});
        var s0 = c3.Interrupt.getIntrStatus0();
        var s1 = c3.Interrupt.getIntrStatus1();
        try c3.logWriter.print("INT STAT 1 0x{x} STAT 0 0x{x}\r\n", .{ s1, s0 });
        c3.System.setCpuIntr0(1);
        s0 = c3.Interrupt.getIntrStatus0();
        s1 = c3.Interrupt.getIntrStatus1();
        try c3.logWriter.print("INT STAT 1 0x{x} STAT 0 0x{x}\r\n", .{ s1, s0 });

        val = !val;
        c3.Gpio.write(OUT_PIN, val);

        const r = c3.Gpio.read(IN_PIN);
        try c3.logWriter.print("READ PORT {} {any} \r\n", .{ IN_PIN, r });
        const mtvec_addr = r_mtvec();
        try c3.logWriter.print("READ mtvec_ptr {x} \r\n", .{mtvec_addr});

        //const mtvec_ptr: [*]const u8 = @ptrFromInt(mtvec_addr & 0xFFFFFF00);
        //c3.Debug.dump_mem(mtvec_ptr, 32 * 4);

        try c3.showInterruptInfo();
        try c3.showInterruptVectors();

        c3.setInterruptVector(int_no, isr_handler);

        try c3.logWriter.print("num_isrs is {d}\r\n", .{num_isrs});

        c3.Interrupt.enableCor0(int_no); // Enable the interrupt
        c3.Interrupt.setIntType(int_no, 0); // level interrupt
        c3.Interrupt.setIntPri(int_no, 2); // priority 2
        c3.Interrupt.setPrioThreshold(1); // priority threshold 1

        c3.Reg.interrupt[c3.Interrupt.CORE0_CPU_INTR_FROM_CPU_0_MAP / 4] = int_no; // map to interrupt 1

        try c3.logWriter.print("XX num_isrs is {d}\r\n", .{num_isrs});
        // s0 = c3.Interrupt.getIntrStatus0();
        // s1 = c3.Interrupt.getIntrStatus1();
        // try c3.logWriter.print("2 INT STAT 1 0x{x} STAT 0 0x{x}\r\n", .{ s1, s0 });

        //c3.Riscv.enable_interrupts();
        try c3.logWriter.print("Interrupt set 0x{x}\r\n", .{c3.Riscv.r_mstatus()});

        //c3.delay_ms(5);

        // s0 = c3.Interrupt.getIntrStatus0();
        // s1 = c3.Interrupt.getIntrStatus1();
        // try c3.logWriter.print("3 INT STAT 1 0x{x} STAT 0 0x{x}\r\n", .{ s1, s0 });
    }
}
