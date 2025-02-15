const std = @import("std");
const mmio = @import("mmio.zig");

pub const ptr: *volatile types.LEDC = @ptrFromInt(0x60019000);

pub const types = struct {
    /// LED Control PWM (Pulse Width Modulation)
    pub const LEDC = extern struct {
        /// LEDC_LSCH0_CONF0.
        LSCH0_CONF0: mmio.Mmio(packed struct(u32) {
            /// reg_timer_sel_lsch0.
            TIMER_SEL_LSCH0: u2,
            /// reg_sig_out_en_lsch0.
            SIG_OUT_EN_LSCH0: u1,
            /// reg_idle_lv_lsch0.
            IDLE_LV_LSCH0: u1,
            /// reg_para_up_lsch0.
            PARA_UP_LSCH0: u1,
            /// reg_ovf_num_lsch0.
            OVF_NUM_LSCH0: u10,
            /// reg_ovf_cnt_en_lsch0.
            OVF_CNT_EN_LSCH0: u1,
            /// reg_ovf_cnt_reset_lsch0.
            OVF_CNT_RESET_LSCH0: u1,
            padding: u15,
        }),
        /// LEDC_LSCH0_HPOINT.
        LSCH0_HPOINT: mmio.Mmio(packed struct(u32) {
            /// reg_hpoint_lsch0.
            HPOINT_LSCH0: u14,
            padding: u18,
        }),
        /// LEDC_LSCH0_DUTY.
        LSCH0_DUTY: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch0.
            DUTY_LSCH0: u19,
            padding: u13,
        }),
        /// LEDC_LSCH0_CONF1.
        LSCH0_CONF1: mmio.Mmio(packed struct(u32) {
            /// reg_duty_scale_lsch0.
            DUTY_SCALE_LSCH0: u10,
            /// reg_duty_cycle_lsch0.
            DUTY_CYCLE_LSCH0: u10,
            /// reg_duty_num_lsch0.
            DUTY_NUM_LSCH0: u10,
            /// reg_duty_inc_lsch0.
            DUTY_INC_LSCH0: u1,
            /// reg_duty_start_lsch0.
            DUTY_START_LSCH0: u1,
        }),
        /// LEDC_LSCH0_DUTY_R.
        LSCH0_DUTY_R: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch0_r.
            DUTY_LSCH0_R: u19,
            padding: u13,
        }),
        /// LEDC_LSCH1_CONF0.
        LSCH1_CONF0: mmio.Mmio(packed struct(u32) {
            /// reg_timer_sel_lsch1.
            TIMER_SEL_LSCH1: u2,
            /// reg_sig_out_en_lsch1.
            SIG_OUT_EN_LSCH1: u1,
            /// reg_idle_lv_lsch1.
            IDLE_LV_LSCH1: u1,
            /// reg_para_up_lsch1.
            PARA_UP_LSCH1: u1,
            /// reg_ovf_num_lsch1.
            OVF_NUM_LSCH1: u10,
            /// reg_ovf_cnt_en_lsch1.
            OVF_CNT_EN_LSCH1: u1,
            /// reg_ovf_cnt_reset_lsch1.
            OVF_CNT_RESET_LSCH1: u1,
            padding: u15,
        }),
        /// LEDC_LSCH1_HPOINT.
        LSCH1_HPOINT: mmio.Mmio(packed struct(u32) {
            /// reg_hpoint_lsch1.
            HPOINT_LSCH1: u14,
            padding: u18,
        }),
        /// LEDC_LSCH1_DUTY.
        LSCH1_DUTY: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch1.
            DUTY_LSCH1: u19,
            padding: u13,
        }),
        /// LEDC_LSCH1_CONF1.
        LSCH1_CONF1: mmio.Mmio(packed struct(u32) {
            /// reg_duty_scale_lsch1.
            DUTY_SCALE_LSCH1: u10,
            /// reg_duty_cycle_lsch1.
            DUTY_CYCLE_LSCH1: u10,
            /// reg_duty_num_lsch1.
            DUTY_NUM_LSCH1: u10,
            /// reg_duty_inc_lsch1.
            DUTY_INC_LSCH1: u1,
            /// reg_duty_start_lsch1.
            DUTY_START_LSCH1: u1,
        }),
        /// LEDC_LSCH1_DUTY_R.
        LSCH1_DUTY_R: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch1_r.
            DUTY_LSCH1_R: u19,
            padding: u13,
        }),
        /// LEDC_LSCH2_CONF0.
        LSCH2_CONF0: mmio.Mmio(packed struct(u32) {
            /// reg_timer_sel_lsch2.
            TIMER_SEL_LSCH2: u2,
            /// reg_sig_out_en_lsch2.
            SIG_OUT_EN_LSCH2: u1,
            /// reg_idle_lv_lsch2.
            IDLE_LV_LSCH2: u1,
            /// reg_para_up_lsch2.
            PARA_UP_LSCH2: u1,
            /// reg_ovf_num_lsch2.
            OVF_NUM_LSCH2: u10,
            /// reg_ovf_cnt_en_lsch2.
            OVF_CNT_EN_LSCH2: u1,
            /// reg_ovf_cnt_reset_lsch2.
            OVF_CNT_RESET_LSCH2: u1,
            padding: u15,
        }),
        /// LEDC_LSCH2_HPOINT.
        LSCH2_HPOINT: mmio.Mmio(packed struct(u32) {
            /// reg_hpoint_lsch2.
            HPOINT_LSCH2: u14,
            padding: u18,
        }),
        /// LEDC_LSCH2_DUTY.
        LSCH2_DUTY: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch2.
            DUTY_LSCH2: u19,
            padding: u13,
        }),
        /// LEDC_LSCH2_CONF1.
        LSCH2_CONF1: mmio.Mmio(packed struct(u32) {
            /// reg_duty_scale_lsch2.
            DUTY_SCALE_LSCH2: u10,
            /// reg_duty_cycle_lsch2.
            DUTY_CYCLE_LSCH2: u10,
            /// reg_duty_num_lsch2.
            DUTY_NUM_LSCH2: u10,
            /// reg_duty_inc_lsch2.
            DUTY_INC_LSCH2: u1,
            /// reg_duty_start_lsch2.
            DUTY_START_LSCH2: u1,
        }),
        /// LEDC_LSCH2_DUTY_R.
        LSCH2_DUTY_R: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch2_r.
            DUTY_LSCH2_R: u19,
            padding: u13,
        }),
        /// LEDC_LSCH3_CONF0.
        LSCH3_CONF0: mmio.Mmio(packed struct(u32) {
            /// reg_timer_sel_lsch3.
            TIMER_SEL_LSCH3: u2,
            /// reg_sig_out_en_lsch3.
            SIG_OUT_EN_LSCH3: u1,
            /// reg_idle_lv_lsch3.
            IDLE_LV_LSCH3: u1,
            /// reg_para_up_lsch3.
            PARA_UP_LSCH3: u1,
            /// reg_ovf_num_lsch3.
            OVF_NUM_LSCH3: u10,
            /// reg_ovf_cnt_en_lsch3.
            OVF_CNT_EN_LSCH3: u1,
            /// reg_ovf_cnt_reset_lsch3.
            OVF_CNT_RESET_LSCH3: u1,
            padding: u15,
        }),
        /// LEDC_LSCH3_HPOINT.
        LSCH3_HPOINT: mmio.Mmio(packed struct(u32) {
            /// reg_hpoint_lsch3.
            HPOINT_LSCH3: u14,
            padding: u18,
        }),
        /// LEDC_LSCH3_DUTY.
        LSCH3_DUTY: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch3.
            DUTY_LSCH3: u19,
            padding: u13,
        }),
        /// LEDC_LSCH3_CONF1.
        LSCH3_CONF1: mmio.Mmio(packed struct(u32) {
            /// reg_duty_scale_lsch3.
            DUTY_SCALE_LSCH3: u10,
            /// reg_duty_cycle_lsch3.
            DUTY_CYCLE_LSCH3: u10,
            /// reg_duty_num_lsch3.
            DUTY_NUM_LSCH3: u10,
            /// reg_duty_inc_lsch3.
            DUTY_INC_LSCH3: u1,
            /// reg_duty_start_lsch3.
            DUTY_START_LSCH3: u1,
        }),
        /// LEDC_LSCH3_DUTY_R.
        LSCH3_DUTY_R: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch3_r.
            DUTY_LSCH3_R: u19,
            padding: u13,
        }),
        /// LEDC_LSCH4_CONF0.
        LSCH4_CONF0: mmio.Mmio(packed struct(u32) {
            /// reg_timer_sel_lsch4.
            TIMER_SEL_LSCH4: u2,
            /// reg_sig_out_en_lsch4.
            SIG_OUT_EN_LSCH4: u1,
            /// reg_idle_lv_lsch4.
            IDLE_LV_LSCH4: u1,
            /// reg_para_up_lsch4.
            PARA_UP_LSCH4: u1,
            /// reg_ovf_num_lsch4.
            OVF_NUM_LSCH4: u10,
            /// reg_ovf_cnt_en_lsch4.
            OVF_CNT_EN_LSCH4: u1,
            /// reg_ovf_cnt_reset_lsch4.
            OVF_CNT_RESET_LSCH4: u1,
            padding: u15,
        }),
        /// LEDC_LSCH4_HPOINT.
        LSCH4_HPOINT: mmio.Mmio(packed struct(u32) {
            /// reg_hpoint_lsch4.
            HPOINT_LSCH4: u14,
            padding: u18,
        }),
        /// LEDC_LSCH4_DUTY.
        LSCH4_DUTY: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch4.
            DUTY_LSCH4: u19,
            padding: u13,
        }),
        /// LEDC_LSCH4_CONF1.
        LSCH4_CONF1: mmio.Mmio(packed struct(u32) {
            /// reg_duty_scale_lsch4.
            DUTY_SCALE_LSCH4: u10,
            /// reg_duty_cycle_lsch4.
            DUTY_CYCLE_LSCH4: u10,
            /// reg_duty_num_lsch4.
            DUTY_NUM_LSCH4: u10,
            /// reg_duty_inc_lsch4.
            DUTY_INC_LSCH4: u1,
            /// reg_duty_start_lsch4.
            DUTY_START_LSCH4: u1,
        }),
        /// LEDC_LSCH4_DUTY_R.
        LSCH4_DUTY_R: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch4_r.
            DUTY_LSCH4_R: u19,
            padding: u13,
        }),
        /// LEDC_LSCH5_CONF0.
        LSCH5_CONF0: mmio.Mmio(packed struct(u32) {
            /// reg_timer_sel_lsch5.
            TIMER_SEL_LSCH5: u2,
            /// reg_sig_out_en_lsch5.
            SIG_OUT_EN_LSCH5: u1,
            /// reg_idle_lv_lsch5.
            IDLE_LV_LSCH5: u1,
            /// reg_para_up_lsch5.
            PARA_UP_LSCH5: u1,
            /// reg_ovf_num_lsch5.
            OVF_NUM_LSCH5: u10,
            /// reg_ovf_cnt_en_lsch5.
            OVF_CNT_EN_LSCH5: u1,
            /// reg_ovf_cnt_reset_lsch5.
            OVF_CNT_RESET_LSCH5: u1,
            padding: u15,
        }),
        /// LEDC_LSCH5_HPOINT.
        LSCH5_HPOINT: mmio.Mmio(packed struct(u32) {
            /// reg_hpoint_lsch5.
            HPOINT_LSCH5: u14,
            padding: u18,
        }),
        /// LEDC_LSCH5_DUTY.
        LSCH5_DUTY: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch5.
            DUTY_LSCH5: u19,
            padding: u13,
        }),
        /// LEDC_LSCH5_CONF1.
        LSCH5_CONF1: mmio.Mmio(packed struct(u32) {
            /// reg_duty_scale_lsch5.
            DUTY_SCALE_LSCH5: u10,
            /// reg_duty_cycle_lsch5.
            DUTY_CYCLE_LSCH5: u10,
            /// reg_duty_num_lsch5.
            DUTY_NUM_LSCH5: u10,
            /// reg_duty_inc_lsch5.
            DUTY_INC_LSCH5: u1,
            /// reg_duty_start_lsch5.
            DUTY_START_LSCH5: u1,
        }),
        /// LEDC_LSCH5_DUTY_R.
        LSCH5_DUTY_R: mmio.Mmio(packed struct(u32) {
            /// reg_duty_lsch5_r.
            DUTY_LSCH5_R: u19,
            padding: u13,
        }),
        reserved160: [40]u8,
        /// LEDC_LSTIMER0_CONF.
        LSTIMER0_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer0_duty_res.
            LSTIMER0_DUTY_RES: u4,
            /// reg_clk_div_lstimer0.
            CLK_DIV_LSTIMER0: u18,
            /// reg_lstimer0_pause.
            LSTIMER0_PAUSE: u1,
            /// reg_lstimer0_rst.
            LSTIMER0_RST: u1,
            /// reg_tick_sel_lstimer0.
            TICK_SEL_LSTIMER0: u1,
            /// reg_lstimer0_para_up.
            LSTIMER0_PARA_UP: u1,
            padding: u6,
        }),
        /// LEDC_LSTIMER0_VALUE.
        LSTIMER0_VALUE: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer0_cnt.
            LSTIMER0_CNT: u14,
            padding: u18,
        }),
        /// LEDC_LSTIMER1_CONF.
        LSTIMER1_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer1_duty_res.
            LSTIMER1_DUTY_RES: u4,
            /// reg_clk_div_lstimer1.
            CLK_DIV_LSTIMER1: u18,
            /// reg_lstimer1_pause.
            LSTIMER1_PAUSE: u1,
            /// reg_lstimer1_rst.
            LSTIMER1_RST: u1,
            /// reg_tick_sel_lstimer1.
            TICK_SEL_LSTIMER1: u1,
            /// reg_lstimer1_para_up.
            LSTIMER1_PARA_UP: u1,
            padding: u6,
        }),
        /// LEDC_LSTIMER1_VALUE.
        LSTIMER1_VALUE: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer1_cnt.
            LSTIMER1_CNT: u14,
            padding: u18,
        }),
        /// LEDC_LSTIMER2_CONF.
        LSTIMER2_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer2_duty_res.
            LSTIMER2_DUTY_RES: u4,
            /// reg_clk_div_lstimer2.
            CLK_DIV_LSTIMER2: u18,
            /// reg_lstimer2_pause.
            LSTIMER2_PAUSE: u1,
            /// reg_lstimer2_rst.
            LSTIMER2_RST: u1,
            /// reg_tick_sel_lstimer2.
            TICK_SEL_LSTIMER2: u1,
            /// reg_lstimer2_para_up.
            LSTIMER2_PARA_UP: u1,
            padding: u6,
        }),
        /// LEDC_LSTIMER2_VALUE.
        LSTIMER2_VALUE: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer2_cnt.
            LSTIMER2_CNT: u14,
            padding: u18,
        }),
        /// LEDC_LSTIMER3_CONF.
        LSTIMER3_CONF: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer3_duty_res.
            LSTIMER3_DUTY_RES: u4,
            /// reg_clk_div_lstimer3.
            CLK_DIV_LSTIMER3: u18,
            /// reg_lstimer3_pause.
            LSTIMER3_PAUSE: u1,
            /// reg_lstimer3_rst.
            LSTIMER3_RST: u1,
            /// reg_tick_sel_lstimer3.
            TICK_SEL_LSTIMER3: u1,
            /// reg_lstimer3_para_up.
            LSTIMER3_PARA_UP: u1,
            padding: u6,
        }),
        /// LEDC_LSTIMER3_VALUE.
        LSTIMER3_VALUE: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer3_cnt.
            LSTIMER3_CNT: u14,
            padding: u18,
        }),
        /// LEDC_INT_RAW.
        INT_RAW: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer0_ovf_int_raw.
            LSTIMER0_OVF_INT_RAW: u1,
            /// reg_lstimer1_ovf_int_raw.
            LSTIMER1_OVF_INT_RAW: u1,
            /// reg_lstimer2_ovf_int_raw.
            LSTIMER2_OVF_INT_RAW: u1,
            /// reg_lstimer3_ovf_int_raw.
            LSTIMER3_OVF_INT_RAW: u1,
            /// reg_duty_chng_end_lsch0_int_raw.
            DUTY_CHNG_END_LSCH0_INT_RAW: u1,
            /// reg_duty_chng_end_lsch1_int_raw.
            DUTY_CHNG_END_LSCH1_INT_RAW: u1,
            /// reg_duty_chng_end_lsch2_int_raw.
            DUTY_CHNG_END_LSCH2_INT_RAW: u1,
            /// reg_duty_chng_end_lsch3_int_raw.
            DUTY_CHNG_END_LSCH3_INT_RAW: u1,
            /// reg_duty_chng_end_lsch4_int_raw.
            DUTY_CHNG_END_LSCH4_INT_RAW: u1,
            /// reg_duty_chng_end_lsch5_int_raw.
            DUTY_CHNG_END_LSCH5_INT_RAW: u1,
            /// reg_ovf_cnt_lsch0_int_raw.
            OVF_CNT_LSCH0_INT_RAW: u1,
            /// reg_ovf_cnt_lsch1_int_raw.
            OVF_CNT_LSCH1_INT_RAW: u1,
            /// reg_ovf_cnt_lsch2_int_raw.
            OVF_CNT_LSCH2_INT_RAW: u1,
            /// reg_ovf_cnt_lsch3_int_raw.
            OVF_CNT_LSCH3_INT_RAW: u1,
            /// reg_ovf_cnt_lsch4_int_raw.
            OVF_CNT_LSCH4_INT_RAW: u1,
            /// reg_ovf_cnt_lsch5_int_raw.
            OVF_CNT_LSCH5_INT_RAW: u1,
            padding: u16,
        }),
        /// LEDC_INT_ST.
        INT_ST: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer0_ovf_int_st.
            LSTIMER0_OVF_INT_ST: u1,
            /// reg_lstimer1_ovf_int_st.
            LSTIMER1_OVF_INT_ST: u1,
            /// reg_lstimer2_ovf_int_st.
            LSTIMER2_OVF_INT_ST: u1,
            /// reg_lstimer3_ovf_int_st.
            LSTIMER3_OVF_INT_ST: u1,
            /// reg_duty_chng_end_lsch0_int_st.
            DUTY_CHNG_END_LSCH0_INT_ST: u1,
            /// reg_duty_chng_end_lsch1_int_st.
            DUTY_CHNG_END_LSCH1_INT_ST: u1,
            /// reg_duty_chng_end_lsch2_int_st.
            DUTY_CHNG_END_LSCH2_INT_ST: u1,
            /// reg_duty_chng_end_lsch3_int_st.
            DUTY_CHNG_END_LSCH3_INT_ST: u1,
            /// reg_duty_chng_end_lsch4_int_st.
            DUTY_CHNG_END_LSCH4_INT_ST: u1,
            /// reg_duty_chng_end_lsch5_int_st.
            DUTY_CHNG_END_LSCH5_INT_ST: u1,
            /// reg_ovf_cnt_lsch0_int_st.
            OVF_CNT_LSCH0_INT_ST: u1,
            /// reg_ovf_cnt_lsch1_int_st.
            OVF_CNT_LSCH1_INT_ST: u1,
            /// reg_ovf_cnt_lsch2_int_st.
            OVF_CNT_LSCH2_INT_ST: u1,
            /// reg_ovf_cnt_lsch3_int_st.
            OVF_CNT_LSCH3_INT_ST: u1,
            /// reg_ovf_cnt_lsch4_int_st.
            OVF_CNT_LSCH4_INT_ST: u1,
            /// reg_ovf_cnt_lsch5_int_st.
            OVF_CNT_LSCH5_INT_ST: u1,
            padding: u16,
        }),
        /// LEDC_INT_ENA.
        INT_ENA: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer0_ovf_int_ena.
            LSTIMER0_OVF_INT_ENA: u1,
            /// reg_lstimer1_ovf_int_ena.
            LSTIMER1_OVF_INT_ENA: u1,
            /// reg_lstimer2_ovf_int_ena.
            LSTIMER2_OVF_INT_ENA: u1,
            /// reg_lstimer3_ovf_int_ena.
            LSTIMER3_OVF_INT_ENA: u1,
            /// reg_duty_chng_end_lsch0_int_ena.
            DUTY_CHNG_END_LSCH0_INT_ENA: u1,
            /// reg_duty_chng_end_lsch1_int_ena.
            DUTY_CHNG_END_LSCH1_INT_ENA: u1,
            /// reg_duty_chng_end_lsch2_int_ena.
            DUTY_CHNG_END_LSCH2_INT_ENA: u1,
            /// reg_duty_chng_end_lsch3_int_ena.
            DUTY_CHNG_END_LSCH3_INT_ENA: u1,
            /// reg_duty_chng_end_lsch4_int_ena.
            DUTY_CHNG_END_LSCH4_INT_ENA: u1,
            /// reg_duty_chng_end_lsch5_int_ena.
            DUTY_CHNG_END_LSCH5_INT_ENA: u1,
            /// reg_ovf_cnt_lsch0_int_ena.
            OVF_CNT_LSCH0_INT_ENA: u1,
            /// reg_ovf_cnt_lsch1_int_ena.
            OVF_CNT_LSCH1_INT_ENA: u1,
            /// reg_ovf_cnt_lsch2_int_ena.
            OVF_CNT_LSCH2_INT_ENA: u1,
            /// reg_ovf_cnt_lsch3_int_ena.
            OVF_CNT_LSCH3_INT_ENA: u1,
            /// reg_ovf_cnt_lsch4_int_ena.
            OVF_CNT_LSCH4_INT_ENA: u1,
            /// reg_ovf_cnt_lsch5_int_ena.
            OVF_CNT_LSCH5_INT_ENA: u1,
            padding: u16,
        }),
        /// LEDC_INT_CLR.
        INT_CLR: mmio.Mmio(packed struct(u32) {
            /// reg_lstimer0_ovf_int_clr.
            LSTIMER0_OVF_INT_CLR: u1,
            /// reg_lstimer1_ovf_int_clr.
            LSTIMER1_OVF_INT_CLR: u1,
            /// reg_lstimer2_ovf_int_clr.
            LSTIMER2_OVF_INT_CLR: u1,
            /// reg_lstimer3_ovf_int_clr.
            LSTIMER3_OVF_INT_CLR: u1,
            /// reg_duty_chng_end_lsch0_int_clr.
            DUTY_CHNG_END_LSCH0_INT_CLR: u1,
            /// reg_duty_chng_end_lsch1_int_clr.
            DUTY_CHNG_END_LSCH1_INT_CLR: u1,
            /// reg_duty_chng_end_lsch2_int_clr.
            DUTY_CHNG_END_LSCH2_INT_CLR: u1,
            /// reg_duty_chng_end_lsch3_int_clr.
            DUTY_CHNG_END_LSCH3_INT_CLR: u1,
            /// reg_duty_chng_end_lsch4_int_clr.
            DUTY_CHNG_END_LSCH4_INT_CLR: u1,
            /// reg_duty_chng_end_lsch5_int_clr.
            DUTY_CHNG_END_LSCH5_INT_CLR: u1,
            /// reg_ovf_cnt_lsch0_int_clr.
            OVF_CNT_LSCH0_INT_CLR: u1,
            /// reg_ovf_cnt_lsch1_int_clr.
            OVF_CNT_LSCH1_INT_CLR: u1,
            /// reg_ovf_cnt_lsch2_int_clr.
            OVF_CNT_LSCH2_INT_CLR: u1,
            /// reg_ovf_cnt_lsch3_int_clr.
            OVF_CNT_LSCH3_INT_CLR: u1,
            /// reg_ovf_cnt_lsch4_int_clr.
            OVF_CNT_LSCH4_INT_CLR: u1,
            /// reg_ovf_cnt_lsch5_int_clr.
            OVF_CNT_LSCH5_INT_CLR: u1,
            padding: u16,
        }),
        /// LEDC_CONF.
        CONF: mmio.Mmio(packed struct(u32) {
            /// reg_apb_clk_sel.
            APB_CLK_SEL: u2,
            reserved31: u29,
            /// reg_clk_en.
            CLK_EN: u1,
        }),
        reserved252: [40]u8,
        /// LEDC_DATE.
        DATE: mmio.Mmio(packed struct(u32) {
            /// reg_ledc_date.
            LEDC_DATE: u32,
        }),
    };
};
