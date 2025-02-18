const std = @import("std");
const chip = @import("chip.zig");
const peripherals = chip.devices.@"ESP32-C3".peripherals;


pub const Timer0 = Timer(0);
pub const Timer1 = Timer(1);

// pub const timer0 = Timer0 {};
// pub const timer1 = Timer1 {};

pub fn Timer(comptime n: u1) type {
    return struct {
        const Self = @This();

        pub const _ptr = switch (n) {
            0 => peripherals.TIMG0,
            1 => peripherals.TIMG1,
        };

        pub fn disableWatchdog() void {
            const DOGFOOD = 0x50d83aa1;
            // feed and disable watchdogs 0 and disable them
            _ptr.WDTWPROTECT.raw = DOGFOOD;
            _ptr.WDTCONFIG0.raw = 0;
            _ptr.WDTWPROTECT.raw = 0;
        }

        pub fn setup_repeat(comptime div: u16) void {
            // see section 11.2
            disable();
            _ptr.T0CONFIG.modify(.{ .T0_ALARM_EN = 0, .T0_USE_XTAL = 0, .T0_INCREASE = 1, .T0_DIVIDER = div });
            _ptr.T0CONFIG.modify(.{ .T0_DIVCNT_RST = 1 });
            enable();
        }

        pub fn enable() void {
            _ptr.T0CONFIG.modify(.{ .T0_EN = 1 });
        }

        pub fn disable() void {
            _ptr.T0CONFIG.modify(.{ .T0_EN = 0 });
        }

        pub fn count() u64 {
            // update regs, see 11.2.2
            _ptr.T0UPDATE.modify(.{ .T0_UPDATE = 1 });

            // wait for update to complete
            while (_ptr.T0UPDATE.read().T0_UPDATE != 0) {}
            const hi = _ptr.T0HI.raw;
            const lo = _ptr.T0LO.raw;
            return (@as(u64, hi) << 32) | @as(u64, lo);
        }

        // const _regs: [*]volatile u32 = Reg.timerGroup0;

        // pub fn setLoadValue(value: u32) void {
        //     _regs[0x00 / 4] = value;
        // }

        // pub fn enableInterrupt() void {
        //     // Enable the interrupt for Timer0        const int_enable_reg = @intToPtr(*volatile u32, 0x6001F004);
        //     _regs[0x04 / 4] |= 0x1;
        // }

        // pub fn start() void {
        //     // Start Timer0
        //     _regs[0x08 / 4] |= 0x1;
        // }

        // pub fn clearInterrupt() void {
        //     // Clear the interrupt for Timer0
        //     _regs[0x0C / 4] |= 0x1;
        // }
    };
}
