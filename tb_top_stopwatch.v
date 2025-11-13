// tb_top_stopwatch.v
// this is our test bench

`timescale 1ns/1ps
module tb_top_stopwatch;
  reg clk = 0;
  always #5 clk = ~clk;

  reg btn_reset_raw = 1;
  reg btn_pause_raw = 0;
  reg sw_adj_raw = 0;
  reg sw_sel_raw = 0;

  wire [6:0] seg;
  wire [3:0] an;
  wire dp;
  top_stopwatch uut (
    .clk_100mhz(clk),
    .btn_reset_raw(btn_reset_raw),
    .btn_pause_raw(btn_pause_raw),
    .sw_adj_raw(sw_adj_raw),
    .sw_sel_raw(sw_sel_raw),
    .seg(seg), .an(an), .dp(dp)
  );

  defparam uut.u_div.DIV_1HZ   = 10;
  defparam uut.u_div.DIV_2HZ   = 5;
  defparam uut.u_div.DIV_FAST  = 2;
  defparam uut.u_div.DIV_BLINK = 7;

  defparam uut.u_db_adj.STABLE_COUNT   = 2;
  defparam uut.u_db_sel.STABLE_COUNT   = 2;
  defparam uut.u_db_rst.STABLE_COUNT   = 2;
  defparam uut.u_db_pause.STABLE_COUNT = 2;

  wire [3:0] mt = uut.mt, mo = uut.mo, st = uut.st, so = uut.so;

  task press_pause;
    begin
      btn_pause_raw = 1; repeat (4) @(posedge clk);
      btn_pause_raw = 0; repeat (4) @(posedge clk);
    end
  endtask

  reg [15:0] snapshot;

  initial begin
    $display("== Sim start ==");
    repeat (8) @(posedge clk);
    btn_reset_raw = 0;

    repeat (40) @(posedge clk);

    press_pause();
    repeat (20) @(posedge clk);

    press_pause();
    repeat (20) @(posedge clk);

    sw_adj_raw = 1; sw_sel_raw = 1;
    repeat (80) @(posedge clk);

    sw_sel_raw = 0;
    repeat (80) @(posedge clk);

    sw_adj_raw = 0;
    repeat (12) @(posedge clk);

    snapshot = {mt, mo, st, so};
    repeat (40) @(posedge clk);
    if ({mt, mo, st, so} !== snapshot) begin
      $error("Timer advanced after exiting adjust despite pause toggle during adjust");
      $fatal;
    end

    press_pause();
    repeat (20) @(posedge clk);

    press_pause();
    repeat (20) @(posedge clk);

    sw_adj_raw = 1; sw_sel_raw = 1;
    repeat (40) @(posedge clk);
    sw_sel_raw = 0;
    repeat (40) @(posedge clk);

    press_pause();
    repeat (20) @(posedge clk);

    sw_adj_raw = 1; sw_sel_raw = 1;
    repeat (40) @(posedge clk);
    sw_sel_raw = 0;
    repeat (40) @(posedge clk);

    snapshot = {mt, mo, st, so};
    sw_adj_raw = 0;
    repeat (20) @(posedge clk);
    if ({mt, mo, st, so} !== snapshot) begin
      $error("Timer advanced after adjust even though pause should persist");
      $fatal;
    end

    press_pause();
    repeat (40) @(posedge clk);

    btn_reset_raw = 1;
    repeat (12) @(posedge clk);
    btn_reset_raw = 0;
    repeat (5) @(posedge clk);
    if (mt | mo | st | so) begin
      $error("Reset failed to clear stopwatch digits");
      $fatal;
    end
    repeat (15) @(posedge clk);

    $display("== Sim done ==");
    $finish;
  end

  initial begin
    $display("time\t mt mo : st so | an seg");
    forever begin
      @(posedge clk);
      $display("%0t\t   %0d  %0d :  %0d  %0d | %b %b",
        $time, mt, mo, st, so, an, seg);
    end
  end
endmodule
