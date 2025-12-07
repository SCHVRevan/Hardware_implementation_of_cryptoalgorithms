`timescale 1ns / 1ns

module tb_tea_iterative;
	parameter VALIDATIONS = 100;
	
   	logic s_axis_tvalid;
  	logic s_axis_tready;
  	logic m_axis_tvalid;
  	logic m_axis_tready;

	logic rst = 0;
	logic clk = 1;
	logic [255:0] test_vectors [VALIDATIONS];
	logic [63:0] data, tea, tea_ref;
	logic [127:0] key;

initial begin
	$dumpfile("work/wave_iterative.ocd");
	$dumpvars(0, tb_tea_iterative);
end

initial begin
	$readmemb("iter_sequence.tv", test_vectors);

	@(posedge clk);
	rst = 1'b1;
	@(posedge clk);
	rst = 1'b0;

	for (int i = 0; i < VALIDATIONS; i++) begin
		{data, key, tea_ref} = test_vectors[i];
		
		wait(s_axis_tready);

		while (!m_axis_tvalid) @(posedge clk);
		m_axis_tready = 1'b1;
		@(posedge clk);
		m_axis_tready = 1'b0;

		assert (tea == tea_ref) else $error("Wrong encrypted data on test vector %d: tea = %h, tea_ref = %h", i, tea, tea_ref);
	end
	$finish;
end

always #5 clk = ~clk;

tea_iterative dut (
  .rst (rst),
  .clk (clk),
  .key (key),

  .s_axis_tdata (data),
  .s_axis_tvalid (1'b1),
  .s_axis_tready (s_axis_tready),

  .m_axis_tdata (tea),
  .m_axis_tvalid (m_axis_tvalid),
  .m_axis_tready (m_axis_tready)
);

endmodule
