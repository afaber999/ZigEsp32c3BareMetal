 MEMORY
{
  drom (r): ORIGIN = 0x3C000000, LENGTH = 0x400000  # 4 MB flash, 1 byte adressing (maps to irom)
  irom (x): ORIGIN = 0x42000000, LENGTH = 0x400000  # 4 MB flash, 4 bytes addressing only
  
  dram1 (rw!x) : ORIGIN = 0x3FC80000,LENGTH = 192k 
  iram1 (rx)  : ORIGIN = 0x40380000 + LENGTH(dram1), LENGTH = 192k 
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
  PROVIDE (_rv32_text_start = .);
  .text .:
  {
    KEEP(*(.text.entry))
    *(.text*)
    KEEP(*(.text.isr_handler*))
  } > irom

  .isr_table :
  {
    PROVIDE(_rv32_interrupt_vectors = .);
    KEEP(*(.mtvec_table))
  } > irom

  . = ALIGN(8);
 
  PROVIDE (__etext = .);
  PROVIDE (_etext = .);
  PROVIDE (etext = .);
  PROVIDE (_rv32_text_end = .);
  PROVIDE(_irom_size = SIZEOF(.text));


  _irom_size = . - _irom_start;
  
  _drom_start = ORIGIN(drom) + _irom_size;
  .rodata _drom_start :  ALIGN(8)
  {
    _rv32_rodata_start = .; 
    *(.rodata .rodata.* .srodata .srodata.* .sdata2 .sdata2.* .gnu.linkonce.r.*)
    *(.rela.data .rela.data.* .rela.gnu.linkonce.r.*)
    _rv32_rodata_end = .; 
  } > drom AT> irom


  .data : ALIGN(4)
  {
     _rv32_data_start = .;
     *(.sdata*)
     *(.data*)
     _rv32_data_end = .;
  } > dram1 AT> irom

  .bss (NOLOAD) :
  {
      _rv32_bss_start = .;
      *(.bss*)
      *(.sbss*)
      _rv32_bss_end = .;
  } > dram1

  _end = .; PROVIDE (end = .);
  _rv32_data_load_start = LOADADDR(.data);

  /* stack growing down from top of SRAM */
  PROVIDE(_rv32_stack_top = ORIGIN(dram1) + LENGTH(dram1));
  PROVIDE(_rv32_stack_size = 0x400);
  PROVIDE(_rv32_stack_bottom = _rv32_stack_top - _rv32_stack_size);
  PROVIDE(_rv32_heap_start = _rv32_data_load_start + ( _rv32_bss_end - _rv32_data_start ));
  PROVIDE(_rv32_heap_end = _rv32_stack_bottom);
  PROVIDE(_rv32_heap_size = _rv32_heap_end - _rv32_heap_start);

  PROVIDE(_rv32_global_pointer = _rv32_data_start + 0x800);  
}
