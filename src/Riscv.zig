const std = @import("std");

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

// Read interrupt enable register
pub inline fn r_mie() usize {
    return asm volatile ("csrr a0, mie"
        : [ret] "={a0}" (-> usize),
    );
}

// Write interrupt enable register
pub inline fn w_mie(mie: usize) void {
    asm volatile ("csrw mie, a0"
        :
        : [mie] "{a0}" (mie),
    );
}

// Read mstatus register
pub inline fn r_mstatus() usize {
    return asm volatile ("csrr a0, mstatus"
        : [ret] "={a0}" (-> usize),
    );
}

// Write mstatus register
pub inline fn w_mstatus(mstatus: usize) void {
    asm volatile ("csrw mstatus, a0"
        :
        : [mstatus] "{a0}" (mstatus),
    );
}

// Enable interrupts by setting the MIE bit in mstatus
pub inline fn enable_interrupts() void {
    var mstatus = r_mstatus();
    mstatus |= 1 << 3; // Set the MIE bit (bit 3)
    w_mstatus(mstatus);
}

// Disable interrupts by clearing the MIE bit in mstatus
pub inline fn disable_interrupts() void {
    var mstatus = r_mstatus();
    mstatus &= ~(1 << 3); // Clear the MIE bit (bit 3)
    w_mstatus(mstatus);
}

const registers = [_][]const u8{
    "ra", "t0", "t1", "t2", "t3", "t4", "t5", "t6",
    "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7",
};

pub inline fn push_interrupt_state() void {
    asm volatile (std.fmt.comptimePrint("addi sp, sp, -{}", .{registers.len * @sizeOf(u32)}));

    inline for (registers, 0..) |reg, i| {
        asm volatile (std.fmt.comptimePrint("sw {s}, 4*{}(sp)", .{ reg, i }));
    }
}

pub inline fn pop_interrupt_state() void {
    inline for (registers, 0..) |reg, i| {
        asm volatile (std.fmt.comptimePrint("lw {s}, 4*{}(sp)", .{ reg, i }));
    }

    asm volatile (std.fmt.comptimePrint("addi sp, sp, {}", .{registers.len * @sizeOf(u32)}));
}

pub inline fn interrupt_return() void {
    asm volatile ("mret" ::: "memory");
}
