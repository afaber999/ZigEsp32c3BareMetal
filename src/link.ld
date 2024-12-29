MEMORY {
	flash (rx): ORIGIN = 0x42000000,  LENGTH = 4M
	iram  (rx): ORIGIN = 0x40380000,  LENGTH = 192k
	dram  (rw): ORIGIN = 0x3FC80000 + LENGTH(iram), LENGTH = 192k}

ENTRY(_start);

SECTIONS {
  .text     : { 
    KEEP(*(.text.start))
    *(.text) *(.text*) } > iram

  .data : {
    . = ALIGN(16);
    _sdata = .;
    *(.data)
    *(.data*)
    *(.sdata)
    *(.sdata*)
    *(.srodata)
    *(.srodata*)
    *(.rodata)
    *(.rodata*)
    . = ALIGN(16);
    _edata = .;
  } > dram

  .bss (NOLOAD): {
    . = ALIGN(16);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(.sbss)
    *(.sbss*)
    *(COMMON)
    . = ALIGN(16);
    _ebss = .;
  } > dram

  . = ALIGN(16);
  PROVIDE(end = .);
  PROVIDE(_end = .);
}

__stack_top = ORIGIN(dram) + LENGTH(dram);