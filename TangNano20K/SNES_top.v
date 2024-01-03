`default_nettype none

module SNES_top
(
    input wire sys_clk,
    input wire sys_reset,
    input wire button,
    output wire [5:0] led_n,

	// SD card
    output wire SD_CSn,
    output wire SD_CLK,
    output wire SD_CMD,
    input  wire SD_DAT,

    // SDRAM
    output wire O_sdram_clk,
    output wire O_sdram_cke,
    output wire O_sdram_cs_n,            // chip select
    output wire O_sdram_cas_n,           // columns address select
    output wire O_sdram_ras_n,           // row address select
    output wire O_sdram_wen_n,           // write enable
    inout wire [31:0] IO_sdram_dq,       // 32 bit bidirectional data bus
    output wire [10:0] O_sdram_addr,     // 11 bit multiplexed address bus
    output wire [1:0] O_sdram_ba,        // two banks
    output wire [3:0] O_sdram_dqm,       // 32/4

    output wire       dvi_clk_p,
    output wire       dvi_clk_n,
    output wire [2:0] dvi_data_p,
    output wire [2:0] dvi_data_n
);

wire serial_clk, pll_124_locked; // 124.875 MHz

    gowin_rpll_124875 pll_124875 (
        .clkout(serial_clk), //output clkout
        .lock(pll_124_locked), //output lock
        .reset(sys_reset), //input reset
        .clkin(sys_clk) //input clkin
    );

wire sys_reset_124;

	sys_reset rstu_124 (
		.RSTn(~sys_reset & pll_124_locked), .CLK(sys_clk), .DOUT(sys_reset_124)
	);

wire pixel_clk; // 24.975 MHz

    gowin_clkdiv_5 clkdiv_5 (
        .clkout(pixel_clk), //output clkout
        .hclkin(serial_clk), //input hclkin
        .resetn(~sys_reset) //input resetn
    );

wire rgb_vs, rgb_hs, rgb_de;
wire [7:0] rgb_r, rgb_g, rgb_b;

	DVI_TX_Top dvi_tx (
		.I_rst_n       (~sys_reset_124),       // input I_rst_n
		.I_serial_clk  (serial_clk),  // input I_serial_clk
		.I_rgb_clk     (pixel_clk),   // input I_rgb_clk
		.I_rgb_vs      (rgb_vs),      // input I_rgb_vs
		.I_rgb_hs      (rgb_hs),      // input I_rgb_hs
		.I_rgb_de      (rgb_de),      // input I_rgb_de
		.I_rgb_r       (rgb_r),       // input [7:0] I_rgb_r
		.I_rgb_g       (rgb_g),       // input [7:0] I_rgb_g
		.I_rgb_b       (rgb_b),       // input [7:0] I_rgb_b
		.O_tmds_clk_p  (dvi_clk_p),  // output O_tmds_clk_p
		.O_tmds_clk_n  (dvi_clk_n),  // output O_tmds_clk_n
		.O_tmds_data_p (dvi_data_p), // output [2:0] O_tmds_data_p
		.O_tmds_data_n (dvi_data_n)  // output [2:0] O_tmds_data_n
	);


wire sdram_clk, sdram_clk_p, core_clk, pll_49_locked;

	gowin_rpll_4995_p90 pll_4995 (
		.clkout(sdram_clk),        // 49.95 MHZ main clock
		.clkoutp(sdram_clk_p),     // 49.95 MHZ phase shifted (90 degrees)
		.clkoutd(core_clk),
		.lock(pll_49_locked),
		.reset(sys_reset_124),
		.clkin(pixel_clk)      // 24.975 Mhz clock
	);

wire sys_reset_249;

	sys_reset rstu_24975 (
		.RSTn(/*sys_reset_n &*/ ~sys_reset_124 & pll_49_locked), .CLK(pixel_clk), .DOUT(sys_reset_249)
	);

wire [5:0] led;

wire sdram_write, sdram_read;
wire [7:0] sdram_din, sdram_dout;
wire [22:0] sdram_adrs;
wire sdram_auto_refresh, sdram_refresh_go;
wire sdram_ack_50;

wire [31:0] sdram_Dout;
wire sdram_Dout_En;

	core CU (
		.p_reset(sys_reset_249), .m_clock(core_clk),
		.BTN(button), .LED(led),
		// SD card
		.SD_CSn(SD_CSn), .SD_CLK(SD_CLK),
		.SD_CMD(SD_CMD), .SD_DAT(SD_DAT),
		// SDRAM
	//	.SDRAM_Din(IO_sdram_dq), .SDRAM_ADDR(O_sdram_addr), .SDRAM_BA(O_sdram_ba), .SDRAM_CSn(O_sdram_cs_n),
	//	.SDRAM_WEn(O_sdram_wen_n), .SDRAM_RASn(O_sdram_ras_n), .SDRAM_CASn(O_sdram_cas_n), .SDRAM_DEn(sdram_Dout_En),
	//	.SDRAM_Dout(sdram_Dout), .SDRAM_DQM(O_sdram_dqm),
		.sdram_write(sdram_write), .sdram_din(sdram_din),
		.sdram_adrs(sdram_adrs), .sdram_read(sdram_read), .sdram_dout(sdram_dout),
		.sdram_auto_refresh(sdram_auto_refresh), .sdram_refresh_go(sdram_refresh_go),
		.sdram_ack_50(sdram_ack_50),
		.DVI_VS(rgb_vs), .DVI_HS(rgb_hs), .DVI_DE(rgb_de),
		.DVI_R(rgb_r), .DVI_G(rgb_g), .DVI_B(rgb_b)
	);

	assign led_n = ~led;

	sdram8_ctrl sdram8_ctrl_inst (
		.p_reset(sys_reset_249),
		.m_clock(sdram_clk),
		.CSn(O_sdram_cs_n),
		.RASn(O_sdram_ras_n),
		.CASn(O_sdram_cas_n),
		.WEn(O_sdram_wen_n),
		.DQM(O_sdram_dqm),
		.DEn(sdram_Dout_En),
		.BA(O_sdram_ba),
		.A(O_sdram_addr),
		.Din(IO_sdram_dq),
		.Dout(sdram_Dout),
		.write(sdram_write),
		.din(sdram_din),
		.adrs(sdram_adrs),
		.read(sdram_read),
		.dout(sdram_dout),
		.auto_refresh(sdram_auto_refresh),
		.refresh_go(sdram_refresh_go),
		.ack(sdram_ack_50)
	);

	assign O_sdram_cke = 1'b1;
	assign O_sdram_clk = sdram_clk_p;
	assign IO_sdram_dq = sdram_Dout_En==1'b0 ? sdram_Dout : 32'bz;

endmodule

`default_nettype wire
