OUTPUT_ARCH( "riscv" )

SECTIONS
{
  . = 0x00000000;
  . = ALIGN(4);
  .data : { *(.data) }
  . = 0x00004000;
  . = ALIGN(4);
  .text : { *(.text) }
}