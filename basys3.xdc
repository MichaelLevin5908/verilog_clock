## ===== Basys-3 constraints for top_stopwatch =====

## 100 MHz clock
set_property PACKAGE_PIN W5 [get_ports {clk_100mhz}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk_100mhz}]
create_clock -name sys_clk -period 10.000 [get_ports {clk_100mhz}]

## Buttons
# RESET (BTN C / center)
set_property PACKAGE_PIN U18 [get_ports {btn_reset_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn_reset_raw}]
# PAUSE (BTN R / right)
set_property PACKAGE_PIN T17 [get_ports {btn_pause_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn_pause_raw}]

## Switches
# ADJ = SW0
set_property PACKAGE_PIN V17 [get_ports {sw_adj_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_adj_raw}]
# SEL = SW1
set_property PACKAGE_PIN V16 [get_ports {sw_sel_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_sel_raw}]

## Seven-segment segments (active-low) seg[6:0] = {a,b,c,d,e,f,g}
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]  ;# a
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]  ;# b
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]  ;# c
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]  ;# d
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]  ;# e
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]  ;# f
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]  ;# g
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

## Decimal point (active-low)
set_property PACKAGE_PIN V7 [get_ports {dp}]
set_property IOSTANDARD LVCMOS33 [get_ports {dp}]

## Seven-segment anodes (active-low): an[3] leftmost ... an[0] rightmost
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

## LEDs (led[3:0]) — Basys-3 defaults
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]


