`timescale 1ns / 1ns

module tb_crc_v6;
	parameter ITERATIONS = 100;
	parameter MAX_LENGTH = 1024;

// x^13 + x^4 + x^3 + x + 1 polynomial

function logic [12:0] crc_v6_func(
	input [12:0] state,
	input data
);
	logic [12:0] result;

	result = {state[11:0], data};
	result = result ^ state[12] ^ (state[12] << 1) ^ (state[12] << 3) ^ (state[12] << 4);
	return result;
endfunction

logic rst = 0;
logic clk = 1;
logic data;
logic [12:0] crc, ref_crc;

int length;
logic current_bit;

initial begin
	$dumpfile("work/wave.ocd");
	$dumpvars(0, tb_crc_v6);
end

initial begin
	for (int i = 0; i < ITERATIONS; i++) begin
		data = 1'b0;

		@(posedge clk);
		rst = 1'b1;
		@(posedge clk);
		rst = 1'b0;

		ref_crc = 13'd0;

		length = $urandom_range(1, MAX_LENGTH);
		for (int j = 0; j < length; j++) begin
			current_bit = $urandom;

			ref_crc = crc_v6_func(ref_crc, current_bit);
			data = current_bit;

			@(posedge clk);
		end

		@(posedge clk);

		for (int j = 0; j < 13; j++) // * x^13
			ref_crc = crc_v6_func(ref_crc, 1'b0);

		assert (crc == ref_crc) else $error("CRC_v6 calculation failed: rtl - %b, model - %b", crc, ref_crc);
	end

	$finish;
end

always #5 clk = ~clk;

crc_v6 dut (
  .rst (rst ),
  .clk (clk ),
  .data(data),
  .crc (crc )
);

endmodule
