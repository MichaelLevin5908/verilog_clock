## xdc constraints for our stopwatch

set_property PACKAGE_PIN W5 [get_ports {clk_100mhz}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk_100mhz}]
create_clock -name sys_clk -period 10.000 [get_ports {clk_100mhz}]

# RESET (BTN C / center)
set_property PACKAGE_PIN U18 [get_ports {btn_reset_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn_reset_raw}]
# PAUSE (BTN R / right)
set_property PACKAGE_PIN T17 [get_ports {btn_pause_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn_pause_raw}]

## switches
# ADJ = SW0
set_property PACKAGE_PIN V17 [get_ports {sw_adj_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_adj_raw}]
# SEL = SW1
set_property PACKAGE_PIN V16 [get_ports {sw_sel_raw}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_sel_raw}]

set_property PACKAGE_PIN W7 [get_ports {seg[0]}];
set_property PACKAGE_PIN W6 [get_ports {seg[1]}];
set_property PACKAGE_PIN U8 [get_ports {seg[2]}];
set_property PACKAGE_PIN V8 [get_ports {seg[3]}];
set_property PACKAGE_PIN U5 [get_ports {seg[4]}];
set_property PACKAGE_PIN V5 [get_ports {seg[5]}];
set_property PACKAGE_PIN U7 [get_ports {seg[6]}];
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

set_property PACKAGE_PIN V7 [get_ports {dp}]
set_property IOSTANDARD LVCMOS33 [get_ports {dp}]

set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]


