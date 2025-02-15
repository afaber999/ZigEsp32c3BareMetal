const std = @import("std");
const c3 = @import("c3.zig");
const mmio = @import("mmio.zig");

const CPU_PERI_CLK_EN0 = 0x010;
const CPU_INTR_FROM_CPU_0 = 0x028;
const CPU_INTR_FROM_CPU_1 = 0x02C;
const CPU_INTR_FROM_CPU_2 = 0x030;
const CPU_INTR_FROM_CPU_3 = 0x034;

const CONF = 0x0058;

const _regs: [*]volatile u32 = c3.Reg.system;

const SYSTEM_LEDC_CLK_EN = 11;

pub fn getPeriClkEn0() u32 {
    return _regs[CPU_PERI_CLK_EN0 / 4];
}

pub fn setPeriClkEn0(val: u32) u32 {
    _regs[CPU_PERI_CLK_EN0 / 4] = val;
}

pub fn isCpuIntr0() u1 {
    return ptr.CPU_INTR_FROM_CPU_0;
    //return @truncate(_regs[CPU_INTR_FROM_CPU_0 / 4]);
}

pub fn setCpuIntr0(value: u1) void {
    //    _regs[CPU_INTR_FROM_CPU_0 / 4] = value;
    ptr.CPU_INTR_FROM_CPU_0.modify(.{ .CPU_INTR_FROM_CPU_0 = value });
}

pub fn setCpuIntr(comptime intr: u2, value: u1) void {
    switch (intr) {
        0 => ptr.CPU_INTR_FROM_CPU_0.modify(.{ .CPU_INTR_FROM_CPU_0 = value }),
        1 => ptr.CPU_INTR_FROM_CPU_1.modify(.{ .CPU_INTR_FROM_CPU_1 = value }),
        2 => ptr.CPU_INTR_FROM_CPU_2.modify(.{ .CPU_INTR_FROM_CPU_2 = value }),
        3 => ptr.CPU_INTR_FROM_CPU_3.modify(.{ .CPU_INTR_FROM_CPU_3 = value }),
    }
}

pub const ptr: *volatile types.SYSTEM = @ptrFromInt(0x600c0000);

