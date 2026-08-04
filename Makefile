# ========================================
# regs (通用寄存器文件) Makefile
# ========================================

SYNOPSYS_HOME = /home/ripplish/synopsys
VCS_HOME     = $(SYNOPSYS_HOME)/vcs-mx/L-2016.06
VERDI_HOME   = $(SYNOPSYS_HOME)/verdi/Verdi3_L-2016.06-1

export SNPSLMD_LICENSE_FILE = 27000@ripplish-Dell-G15-5530
export LM_LICENSE_FILE      = $(SNPSLMD_LICENSE_FILE)

TOP    = gpr
TB     = gpr_tb

SRC_DIR = src
TB_DIR  = tb
SIM_DIR = sim
LOG_DIR = log

SRC_FILES = $(wildcard $(SRC_DIR)/*.v $(SRC_DIR)/*.sv)
TB_FILE   = $(TB_DIR)/$(TB).v
SIMV      = simv

VCS = $(VCS_HOME)/bin/vcs -full64
VCS_FLAGS  = -sverilog -debug_access+all -kdb -lca +vcs+lic+wait
VCS_FLAGS += -LDFLAGS -no-pie -LDFLAGS -fno-lto
VCS_FLAGS += -P $(VERDI_HOME)/share/PLI/VCS/LINUX64/novas.tab $(VERDI_HOME)/share/PLI/VCS/LINUX64/pli.a

FSDB     = $(SIM_DIR)/$(TB).fsdb
DUMP_TCL = $(SIM_DIR)/dump_fsdb.tcl

.PHONY: comp run sim verdi clean

comp:
	@mkdir -p $(SIM_DIR) $(LOG_DIR)
	@echo "Compiling regs ($(TOP), tb=$(TB))..."
	$(VCS) $(VCS_FLAGS) \
		$(addprefix -v ,$(SRC_FILES)) \
		$(TB_FILE) \
		-top $(TB) \
		-o $(SIMV)
	@echo "Compile done."

$(DUMP_TCL):
	@mkdir -p $(SIM_DIR)
	@echo 'fsdbDumpfile "$(FSDB)"'  > $@
	@echo 'fsdbDumpvars 0 $(TB)'  >> $@
	@echo 'run'                   >> $@
	@echo 'quit'                  >> $@

run: $(DUMP_TCL)
	@echo "Running simulation..."
	./$(SIMV) -ucli -do $(DUMP_TCL) -l $(LOG_DIR)/sim.log
	@echo "FSDB: $(FSDB)"

sim: comp run

verdi:
	$(VERDI_HOME)/bin/verdi \
		-dbdir simv.daidir \
		-ssf $(FSDB) \
		$(addprefix -v ,$(SRC_FILES)) \
		-nologo &

clean:
	rm -rf sim log simv simv.daidir csrc DVEfiles *.key novas* verdiLog
	@echo "Clean done."