const std = @import("std");
const mmio = @import("mmio.zig");

const chip = @import("chip.zig");
const peripherals = chip.devices.@"ESP32-C3".peripherals;

pub const ptr = peripherals.SYSTEM;

pub fn setCpuIntr(comptime intr: u2, value: u1) void {
    switch (intr) {
        0 => ptr.CPU_INTR_FROM_CPU_0.modify(.{ .CPU_INTR_FROM_CPU_0 = value }),
        1 => ptr.CPU_INTR_FROM_CPU_1.modify(.{ .CPU_INTR_FROM_CPU_1 = value }),
        2 => ptr.CPU_INTR_FROM_CPU_2.modify(.{ .CPU_INTR_FROM_CPU_2 = value }),
        3 => ptr.CPU_INTR_FROM_CPU_3.modify(.{ .CPU_INTR_FROM_CPU_3 = value }),
    }
}
