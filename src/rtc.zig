const std = @import("std");
const chip = @import("chip.zig");
const peripherals = chip.devices.@"ESP32-C3".peripherals;

pub const ptr = peripherals.RTC_CNTL;
