// display_mux.v
module display_mux(
  input wire clk,
  input wire rst,
  input wire tick_fast,
  input wire blink_enable,
  input wire blink_state,
  input wire sel_minutes,
  input wire sel_seconds,
  input wire [3:0] mt, mo, st, so,
  output reg [6:0] seg,
  output reg [3:0] an,
  output reg dp
);

  reg [1:0] idx;
  always @(posedge clk) begin
    if (rst) idx<=0;
    else if (tick_fast) idx<=idx+1;
  end

  reg [3:0] bcd;
  always @(*) begin
    case(idx)
      2'd0: bcd=so;
      2'd1: bcd=st;
      2'd2: bcd=mo;
      2'd3: bcd=mt;
    endcase
  end

  wire is_min = (idx==2'd2)||(idx==2'd3);
  wire is_sec = (idx==2'd0)||(idx==2'd1);
  wire blank  = blink_enable && ~blink_state &&
                ((sel_minutes && is_min) || (sel_seconds && is_sec));

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

  always @(*) begin
    case(idx)
      2'd0: an=4'b1110;
      2'd1: an=4'b1101;
      2'd2: an=4'b1011;
      2'd3: an=4'b0111;
    endcase
    seg = blank ? 7'b1111111 : seg_n;
    dp  = 1'b1;
  end
endmodule
