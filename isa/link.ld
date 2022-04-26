OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0x00001000;
  . = ALIGN(4);
  .text : { *(.text) }
  . = 0x00000000;
  . = ALIGN(4);
  .data : { *(.data) }
}

