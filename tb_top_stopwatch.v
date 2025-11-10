`timescale 1ns/1ps

module tb_top_stopwatch;
  // 100 MHz sim clock
  reg clk = 0;
  always #5 clk = ~clk; // 10ns period

  // raw I/Os to top
  reg btn_reset_raw = 1;
  reg btn_pause_raw = 0;
  reg sw_adj_raw    = 0;
  reg sw_sel_raw    = 0;

  wire [6:0] seg;
  wire [3:0] an;
  wire       dp;

  // DUT
  top_stopwatch uut (
    .clk_100mhz(clk),
    .btn_reset_raw(btn_reset_raw),
    .btn_pause_raw(btn_pause_raw),
    .sw_adj_raw(sw_adj_raw),
    .sw_sel_raw(sw_sel_raw),
    .seg(seg), .an(an), .dp(dp)
  );

  // --------- SPEED UP the design for sim via defparam ----------
  // Clock divider: make “1 Hz” every 10 cycles, “2 Hz” every 5 cycles, fast tick every 2 cycles
  defparam uut.u_div.DIV_1HZ   = 10;
  defparam uut.u_div.DIV_2HZ   = 5;
  defparam uut.u_div.DIV_FAST  = 2;
  defparam uut.u_div.DIV_BLINK = 7;

  // Debouncers: shrink stable window to 2 samples
  defparam uut.u_db_adj.STABLE_COUNT   = 2;
  defparam uut.u_db_sel.STABLE_COUNT   = 2;
  defparam uut.u_db_rst.STABLE_COUNT   = 2;
  defparam uut.u_db_pause.STABLE_COUNT = 2;

  // Peek the internal BCD digits (declared in top)
  wire [3:0] mt = uut.mt, mo = uut.mo, st = uut.st, so = uut.so;

  // Helpers to "press" a button with a short clean pulse
  task press_pause;
    begin
      btn_pause_raw = 1; repeat (4) @(posedge clk);
      btn_pause_raw = 0; repeat (4) @(posedge clk);
    end
  endtask

  initial begin
    $display("== Sim start ==");
    // Release reset after a few cycles
    repeat (8) @(posedge clk);
    btn_reset_raw = 0;

    // Let it run for a few "seconds" (fast)
    repeat (40) @(posedge clk);

    // Pause
    press_pause();
    repeat (20) @(posedge clk);

    // Resume
    press_pause();
    repeat (20) @(posedge clk);

    // Enter adjust mode, adjust SECONDS (SEL=1)
    sw_adj_raw = 1; sw_sel_raw = 1;
    repeat (40) @(posedge clk);

    // Switch to adjust MINUTES (SEL=0)
    sw_sel_raw = 0;
    repeat (40) @(posedge clk);

    // Exit adjust
    sw_adj_raw = 0;
    repeat (40) @(posedge clk);

    $display("== Sim done ==");
    $finish;
  end

  // Simple monitor (watch digits & anodes)
  initial begin
    $display("time\t mt mo : st so | an seg");
    forever begin
      @(posedge clk);
      $display("%0t\t   %0d  %0d :  %0d  %0d | %b %b",
        $time, mt, mo, st, so, an, seg);
    end
  end
endmodule
