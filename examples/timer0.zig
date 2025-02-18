const std = @import("std");
const rv32 = @import("rv32");

pub const std_options = std.Options{
    .log_level = std.log.Level.debug,
    .logFn = rv32.logFn,
};

pub fn panic(message: []const u8, _: ?*std.builtin.StackTrace, addr: ?usize) noreturn {
    std.log.err("PANIC: {s} at {any} \r\n", .{ message, addr });
    @breakpoint();
    rv32.hang();
}

export fn _rv32Start() noreturn {
    rv32.wdt_disable();
    setup() catch {};
    while (true) {
        loop() catch {};
    }
}

var loops: u32 = 0;

var tmr0_ints: u32 = 0;
const int_2 = 2;

// ISR handler for interrupt 2 (timer0 interrupt)
// have to clear the timer interrupt
export fn timer_isr_handler() callconv(.C) void {

    // clear the interrupt
    rv32.timer0.INT_CLR_TIMERS.modify(.{ .T0_INT_CLR = 1 });

    // re-enable the alarm
    rv32.timer0.T0CONFIG.modify(.{ .T0_ALARM_EN = 1 });

    tmr0_ints += 1;
}

pub fn setup() !void {
    rv32.set_clock_pll(true);
    // see section 11.2
    // ABP_CLK is 80 Mhz, DIV = (1+1) = 2, so 40 Mhz, COUNT UP,

    // setup time (11.3.1)
    rv32.timer0.T0CONFIG.modify(.{ .T0_EN = 0 });
    rv32.timer0.T0CONFIG.modify(.{ .T0_ALARM_EN = 0, .T0_USE_XTAL = 0, .T0_INCREASE = 1, .T0_DIVIDER = 1 });
    rv32.timer0.T0CONFIG.modify(.{ .T0_DIVCNT_RST = 1 });
    rv32.timer0.T0CONFIG.modify(.{ .T0_EN = 1 });

    // setup alarm (11.3.2)
    //   800_059_146
    rv32.timer0.T0ALARMLO.modify(.{ .T0_ALARM_LO = 40_000_000 * 6 });
    rv32.timer0.T0ALARMHI.modify(.{ .T0_ALARM_HI = 0 });
    rv32.timer0.T0CONFIG.modify(.{ .T0_AUTORELOAD = 1 });
    rv32.timer0.T0CONFIG.modify(.{ .T0_ALARM_EN = 1 });

    rv32.system.ptr.PERIP_CLK_EN0.modify(.{ .TIMERGROUP_CLK_EN = 1 });

    // setup interrupt 2 (timer interrupt)
    rv32.Interrupt.enableCor0(int_2); // Enable the interrupt 2
    rv32.Interrupt.setIntType(int_2, 0); // level interrupt for int 2
    rv32.Interrupt.setIntPri(int_2, 2); // priority 2 for int 2
    //rv32.Interrupt.map_core0_systimer_target0(int_2); // map systimer target 0 to interrupt 2
    rv32.Interrupt.core0.TG_T0_INT_MAP.modify(.{ .TG_T0_INT_MAP = int_2 });
    rv32.Interrupt.setPrioThreshold(1); // priority threshold 1

    // set timer interrupt handler and enable the interrupt
    _ = rv32.Interrupt.make_isr_handler(int_2, timer_isr_handler);
    rv32.timer0.INT_ENA_TIMERS.modify(.{ .T0_INT_ENA = 1 });
    rv32.Riscv.enable_interrupts();
}

pub fn loop() !void {
    //try rv32.logWriter.print("CPU_CLK {any}\r\n", .{get_cpu_freq()});
    //try rv32.logWriter.print("APB_CLK {any}\r\n", .{get_apb_freq()});

    //try rv32.logWriter.print("CPU_CLK {any}\r\n", .{rv32.system.ptr.CPU_PER_CONF.read()});

    try rv32.logWriter.print("TIMER0 {any}\r\n", .{rv32.Timer0.count()});
    //try rv32.logWriter.print("TIMER {any}\r\n", .{rv32.Timer0._ptr});
    // if ((loops % 2) == 0) {
    //     rv32.Timer0.enable();
    // } else {
    //     rv32.Timer0.disable();
    // }
    try rv32.logWriter.print("tmr0_ints {}\r\n", .{tmr0_ints});
    try rv32.logWriter.print("INT_RAW {any}\r\n", .{rv32.timer0.INT_RAW_TIMERS.read()});
    // try rv32.logWriter.print("INTR STAT 0 0x{any}\r\n", .{rv32.Interrupt.core0.INTR_STATUS_REG_0.read()});
    // try rv32.logWriter.print("INTR STAT 1 0x{any}\r\n", .{rv32.Interrupt.core0.INTR_STATUS_REG_1.read()});
    //try rv32.logWriter.print("INT_ST {any}\r\n", .{rv32.timer0.INT_ST_TIMERS.read()});

    // if (rv32.timer0.INT_RAW_TIMERS.read().T0_INT_RAW != 0) {
    //     timer_isr_handler();
    // }

    rv32.delay_ms(1000);
    loops += 1;
}
