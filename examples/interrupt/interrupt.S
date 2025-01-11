.section .text
    .global isr_handler

# This assembly function redirects to a Zig-defined function
isr_handler:
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

    # Load the address 0x600C002B
    lui t0, 0x600C0        # Load upper 20 bits of 0x600C0000
    addi t0, t0, 0x02B     # Add the lower 12 bits (0x02B)

    # Store 0 to the address using x0 to clear the interrupt flag
    sw x0, 0(t0)           # Store word (0) at the address in t0

    la t0, num_isrs        # Load the address of num_isrs into t0
    lw t1, 0(t0)           # Load the current value of num_isrs into t1
    addi t1, t1, 1         # Increment the value in t1 by 1
    sw t1, 0(t0)           # Store the incremented value back to num_isrs

    # Restore saved registers
    lw t0, 0(sp)           # Restore t0 from stack
    lw t1, 4(sp)           # Restore t1 from stack
    addi sp, sp, 8         # Deallocate stack space

    mret                   # Return from machine mode

.section .data
    .global num_isrs

# Define a global variable `num_isrs` initialized to 42
num_isrs:
    .word 42