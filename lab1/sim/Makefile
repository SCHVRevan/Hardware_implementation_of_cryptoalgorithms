SRC_PATH=../rtl

all: synth sim

synth:
	mkdir -p work
	iverilog -g2012 -o work/tb_spboxes $(SRC_PATH)/spboxes.sv tb_spboxes.sv

sim:
	./work/tb_spboxes

wave:
	gtkwave work/wave.ocd \
		--rcvar 'fontname_signals Monospace 20' \
		--rcvar 'fontname_waves Monospace 20' \
		--rcvar 'scale_to_time_dimension n'

clean:
	rm -rf work
