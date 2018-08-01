set QROOT_SH=D:\intelFPGA\17.0\quartus\bin64
set PROJ_DIR=C:\Users\hatikvah\Desktop\dcoder
set REVS_DIR=C:\Users\hatikvah\Desktop\dcoder
cd %PROJ_DIR%
@echo off>dcoder_15k.qsf
%QROOT_SH%\quartus_sh -t %REVS_DIR%\rev_dcoder_15k.tcl
cd %REVS_DIR%