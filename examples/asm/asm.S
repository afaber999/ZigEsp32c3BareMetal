    .section .text
    .global add_numbers
    .global inc_glob_counts
    .global led_on
    .global led_off


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

# Function: int add_numbers(int a, int b)
# Arguments:
#   a - Passed in register a0
#   b - Passed in register a1
# Return Value:
#   Sum of a and b, returned in register a0

add_numbers:
    add a0, a0, a1  # Add the values in registers a0 and a1, store result in a0
    ret             # Return to the caller



inc_glob_counts:
    # Save registers used by the ISR
    addi sp, sp, -8        # Allocate stack space for 2 registers
    sw t0, 0(sp)           # Save t0 to stack
    sw t1, 4(sp)           # Save t1 to stack

    la t0, glob_counts     # Load the address of num_isrs into t0
    lw t1, 0(t0)           # Load the current value of num_isrs into t1
    addi t1, t1, 1         # Increment the value in t1 by 1
    sw t1, 0(t0)           # Store the incremented value back to num_isrs

    # Restore saved registers
    lw t0, 0(sp)           # Restore t0 from stack
    lw t1, 4(sp)           # Restore t1 from stack
    addi sp, sp, 8         # Deallocate stack space

    ret

// Declare the global variable defined in assembly
//extern var glob_counts: i32;
    .section .data
    .global glob_counts

# Define a global variable `my_global_var` initialized to 42
glob_counts:
    .word 42