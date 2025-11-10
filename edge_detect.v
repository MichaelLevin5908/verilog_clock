// edge_detect.v
module edge_detect(
  input  wire clk,
  input  wire rst,
  input  wire in_level,
  output reg  rise_pulse
);
  reg d;
  always @(posedge clk) begin
    if (rst) begin d<=0; rise_pulse<=0; end
    else begin rise_pulse <= in_level & ~d; d <= in_level; end
  end
endmodule
