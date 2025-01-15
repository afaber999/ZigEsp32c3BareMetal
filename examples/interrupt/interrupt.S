.section .text
    .global isr_handler
    .global led_on
    .global led_off
        
; # This assembly function redirects to a Zig-defined function
; isr_handler:
; sub_handler:
;     # call isr_main   # Call the Zig function for handling interrupts
    
;     # Save registers used by the ISR
;     addi sp, sp, -8      # Allocate stack space for 2 registers
;     sw t0, 0(sp)         # Save t0 to stack
;     sw t1, 4(sp)         # Save t1 to stack

;     # LED ON
;     lui	t0,0x60004
;     lw	t1,4(t0) # 60004004 <_c3_data_load_start+0x1e003f24>
;     or	t1,t1,512
;     sw	t1,4(t0)

;     # increment num_isrs
;     la t0, num_isrs        # Load the address of num_isrs into t0
;     lw t1, 0(t0)           # Load the current value of num_isrs into t1
;     addi t1, t1, 1         # Increment the value in t1 by 1
;     sw t1, 0(t0)           # Store the incremented value back to num_isrs

;     # loop_x:
;     #    j loop_x

;     # Clear interrupt level (CPU_INTR_FROM_CPU_0 ) 0x600C0028
;     lui t0, 0x600C0        # Load upper 20 bits of 0x600C0000
;     addi t0, t0, 0x028     # Add the lower 12 bits (0x028)
;     sw x0, 0(t0)           # Store word (0) at the address in t0

;     # Restore saved registers
;     lw t0, 0(sp)           # Restore t0 from stack
;     lw t1, 4(sp)           # Restore t1 from stack
;     addi sp, sp, 8         # Deallocate stack space
;     # AS INTERRUPT ret
;     mret



;     # Load the address 0x600C002B
;     lui t0, 0x600C0        # Load upper 20 bits of 0x600C0000
;     addi t0, t0, 0x02B     # Add the lower 12 bits (0x02B)

;     # Store 0 to the address using x0 to clear the interrupt flag
;     sw x0, 0(t0)           # Store word (0) at the address in t0

;     la t0, num_isrs        # Load the address of num_isrs into t0
;     lw t1, 0(t0)           # Load the current value of num_isrs into t1
;     addi t1, t1, 1         # Increment the value in t1 by 1
;     sw t1, 0(t0)           # Store the incremented value back to num_isrs

;     # Restore saved registers
;     lw t0, 0(sp)           # Restore t0 from stack
;     lw t1, 4(sp)           # Restore t1 from stack
;     addi sp, sp, 8         # Deallocate stack space
;     ret
;     //mret                   # Return from machine mode

.section .data
    .global num_isrs

# Define a global variable `num_isrs` initialized to 42
num_isrs:
    .word 42


.section .text.isr_handler

    /* This is the vector table. MTVEC points here.
     *
     * Use 4-byte intructions here. 1 instruction = 1 entry of the table.
     * The CPU jumps to MTVEC (i.e. the first entry) in case of an exception,
     * and (MTVEC & 0xfffffffc) + (mcause & 0x7fffffff) * 4, in case of an interrupt.
    ;.balign 0x100
     */
    .global _vector_table
    .type _vector_table, @function
_vector_table:
    .option push
    .option norvc
    j _panic_handler            /* exception handler, entry 0 */
    .rept 31
    j _interrupt_handler        /* 31 identical entries, all pointing to the interrupt handler */
    .endr
    .option pop
    .size _vector_table, .-_vector_table



    /* This should be the exception handler.
     * It doesn't do anything useful yet, but you can set a breakpoint here, to see if an exception happens.
    ;.balign 0x04
     */
    .global _panic_handler
    .type _panic_handler, @function
     .align 2
_panic_handler:
    # LED ON
    lui	t0,0x60004
    lw	t1,4(t0) # 60004004 <_c3_data_load_start+0x1e003f24>
    or	t1,t1,512
    sw	t1,4(t0)

    j _panic_handler
    .size  _panic_handler, .-_panic_handler

    /* This is the interrupt handler.
     * It is declared as a weak function, and can be overridden.
    ;.balign 0x04
     */
    .global _interrupt_handler
    .weak _interrupt_handler
    .type _interrupt_handler, @function
_interrupt_handler:
    # Save registers used by the ISR
    addi sp, sp, -8      # Allocate stack space for 2 registers
    sw t0, 0(sp)         # Save t0 to stack
    sw t1, 4(sp)         # Save t1 to stack

    # LED ON
    lui	t0,0x60004
    lw	t1,4(t0) # 60004004 <_c3_data_load_start+0x1e003f24>
    or	t1,t1,512
    sw	t1,4(t0)

    # increment num_isrs
    la t0, num_isrs        # Load the address of num_isrs into t0
    lw t1, 0(t0)           # Load the current value of num_isrs into t1
    addi t1, t1, 1         # Increment the value in t1 by 1
    sw t1, 0(t0)           # Store the incremented value back to num_isrs

    # loop_x:
    #    j loop_x

    # Clear interrupt level (CPU_INTR_FROM_CPU_0 ) 0x600C0028
    lui t0, 0x600C0        # Load upper 20 bits of 0x600C0000
    addi t0, t0, 0x028     # Add the lower 12 bits (0x028)
    sw x0, 0(t0)           # Store word (0) at the address in t0

    # Restore saved registers
    lw t0, 0(sp)           # Restore t0 from stack
    lw t1, 4(sp)           # Restore t1 from stack
    addi sp, sp, 8         # Deallocate stack space
    # AS INTERRUPT ret
    mret
    .size  _interrupt_handler, .-_interrupt_handler


led_on:
    lui	a0,0x60004
    lw	a1,4(a0) # 60004004 <_c3_data_load_start+0x1e003f24>
    or	a1,a1,512
    sw	a1,4(a0)
    ret
    
led_off:
    lui	a0,0x60004
    lw	a1,4(a0) # 60004004 <_c3_data_load_start+0x1e003f24>
    andi	a1,a1,-513
    sw	a1,4(a0)
    ret