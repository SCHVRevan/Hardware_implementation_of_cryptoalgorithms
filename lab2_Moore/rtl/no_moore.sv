
module no_moore (
	input logic rst, clk,
	input logic [1:0] a,
	output logic [1:0] y
);

	parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

	logic [1:0] state, next_state;

	always @(*) begin
		case(state)
			S0: case(a)
				2'b00: next_state = S0;
				2'b01: next_state = S0;
				2'b10: next_state = S1;
				2'b11: next_state = S1;
			endcase
			S1: case(a)
				2'b00: next_state = S2;
				2'b01: next_state = S1;
				2'b10: next_state = S1;
				2'b11: next_state = S2;
			endcase
			S2: case(a)
				2'b00: next_state = S2;
				2'b01: next_state = S3;
				2'b10: next_state = S2;
				2'b11: next_state = S3;
			endcase
			S3: case(a)
				2'b00: next_state = S3;
				2'b01: next_state = S0;
				2'b10: next_state = S0;
				2'b11: next_state = S3;
			endcase
			default: next_state = S0;
		endcase
	end

	always @(posedge clk) begin
		if (rst) state <= S0;
		else state <= next_state;
	end

	assign y = state;

endmodule
