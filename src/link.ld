

MEMORY
{
  flash0    (rx!w) : ORIGIN = 0x42000000, LENGTH = 0x00800000
  ram0      (rw!x) : ORIGIN = 0x3FC80000, LENGTH = 0x00060000
}

ENTRY(_start)

SECTIONS
{
  .header : 
  {
    _irom_start = .;
    LONG(0xaedb041d)
    LONG(0xaedb041d)
  } > flash0

  .text :
  {
    _c3_text_start = .;
    KEEP(*(.text.entry))
    *(.text*)
    _c3_text_end = .;
  } > flash0

  .data :
  {
     _c3_data_start = .;
     *(.sdata*)
     *(.data*)
     *(.rodata*)
     _c3_data_end = .;
  } > ram0 AT> flash0

  .bss (NOLOAD) :
  {
      _c3_bss_start = .;
      *(.bss*)
      *(.sbss*)
      _c3_bss_end = .;
  } > ram0

  _end = .; PROVIDE (end = .);

  /* Stack */
  .stack  (NOLOAD) :
  {
    _c3_stack_bottom = .;
    _c3_stack_top = ORIGIN(ram0) + LENGTH(ram0);
    _c3_stack_size_min = 0x4000;
    ASSERT(_c3_stack_bottom + _c3_stack_size_min < _c3_stack_top, "Error: no space for stack");
  }
  
  _c3_data_load_start = LOADADDR(.data);

  /* stack growing down from top of SRAM */
  PROVIDE(_c3_stack_top = ORIGIN(ram0) + LENGTH(ram0));
  PROVIDE(_c3_stack_size = _c3_stack_size_min);
  PROVIDE(_c3_stack_bottom = _c3_stack_top - _c3_stack_size);
  PROVIDE(_c3_heap_start = _c3_data_load_start + ( _c3_bss_end - _c3_data_start ));
  PROVIDE(_c3_heap_end = _c3_stack_bottom);
  PROVIDE(_c3_heap_size = _c3_heap_end - _c3_heap_start);

  PROVIDE(_c3_global_pointer = _c3_data_start + 0x800);  
}
