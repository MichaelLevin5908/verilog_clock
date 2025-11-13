// top_stopwatch.v
module top_stopwatch(
  input wire clk_100mhz,
  input wire btn_reset_raw,
  input wire btn_pause_raw,
  input wire sw_adj_raw,
  input wire sw_sel_raw,
  output wire [6:0] seg,
  output wire [3:0] an,
  output wire dp,
  output wire [3:0] led
);
  wire tick_1hz, tick_2hz, tick_fast, tick_blink;
  wire sw_adj, sw_sel, btn_reset, btn_pause_deb;
  wire pause_tog;
  wire use_1hz, use_2hz, sel_minutes, sel_seconds, blink_enable, count_enable;
  wire [3:0] mt, mo, st, so;

  clock_divider #(
    .DIV_1HZ(100_000_000), .DIV_2HZ(50_000_000),
    .DIV_FAST(500_000), .DIV_BLINK(33_333_333)
  ) u_div (.clk(clk_100mhz), .rst(1'b0),
           .tick_1hz(tick_1hz), .tick_2hz(tick_2hz),
           .tick_fast(tick_fast), .tick_blink(tick_blink));

  debounce_sync #(.STABLE_COUNT(10)) u_db_adj
    (.clk(clk_100mhz), .tick_fast(tick_fast), .in_raw(sw_adj_raw), .out_deb(sw_adj));
  debounce_sync #(.STABLE_COUNT(10)) u_db_sel
    (.clk(clk_100mhz), .tick_fast(tick_fast), .in_raw(sw_sel_raw), .out_deb(sw_sel));
  debounce_sync #(.STABLE_COUNT(10)) u_db_rst
    (.clk(clk_100mhz), .tick_fast(tick_fast), .in_raw(btn_reset_raw), .out_deb(btn_reset));
  debounce_sync #(.STABLE_COUNT(10)) u_db_pause
    (.clk(clk_100mhz), .tick_fast(tick_fast), .in_raw(btn_pause_raw), .out_deb(btn_pause_deb));

  edge_detect u_ed_pause (.clk(clk_100mhz), .rst(btn_reset), .in_level(btn_pause_deb), .rise_pulse(pause_tog));

  control_fsm u_fsm(
    .clk(clk_100mhz), .rst(btn_reset),
    .adj(sw_adj), .sel(sw_sel), .pause_tog(pause_tog),
    .use_1hz(use_1hz), .use_2hz(use_2hz),
    .sel_minutes(sel_minutes), .sel_seconds(sel_seconds),
    .blink_enable(blink_enable), .count_enable(count_enable)
  );
  wire tick_active = use_2hz ? tick_2hz : tick_1hz;

  time_core u_time(
    .clk(clk_100mhz), .rst(btn_reset),
    .tick_active(tick_active), .count_enable(count_enable),
    .use_2hz(use_2hz), .sel_minutes(sel_minutes), .sel_seconds(sel_seconds),
    .min_tens(mt), .min_ones(mo), .sec_tens(st), .sec_ones(so)
  );

  reg hb_1hz, hb_2hz, hb_blink;
  always @(posedge clk_100mhz) begin
    if (btn_reset) begin
      hb_1hz <= 1'b0;
      hb_2hz <= 1'b0;
      hb_blink <= 1'b0;
    end else begin
      if (tick_1hz) hb_1hz <= ~hb_1hz;
      if (tick_2hz) hb_2hz <= ~hb_2hz;
      if (tick_blink) hb_blink <= ~hb_blink;
    end
  end

  assign led[0] = hb_1hz;
  assign led[1] = hb_2hz;
  assign led[2] = hb_blink;
  assign led[3] = ~count_enable;

  reg blink_state;
  always @(posedge clk_100mhz) begin
    if (btn_reset) blink_state<=1'b0;
    else if (tick_blink) blink_state<=~blink_state;
  end

  display_mux u_disp(
    .clk(clk_100mhz), .rst(btn_reset), .tick_fast(tick_fast),
    .blink_enable(blink_enable), .blink_state(blink_state),
    .sel_minutes(sel_minutes), .sel_seconds(sel_seconds),
    .mt(mt), .mo(mo), .st(st), .so(so),
    .seg(seg), .an(an), .dp(dp)
  );
endmodule
