
create_clock -name clk_SYS -period 20.000 -waveform {0 10.000} [get_ports {sys_clk}]
create_generated_clock -name clk_SERIAL -source [get_ports {sys_clk}] -master_clock clk_SYS -divide_by 8 -multiply_by 20 [get_pins {pll_125/PLL_inst/CLKOUT0}]
create_generated_clock -name clk_PIXEL -source [get_pins {pll_125/PLL_inst/CLKOUT0}] -master_clock clk_SERIAL -divide_by 5 -multiply_by 1 [get_pins {clkdiv_5/clkdiv_inst/CLKOUT}]
//create_generated_clock -name clk_SDRAM -source [get_pins {clkdiv_5/clkdiv_inst/CLKOUT}] -master_clock clk_PIXEL -divide_by 1 -multiply_by 2 [get_pins {pll_50/PLL_inst/CLKOUT}]
create_generated_clock -name clk_SDRAMp -source [get_pins {clkdiv_5/clkdiv_inst/CLKOUT}] -master_clock clk_PIXEL -divide_by 1 -multiply_by 2 -phase 225 [get_pins {pll_50/PLL_inst/CLKOUT1}]
create_generated_clock -name clk_CORE -source [get_pins {clkdiv_5/clkdiv_inst/CLKOUT}] -master_clock clk_PIXEL -divide_by 1 -multiply_by 2 [get_pins {pll_50/PLL_inst/CLKOUT0}]
create_clock -name clk_AUDIO -period 31250.000 -waveform {0 15625.000} [get_nets {audio_clk}]

set_false_path -from [get_clocks {clk_SYS}] -to [get_clocks {clk_PIXEL}]
set_false_path -from [get_clocks {clk_SERIAL}] -to [get_clocks {clk_PIXEL}]
set_false_path -from [get_clocks {clk_PIXEL}] -to [get_clocks {clk_SERIAL}]
set_false_path -from [get_clocks {clk_PIXEL}] -to [get_clocks {clk_CORE}]
set_false_path -from [get_clocks {clk_SDRAMp}] -to [get_clocks {clk_CORE}]
set_false_path -from [get_clocks {clk_CORE}] -to [get_clocks {clk_PIXEL}]
set_false_path -from [get_clocks {clk_CORE}] -to [get_clocks {clk_SERIAL}]

set_false_path -from [get_ports {sys_reset_n, button_n}]
set_false_path -to [get_ports {LED[*], PMOD0[*]}]
