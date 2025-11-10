// display_mux.v
module display_mux(
  input  wire       clk,
  input  wire       rst,
  input  wire       tick_fast,      // ~200 Hz
  input  wire       blink_enable,
  input  wire       blink_state,    // toggles @1 Hz
  input  wire       sel_minutes,    // adjusting minutes?
  input  wire       sel_seconds,    // adjusting seconds?
  input  wire [3:0] mt, mo, st, so, // digits
  output reg  [6:0] seg,            // active-low a..g
  output reg  [3:0] an,             // active-low an[3:0]
  output reg        dp              // active-low
);
  // rotating digit index: 0=so,1=st,2=mo,3=mt
  reg [1:0] idx;
  always @(posedge clk) begin
    if (rst) idx<=0;
    else if (tick_fast) idx<=idx+1;
  end

  // pick digit
  reg [3:0] bcd;
  always @(*) begin
    case(idx)
      2'd0: bcd=so;
      2'd1: bcd=st;
      2'd2: bcd=mo;
      2'd3: bcd=mt;
    endcase
  end

  // blink mask
  wire is_min = (idx==2'd2)||(idx==2'd3);
  wire is_sec = (idx==2'd0)||(idx==2'd1);
  wire blank  = blink_enable && ~blink_state &&
                ((sel_minutes && is_min) || (sel_seconds && is_sec));

  // encode BCD (active-low)
  reg [6:0] seg_n;
  always @(*) begin
    case (bcd)
      4'd0: seg_n=7'b1000000;
      4'd1: seg_n=7'b1111001;
      4'd2: seg_n=7'b0100100;
      4'd3: seg_n=7'b0110000;
      4'd4: seg_n=7'b0011001;
      4'd5: seg_n=7'b0010010;
      4'd6: seg_n=7'b0000010;
      4'd7: seg_n=7'b1111000;
      4'd8: seg_n=7'b0000000;
      4'd9: seg_n=7'b0010000;
      default: seg_n=7'b1111111;
    endcase
  end

  // outputs
  always @(*) begin
    case(idx)
      2'd0: an=4'b1110;
      2'd1: an=4'b1101;
      2'd2: an=4'b1011;
      2'd3: an=4'b0111;
    endcase
    seg = blank ? 7'b1111111 : seg_n;
    dp  = 1'b1; // off
  end
endmodule
