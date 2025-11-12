// time_core.v
module time_core(
  input  wire       clk,
  input  wire       rst,
  input  wire       tick_active,   // 1-cycle pulse: 1 Hz or 2 Hz chosen upstream
  input  wire       count_enable,  // high only while running (not paused/adjusting)
  input  wire       use_2hz,       // 1 in adjust mode
  input  wire       sel_minutes,   // which field to adjust when use_2hz=1
  input  wire       sel_seconds,
  input  wire       adj_step_hold,   // hold PAUSE to stream 2 Hz adjustments
  input  wire       adj_step_pulse,  // tap PAUSE for single-step adjustments
  output wire [3:0] min_tens,
  output wire [3:0] min_ones,
  output wire [3:0] sec_tens,
  output wire [3:0] sec_ones
);
  // Base increment pulses for seconds/minutes ones
  reg base_sec_ones, base_min_ones;
  always @(posedge clk) begin
    if (rst) begin base_sec_ones<=0; base_min_ones<=0; end
    else begin
      base_sec_ones<=0; base_min_ones<=0;
      if (tick_active) begin
        if (!use_2hz) begin
          if (count_enable) base_sec_ones<=1;     // normal 1 Hz
        end else if (adj_step_hold) begin
          if (sel_seconds) base_sec_ones<=1;      // adjust seconds @2 Hz while held
          else if (sel_minutes) base_min_ones<=1; // adjust minutes @2 Hz while held
        end
      end
      if (use_2hz && adj_step_pulse) begin
        if (sel_seconds) base_sec_ones<=1;        // single manual tap
        else if (sel_minutes) base_min_ones<=1;
      end
    end
  end

  // Counters + cascades
  wire c_s_ones, c_s_tens, c_m_ones;

  // sec ones (0..9)
  bcd_counter #(.MAX(9)) u_so (.clk(clk), .rst(rst), .en(base_sec_ones),
                               .q(sec_ones), .carry(c_s_ones));
  // sec tens (0..5), enable when sec ones rolled 9->0
  bcd_counter #(.MAX(5)) u_st (.clk(clk), .rst(rst), .en(c_s_ones),
                               .q(sec_tens), .carry(c_s_tens));
  // min ones (0..9)
  // In normal run mode the minutes advance whenever seconds roll 59->00
  // (c_s_tens).  While adjusting seconds (use_2hz asserted with sel_seconds)
  // the minutes must remain frozen, so mask off that cascade during adjust.
  wire en_m_ones = base_min_ones | (c_s_tens & ~use_2hz);
  bcd_counter #(.MAX(9)) u_mo (.clk(clk), .rst(rst), .en(en_m_ones),
                               .q(min_ones), .carry(c_m_ones));
  // min tens (0..5), enable when min ones rolled 9->0
  bcd_counter #(.MAX(5)) u_mt (.clk(clk), .rst(rst), .en(c_m_ones),
                               .q(min_tens), .carry(/*unused*/));
endmodule
