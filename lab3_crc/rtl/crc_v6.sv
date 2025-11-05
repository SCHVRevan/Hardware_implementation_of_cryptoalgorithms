
module crc_v6 (
  input logic rst,
  input logic clk,
  input logic data,
  output logic [12:0] crc
);
  logic main_xor;
  assign main_xor = data ^ crc[12];
  always @(posedge clk)
    if (rst) begin
      crc <= 13'b0;
    end else begin
      for(int i = 0; i < 13; i++) begin
        if (i == 0)
          crc[i] <= main_xor;
        else if (i == 1 || i == 3 || i == 4)
          crc[i] <= main_xor ^ crc[i-1];
        else
          crc[i] <= crc[i-1];
      end
    end
endmodule
