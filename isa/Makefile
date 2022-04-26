#=======================================================================
# Makefile for rv32mi isa
#-----------------------------------------------------------------------

SRC_DIR := ./rv32mi
INC_DIR := ./
LINK_FILE := ./link.ld

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_PREFIX ?= riscv32-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_GCC_OPTS ?= -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles
RISCV_OBJCOPY ?= $(RISCV_PREFIX)objcopy
RISCV_OBJCOPY_OPTS ?= -O binary
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump
RISCV_OBJDUMP_OPTS ?= -M no-aliases,numeric --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.text.init --section=.data

#------------------------------------------------------------
# Build tests
#------------------------------------------------------------

OBJS := $(subst .S,.o,$(wildcard $(SRC_DIR)/*.S))
COES := $(subst .S,.coe,$(wildcard $(SRC_DIR)/*.S))
BINS := $(subst .S,.bin,$(wildcard $(SRC_DIR)/*.S))
DUMPS := $(subst .S,.dump,$(wildcard $(SRC_DIR)/*.S))

all: $(DUMPS) $(COES) $(BINS) $(OBJS)

%.dump: %.o
	$(RISCV_OBJDUMP) $(RISCV_OBJDUMP_OPTS) $< > $@

%.coe: %.bin bin2coe
	./bin2coe $< $@

%.bin: %.o
	$(RISCV_OBJCOPY) $(RISCV_OBJCOPY_OPTS) $< $@
	
%.o: %.S
	$(RISCV_GCC) $(RISCV_GCC_OPTS) -I $(INC_DIR) -T $(LINK_FILE) -o $@ $<

bin2coe: ../tools/bin2coe.cpp
	g++ ../tools/bin2coe.cpp -o bin2coe

#------------------------------------------------------------
# Clean up
#------------------------------------------------------------

.PHONY: clean
clean:
	rm -rf $(SRC_DIR)/*.dump $(SRC_DIR)/*.bin $(SRC_DIR)/*.coe $(SRC_DIR)/*.o bin2coe
