// time_core.v
module time_core(
  input  wire clk,
  input  wire rst,
  input  wire tick_active,
  input  wire count_enable,
  input  wire use_2hz,
  input  wire sel_minutes,
  input  wire sel_seconds,
  output wire [3:0] min_tens,
  output wire [3:0] min_ones,
  output wire [3:0] sec_tens,
  output wire [3:0] sec_ones
);
  reg base_sec_ones, base_min_ones;
  always @(posedge clk) begin
    if (rst) begin base_sec_ones<=0; base_min_ones<=0; end
    else begin
      base_sec_ones<=0; base_min_ones<=0;
      if (tick_active) begin
        if (!use_2hz) begin
          if (count_enable) base_sec_ones<=1;
        end else begin
          if (sel_seconds) base_sec_ones<=1;
          else if (sel_minutes) base_min_ones<=1;
        end
      end
    end
  end

  wire c_s_ones, c_s_tens, c_m_ones;

  bcd_counter #(.MAX(9)) u_so (.clk(clk), .rst(rst), .en(base_sec_ones),
    .q(sec_ones), .carry(c_s_ones));

  bcd_counter #(.MAX(5)) u_st (.clk(clk), .rst(rst), .en(c_s_ones),
    .q(sec_tens), .carry(c_s_tens));

  wire en_m_ones = base_min_ones | (c_s_tens & ~use_2hz);
  bcd_counter #(.MAX(9)) u_mo (.clk(clk), .rst(rst), .en(en_m_ones),
    .q(min_ones), .carry(c_m_ones));

  bcd_counter #(.MAX(5)) u_mt (.clk(clk), .rst(rst), .en(c_m_ones),
    .q(min_tens), .carry(/*unused*/));
endmodule