pub const types = struct {
    /// System
    pub const SYSTEM = extern struct {
        /// cpu_peripheral clock gating register
        CPU_PERI_CLK_EN: mmio.Mmio(packed struct(u32) {
            reserved6: u6,
            /// reg_clk_en_assist_debug
            CLK_EN_ASSIST_DEBUG: u1,
            /// reg_clk_en_dedicated_gpio
            CLK_EN_DEDICATED_GPIO: u1,
            padding: u24,
        }),
        /// cpu_peripheral reset register
        CPU_PERI_RST_EN: mmio.Mmio(packed struct(u32) {
            reserved6: u6,
            /// reg_rst_en_assist_debug
            RST_EN_ASSIST_DEBUG: u1,
            /// reg_rst_en_dedicated_gpio
            RST_EN_DEDICATED_GPIO: u1,
            padding: u24,
        }),
        /// cpu clock config register
        CPU_PER_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_cpuperiod_sel
            CPUPERIOD_SEL: u2,
            /// reg_pll_freq_sel
            PLL_FREQ_SEL: u1,
            /// reg_cpu_wait_mode_force_on
            CPU_WAIT_MODE_FORCE_ON: u1,
            /// reg_cpu_waiti_delay_num
            CPU_WAITI_DELAY_NUM: u4,
            padding: u24,
        }),
        /// memory power down mask register
        MEM_PD_MASK: mmio.Mmio(packed struct(u32) {
            /// reg_lslp_mem_pd_mask
            LSLP_MEM_PD_MASK: u1,
            padding: u31,
        }),
        /// peripheral clock gating register
        PERIP_CLK_EN0: mmio.Mmio(packed struct(u32) {
            /// reg_timers_clk_en
            TIMERS_CLK_EN: u1,
            /// reg_spi01_clk_en
            SPI01_CLK_EN: u1,
            /// reg_uart_clk_en
            UART_CLK_EN: u1,
            /// reg_wdg_clk_en
            WDG_CLK_EN: u1,
            /// reg_i2s0_clk_en
            I2S0_CLK_EN: u1,
            /// reg_uart1_clk_en
            UART1_CLK_EN: u1,
            /// reg_spi2_clk_en
            SPI2_CLK_EN: u1,
            /// reg_ext0_clk_en
            I2C_EXT0_CLK_EN: u1,
            /// reg_uhci0_clk_en
            UHCI0_CLK_EN: u1,
            /// reg_rmt_clk_en
            RMT_CLK_EN: u1,
            /// reg_pcnt_clk_en
            PCNT_CLK_EN: u1,
            /// reg_ledc_clk_en
            LEDC_CLK_EN: u1,
            /// reg_uhci1_clk_en
            UHCI1_CLK_EN: u1,
            /// reg_timergroup_clk_en
            TIMERGROUP_CLK_EN: u1,
            /// reg_efuse_clk_en
            EFUSE_CLK_EN: u1,
            /// reg_timergroup1_clk_en
            TIMERGROUP1_CLK_EN: u1,
            /// reg_spi3_clk_en
            SPI3_CLK_EN: u1,
            /// reg_pwm0_clk_en
            PWM0_CLK_EN: u1,
            /// reg_ext1_clk_en
            EXT1_CLK_EN: u1,
            /// reg_can_clk_en
            CAN_CLK_EN: u1,
            /// reg_pwm1_clk_en
            PWM1_CLK_EN: u1,
            /// reg_i2s1_clk_en
            I2S1_CLK_EN: u1,
            /// reg_spi2_dma_clk_en
            SPI2_DMA_CLK_EN: u1,
            /// reg_usb_device_clk_en
            USB_DEVICE_CLK_EN: u1,
            /// reg_uart_mem_clk_en
            UART_MEM_CLK_EN: u1,
            /// reg_pwm2_clk_en
            PWM2_CLK_EN: u1,
            /// reg_pwm3_clk_en
            PWM3_CLK_EN: u1,
            /// reg_spi3_dma_clk_en
            SPI3_DMA_CLK_EN: u1,
            /// reg_apb_saradc_clk_en
            APB_SARADC_CLK_EN: u1,
            /// reg_systimer_clk_en
            SYSTIMER_CLK_EN: u1,
            /// reg_adc2_arb_clk_en
            ADC2_ARB_CLK_EN: u1,
            /// reg_spi4_clk_en
            SPI4_CLK_EN: u1,
        }),
        /// peripheral clock gating register
        PERIP_CLK_EN1: mmio.Mmio(packed struct(u32) {
            reserved1: u1,
            /// reg_crypto_aes_clk_en
            CRYPTO_AES_CLK_EN: u1,
            /// reg_crypto_sha_clk_en
            CRYPTO_SHA_CLK_EN: u1,
            /// reg_crypto_rsa_clk_en
            CRYPTO_RSA_CLK_EN: u1,
            /// reg_crypto_ds_clk_en
            CRYPTO_DS_CLK_EN: u1,
            /// reg_crypto_hmac_clk_en
            CRYPTO_HMAC_CLK_EN: u1,
            /// reg_dma_clk_en
            DMA_CLK_EN: u1,
            /// reg_sdio_host_clk_en
            SDIO_HOST_CLK_EN: u1,
            /// reg_lcd_cam_clk_en
            LCD_CAM_CLK_EN: u1,
            /// reg_uart2_clk_en
            UART2_CLK_EN: u1,
            /// reg_tsens_clk_en
            TSENS_CLK_EN: u1,
            padding: u21,
        }),
        /// reserved
        PERIP_RST_EN0: mmio.Mmio(packed struct(u32) {
            /// reg_timers_rst
            TIMERS_RST: u1,
            /// reg_spi01_rst
            SPI01_RST: u1,
            /// reg_uart_rst
            UART_RST: u1,
            /// reg_wdg_rst
            WDG_RST: u1,
            /// reg_i2s0_rst
            I2S0_RST: u1,
            /// reg_uart1_rst
            UART1_RST: u1,
            /// reg_spi2_rst
            SPI2_RST: u1,
            /// reg_ext0_rst
            I2C_EXT0_RST: u1,
            /// reg_uhci0_rst
            UHCI0_RST: u1,
            /// reg_rmt_rst
            RMT_RST: u1,
            /// reg_pcnt_rst
            PCNT_RST: u1,
            /// reg_ledc_rst
            LEDC_RST: u1,
            /// reg_uhci1_rst
            UHCI1_RST: u1,
            /// reg_timergroup_rst
            TIMERGROUP_RST: u1,
            /// reg_efuse_rst
            EFUSE_RST: u1,
            /// reg_timergroup1_rst
            TIMERGROUP1_RST: u1,
            /// reg_spi3_rst
            SPI3_RST: u1,
            /// reg_pwm0_rst
            PWM0_RST: u1,
            /// reg_ext1_rst
            EXT1_RST: u1,
            /// reg_can_rst
            CAN_RST: u1,
            /// reg_pwm1_rst
            PWM1_RST: u1,
            /// reg_i2s1_rst
            I2S1_RST: u1,
            /// reg_spi2_dma_rst
            SPI2_DMA_RST: u1,
            /// reg_usb_device_rst
            USB_DEVICE_RST: u1,
            /// reg_uart_mem_rst
            UART_MEM_RST: u1,
            /// reg_pwm2_rst
            PWM2_RST: u1,
            /// reg_pwm3_rst
            PWM3_RST: u1,
            /// reg_spi3_dma_rst
            SPI3_DMA_RST: u1,
            /// reg_apb_saradc_rst
            APB_SARADC_RST: u1,
            /// reg_systimer_rst
            SYSTIMER_RST: u1,
            /// reg_adc2_arb_rst
            ADC2_ARB_RST: u1,
            /// reg_spi4_rst
            SPI4_RST: u1,
        }),
        /// peripheral reset register
        PERIP_RST_EN1: mmio.Mmio(packed struct(u32) {
            reserved1: u1,
            /// reg_crypto_aes_rst
            CRYPTO_AES_RST: u1,
            /// reg_crypto_sha_rst
            CRYPTO_SHA_RST: u1,
            /// reg_crypto_rsa_rst
            CRYPTO_RSA_RST: u1,
            /// reg_crypto_ds_rst
            CRYPTO_DS_RST: u1,
            /// reg_crypto_hmac_rst
            CRYPTO_HMAC_RST: u1,
            /// reg_dma_rst
            DMA_RST: u1,
            /// reg_sdio_host_rst
            SDIO_HOST_RST: u1,
            /// reg_lcd_cam_rst
            LCD_CAM_RST: u1,
            /// reg_uart2_rst
            UART2_RST: u1,
            /// reg_tsens_rst
            TSENS_RST: u1,
            padding: u21,
        }),
        /// clock config register
        BT_LPCK_DIV_INT: mmio.Mmio(packed struct(u32) {
            /// reg_bt_lpck_div_num
            BT_LPCK_DIV_NUM: u12,
            padding: u20,
        }),
        /// clock config register
        BT_LPCK_DIV_FRAC: mmio.Mmio(packed struct(u32) {
            /// reg_bt_lpck_div_b
            BT_LPCK_DIV_B: u12,
            /// reg_bt_lpck_div_a
            BT_LPCK_DIV_A: u12,
            /// reg_lpclk_sel_rtc_slow
            LPCLK_SEL_RTC_SLOW: u1,
            /// reg_lpclk_sel_8m
            LPCLK_SEL_8M: u1,
            /// reg_lpclk_sel_xtal
            LPCLK_SEL_XTAL: u1,
            /// reg_lpclk_sel_xtal32k
            LPCLK_SEL_XTAL32K: u1,
            /// reg_lpclk_rtc_en
            LPCLK_RTC_EN: u1,
            padding: u3,
        }),
        /// interrupt generate register
        CPU_INTR_FROM_CPU_0: mmio.Mmio(packed struct(u32) {
            /// reg_cpu_intr_from_cpu_0
            CPU_INTR_FROM_CPU_0: u1,
            padding: u31,
        }),
        /// interrupt generate register
        CPU_INTR_FROM_CPU_1: mmio.Mmio(packed struct(u32) {
            /// reg_cpu_intr_from_cpu_1
            CPU_INTR_FROM_CPU_1: u1,
            padding: u31,
        }),
        /// interrupt generate register
        CPU_INTR_FROM_CPU_2: mmio.Mmio(packed struct(u32) {
            /// reg_cpu_intr_from_cpu_2
            CPU_INTR_FROM_CPU_2: u1,
            padding: u31,
        }),
        /// interrupt generate register
        CPU_INTR_FROM_CPU_3: mmio.Mmio(packed struct(u32) {
            /// reg_cpu_intr_from_cpu_3
            CPU_INTR_FROM_CPU_3: u1,
            padding: u31,
        }),
        /// rsa memory power control register
        RSA_PD_CTRL: mmio.Mmio(packed struct(u32) {
            /// reg_rsa_mem_pd
            RSA_MEM_PD: u1,
            /// reg_rsa_mem_force_pu
            RSA_MEM_FORCE_PU: u1,
            /// reg_rsa_mem_force_pd
            RSA_MEM_FORCE_PD: u1,
            padding: u29,
        }),
        /// edma clcok and reset register
        EDMA_CTRL: mmio.Mmio(packed struct(u32) {
            /// reg_edma_clk_on
            EDMA_CLK_ON: u1,
            /// reg_edma_reset
            EDMA_RESET: u1,
            padding: u30,
        }),
        /// cache control register
        CACHE_CONTROL: mmio.Mmio(packed struct(u32) {
            /// reg_icache_clk_on
            ICACHE_CLK_ON: u1,
            /// reg_icache_reset
            ICACHE_RESET: u1,
            /// reg_dcache_clk_on
            DCACHE_CLK_ON: u1,
            /// reg_dcache_reset
            DCACHE_RESET: u1,
            padding: u28,
        }),
        /// SYSTEM_EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_REG
        EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL: mmio.Mmio(packed struct(u32) {
            /// reg_enable_spi_manual_encrypt
            ENABLE_SPI_MANUAL_ENCRYPT: u1,
            /// reg_enable_download_db_encrypt
            ENABLE_DOWNLOAD_DB_ENCRYPT: u1,
            /// reg_enable_download_g0cb_decrypt
            ENABLE_DOWNLOAD_G0CB_DECRYPT: u1,
            /// reg_enable_download_manual_encrypt
            ENABLE_DOWNLOAD_MANUAL_ENCRYPT: u1,
            padding: u28,
        }),
        /// fast memory config register
        RTC_FASTMEM_CONFIG: mmio.Mmio(packed struct(u32) {
            reserved8: u8,
            /// reg_rtc_mem_crc_start
            RTC_MEM_CRC_START: u1,
            /// reg_rtc_mem_crc_addr
            RTC_MEM_CRC_ADDR: u11,
            /// reg_rtc_mem_crc_len
            RTC_MEM_CRC_LEN: u11,
            /// reg_rtc_mem_crc_finish
            RTC_MEM_CRC_FINISH: u1,
        }),
        /// reserved
        RTC_FASTMEM_CRC: mmio.Mmio(packed struct(u32) {
            /// reg_rtc_mem_crc_res
            RTC_MEM_CRC_RES: u32,
        }),
        /// eco register
        REDUNDANT_ECO_CTRL: mmio.Mmio(packed struct(u32) {
            /// reg_redundant_eco_drive
            REDUNDANT_ECO_DRIVE: u1,
            /// reg_redundant_eco_result
            REDUNDANT_ECO_RESULT: u1,
            padding: u30,
        }),
        /// clock gating register
        CLOCK_GATE: mmio.Mmio(packed struct(u32) {
            /// reg_clk_en
            CLK_EN: u1,
            padding: u31,
        }),
        /// system clock config register
        SYSCLK_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_pre_div_cnt
            PRE_DIV_CNT: u10,
            /// reg_soc_clk_sel
            SOC_CLK_SEL: u2,
            /// reg_clk_xtal_freq
            CLK_XTAL_FREQ: u7,
            /// reg_clk_div_en
            CLK_DIV_EN: u1,
            padding: u12,
        }),
        /// mem pvt register
        MEM_PVT: mmio.Mmio(packed struct(u32) {
            /// reg_mem_path_len
            MEM_PATH_LEN: u4,
            /// reg_mem_err_cnt_clr
            MEM_ERR_CNT_CLR: u1,
            /// reg_mem_pvt_monitor_en
            MONITOR_EN: u1,
            /// reg_mem_timing_err_cnt
            MEM_TIMING_ERR_CNT: u16,
            /// reg_mem_vt_sel
            MEM_VT_SEL: u2,
            padding: u8,
        }),
        /// mem pvt register
        COMB_PVT_LVT_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_comb_path_len_lvt
            COMB_PATH_LEN_LVT: u5,
            /// reg_comb_err_cnt_clr_lvt
            COMB_ERR_CNT_CLR_LVT: u1,
            /// reg_comb_pvt_monitor_en_lvt
            COMB_PVT_MONITOR_EN_LVT: u1,
            padding: u25,
        }),
        /// mem pvt register
        COMB_PVT_NVT_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_comb_path_len_nvt
            COMB_PATH_LEN_NVT: u5,
            /// reg_comb_err_cnt_clr_nvt
            COMB_ERR_CNT_CLR_NVT: u1,
            /// reg_comb_pvt_monitor_en_nvt
            COMB_PVT_MONITOR_EN_NVT: u1,
            padding: u25,
        }),
        /// mem pvt register
        COMB_PVT_HVT_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_comb_path_len_hvt
            COMB_PATH_LEN_HVT: u5,
            /// reg_comb_err_cnt_clr_hvt
            COMB_ERR_CNT_CLR_HVT: u1,
            /// reg_comb_pvt_monitor_en_hvt
            COMB_PVT_MONITOR_EN_HVT: u1,
            padding: u25,
        }),
        /// mem pvt register
        COMB_PVT_ERR_LVT_SITE0: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_lvt_site0
            COMB_TIMING_ERR_CNT_LVT_SITE0: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_NVT_SITE0: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_nvt_site0
            COMB_TIMING_ERR_CNT_NVT_SITE0: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_HVT_SITE0: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_hvt_site0
            COMB_TIMING_ERR_CNT_HVT_SITE0: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_LVT_SITE1: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_lvt_site1
            COMB_TIMING_ERR_CNT_LVT_SITE1: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_NVT_SITE1: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_nvt_site1
            COMB_TIMING_ERR_CNT_NVT_SITE1: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_HVT_SITE1: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_hvt_site1
            COMB_TIMING_ERR_CNT_HVT_SITE1: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_LVT_SITE2: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_lvt_site2
            COMB_TIMING_ERR_CNT_LVT_SITE2: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_NVT_SITE2: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_nvt_site2
            COMB_TIMING_ERR_CNT_NVT_SITE2: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_HVT_SITE2: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_hvt_site2
            COMB_TIMING_ERR_CNT_HVT_SITE2: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_LVT_SITE3: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_lvt_site3
            COMB_TIMING_ERR_CNT_LVT_SITE3: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_NVT_SITE3: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_nvt_site3
            COMB_TIMING_ERR_CNT_NVT_SITE3: u16,
            padding: u16,
        }),
        /// mem pvt register
        COMB_PVT_ERR_HVT_SITE3: mmio.Mmio(packed struct(u32) {
            /// reg_comb_timing_err_cnt_hvt_site3
            COMB_TIMING_ERR_CNT_HVT_SITE3: u16,
            padding: u16,
        }),
        reserved4092: [3936]u8,
        /// Version register
        SYSTEM_REG_DATE: mmio.Mmio(packed struct(u32) {
            /// reg_system_reg_date
            SYSTEM_REG_DATE: u28,
            padding: u4,
        }),
    };
};
