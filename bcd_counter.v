// bcd_counter.v
module bcd_counter #(
  parameter integer MAX = 9  // 9 for mod10, 5 for mod6
)(
  input  wire clk,
  input  wire rst,
  input  wire en,      // one-cycle increment pulse
  output reg  [3:0] q,
  output wire carry    // asserted on MAX->0 increment
);
  assign carry = en && (q==MAX);
  always @(posedge clk) begin
    if (rst) q <= 0;
    else if (en) q <= (q==MAX) ? 0 : (q+1'b1);
  end
endmodule
