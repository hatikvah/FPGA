set_location_assignment PIN_E16    -to       clkin_i
set_location_assignment PIN_L2     -to       biss_slo_i
set_location_assignment PIN_L1     -to       biss_ma_o

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to clkin_i
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to biss_slo_i
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to biss_ma_o