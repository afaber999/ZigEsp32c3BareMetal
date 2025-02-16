const std = @import("std");
const mmio = @import("mmio.zig");

pub const ptrTimg0: *volatile types.peripherals.TIMG0 = @ptrFromInt(0x6001f000);
pub const ptrTimg1: *volatile types.peripherals.TIMG0 = @ptrFromInt(0x60020000);

pub const types = struct {
    /// Timer Group
    pub const TIMG = extern struct {
        /// TIMG_T0CONFIG_REG.
        T0CONFIG: mmio.Mmio(packed struct(u32) {
            reserved9: u9,
            /// reg_t0_use_xtal.
            T0_USE_XTAL: u1,
            /// reg_t0_alarm_en.
            T0_ALARM_EN: u1,
            reserved12: u1,
            /// reg_t0_divcnt_rst.
            T0_DIVCNT_RST: u1,
            /// reg_t0_divider.
            T0_DIVIDER: u16,
            /// reg_t0_autoreload.
            T0_AUTORELOAD: u1,
            /// reg_t0_increase.
            T0_INCREASE: u1,
            /// reg_t0_en.
            T0_EN: u1,
        }),
        /// TIMG_T0LO_REG.
        T0LO: mmio.Mmio(packed struct(u32) {
            /// t0_lo
            T0_LO: u32,
        }),
        /// TIMG_T0HI_REG.
        T0HI: mmio.Mmio(packed struct(u32) {
            /// t0_hi
            T0_HI: u22,
            padding: u10,
        }),
        /// TIMG_T0UPDATE_REG.
        T0UPDATE: mmio.Mmio(packed struct(u32) {
            reserved31: u31,
            /// t0_update
            T0_UPDATE: u1,
        }),
        /// TIMG_T0ALARMLO_REG.
        T0ALARMLO: mmio.Mmio(packed struct(u32) {
            /// reg_t0_alarm_lo.
            T0_ALARM_LO: u32,
        }),
        /// TIMG_T0ALARMHI_REG.
        T0ALARMHI: mmio.Mmio(packed struct(u32) {
            /// reg_t0_alarm_hi.
            T0_ALARM_HI: u22,
            padding: u10,
        }),
        /// TIMG_T0LOADLO_REG.
        T0LOADLO: mmio.Mmio(packed struct(u32) {
            /// reg_t0_load_lo.
            T0_LOAD_LO: u32,
        }),
        /// TIMG_T0LOADHI_REG.
        T0LOADHI: mmio.Mmio(packed struct(u32) {
            /// reg_t0_load_hi.
            T0_LOAD_HI: u22,
            padding: u10,
        }),
        /// TIMG_T0LOAD_REG.
        T0LOAD: mmio.Mmio(packed struct(u32) {
            /// t0_load
            T0_LOAD: u32,
        }),
        reserved72: [36]u8,
        /// TIMG_WDTCONFIG0_REG.
        WDTCONFIG0: mmio.Mmio(packed struct(u32) {
            reserved12: u12,
            /// reg_wdt_appcpu_reset_en.
            WDT_APPCPU_RESET_EN: u1,
            /// reg_wdt_procpu_reset_en.
            WDT_PROCPU_RESET_EN: u1,
            /// reg_wdt_flashboot_mod_en.
            WDT_FLASHBOOT_MOD_EN: u1,
            /// reg_wdt_sys_reset_length.
            WDT_SYS_RESET_LENGTH: u3,
            /// reg_wdt_cpu_reset_length.
            WDT_CPU_RESET_LENGTH: u3,
            /// reg_wdt_use_xtal.
            WDT_USE_XTAL: u1,
            /// reg_wdt_conf_update_en.
            WDT_CONF_UPDATE_EN: u1,
            /// reg_wdt_stg3.
            WDT_STG3: u2,
            /// reg_wdt_stg2.
            WDT_STG2: u2,
            /// reg_wdt_stg1.
            WDT_STG1: u2,
            /// reg_wdt_stg0.
            WDT_STG0: u2,
            /// reg_wdt_en.
            WDT_EN: u1,
        }),
        /// TIMG_WDTCONFIG1_REG.
        WDTCONFIG1: mmio.Mmio(packed struct(u32) {
            /// reg_wdt_divcnt_rst.
            WDT_DIVCNT_RST: u1,
            reserved16: u15,
            /// reg_wdt_clk_prescale.
            WDT_CLK_PRESCALE: u16,
        }),
        /// TIMG_WDTCONFIG2_REG.
        WDTCONFIG2: mmio.Mmio(packed struct(u32) {
            /// reg_wdt_stg0_hold.
            WDT_STG0_HOLD: u32,
        }),
        /// TIMG_WDTCONFIG3_REG.
        WDTCONFIG3: mmio.Mmio(packed struct(u32) {
            /// reg_wdt_stg1_hold.
            WDT_STG1_HOLD: u32,
        }),
        /// TIMG_WDTCONFIG4_REG.
        WDTCONFIG4: mmio.Mmio(packed struct(u32) {
            /// reg_wdt_stg2_hold.
            WDT_STG2_HOLD: u32,
        }),
        /// TIMG_WDTCONFIG5_REG.
        WDTCONFIG5: mmio.Mmio(packed struct(u32) {
            /// reg_wdt_stg3_hold.
            WDT_STG3_HOLD: u32,
        }),
        /// TIMG_WDTFEED_REG.
        WDTFEED: mmio.Mmio(packed struct(u32) {
            /// wdt_feed
            WDT_FEED: u32,
        }),
        /// TIMG_WDTWPROTECT_REG.
        WDTWPROTECT: mmio.Mmio(packed struct(u32) {
            /// reg_wdt_wkey.
            WDT_WKEY: u32,
        }),
        /// TIMG_RTCCALICFG_REG.
        RTCCALICFG: mmio.Mmio(packed struct(u32) {
            reserved12: u12,
            /// reg_rtc_cali_start_cycling.
            RTC_CALI_START_CYCLING: u1,
            /// reg_rtc_cali_clk_sel.0:rtcslowclock.1:clk_80m.2:xtal_32k
            RTC_CALI_CLK_SEL: u2,
            /// rtc_cali_rdy
            RTC_CALI_RDY: u1,
            /// reg_rtc_cali_max.
            RTC_CALI_MAX: u15,
            /// reg_rtc_cali_start.
            RTC_CALI_START: u1,
        }),
        /// TIMG_RTCCALICFG1_REG.
        RTCCALICFG1: mmio.Mmio(packed struct(u32) {
            /// rtc_cali_cycling_data_vld
            RTC_CALI_CYCLING_DATA_VLD: u1,
            reserved7: u6,
            /// rtc_cali_value
            RTC_CALI_VALUE: u25,
        }),
        /// INT_ENA_TIMG_REG
        INT_ENA_TIMERS: mmio.Mmio(packed struct(u32) {
            /// t0_int_ena
            T0_INT_ENA: u1,
            /// wdt_int_ena
            WDT_INT_ENA: u1,
            padding: u30,
        }),
        /// INT_RAW_TIMG_REG
        INT_RAW_TIMERS: mmio.Mmio(packed struct(u32) {
            /// t0_int_raw
            T0_INT_RAW: u1,
            /// wdt_int_raw
            WDT_INT_RAW: u1,
            padding: u30,
        }),
        /// INT_ST_TIMG_REG
        INT_ST_TIMERS: mmio.Mmio(packed struct(u32) {
            /// t0_int_st
            T0_INT_ST: u1,
            /// wdt_int_st
            WDT_INT_ST: u1,
            padding: u30,
        }),
        /// INT_CLR_TIMG_REG
        INT_CLR_TIMERS: mmio.Mmio(packed struct(u32) {
            /// t0_int_clr
            T0_INT_CLR: u1,
            /// wdt_int_clr
            WDT_INT_CLR: u1,
            padding: u30,
        }),
        /// TIMG_RTCCALICFG2_REG.
        RTCCALICFG2: mmio.Mmio(packed struct(u32) {
            /// timeoutindicator
            RTC_CALI_TIMEOUT: u1,
            reserved3: u2,
            /// reg_rtc_cali_timeout_rst_cnt.Cyclesthatreleasecalibrationtimeoutreset
            RTC_CALI_TIMEOUT_RST_CNT: u4,
            /// reg_rtc_cali_timeout_thres.timeoutifcalivaluecountsoverthreshold
            RTC_CALI_TIMEOUT_THRES: u25,
        }),
        reserved248: [116]u8,
        /// TIMG_NTIMG_DATE_REG.
        NTIMG_DATE: mmio.Mmio(packed struct(u32) {
            /// reg_ntimers_date.
            NTIMGS_DATE: u28,
            padding: u4,
        }),
        /// TIMG_REGCLK_REG.
        REGCLK: mmio.Mmio(packed struct(u32) {
            reserved29: u29,
            /// reg_wdt_clk_is_active.
            WDT_CLK_IS_ACTIVE: u1,
            /// reg_timer_clk_is_active.
            TIMER_CLK_IS_ACTIVE: u1,
            /// reg_clk_en.
            CLK_EN: u1,
        }),
    };
};
