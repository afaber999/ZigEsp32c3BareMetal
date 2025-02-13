.section .text
.global _isr_handler_01
.global _isr_handler_02
.global num_ints

_isr_handler_01:
    # call isr_main   # Call the Zig function for handling interrupts
    
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
    la t0, num_ints        # Load the address of num_ints array into t0
    lw t1, 4*1(t0)         # Load the current value of num_ints[1] into t1
    addi t1, t1, 1         # Increment the value in t1 by 1
    sw t1, 4*1(t0)         # Store the incremented value back to num_ints[1]

    # Clear interrupt level (CPU_INTR_FROM_CPU_0 ) 0x600C0028
    lui t0, 0x600C0        # Load upper 20 bits of 0x600C0000
    addi t0, t0, 0x028     # Add the lower 12 bits (0x028)
    sw x0, 0(t0)           # Store word (0) at the address in t0

    # Clear interrupt level (CPU_INTR_FROM_CPU_1 ) 0x600C002C
    lui t0, 0x600C0        # Load upper 20 bits of 0x600C0000
    addi t0, t0, 0x02C     # Add the lower 12 bits (0x02c)
    sw x0, 0(t0)           # Store word (0) at the address in t0


    # Restore saved registers
    lw t0, 0(sp)           # Restore t0 from stack
    lw t1, 4(sp)           # Restore t1 from stack
    addi sp, sp, 8         # Deallocate stack space
    # AS INTERRUPT ret
    mret

_isr_handler_02:
    # Save registers used by the ISR
    addi sp, sp, -8      # Allocate stack space for 2 registers
    sw t0, 0(sp)         # Save t0 to stack
    sw t1, 4(sp)         # Save t1 to stack

    # increment num_isrs
    la t0, num_ints        # Load the address of num_ints array into t0
    lw t1, 4*2(t0)         # Load the current value of num_ints[1] into t1
    addi t1, t1, 1         # Increment the value in t1 by 1
    sw t1, 4*2(t0)         # Store the incremented value back to num_ints[1]

    # Clear interrupt of systimer unit 0 (SYSTIMER_INT_CLR) 0x6002306C
    lui	t0,0x60023
    lw	t1,108(t0) # 6002306c <_c3_heap_start+0x1e022d6c>
    or	t1,t1,1
    sw	t1,108(t0)

    lui t0, 0x600C0        # Load upper 20 bits of 0x600C0000
    addi t0, t0, 0x028     # Add the lower 12 bits (0x028)
    sw x0, 0(t0)           # Store word (0) at the address in t0

    # Restore saved registers
    lw t0, 0(sp)           # Restore t0 from stack
    lw t1, 4(sp)           # Restore t1 from stack
    addi sp, sp, 8         # Deallocate stack space
    mret

.section .data

# Define a global variable `num_isrs` initialized to 42
# Define an array of 32 num_ints, each initialized to 0
num_ints:
    .space 32 * 4  # Allocate space for 32 words (4 bytes each)
