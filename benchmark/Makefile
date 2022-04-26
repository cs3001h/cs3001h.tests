#=======================================================================
# Makefile for rv32mi isa
#-----------------------------------------------------------------------

SRC_DIR := .
INC_DIR := .
LINK_FILE := ./link.ld

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_PREFIX ?= riscv32-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_OBJCOPY ?= $(RISCV_PREFIX)objcopy
RISCV_OBJCOPY_OPTS ?= -O binary
RISCV_GCC_AS_OPTS ?= -march=rv32i -mabi=ilp32 -O0 -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -fvisibility=hidden -ffast-math -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns
RISCV_GCC_CC_OPTS ?= -march=rv32i -mabi=ilp32 -O0 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump
RISCV_OBJDUMP_OPTS ?= -M no-aliases,numeric --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.text.init --section=.data

#------------------------------------------------------------
# Build benchmark
#------------------------------------------------------------

OBJS := sort.o sort.S
COES := sort.coe
BINS := sort.bin
DUMPS := sort.dump

all: $(DUMPS) $(COES) $(BINS) $(OBJS)

%.dump: %.o
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_OPTS) $< > $@

%.coe: %.bin bin2coe
	./bin2coe $< $@

%.bin: %.o
	$(RISCV_OBJCOPY) $(RISCV_OBJCOPY_OPTS) $< $@
	
%.o: %.S
	$(RISCV_GCC) $(RISCV_GCC_CC_OPTS) -I $(INC_DIR) -T $(LINK_FILE) -o $@ $<

%.S: %.c
	$(RISCV_GCC) $(RISCV_GCC_AS_OPTS) -I $(INC_DIR) -o $@ -S $<

bin2coe: ../tools/bin2coe.cpp
	g++ ../tools/bin2coe.cpp -o bin2coe

#------------------------------------------------------------
# Clean up
#------------------------------------------------------------

.PHONY: clean
clean:
	rm -rf $(SRC_DIR)/*.dump $(SRC_DIR)/*.bin $(SRC_DIR)/*.coe $(SRC_DIR)/*.o $(SRC_DIR)/*.S
