`timescale 1ns / 1ns

module tb_tea_round;
	parameter VALIDATIONS = 100;

	logic rst = 0;
	logic clk = 1;
	logic [287:0] test_vectors [VALIDATIONS];
	logic [63:0] data, round, round_ref;
    logic [31:0] sum;
    logic [127:0] key;

initial begin
	$dumpfile("work/wave_round.ocd");
	$dumpvars(0, tb_tea_round);
end

initial begin
	$readmemb("round_sequence.tv", test_vectors);

	@(posedge clk);
	rst = 1'b1;
	@(posedge clk);
	rst = 1'b0;

	for (int i = 0; i < VALIDATIONS; i++) begin
		{data, sum, key, round_ref} = test_vectors[i];
		@(posedge clk)

		assert (round == round_ref) else $error("Wrong result on test vector %d: round = %h, round_ref = %h", i, round, round_ref);
	end

	$finish;
end

always #5 clk = ~clk;

tea_round dut (
  .idata (data),
  .sum (sum),
  .key (key),
  .odata (round)
);

endmodule
