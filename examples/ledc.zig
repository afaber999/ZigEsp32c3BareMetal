const std = @import("std");
const rv32 = @import("rv32");

// const Ledc = struct {
//     pub const CH0_CONF0_REG = 0x0000;
//     pub const CH0_CONF1_REG = 0x000C;
//     pub const CH1_CONF0_REG = 0x0014;
//     pub const CH1_CONF1_REG = 0x0020;
//     pub const CH2_CONF0_REG = 0x0028;
//     pub const CH2_CONF1_REG = 0x0034;
//     pub const CH3_CONF0_REG = 0x003C;
//     pub const CH3_CONF1_REG = 0x0048;
//     pub const CH4_CONF0_REG = 0x0050;
//     pub const CH4_CONF1_REG = 0x005C;
//     pub const CH5_CONF0_REG = 0x0064;
//     pub const CH5_CONF1_REG = 0x0070;
//     pub const CONF_REG = 0x00D0;
//     pub const CH0_HPOINT_REG = 0x0004;
//     pub const CH1_HPOINT_REG = 0x0018;
//     pub const CH2_HPOINT_REG = 0x002C;
//     pub const CH3_HPOINT_REG = 0x0040;
//     pub const CH4_HPOINT_REG = 0x0054;
//     pub const CH5_HPOINT_REG = 0x0068;
//     pub const CH0_DUTY_REG = 0x0008;
//     pub const CH0_DUTY_R_REG = 0x0010;
//     pub const CH1_DUTY_REG = 0x001C;
//     pub const CH1_DUTY_R_REG = 0x0024;
//     pub const CH2_DUTY_REG = 0x0030;
//     pub const CH2_DUTY_R_REG = 0x0038;
//     pub const CH3_DUTY_REG = 0x0044;
//     pub const CH3_DUTY_R_REG = 0x004C;
//     pub const CH4_DUTY_REG = 0x0058;
//     pub const CH4_DUTY_R_REG = 0x0060;
//     pub const CH5_DUTY_REG = 0x006C;
//     pub const CH5_DUTY_R_REG = 0x0074;
//     pub const TIMER0_CONF_REG = 0x00A0;
//     pub const TIMER0_VALUE_REG = 0x00A4;
//     pub const TIMER1_CONF_REG = 0x00A8;
//     pub const TIMER1_VALUE_REG = 0x00AC;
//     pub const TIMER2_CONF_REG = 0x00B0;
//     pub const TIMER2_VALUE_REG = 0x00B4;
//     pub const TIMER3_CONF_REG = 0x00B8;
//     pub const TIMER3_VALUE_REG = 0x00BC;
//     pub const INT_RAW_REG = 0x00C0;
//     pub const INT_ST_REG = 0x00C4;
//     pub const INT_ENA_REG = 0x00C8;
//     pub const INT_CLR_REG = 0x00CC;
//     pub const DATE_REG = 0x00FC;

//     _regs = rv32.Reg.ledc,

//     pub fn init() Ledc {
//         return Ledc{
//             //.apb_clk_sel = 0,
//         };
//     }
// };

var ledc = undefined;

// var LEDC_APB_CLK_SEL = rv32.Reg.system[0x3C / 4];

const PIN = 9;

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
    setup();
    while (true) {
        loop() catch {};
    }
}

var loops: u32 = 0;

pub fn setup() void {


    rv32.Gpio.output_enable(PIN, true);
    rv32.Gpio.output(PIN);
    rv32.Gpio.write(PIN, true);
    //rv32.logWriter.info("Starting ledcapp v001 \r\n", .{});

    // ledc = Ledc.init();

    // // set APB_CLK (80 Mhz)
    // // bit 01 : 1: APB_CLK; 2: RC_FAST_CLK; 3: XTAL_CLK. (R/W)
    // // bit 31 : clock enable
    // ledc[Ledc.LEDC_CONF_REG / 4] = 0x01 | rv32.Bit(31);

    // // configure timer 0
    // var reg = 0x00;
    // reg |= (0b1111) << 0; // DUTY_RES
    // reg |= (0b00000000) << 4; // CLK_DIV_B
    // reg |= (0b1111111111) << 11; // CLK_DIV_A
    // reg |= (0b1) << 25; // PARA_UP
    // ledc[Ledc.TIMER0_CONF_REG / 4] = reg;
}

pub fn loop() !void {
    rv32.system.ptr.PERIP_CLK_EN0.modify(.{ .LEDC_CLK_EN = 1 });
    try rv32.logWriter.print("getPeriClkEn0 {any}\r\n", .{rv32.system.ptr.PERIP_CLK_EN0.read()});

    std.log.debug("LOGGING FROM STD LOG DEBUG V {}", .{0});
    rv32.Gpio.write(PIN, true);
    rv32.delay_ms(200);
    rv32.Gpio.write(PIN, false);
    rv32.delay_ms(200);
}



