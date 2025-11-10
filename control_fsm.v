// control_fsm.v
module control_fsm(
  input  wire clk, rst,
  input  wire adj,         // debounced
  input  wire sel,         // debounced (0=minutes, 1=seconds)
  input  wire pause_tog,   // one-cycle pulse
  output reg  use_1hz,
  output reg  use_2hz,
  output reg  sel_minutes,
  output reg  sel_seconds,
  output reg  blink_enable,
  output reg  count_enable
);
  localparam RUN=2'd0, PAUSE=2'd1, AMIN=2'd2, ASEC=2'd3;
  reg [1:0] cur, nxt;

  always @(posedge clk) begin
    if (rst) cur<=RUN; else cur<=nxt;
  end

  always @(*) begin
    nxt=cur;
    case(cur)
      RUN:   begin
        if (pause_tog) nxt=PAUSE;
        else if (adj && ~sel) nxt=AMIN;
        else if (adj &&  sel) nxt=ASEC;
      end
      PAUSE: begin
        if (pause_tog) nxt=RUN;
        else if (adj && ~sel) nxt=AMIN;
        else if (adj &&  sel) nxt=ASEC;
      end
      AMIN:  begin
        if (!adj) nxt=RUN;
        else if (sel) nxt=ASEC;
      end
      ASEC:  begin
        if (!adj) nxt=RUN;
        else if (!sel) nxt=AMIN;
      end
    endcase
  end

  always @(*) begin
    use_1hz=0; use_2hz=0; sel_minutes=0; sel_seconds=0; blink_enable=0; count_enable=0;
    case(cur)
      RUN:   begin use_1hz=1; count_enable=1; end
      PAUSE: begin use_1hz=1; count_enable=0; end
      AMIN:  begin use_2hz=1; sel_minutes=1; blink_enable=1; count_enable=1; end
      ASEC:  begin use_2hz=1; sel_seconds=1; blink_enable=1; count_enable=1; end
    endcase
  end
endmodule
