const std = @import("std");
const c3 = @import("c3.zig");

const CPU_INTR_FROM_CPU_0 = 0x028;
const CPU_INTR_FROM_CPU_1 = 0x02C;
const CPU_INTR_FROM_CPU_2 = 0x030;
const CPU_INTR_FROM_CPU_3 = 0x034;

const _regs: [*]volatile u32 = c3.Reg.system;

pub fn isCpuIntr0() u1 {
    return @truncate(_regs[CPU_INTR_FROM_CPU_0 / 4]);
}

pub fn setCpuIntr0(value: u1) void {
    _regs[CPU_INTR_FROM_CPU_0 / 4] = value;
}
