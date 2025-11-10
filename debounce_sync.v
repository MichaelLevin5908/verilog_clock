// debounce_sync.v
module debounce_sync #(
  parameter integer STABLE_COUNT = 2000 // ~10 ms if tick_fast ≈ 200 Hz
)(
  input  wire clk,
  input  wire tick_fast,
  input  wire in_raw,
  output reg  out_deb
);
  reg s1,s2;  // synchronizer
  always @(posedge clk) begin s1<=in_raw; s2<=s1; end

  reg prev; reg [$clog2(STABLE_COUNT+1)-1:0] cnt;
  always @(posedge clk) begin
    if (tick_fast) begin
      if (s2!=prev) begin prev<=s2; cnt<=0; end
      else begin
        if (cnt<STABLE_COUNT) cnt<=cnt+1;
        if (cnt==STABLE_COUNT) out_deb<=s2;
      end
    end
  end
endmodule
