const std = @import("std");
const rv32 = @import("rv32.zig");

pub const CONF = 0x0000;
pub const UNIT0_OP = 0x0004;
pub const UNIT1_OP = 0x0008;

pub const UNIT0_LOAD_HI = 0x000C;
pub const UNIT0_LOAD_LO = 0x0010;

pub const UNIT1_LOAD_HI = 0x0014;
pub const UNIT1_LOAD_LO = 0x0018;

pub const TARGET0_HI = 0x001C;
pub const TARGET0_LO = 0x0020;

pub const TARGET1_HI = 0x0024;
pub const TARGET1_LO = 0x0028;

pub const TARGET2_HI = 0x002C;
pub const TARGET2_LO = 0x0030;

pub const TARGET0_CONF = 0x0034;
pub const TARGET1_CONF = 0x0038;
pub const TARGET2_CONF = 0x003C;

pub const UNIT0_VALUE_HI = 0x0040;
pub const UNIT0_VALUE_LO = 0x0044;
pub const UNIT1_VALUE_HI = 0x0048;
pub const UNIT1_VALUE_LO = 0x004C;

pub const COMP0_LOAD = 0x0050;
pub const COMP1_LOAD = 0x0054;
pub const COMP2_LOAD = 0x0058;

pub const UNIT0_LOAD = 0x005C;
pub const UNIT1_LOAD = 0x0060;

pub const INT_ENA = 0x0064;
pub const INT_RAW = 0x0068;
pub const INT_CLR = 0x006C;
pub const INT_ST = 0x0070;

pub const DATE = 0x00FC;

pub const _regs: [*]volatile u32 = rv32.Reg.systimer;

pub fn load(unit: u1, hi: u32, lo: u32) void {
    if (unit == 0) {
        _regs[UNIT0_LOAD_HI / 4] = hi;
        _regs[UNIT0_LOAD_LO / 4] = lo;
    } else {
        _regs[UNIT1_LOAD_HI / 4] = hi;
        _regs[UNIT1_LOAD_LO / 4] = lo;
    }
}

pub fn readUnit0() u64 {
    // system timer runs on 16 MHZ thus 16 ticks per microsecond
    _regs[UNIT0_OP / 4] = rv32.Bit(30); // TRM 10.5, update Unit0
    rv32.spin(1);

    const hi = _regs[UNIT0_VALUE_HI / 4];
    const lo = _regs[UNIT0_VALUE_LO / 4];
    return (@as(u64, hi) << 32) | @as(u64, lo);
}

pub fn readUnit1() u64 {
    _regs[UNIT1_OP / 4] = rv32.Bit(30); // TRM 10.5, update Unit1
    rv32.spin(1);
    const hi = _regs[UNIT1_VALUE_HI / 4];
    const lo = _regs[UNIT1_VALUE_LO / 4];
    return (@as(u64, hi) << 32) | @as(u64, lo);
}

// pub fn setOneTimeAlarmTarget0(unit: u1, period: u26) u64 {
//     const conf_val: u32 = switch (unit) {
//         0 => period,
//         1 => period | rv32.Bit(31),
//         else => @compileError("Unknown unit"),
//     };
//     _regs[TARGET0_CONF / 4] = conf_val;
// }

// period based on system clock, so 16 ticks per microsecond
pub fn setPeriodicTimeAlarmTarget(comptime target: u2, comptime unit: u1, period: u26) void {
    // see 10.5.3
    const conf_ptr: *volatile u32 = switch (target) {
        0 => &_regs[TARGET0_CONF / 4],
        1 => &_regs[TARGET1_CONF / 4],
        2 => &_regs[TARGET2_CONF / 4],
        else => @compileError("Unknown target"),
    };

    // PRE make sure unit is enabled
    switch (unit) {
        0 => rv32.Reg.setBit(&_regs[CONF / 4], 30),
        1 => rv32.Reg.setBit(&_regs[CONF / 4], 29),
    }

    const conf_val: u32 = switch (unit) {
        0 => period,
        1 => period | rv32.Bit(31),
    };

    // STEP 1 & 2: set period and unit selection
    _regs[TARGET0_CONF / 4] = conf_val;

    // STEP 3: COMP LOAD
    switch (target) {
        0 => rv32.Reg.setBit(&_regs[COMP0_LOAD / 4], 0),
        1 => rv32.Reg.setBit(&_regs[COMP1_LOAD / 4], 0),
        2 => rv32.Reg.setBit(&_regs[COMP2_LOAD / 4], 0),
        else => @compileError("Unknown target"),
    }

    // STEP 4: clear and set periodic mode
    rv32.Reg.setOrClearBit(conf_ptr, 30, false);
    rv32.Reg.setOrClearBit(conf_ptr, 30, true);

    // STEP 5 & 6: ENABLE TARGETx_WORk and TARGETx_INT_ENA
    switch (target) {
        0 => {
            rv32.Reg.setBit(&_regs[CONF / 4], 24);
            rv32.Reg.setBit(&_regs[INT_ENA / 4], 0);
        },
        1 => {
            rv32.Reg.setBit(&_regs[CONF / 4], 23);
            rv32.Reg.setBit(&_regs[INT_ENA / 4], 1);
        },
        2 => {
            rv32.Reg.setBit(&_regs[CONF / 4], 22);
            rv32.Reg.setBit(&_regs[INT_ENA / 4], 2);
        },
        else => @compileError("Unknown target"),
    }
}

pub fn clearTargetInterrupt(comptime target: u2) void {
    const bit = switch (target) {
        0 => 0,
        1 => 1,
        2 => 2,
        else => @compileError("Unknown target"),
    };
    rv32.Reg.setBit(&_regs[INT_CLR / 4], bit);
}

pub fn readRawInterruptStatus() u32 {
    return _regs[INT_RAW / 4];
}

pub fn readMaskedInterruptStatus() u32 {
    return _regs[INT_ST / 4];
}


