
module tea_round (
  input logic [63:0] idata,
  input logic [31:0] sum,
  input logic [127:0] key,
  output logic [63:0] odata
);
    
//  y = y + ((z << 4) + key[127:96]) ^ (z + sum) ^ ((z >> 5) + key[95:64]);
//  z = z + ((y << 4) + key[63:32]) ^ (y + sum) ^ ((y >> 5) + key[31:0]);

    logic [31:0] y4l, y5r, y_sum, y, y_new;
    logic [31:0] z4l, z5r, z_sum, z, z_new;
    
    assign y = idata[63:32];
    assign z = idata[31:0];

    assign z4l = {z[27:0], 4'b0000};
    assign z5r = {5'd0, z[31:5]};
    assign z_sum = z + sum;
    assign y_new = y + ((z4l + key[127:96]) ^ z_sum ^ (z5r + key[95:64]));

    assign y4l = {y_new[27:0], 4'b0000};
    assign y5r = {5'd0, y_new[31:5]};
    assign y_sum = y_new + sum;
    assign z_new = z + ((y4l + key[63:32]) ^ y_sum ^ (y5r + key[31:0]));

    assign odata = {y_new, z_new};

endmodule
