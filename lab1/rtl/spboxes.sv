module s_box (
	input logic [3:0] a,
	output logic [3:0] y
);
	always @(a) begin
		case(a)
			4'b0000: y = 4'b1110;
			4'b0001: y = 4'b0100;
			4'b0010: y = 4'b1101;
			4'b0011: y = 4'b0001;
			4'b0100: y = 4'b0010;
			4'b0101: y = 4'b1111;
			4'b0110: y = 4'b1011;
			4'b0111: y = 4'b1000;
			4'b1000: y = 4'b0011;
			4'b1001: y = 4'b1010;
			4'b1010: y = 4'b0110;
			4'b1011: y = 4'b1100;
			4'b1100: y = 4'b0101;
			4'b1101: y = 4'b1001;
			4'b1110: y = 4'b0000;
			4'b1111: y = 4'b0111;
		endcase
	end

endmodule

module p_box (
	input logic [3:0] a,
	output logic [3:0] y
);
	always @(a) begin
		case(a)
			4'b0000: y = 4'b0000;
			4'b0001: y = 4'b0010;
			4'b0010: y = 4'b0100;
			4'b0011: y = 4'b0110;
			4'b0100: y = 4'b1000;
			4'b0101: y = 4'b1010;
			4'b0110: y = 4'b1100;
			4'b0111: y = 4'b1110;
			4'b1000: y = 4'b0001;
			4'b1001: y = 4'b0011;
			4'b1010: y = 4'b0101;
			4'b1011: y = 4'b0111;
			4'b1100: y = 4'b1001;
			4'b1101: y = 4'b1011;
			4'b1110: y = 4'b1101;
			4'b1111: y = 4'b1111;
		endcase
	end

endmodule

module sp_round (
	input logic [3:0] a,
	output logic [3:0] y
);
	logic [3:0] tmp;

	s_box in_s_box (a, tmp);
	p_box out_p_box (tmp, y);

endmodule
