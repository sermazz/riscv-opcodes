SHELL := /bin/sh

ALL_REAL_ILEN32_OPCODES := opcodes-rv32i opcodes-rv64i opcodes-rv32m opcodes-rv64m opcodes-rv32a opcodes-rv64a opcodes-rv32h opcodes-rv64h opcodes-rv32f opcodes-rv64f opcodes-rv32d opcodes-rv64d opcodes-rv32q opcodes-rv64q opcodes-system
ALL_REAL_OPCODES := $(ALL_REAL_ILEN32_OPCODES) opcodes-rvc opcodes-rv32c opcodes-rv64c opcodes-custom opcodes-rvv
# Add here your opcodes
MY_OPCODES := opcodes-frep_CUSTOM opcodes-xpulpimg_CUSTOM opcodes-rv32d-zfh_DRAFT opcodes-rv32q-zfh_DRAFT opcodes-rv32zfh_DRAFT opcodes-rv64zfh_DRAFT opcodes_sflt_CUSTOM

ALL_OPCODES := opcodes-pseudo $(ALL_REAL_OPCODES) $(MY_OPCODES) opcodes-rvv-pseudo
# Opcodes to be discarded
DISCARDED_OPCODES :=

OPCODES = $(filter-out $(sort $(DISCARDED_OPCODES)), $(sort $(ALL_OPCODES)))

all: encoding_out.h inst.sverilog

# Makefile inserted as prerequisite of every recipe because it can change due to DISCARDED_OPCODES

encoding_out.h: $(OPCODES) parse_opcodes encoding.h Makefile
	echo "/*" > $@
	echo " * This file is auto-generated by running 'make $@' in 'riscv-opcodes'" >> $@
	echo " */" >> $@
	echo >> $@
	cat encoding.h >> $@
	cat $(OPCODES) | ./parse_opcodes -c >> $@

inst.chisel: $(OPCODES) parse_opcodes Makefile
	cat $(OPCODES) | ./parse_opcodes -chisel > $@

inst.go: $(ALL_REAL_ILEN32_OPCODES) parse_opcodes Makefile
	cat $(ALL_REAL_ILEN32_OPCODES) | ./parse_opcodes -go > $@

inst.sverilog: $(OPCODES) parse_opcodes Makefile
	cat $(OPCODES) | ./parse_opcodes -sverilog > $@

instr-table.tex: $(OPCODES) parse_opcodes Makefile
	cat $(OPCODES) | ./parse_opcodes -tex > $@

priv-instr-table.tex: $(OPCODES) parse_opcodes Makefile
	cat $(OPCODES) | ./parse_opcodes -privtex > $@
