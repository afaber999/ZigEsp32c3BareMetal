

MEMORY
{
  irom (x): ORIGIN = 0x42000000, LENGTH = 0x800000  # 384 Kb, 4 bytes addressing only
  drom (r): ORIGIN = 0x3C000000, LENGTH = 0x800000  # 384 Kb, 1 byte adressing (maps to irom)
  ram0 (rw!x) : ORIGIN = 0x3FC80000, LENGTH = 0x00060000
}

ENTRY(_start)

SECTIONS
{
  .header : 
  {
    _irom_start = .;
    LONG(0xaedb041d)
    LONG(0xaedb041d)
  } > irom
  PROVIDE(_header_size = SIZEOF(.header));

  . = ALIGN(4);
  PROVIDE (__stext = .);
  PROVIDE (_stext = .);
  PROVIDE (stext = .);
  PROVIDE (_c3_text_start = .);
  .text :
  {
    KEEP(*(.text.entry))
    *(.text*)
  } > irom
 
 . = ALIGN(8);
 
  PROVIDE (__etext = .);
  PROVIDE (_etext = .);
  PROVIDE (etext = .);
  PROVIDE (_c3_text_end = .);
  PROVIDE(_irom_size = SIZEOF(.text));


  _irom_size = . - _irom_start;
  
  _drom_start = ORIGIN(drom) + _irom_size;
  .rodata _drom_start :  ALIGN(8)
  {
    _c3_rodata_start = .; 
    *(.rodata .rodata.* .srodata .srodata.* .sdata2 .sdata2.* .gnu.linkonce.r.*)
    *(.rela.data .rela.data.* .rela.gnu.linkonce.r.*)
    _c3_rodata_end = .; 
  } > drom AT> irom


  .data : ALIGN(4)
  {
     _c3_data_start = .;
     *(.sdata*)
     *(.data*)
     _c3_data_end = .;
  } > ram0 AT> irom

  .bss (NOLOAD) :
  {
      _c3_bss_start = .;
      *(.bss*)
      *(.sbss*)
      _c3_bss_end = .;
  } > ram0

  _end = .; PROVIDE (end = .);

  /* Place interrupt vector table at mem upper */
  /* size and alignment is 256 byte (0x100)    */
  PROVIDE(_c3_interrupt_vectors_size = 0x100);
  PROVIDE(_c3_interrupt_vectors = ORIGIN(ram0) + LENGTH(ram0) - _c3_interrupt_vectors_size);

  /* Stack, place just under the interrupt vector table */
  .stack  (NOLOAD) :
  {
    _c3_stack_bottom = .;
    _c3_stack_top = _c3_interrupt_vectors;
    _c3_stack_size_min = 0x4000;
    ASSERT(_c3_stack_bottom + _c3_stack_size_min < _c3_stack_top, "Error: no space for stack");
  }
  
  _c3_data_load_start = LOADADDR(.data);

  /* stack growing down from top of SRAM */
  PROVIDE(_c3_stack_top = ORIGIN(ram0) + LENGTH(ram0));
  PROVIDE(_c3_stack_size = 0x400);
  PROVIDE(_c3_stack_bottom = _c3_stack_top - _c3_stack_size);
  PROVIDE(_c3_heap_start = _c3_data_load_start + ( _c3_bss_end - _c3_data_start ));
  PROVIDE(_c3_heap_end = _c3_stack_bottom);
  PROVIDE(_c3_heap_size = _c3_heap_end - _c3_heap_start);

  PROVIDE(_c3_global_pointer = _c3_data_start + 0x800);  
}
