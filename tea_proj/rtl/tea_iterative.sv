
module tea_iterative (
  input logic rst,
  input logic clk,

  input logic [127:0] key,

  input logic [63:0] s_axis_tdata,
  input logic s_axis_tvalid,
  output logic s_axis_tready,

  output logic [63:0] m_axis_tdata,
  output logic m_axis_tvalid,
  input logic m_axis_tready
);

  parameter [1:0] IDLE = 2'b00, ENC_1 = 2'b01, ENC_2 = 2'b10, DONE = 2'b11;
  logic [1:0] next_state, state = IDLE;

  logic [63:0] block, enc_block;
  logic [31:0] sum = 32'h9e3779b9;

  logic [4:0] counter = 5'd0; // 32 rounds
  logic last_round;

  assign last_round = &counter;

  always @(*) begin
    next_state = state;
    case(state)
      IDLE: if (s_axis_tvalid) next_state = ENC_1;
      ENC_1: next_state = ENC_2;
      ENC_2: next_state = last_round ? DONE : ENC_1;
      DONE: if (m_axis_tready) next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (rst) state <= IDLE;
    else state <= next_state;
  end

  always @(posedge clk) begin
    if (rst) begin
      counter <= 5'd0;
      block <= 64'd0;
    end else begin
      case (state)
        IDLE: begin
          counter <= 5'd0;
          if (s_axis_tvalid) block <= s_axis_tdata;
        end
        ENC_2: begin
          counter <= counter + 1;
          block <= enc_block;
        end
      endcase
    end
  end

always @(*) begin
  case(counter)
    5'd0: sum = 32'h9e3779b9;
    5'd1: sum = 32'h3c6ef372;
    5'd2: sum = 32'hdaa66d2b;
    5'd3: sum = 32'h78dde6e4;
    5'd4: sum = 32'h1715609d;
    5'd5: sum = 32'hb54cda56;
    5'd6: sum = 32'h5384540f;
    5'd7: sum = 32'hf1bbcdc8;
    5'd8: sum = 32'h8ff34781;
    5'd9: sum = 32'h2e2ac13a;
    5'd10: sum = 32'hcc623af3;
    5'd11: sum = 32'h6a99b4ac;
    5'd12: sum = 32'h08d12e65;
    5'd13: sum = 32'ha708a81e;
    5'd14: sum = 32'h454021d7;
    5'd15: sum = 32'he3779b90;
    5'd16: sum = 32'h81af1549;
    5'd17: sum = 32'h1fe68f02;
    5'd18: sum = 32'hbe1e08bb;
    5'd19: sum = 32'h5c558274;
    5'd20: sum = 32'hfa8cfc2d;
    5'd21: sum = 32'h98c475e6;
    5'd22: sum = 32'h36fbef9f;
    5'd23: sum = 32'hd5336958;
    5'd24: sum = 32'h736ae311;
    5'd25: sum = 32'h11a25cca;
    5'd26: sum = 32'hafd9d683;
    5'd27: sum = 32'h4e11503c;
    5'd28: sum = 32'hec48c9f5;
    5'd29: sum = 32'h8a8043ae;
    5'd30: sum = 32'h28b7bd67;
    5'd31: sum = 32'hc6ef3720;
    default: sum = 32'h9e3779b9;
  endcase
end

tea_round round_inst (
  .clk (clk),
  .idata (block),
  .sum (sum),
  .key (key),
  .odata (enc_block)
);

assign m_axis_tdata = block;
assign m_axis_tvalid = (state == DONE);
assign s_axis_tready = (state == IDLE);

endmodule
