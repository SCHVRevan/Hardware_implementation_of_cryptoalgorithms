//  y = y + ((z << 4) + key[127:96]) ^ (z + sum) ^ ((z >> 5) + key[95:64]);
//  z = z + ((y << 4) + key[63:32]) ^ (y + sum) ^ ((y >> 5) + key[31:0]);

module tea_round (
  input logic clk,
  input logic [63:0] idata,
  input logic [31:0] sum,
  input logic [127:0] key,
  
  output logic [63:0] odata
);
  logic [31:0] zl4, zr5, z_sum;
  logic [31:0] yl4, yr5, y_sum;
  logic [31:0] y_new, z_new;

  always @(posedge clk) begin
    zl4 = {idata[27:0], 4'b0000} + key[127:96];
    zr5 = {5'd0, idata[31:5]} + key[95:64];
    z_sum = idata[31:0] + sum;
    y_new = idata[63:32] + (zl4 ^ z_sum ^ zr5);
  end
  always @(posedge clk) begin
    yl4 = {y_new[27:0], 4'b0000} + key[63:32];
    yr5 = {5'd0, y_new[31:5]} + key[31:0];
    y_sum = y_new + sum;
    z_new = idata[31:0] + (yl4 ^ y_sum ^ yr5);
  end

assign odata = {y_new, z_new};

endmodule
