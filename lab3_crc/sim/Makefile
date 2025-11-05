DESIGN_NAME=crc_v6
SRC_PATH=../rtl

all:	synth sim

synth:
	mkdir -p work
	iverilog -g2012 -o work/tb_$(DESIGN_NAME) $(SRC_PATH)/$(DESIGN_NAME).sv tb_$(DESIGN_NAME).sv

sim:
	./work/tb_$(DESIGN_NAME)

wave:
	gtkwave work/wave.ocd \
		--rcvar 'fontname_signals Monospace 20' \
		--rcvar 'fontname_waves Monospace 20' \
		--rcvar 'scale_to_time_dimension n'

clean:
	rm -rf work
