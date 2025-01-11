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
