// bcd_counter.v
module bcd_counter #(
  parameter integer MAX = 9
)(
  input wire clk,
  input wire rst,
  input wire en,
  output reg [3:0] q,
  output wire carry
);
  assign carry = en && (q==MAX);
  always @(posedge clk) begin
    if (rst) q <= 0;
    else if (en) q <= (q==MAX) ? 0 : (q+1'b1);
  end
endmodule
