# See LICENSE for license details.

#*****************************************************************************
# add.S
#-----------------------------------------------------------------------------
#
# Test add instruction.
#

#include "macros.h"

RVTEST_RV32MI
RVTEST_CODE_BEGIN

  TEST_IMM_DEST_BYPASS( 2, 0, addi, 24, 13, 11 );
  TEST_IMM_DEST_BYPASS( 3, 1, addi, 23, 13, 10 );
  TEST_IMM_DEST_BYPASS( 4, 2, addi, 22, 13,  9 );

  TEST_IMM_SRC1_BYPASS( 5, 0, addi, 24, 13, 11 );
  TEST_IMM_SRC1_BYPASS( 6, 1, addi, 23, 13, 10 );
  TEST_IMM_SRC1_BYPASS( 7, 2, addi, 22, 13,  9 );

  TEST_RR_DEST_BYPASS( 8, 0, add, 24, 13, 11 );
  TEST_RR_DEST_BYPASS( 9, 1, add, 25, 14, 11 );
  TEST_RR_DEST_BYPASS( 10, 2, add, 26, 15, 11 );

  TEST_BR2_SRC12_BYPASS( 11, 0, 0, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 12, 0, 1, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 13, 0, 2, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 14, 1, 0, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 15, 1, 1, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 16, 2, 0, bne, 0, 0 );

  TEST_BR2_SRC12_BYPASS( 17, 0, 0, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 18, 0, 1, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 19, 0, 2, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 20, 1, 0, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 21, 1, 1, bne, 0, 0 );
  TEST_BR2_SRC12_BYPASS( 22, 2, 0, bne, 0, 0 );

  TEST_BR2_SRC12_BYPASS( 23, 0, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 24, 0, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 25, 0, 2, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 26, 1, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 27, 1, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 28, 2, 0, beq, 0, -1 );

  TEST_BR2_SRC12_BYPASS( 29, 0, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 30, 0, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 31, 0, 2, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 32, 1, 0, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 33, 1, 1, beq, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 34, 2, 0, beq, 0, -1 );

  TEST_BR2_SRC12_BYPASS( 35, 0, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 36, 0, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 37, 0, 2, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 38, 1, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 39, 1, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 40, 2, 0, blt, 0, -1 );

  TEST_BR2_SRC12_BYPASS( 41, 0, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 42, 0, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 43, 0, 2, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 44, 1, 0, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 45, 1, 1, blt, 0, -1 );
  TEST_BR2_SRC12_BYPASS( 46, 2, 0, blt, 0, -1 );

  TEST_JALR_SRC1_BYPASS( 47, 0, jalr );
  TEST_JALR_SRC1_BYPASS( 48, 1, jalr );
  TEST_JALR_SRC1_BYPASS( 49, 2, jalr );

  TEST_RR_SRC12_BYPASS( 50, 0, 0, add, 24, 13, 11 );
  TEST_RR_SRC12_BYPASS( 51, 0, 1, add, 25, 14, 11 );
  TEST_RR_SRC12_BYPASS( 52, 0, 2, add, 26, 15, 11 );
  TEST_RR_SRC12_BYPASS( 53, 1, 0, add, 24, 13, 11 );
  TEST_RR_SRC12_BYPASS( 54, 1, 1, add, 25, 14, 11 );
  TEST_RR_SRC12_BYPASS( 55, 2, 0, add, 26, 15, 11 );

  TEST_RR_SRC21_BYPASS( 56, 0, 0, add, 24, 13, 11 );
  TEST_RR_SRC21_BYPASS( 57, 0, 1, add, 25, 14, 11 );
  TEST_RR_SRC21_BYPASS( 58, 0, 2, add, 26, 15, 11 );
  TEST_RR_SRC21_BYPASS( 59, 1, 0, add, 24, 13, 11 );
  TEST_RR_SRC21_BYPASS( 60, 1, 1, add, 25, 14, 11 );
  TEST_RR_SRC21_BYPASS( 61, 2, 0, add, 26, 15, 11 );

  TEST_RR_DEST_BYPASS( 62, 0, sub, 2, 13, 11 );
  TEST_RR_DEST_BYPASS( 63, 1, sub, 3, 14, 11 );
  TEST_RR_DEST_BYPASS( 64, 2, sub, 4, 15, 11 );

  TEST_RR_SRC12_BYPASS( 65, 0, 0, sub, 2, 13, 11 );
  TEST_RR_SRC12_BYPASS( 66, 0, 1, sub, 3, 14, 11 );
  TEST_RR_SRC12_BYPASS( 67, 0, 2, sub, 4, 15, 11 );
  TEST_RR_SRC12_BYPASS( 68, 1, 0, sub, 2, 13, 11 );
  TEST_RR_SRC12_BYPASS( 69, 1, 1, sub, 3, 14, 11 );
  TEST_RR_SRC12_BYPASS( 70, 2, 0, sub, 4, 15, 11 );

  TEST_RR_SRC21_BYPASS( 71, 0, 0, sub, 2, 13, 11 );
  TEST_RR_SRC21_BYPASS( 72, 0, 1, sub, 3, 14, 11 );
  TEST_RR_SRC21_BYPASS( 73, 0, 2, sub, 4, 15, 11 );
  TEST_RR_SRC21_BYPASS( 74, 1, 0, sub, 2, 13, 11 );
  TEST_RR_SRC21_BYPASS( 75, 1, 1, sub, 3, 14, 11 );
  TEST_RR_SRC21_BYPASS( 76, 2, 0, sub, 4, 15, 11 );

  TEST_LD_DEST_BYPASS( 77, 0, lw, 0x0000000000000010, 4, tdat12 );
  TEST_LD_DEST_BYPASS( 78, 1, lw, 0x0000000000000100, 4, tdat13 );
  TEST_LD_DEST_BYPASS( 79, 2, lw, 0x0000000000000001, 4, tdat11 );

  TEST_LD_SRC1_BYPASS( 80, 0, lw, 0x0000000000000010, 4, tdat12 );
  TEST_LD_SRC1_BYPASS( 81, 1, lw, 0x0000000000000100, 4, tdat13 );
  TEST_LD_SRC1_BYPASS( 82, 2, lw, 0x0000000000000001, 4, tdat11 );

  TEST_ST_SRC12_BYPASS( 83, 0, 0, lw, sw, 0x0000000000000000, 0,  tdat );
  TEST_ST_SRC12_BYPASS( 84, 0, 1, lw, sw, 0x0000000000000004, 4,  tdat );
  TEST_ST_SRC12_BYPASS( 85, 0, 2, lw, sw, 0x0000000000000008, 8,  tdat );
  TEST_ST_SRC12_BYPASS( 86, 1, 0, lw, sw, 0x000000000000000c, 12, tdat );
  TEST_ST_SRC12_BYPASS( 87, 1, 1, lw, sw, 0x0000000000000010, 16, tdat );
  TEST_ST_SRC12_BYPASS( 88, 2, 0, lw, sw, 0x0000000000000014, 20, tdat );

  TEST_ST_SRC21_BYPASS( 89, 0, 0, lw, sw, 0x00000700, 0,  tdat );
  TEST_ST_SRC21_BYPASS( 90, 0, 1, lw, sw, 0x00000704, 4,  tdat );
  TEST_ST_SRC21_BYPASS( 91, 0, 2, lw, sw, 0x00000708, 8,  tdat );
  TEST_ST_SRC21_BYPASS( 92, 1, 0, lw, sw, 0x0000070c, 12, tdat );
  TEST_ST_SRC21_BYPASS( 93, 1, 1, lw, sw, 0x00000710, 16, tdat );
  TEST_ST_SRC21_BYPASS( 94, 2, 0, lw, sw, 0x00000714, 20, tdat );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
tdat1:  .word 0xdeadbeef
tdat2:  .word 0xdeadbeef
tdat3:  .word 0xdeadbeef
tdat4:  .word 0xdeadbeef
tdat5:  .word 0xdeadbeef
tdat6:  .word 0xdeadbeef
tdat7:  .word 0xdeadbeef
tdat8:  .word 0xdeadbeef
tdat9:  .word 0xdeadbeef
tdat10: .word 0xdeadbeef
tdat11: .word 0x00000111
tdat12: .word 0x00000001
tdat13: .word 0x00000010
tdat14: .word 0x00000100

RVTEST_DATA_END