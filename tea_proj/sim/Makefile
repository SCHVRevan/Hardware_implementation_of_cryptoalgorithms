DESIGN_NAMES = tea_iterative tea_round
SRC_PATH = ../rtl
WORK_DIR = work

all: synth sim

synth:
	mkdir -p $(WORK_DIR)
	iverilog -g2012 -o $(WORK_DIR)/tb_tea_iterative \
		$(SRC_PATH)/tea_iterative.sv \
		$(SRC_PATH)/tea_round.sv \
		tb_tea_iterative.sv
	iverilog -g2012 -o $(WORK_DIR)/tb_tea_round \
		$(SRC_PATH)/tea_round.sv \
		tb_tea_round.sv

sim:
	./$(WORK_DIR)/tb_tea_iterative
	./$(WORK_DIR)/tb_tea_round

wave_iterative:
	gtkwave $(WORK_DIR)/wave_iterative.ocd \
		--rcvar 'fontname_signals Monospace 20' \
		--rcvar 'fontname_waves Monospace 20' \
		--rcvar 'scale_to_time_dimension n'

wave_round:
	gtkwave $(WORK_DIR)/wave_round.ocd \
		--rcvar 'fontname_signals Monospace 20' \
		--rcvar 'fontname_waves Monospace 20' \
		--rcvar 'scale_to_time_dimension n'

wave: wave_iterative wave_round

clean:
	rm -rf $(WORK_DIR)
