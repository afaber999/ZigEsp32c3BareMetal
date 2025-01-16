const std = @import("std");
const c3 = @import("c3.zig");

pub const CORE0_CPU_INT_THRESH = 0x194;
pub const CORE0_MAC_INTR_MAP = 0x000;
pub const CORE0_MAC_NMI_MAP = 0x004;
pub const CORE0_PWR_INTR_MAP = 0x008;
pub const CORE0_BB_INT_MAP = 0x00C;
pub const CORE0_BT_MAC_INT_MAP = 0x010;
pub const CORE0_BT_BB_INT_MAP = 0x014;
pub const CORE0_BT_BB_NMI_MAP = 0x018;
pub const CORE0_RWBT_IRQ_MAP = 0x01C;
pub const CORE0_RWBLE_IRQ_MAP = 0x020;
pub const CORE0_RWBT_NMI_MAP = 0x024;
pub const CORE0_RWBLE_NMI_MAP = 0x028;
pub const CORE0_I2C_MST_INT_MAP = 0x02C;
pub const CORE0_SLC0_INTR_MAP = 0x030;
pub const CORE0_SLC1_INTR_MAP = 0x034;
pub const CORE0_APB_CTRL_INTR_MAP = 0x038;
pub const CORE0_UHCI0_INTR_MAP = 0x03C;
pub const CORE0_GPIO_INTERRUPT_PRO_MAP = 0x040;
pub const CORE0_GPIO_INTERRUPT_PRO_NMI_MAP = 0x044;
pub const CORE0_SPI_INTR_1_MAP = 0x048;
pub const CORE0_SPI_INTR_2_MAP = 0x04C;
pub const CORE0_I2S1_INT_MAP = 0x050;
pub const CORE0_UART_INTR_MAP = 0x054;
pub const CORE0_UART1_INTR_MAP = 0x058;
pub const CORE0_LEDC_INT_MAP = 0x05C;
pub const CORE0_EFUSE_INT_MAP = 0x060;
pub const CORE0_CAN_INT_MAP = 0x064;
pub const CORE0_USB_INTR_MAP = 0x068;
pub const CORE0_RTC_CORE_INTR_MAP = 0x06C;
pub const CORE0_RMT_INTR_MAP = 0x070;
pub const CORE0_I2C_EXT0_INTR_MAP = 0x074;
pub const CORE0_TIMER_INT1_MAP = 0x078;
pub const CORE0_TIMER_INT2_MAP = 0x07C;
pub const CORE0_TG_T0_INT_MAP = 0x080;
pub const CORE0_TG_WDT_INT_MAP = 0x084;
pub const CORE0_TG1_T0_INT_MAP = 0x088;
pub const CORE0_TG1_WDT_INT_MAP = 0x08C;
pub const CORE0_CACHE_IA_INT_MAP = 0x090;
pub const CORE0_SYSTIMER_TARGET0_INT_MAP = 0x094;
pub const CORE0_SYSTIMER_TARGET1_INT_MAP = 0x098;
pub const CORE0_SYSTIMER_TARGET2_INT_MAP = 0x09C;
pub const CORE0_SPI_MEM_REJECT_INTR_MAP = 0x0A0;
pub const CORE0_ICACHE_PRELOAD_INT_MAP = 0x0A4;
pub const CORE0_ICACHE_SYNC_INT_MAP = 0x0A8;
pub const CORE0_APB_ADC_INT_MAP = 0x0AC;
pub const CORE0_DMA_CH0_INT_MAP = 0x0B0;
pub const CORE0_DMA_CH1_INT_MAP = 0x0B4;
pub const CORE0_DMA_CH2_INT_MAP = 0x0B8;
pub const CORE0_RSA_INT_MAP = 0x0BC;
pub const CORE0_AES_INT_MAP = 0x0C0;
pub const CORE0_SHA_INT_MAP = 0x0C4;
pub const CORE0_CPU_INTR_FROM_CPU_0_MAP = 0x0C8;
pub const CORE0_CPU_INTR_FROM_CPU_1_MAP = 0x0CC;
pub const CORE0_CPU_INTR_FROM_CPU_2_MAP = 0x0D0;
pub const CORE0_CPU_INTR_FROM_CPU_3_MAP = 0x0D4;
pub const CORE0_ASSIST_DEBUG_INTR_MAP = 0x0D8;
pub const CORE0_DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP = 0x0DC;
pub const CORE0_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP = 0x0E0;
pub const CORE0_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP = 0x0E4;
pub const CORE0_CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP = 0x0E8;
pub const CORE0_CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP = 0x0EC;
pub const CORE0_BACKUP_PMS_VIOLATE_INTR_MAP = 0x0F0;
pub const CORE0_CACHE_CORE0_ACS_INT_MAP = 0x0F4;
pub const CORE0_INTR_STATUS_0 = 0x0F8;
pub const CORE0_INTR_STATUS_1 = 0x0FC;
pub const CORE0_CLOCK_GATE = 0x100;
pub const CORE0_CPU_INT_ENABLE = 0x104;
pub const CORE0_CPU_INT_TYPE = 0x108;
pub const CORE0_CPU_INT_CLEAR = 0x10C;
pub const CORE0_CPU_INT_EIP_STATUS = 0x110;
pub const CORE0_CPU_INT_PRI_0 = 0x114;

const _regs: [*]volatile u32 = c3.Reg.interrupt;

pub inline fn eipStatuCor0() u32 {
    return _regs[CORE0_CPU_INT_EIP_STATUS / 4];
}

pub inline fn enableCor0(interrupt: u5) void {
    _regs[CORE0_CPU_INT_ENABLE / 4] = c3.Bit(interrupt);
}

pub inline fn disableCor0(interrupt: u5) void {
    _regs[CORE0_CPU_INT_ENABLE / 4] = c3.Bit(interrupt);
}

// AF DECL ENUM for u1 (edge/level)
pub inline fn setIntType(interrupt: u5, tp: u1) void {
    c3.Reg.setOrClearBit(&_regs[CORE0_CPU_INT_TYPE / 4], interrupt, tp != 0);
}

pub inline fn setIntPri(interrupt: u5, level: u4) void {
    const idx = CORE0_CPU_INT_PRI_0 / 4 + @as(u32, interrupt);
    _regs[idx] = level;
}

pub inline fn setPrioThreshold(threshold: u4) void {
    _regs[CORE0_CPU_INT_THRESH / 4] = threshold;
}

// clear pending interrupt (of edge triggered interrupts)
// for levle triggered interrupts, this is not necessary
// once should clear the interrupt source instead
pub inline fn clearPendingInterrupt(interrupt: u5) void {
    _regs[CORE0_CPU_INT_CLEAR / 4] = c3.Bit(interrupt);
}

pub inline fn clearAllPendingInterrupts() void {
    _regs[CORE0_CPU_INT_CLEAR / 4] = 0xFFFFFFFF;
}

pub inline fn getIntrStatus0() u32 {
    return _regs[CORE0_INTR_STATUS_0 / 4];
}

pub inline fn getIntrStatus1() u32 {
    return _regs[CORE0_INTR_STATUS_1 / 4];
}
