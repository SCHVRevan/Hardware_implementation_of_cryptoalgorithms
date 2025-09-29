`timescale 1ns / 1ns

module tb_no_moore;
	parameter TRANSITIONS = 18;

	logic rst = 0;
	logic clk = 1;
	logic [3:0] test_vectors [TRANSITIONS];
	logic [1:0] a, y, y_ref;

initial begin
	$dumpfile("work/wave.ocd");
	$dumpvars(0, tb_no_moore);
end

initial begin
	$readmemb("sequence.tv", test_vectors);

	@(posedge clk);
	rst = 1'b1;
	@(posedge clk);
	rst = 1'b0;

	for (int i = 0; i < TRANSITIONS; i++) begin
		{a, y_ref} = test_vectors[i];
		@(posedge clk)

		assert (y == y_ref)
		else $error($sformatf("Wrong output on test vector %d: a = %b, y_ref = %b, y = %b", i, a, y_ref, y));
	end

	$finish;
end

always #5 clk = ~clk;

no_moore dut (
	.rst(rst),
	.clk(clk),
	.a(a),
	.y(y)
);

endmodule
