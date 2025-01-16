.section .text
.global cpu0_isr_handler
.global _num_isrs
.global _mtvec_table

.weak _panic_handler
.weak _isr_handler_01
.weak _isr_handler_02
.weak _isr_handler_03
.weak _isr_handler_04
.weak _isr_handler_05
.weak _isr_handler_06
.weak _isr_handler_07
.weak _isr_handler_08
.weak _isr_handler_09
.weak _isr_handler_10
.weak _isr_handler_11
.weak _isr_handler_12
.weak _isr_handler_13
.weak _isr_handler_14
.weak _isr_handler_15
.weak _isr_handler_16
.weak _isr_handler_17
.weak _isr_handler_18
.weak _isr_handler_19
.weak _isr_handler_20
.weak _isr_handler_21
.weak _isr_handler_22
.weak _isr_handler_23
.weak _isr_handler_24
.weak _isr_handler_25
.weak _isr_handler_26
.weak _isr_handler_27
.weak _isr_handler_28
.weak _isr_handler_29
.weak _isr_handler_30
.weak _isr_handler_31


_panic_handler:
_isr_handler_01:
_isr_handler_02:
_isr_handler_03:
_isr_handler_04:
_isr_handler_05:
_isr_handler_06:
_isr_handler_07:
_isr_handler_08:
_isr_handler_09:
_isr_handler_10:
_isr_handler_11:
_isr_handler_12:
_isr_handler_13:
_isr_handler_14:
_isr_handler_15:
_isr_handler_16:
_isr_handler_17:
_isr_handler_18:
_isr_handler_19:
_isr_handler_20:
_isr_handler_21:
_isr_handler_22:
_isr_handler_23:
_isr_handler_24:
_isr_handler_25:
_isr_handler_26:
_isr_handler_27:
_isr_handler_28:
_isr_handler_29:
_isr_handler_30:
_isr_handler_31:
        lui a0,0x60004
        lw a1,4(a0) # 60004004"
        or a1,a1,512
        sw a1,4(a0)
        j _panic_handler

.section .mtvec_table, "ax", %progbits
.align(8)
_mtvec_table:
    jal zero, _panic_handler
    jal zero, _isr_handler_01
    jal zero, _isr_handler_02
    jal zero, _isr_handler_03
    jal zero, _isr_handler_04
    jal zero, _isr_handler_05
    jal zero, _isr_handler_06
    jal zero, _isr_handler_07
    jal zero, _isr_handler_08
    jal zero, _isr_handler_09
    jal zero, _isr_handler_10
    jal zero, _isr_handler_11
    jal zero, _isr_handler_12
    jal zero, _isr_handler_13
    jal zero, _isr_handler_14
    jal zero, _isr_handler_15
    jal zero, _isr_handler_16
    jal zero, _isr_handler_17
    jal zero, _isr_handler_18
    jal zero, _isr_handler_19
    jal zero, _isr_handler_20
    jal zero, _isr_handler_21
    jal zero, _isr_handler_22
    jal zero, _isr_handler_23
    jal zero, _isr_handler_24
    jal zero, _isr_handler_25
    jal zero, _isr_handler_26
    jal zero, _isr_handler_27
    jal zero, _isr_handler_28
    jal zero, _isr_handler_29
    jal zero, _isr_handler_30
    jal zero, _isr_handler_31

.section .data

# Define a global variable `num_isrs` initialized to 42
_num_isrs:
    .word 0
