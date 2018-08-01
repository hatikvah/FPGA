package require ::quartus::project
project_new -revision dcoder_15k Dcoder
set PATH_HW_TCL [regsub -all {\\} {C:\Users\hatikvah\Desktop\dcoder-s} {/}]
source "$PATH_HW_TCL/Dcoder_LI_HW0_dev.tcl"
source "$PATH_HW_TCL/Dcoder_LI_HW0_pin.tcl"
#source "$PATH_HW_TCL/Dcoder_HW0_sdc.tcl"
export_assignments
