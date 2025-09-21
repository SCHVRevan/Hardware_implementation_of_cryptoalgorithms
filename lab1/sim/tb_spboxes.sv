`timescale 1ns / 1ns

module tb_spboxes;
	logic [3:0] a, y;
	bit [3:0] y_ref;

	initial begin
		$dumpfile("work/wave.ocd");
		$dumpvars(0, tb_spboxes);
	end

	initial begin
		for (int i = 0; i < 16; i++) begin
			a = i; #1;
			case(a)
				4'b0000: y_ref = 4'b1101;
				4'b0001: y_ref = 4'b1000;
				4'b0010: y_ref = 4'b1011;
				4'b0011: y_ref = 4'b0010;
				4'b0100: y_ref = 4'b0100;
				4'b0101: y_ref = 4'b1111;
				4'b0110: y_ref = 4'b0111;
				4'b0111: y_ref = 4'b0001;
				4'b1000: y_ref = 4'b0110;
				4'b1001: y_ref = 4'b0101;
				4'b1010: y_ref = 4'b1100;
				4'b1011: y_ref = 4'b1001;
				4'b1100: y_ref = 4'b1010;
				4'b1101: y_ref = 4'b0011;
				4'b1110: y_ref = 4'b0000;
				4'b1111: y_ref = 4'b1110;
			endcase
			assert (y == y_ref)
			else $error($sformatf("Wrong result for a = %b: expected - %b, rtl - %b", a, y_ref, y));
		end

		$finish;
	end

	sp_round dut (
		.a(a),
		.y(y)
	);

endmodule
