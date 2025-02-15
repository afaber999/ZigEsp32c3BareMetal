const std = @import("std");
const c3 = @import("c3.zig");
const mmio = @import("mmio.zig");


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
    _regs[CORE0_CPU_INT_ENABLE / 4] |= c3.Bit(interrupt);
}

pub inline fn disableCor0(interrupt: u5) void {
    _regs[CORE0_CPU_INT_ENABLE / 4] |= c3.Bit(interrupt);
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
    _regs[CORE0_CPU_INT_CLEAR / 4] |= c3.Bit(interrupt);
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

pub inline fn map_core0_systimer_target0(interrupt: u5) void {
    _regs[CORE0_SYSTIMER_TARGET0_INT_MAP / 4] = interrupt;
}
pub inline fn map_core0_systimer_target1(interrupt: u5) void {
    _regs[CORE0_SYSTIMER_TARGET1_INT_MAP / 4] = interrupt;
}
pub inline fn map_core0_systimer_target2(interrupt: u5) void {
    _regs[CORE0_SYSTIMER_TARGET2_INT_MAP / 4] = interrupt;
}

pub inline fn map_core0_cpu_intr_0(interrupt: u5) void {
    _regs[CORE0_CPU_INTR_FROM_CPU_0_MAP / 4] = interrupt;
}

pub inline fn map_core0_cpu_intr_1(interrupt: u5) void {
    _regs[CORE0_CPU_INTR_FROM_CPU_1_MAP / 4] = interrupt;
}

pub inline fn map_core0_cpu_intr_2(interrupt: u5) void {
    _regs[CORE0_CPU_INTR_FROM_CPU_2_MAP / 4] = interrupt;
}

pub inline fn map_core0_cpu_intr_3(interrupt: u5) void {
    _regs[CORE0_CPU_INTR_FROM_CPU_3_MAP / 4] = interrupt;
}

// ISR wrapper generator
pub fn make_isr_handler(comptime irq_nr: usize, comptime func: anytype) type {
    comptime std.debug.assert(@typeInfo(@TypeOf(func)) == .Fn);
    comptime std.debug.assert(irq_nr < 32);

    return struct {
        pub const exported_name = std.fmt.comptimePrint("_isr_handler_{d:0>2}", .{irq_nr});
        pub const fn_name = nameOf.Fn(func);

        pub fn isr_vector() callconv(.Naked) void {
            c3.Riscv.push_interrupt_state();
            asm volatile ("jal " ++ fn_name ::: "memory");
            c3.Riscv.pop_interrupt_state();
            c3.Riscv.interrupt_return();
        }
        comptime {
            const options = .{ .name = exported_name };
            @export(isr_vector, options);
        }
    };
}

// Trick to obtain name of a function
// This is a workaround for the lack of a proper way to get the name of a function in Zig
// https://github.com/ziglang/zig/issues/8270
const nameOf = struct {
    fn Dummy(func: anytype) type {
        return struct {
            fn warpper() void {
                func();
            }
        };
    }

    pub fn Fn(func: anytype) []const u8 {
        const name = @typeName(Dummy(func));
        const start = (std.mem.indexOfScalar(u8, name, '\'') orelse unreachable) + 1;
        const end = std.mem.indexOfScalarPos(u8, name, start, '\'') orelse unreachable;
        return name[start..end];
    }
};

pub const ptr: *volatile types.INTERRUPT_CORE0 = @ptrFromInt(0x600c2000);

pub const types = struct {
    pub const INTERRUPT_CORE0 = extern struct {
        /// mac intr map register
        MAC_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// core0_mac_intr_map
            MAC_INTR_MAP: u5,
            padding: u27,
        }),
        /// mac nmi_intr map register
        MAC_NMI_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_mac_nmi_map
            MAC_NMI_MAP: u5,
            padding: u27,
        }),
        /// pwr intr map register
        PWR_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_pwr_intr_map
            PWR_INTR_MAP: u5,
            padding: u27,
        }),
        /// bb intr map register
        BB_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_bb_int_map
            BB_INT_MAP: u5,
            padding: u27,
        }),
        /// bt intr map register
        BT_MAC_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_bt_mac_int_map
            BT_MAC_INT_MAP: u5,
            padding: u27,
        }),
        /// bb_bt intr map register
        BT_BB_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_bt_bb_int_map
            BT_BB_INT_MAP: u5,
            padding: u27,
        }),
        /// bb_bt_nmi intr map register
        BT_BB_NMI_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_bt_bb_nmi_map
            BT_BB_NMI_MAP: u5,
            padding: u27,
        }),
        /// rwbt intr map register
        RWBT_IRQ_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_rwbt_irq_map
            RWBT_IRQ_MAP: u5,
            padding: u27,
        }),
        /// rwble intr map register
        RWBLE_IRQ_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_rwble_irq_map
            RWBLE_IRQ_MAP: u5,
            padding: u27,
        }),
        /// rwbt_nmi intr map register
        RWBT_NMI_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_rwbt_nmi_map
            RWBT_NMI_MAP: u5,
            padding: u27,
        }),
        /// rwble_nmi intr map register
        RWBLE_NMI_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_rwble_nmi_map
            RWBLE_NMI_MAP: u5,
            padding: u27,
        }),
        /// i2c intr map register
        I2C_MST_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_i2c_mst_int_map
            I2C_MST_INT_MAP: u5,
            padding: u27,
        }),
        /// slc0 intr map register
        SLC0_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_slc0_intr_map
            SLC0_INTR_MAP: u5,
            padding: u27,
        }),
        /// slc1 intr map register
        SLC1_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_slc1_intr_map
            SLC1_INTR_MAP: u5,
            padding: u27,
        }),
        /// apb_ctrl intr map register
        APB_CTRL_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_apb_ctrl_intr_map
            APB_CTRL_INTR_MAP: u5,
            padding: u27,
        }),
        /// uchi0 intr map register
        UHCI0_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_uhci0_intr_map
            UHCI0_INTR_MAP: u5,
            padding: u27,
        }),
        /// gpio intr map register
        GPIO_INTERRUPT_PRO_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_gpio_interrupt_pro_map
            GPIO_INTERRUPT_PRO_MAP: u5,
            padding: u27,
        }),
        /// gpio_pro intr map register
        GPIO_INTERRUPT_PRO_NMI_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_gpio_interrupt_pro_nmi_map
            GPIO_INTERRUPT_PRO_NMI_MAP: u5,
            padding: u27,
        }),
        /// gpio_pro_nmi intr map register
        SPI_INTR_1_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_spi_intr_1_map
            SPI_INTR_1_MAP: u5,
            padding: u27,
        }),
        /// spi1 intr map register
        SPI_INTR_2_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_spi_intr_2_map
            SPI_INTR_2_MAP: u5,
            padding: u27,
        }),
        /// spi2 intr map register
        I2S1_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_i2s1_int_map
            I2S1_INT_MAP: u5,
            padding: u27,
        }),
        /// i2s1 intr map register
        UART_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_uart_intr_map
            UART_INTR_MAP: u5,
            padding: u27,
        }),
        /// uart1 intr map register
        UART1_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_uart1_intr_map
            UART1_INTR_MAP: u5,
            padding: u27,
        }),
        /// ledc intr map register
        LEDC_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_ledc_int_map
            LEDC_INT_MAP: u5,
            padding: u27,
        }),
        /// efuse intr map register
        EFUSE_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_efuse_int_map
            EFUSE_INT_MAP: u5,
            padding: u27,
        }),
        /// can intr map register
        CAN_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_can_int_map
            CAN_INT_MAP: u5,
            padding: u27,
        }),
        /// usb intr map register
        USB_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_usb_intr_map
            USB_INTR_MAP: u5,
            padding: u27,
        }),
        /// rtc intr map register
        RTC_CORE_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_rtc_core_intr_map
            RTC_CORE_INTR_MAP: u5,
            padding: u27,
        }),
        /// rmt intr map register
        RMT_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_rmt_intr_map
            RMT_INTR_MAP: u5,
            padding: u27,
        }),
        /// i2c intr map register
        I2C_EXT0_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_i2c_ext0_intr_map
            I2C_EXT0_INTR_MAP: u5,
            padding: u27,
        }),
        /// timer1 intr map register
        TIMER_INT1_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_timer_int1_map
            TIMER_INT1_MAP: u5,
            padding: u27,
        }),
        /// timer2 intr map register
        TIMER_INT2_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_timer_int2_map
            TIMER_INT2_MAP: u5,
            padding: u27,
        }),
        /// tg to intr map register
        TG_T0_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_tg_t0_int_map
            TG_T0_INT_MAP: u5,
            padding: u27,
        }),
        /// tg wdt intr map register
        TG_WDT_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_tg_wdt_int_map
            TG_WDT_INT_MAP: u5,
            padding: u27,
        }),
        /// tg1 to intr map register
        TG1_T0_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_tg1_t0_int_map
            TG1_T0_INT_MAP: u5,
            padding: u27,
        }),
        /// tg1 wdt intr map register
        TG1_WDT_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_tg1_wdt_int_map
            TG1_WDT_INT_MAP: u5,
            padding: u27,
        }),
        /// cache ia intr map register
        CACHE_IA_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cache_ia_int_map
            CACHE_IA_INT_MAP: u5,
            padding: u27,
        }),
        /// systimer intr map register
        SYSTIMER_TARGET0_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_systimer_target0_int_map
            SYSTIMER_TARGET0_INT_MAP: u5,
            padding: u27,
        }),
        /// systimer target1 intr map register
        SYSTIMER_TARGET1_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_systimer_target1_int_map
            SYSTIMER_TARGET1_INT_MAP: u5,
            padding: u27,
        }),
        /// systimer target2 intr map register
        SYSTIMER_TARGET2_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_systimer_target2_int_map
            SYSTIMER_TARGET2_INT_MAP: u5,
            padding: u27,
        }),
        /// spi mem reject intr map register
        SPI_MEM_REJECT_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_spi_mem_reject_intr_map
            SPI_MEM_REJECT_INTR_MAP: u5,
            padding: u27,
        }),
        /// icache perload intr map register
        ICACHE_PRELOAD_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_icache_preload_int_map
            ICACHE_PRELOAD_INT_MAP: u5,
            padding: u27,
        }),
        /// icache sync intr map register
        ICACHE_SYNC_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_icache_sync_int_map
            ICACHE_SYNC_INT_MAP: u5,
            padding: u27,
        }),
        /// adc intr map register
        APB_ADC_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_apb_adc_int_map
            APB_ADC_INT_MAP: u5,
            padding: u27,
        }),
        /// dma ch0 intr map register
        DMA_CH0_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_dma_ch0_int_map
            DMA_CH0_INT_MAP: u5,
            padding: u27,
        }),
        /// dma ch1 intr map register
        DMA_CH1_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_dma_ch1_int_map
            DMA_CH1_INT_MAP: u5,
            padding: u27,
        }),
        /// dma ch2 intr map register
        DMA_CH2_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_dma_ch2_int_map
            DMA_CH2_INT_MAP: u5,
            padding: u27,
        }),
        /// rsa intr map register
        RSA_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_rsa_int_map
            RSA_INT_MAP: u5,
            padding: u27,
        }),
        /// aes intr map register
        AES_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_aes_int_map
            AES_INT_MAP: u5,
            padding: u27,
        }),
        /// sha intr map register
        SHA_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_sha_int_map
            SHA_INT_MAP: u5,
            padding: u27,
        }),
        /// cpu from cpu 0 intr map register
        CPU_INTR_FROM_CPU_0_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_intr_from_cpu_0_map
            CPU_INTR_FROM_CPU_0_MAP: u5,
            padding: u27,
        }),
        /// cpu from cpu 0 intr map register
        CPU_INTR_FROM_CPU_1_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_intr_from_cpu_1_map
            CPU_INTR_FROM_CPU_1_MAP: u5,
            padding: u27,
        }),
        /// cpu from cpu 1 intr map register
        CPU_INTR_FROM_CPU_2_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_intr_from_cpu_2_map
            CPU_INTR_FROM_CPU_2_MAP: u5,
            padding: u27,
        }),
        /// cpu from cpu 3 intr map register
        CPU_INTR_FROM_CPU_3_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_intr_from_cpu_3_map
            CPU_INTR_FROM_CPU_3_MAP: u5,
            padding: u27,
        }),
        /// assist debug intr map register
        ASSIST_DEBUG_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_assist_debug_intr_map
            ASSIST_DEBUG_INTR_MAP: u5,
            padding: u27,
        }),
        /// dma pms violatile intr map register
        DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_dma_apbperi_pms_monitor_violate_intr_map
            DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP: u5,
            padding: u27,
        }),
        /// iram0 pms violatile intr map register
        CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_core_0_iram0_pms_monitor_violate_intr_map
            CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP: u5,
            padding: u27,
        }),
        /// mac intr map register
        CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_core_0_dram0_pms_monitor_violate_intr_map
            CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP: u5,
            padding: u27,
        }),
        /// mac intr map register
        CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_core_0_pif_pms_monitor_violate_intr_map
            CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP: u5,
            padding: u27,
        }),
        /// mac intr map register
        CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_core_0_pif_pms_monitor_violate_size_intr_map
            CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP: u5,
            padding: u27,
        }),
        /// mac intr map register
        BACKUP_PMS_VIOLATE_INTR_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_backup_pms_violate_intr_map
            BACKUP_PMS_VIOLATE_INTR_MAP: u5,
            padding: u27,
        }),
        /// mac intr map register
        CACHE_CORE0_ACS_INT_MAP: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cache_core0_acs_int_map
            CACHE_CORE0_ACS_INT_MAP: u5,
            padding: u27,
        }),
        /// mac intr map register
        INTR_STATUS_REG_0: mmio.Mmio(packed struct(u32) {
            /// reg_core0_intr_status_0
            INTR_STATUS_0: u32,
        }),
        /// mac intr map register
        INTR_STATUS_REG_1: mmio.Mmio(packed struct(u32) {
            /// reg_core0_intr_status_1
            INTR_STATUS_1: u32,
        }),
        /// mac intr map register
        CLOCK_GATE: mmio.Mmio(packed struct(u32) {
            /// reg_core0_reg_clk_en
            REG_CLK_EN: u1,
            padding: u31,
        }),
        /// mac intr map register
        CPU_INT_ENABLE: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_int_enable
            CPU_INT_ENABLE: u32,
        }),
        /// mac intr map register
        CPU_INT_TYPE: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_int_type
            CPU_INT_TYPE: u32,
        }),
        /// mac intr map register
        CPU_INT_CLEAR: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_int_clear
            CPU_INT_CLEAR: u32,
        }),
        /// mac intr map register
        CPU_INT_EIP_STATUS: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_int_eip_status
            CPU_INT_EIP_STATUS: u32,
        }),
        /// mac intr map register
        CPU_INT_PRI_0: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_0_map
            CPU_PRI_0_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_1: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_1_map
            CPU_PRI_1_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_2: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_2_map
            CPU_PRI_2_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_3: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_3_map
            CPU_PRI_3_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_4: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_4_map
            CPU_PRI_4_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_5: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_5_map
            CPU_PRI_5_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_6: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_6_map
            CPU_PRI_6_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_7: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_7_map
            CPU_PRI_7_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_8: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_8_map
            CPU_PRI_8_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_9: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_9_map
            CPU_PRI_9_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_10: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_10_map
            CPU_PRI_10_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_11: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_11_map
            CPU_PRI_11_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_12: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_12_map
            CPU_PRI_12_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_13: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_13_map
            CPU_PRI_13_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_14: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_14_map
            CPU_PRI_14_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_15: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_15_map
            CPU_PRI_15_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_16: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_16_map
            CPU_PRI_16_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_17: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_17_map
            CPU_PRI_17_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_18: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_18_map
            CPU_PRI_18_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_19: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_19_map
            CPU_PRI_19_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_20: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_20_map
            CPU_PRI_20_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_21: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_21_map
            CPU_PRI_21_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_22: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_22_map
            CPU_PRI_22_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_23: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_23_map
            CPU_PRI_23_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_24: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_24_map
            CPU_PRI_24_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_25: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_25_map
            CPU_PRI_25_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_26: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_26_map
            CPU_PRI_26_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_27: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_27_map
            CPU_PRI_27_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_28: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_28_map
            CPU_PRI_28_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_29: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_29_map
            CPU_PRI_29_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_30: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_30_map
            CPU_PRI_30_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_PRI_31: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_pri_31_map
            CPU_PRI_31_MAP: u4,
            padding: u28,
        }),
        /// mac intr map register
        CPU_INT_THRESH: mmio.Mmio(packed struct(u32) {
            /// reg_core0_cpu_int_thresh
            CPU_INT_THRESH: u4,
            padding: u28,
        }),
        reserved2044: [1636]u8,
        /// mac intr map register
        INTERRUPT_REG_DATE: mmio.Mmio(packed struct(u32) {
            /// reg_core0_interrupt_reg_date
            INTERRUPT_REG_DATE: u28,
            padding: u4,
        }),
    };
};
