// clock_divider.v
module clock_divider #(
  parameter integer DIV_1HZ   = 100_000_000, // 100 MHz -> 1 Hz
  parameter integer DIV_2HZ   = 50_000_000,  // 100 MHz -> 2 Hz
  parameter integer DIV_FAST  = 500_000,     // ~200 Hz scan/debounce
  parameter integer DIV_BLINK = 100_000_000  // 1 Hz blink (>=1 Hz, != 2 Hz)
)(
  input  wire clk,
  input  wire rst,          // sync reset
  output reg  tick_1hz,
  output reg  tick_2hz,
  output reg  tick_fast,
  output reg  tick_blink
);
  localparam W1=$clog2(DIV_1HZ), W2=$clog2(DIV_2HZ),
             WF=$clog2(DIV_FAST), WB=$clog2(DIV_BLINK);
  reg [W1-1:0] c1; reg [W2-1:0] c2; reg [WF-1:0] cf; reg [WB-1:0] cb;

  always @(posedge clk) begin
    if (rst) begin
      c1<=0; c2<=0; cf<=0; cb<=0;
      tick_1hz<=0; tick_2hz<=0; tick_fast<=0; tick_blink<=0;
    end else begin
      tick_1hz<=0; tick_2hz<=0; tick_fast<=0; tick_blink<=0;
      if (c1==DIV_1HZ-1) begin c1<=0; tick_1hz<=1; end else c1<=c1+1;
      if (c2==DIV_2HZ-1) begin c2<=0; tick_2hz<=1; end else c2<=c2+1;
      if (cf==DIV_FAST-1) begin cf<=0; tick_fast<=1; end else cf<=cf+1;
      if (cb==DIV_BLINK-1) begin cb<=0; tick_blink<=1; end else cb<=cb+1;
    end
  end
endmodule
