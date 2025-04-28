`default_nettype none

module SNES_top
(
	input wire sys_reset_n,
	input wire sys_clk,  // 50 Mhz, crystal clock from board
	input wire button_n,
	output wire [1:0] LED,

	output wire [7:0] PMOD0,

	// SD card
/*
	output wire SD_CSn,
	output wire SD_CLK,
	output wire SD_CMD,
	input  wire SD_DAT,
*/
	output wire SD_CLK,
	inout  wire SD_CMD,
	inout  wire [3:0] SD_DAT,

	input  wire UART_rx,
	output wire UART_tx,

	// SDRAM
	output wire O_sdram_clk,
	output wire O_sdram_cke,
	output wire O_sdram_cs_n,            // chip select
	output wire O_sdram_cas_n,           // columns address select
	output wire O_sdram_ras_n,           // row address select
	output wire O_sdram_wen_n,           // write enable
	inout wire [15:0] IO_sdram_dq,       // 16 bit bidirectional data bus
	output wire [12:0] O_sdram_addr,     // 13 bit multiplexed address bus
	output wire [1:0] O_sdram_ba,        // four banks
	output wire [1:0] O_sdram_dqm,       // 16/2

	output wire       tmds_clk_p,
//	output wire       tmds_clk_n,
	output wire [2:0] tmds_dat_p
//	output wire [2:0] tmds_dat_n
);

wire serial_clk, pll_125_locked; // 125 MHz

	gowin_pll_125 pll_125 (
		.clkout0(serial_clk),  // output clkout
		.lock(pll_125_locked), // output lock
		.reset(~sys_reset_n),  // input reset
		.clkin(sys_clk)        // input clkin
	);

wire sys_reset_125;

	sys_reset rstu_125 (
		.RSTn(sys_reset_n & pll_125_locked), .CLK(sys_clk), .DOUT(sys_reset_125)
	);

wire pixel_clk; // 25 MHz

	gowin_clkdiv_5 clkdiv_5 (
		.clkout(pixel_clk),  // output clkout
		.hclkin(serial_clk), // input hclkin
		.resetn(sys_reset_n) // input resetn
	);

wire rgb_vs, rgb_hs, rgb_de;
wire [7:0] rgb_r, rgb_g, rgb_b;

reg audio_clk;
wire [15:0] Audio [1:0];
reg [15:0] s_Audio [1:0];

// 25MHzから64kHzサイクル(32kHzクロック)を生成
// これでHDMIオーディオの音の途切れが解消された
	localparam COUNT_WIDTH = 13;
	wire [COUNT_WIDTH-1:0] add;
	wire [COUNT_WIDTH-1:0] max;
	reg  [COUNT_WIDTH-1:0] count;
	wire [COUNT_WIDTH-1:0] sa;

	assign add = 8;
	assign max = 3125;
	assign sa = count - max;

	always @(posedge pixel_clk or posedge sys_reset_125) begin
		if(sys_reset_125)
			count <= 0;
		else if(sa[COUNT_WIDTH-1]) // count < max
			count <= count + add;
		else begin
			count <= sa + add;
			audio_clk <= ~audio_clk;
			if(audio_clk) s_Audio <= Audio; // 立ち下がりでホールド
		end
	end

	hdmi_tx #(
		.CLOCK_FREQUENCY(25.0),
	//	.SYNC_POLARITY("POSITIVE"),
		.AUDIO_FREQUENCY(32.0),
		.PCMFIFO_DEPTH(7)
	) u_tx (
		.reset      (sys_reset_125),
		.clk        (pixel_clk),
		.clk_x5     (serial_clk),
		.active     (rgb_de),
		.r_data     (rgb_r),
		.g_data     (rgb_g),
		.b_data     (rgb_b),
		.hsync      (rgb_hs),
		.vsync      (rgb_vs),
		.pcm_fs     (audio_clk),
		.pcm_l      ({19'(signed'(s_Audio[0])), 5'b0}),
		.pcm_r      ({19'(signed'(s_Audio[1])), 5'b0}),
		.data       (tmds_dat_p),
	//	.data_n     (tmds_dat_n),
		.clock      (tmds_clk_p)
	//	.clock_n    (tmds_clk_n)
	);

wire /*sdram_clk,*/ core_clk, sdram_clk_p, pll_50_locked;

	gowin_pll_50_p225 pll_50 (
		.clkout0(core_clk),    // 50 MHZ main clock
		.clkout1(sdram_clk_p), // 50 MHZ phase shifted (225 degrees)
		.lock(pll_50_locked),
		.reset(sys_reset_125),
		.clkin(pixel_clk)      // 25 Mhz clock
	);

wire sys_reset_50_;

	sys_reset rstu_50 (
		.RSTn(/*sys_reset_n &*/ ~sys_reset_125 & pll_50_locked), .CLK(pixel_clk), .DOUT(sys_reset_50_)
	);

wire sys_reset_50;

	DCE dce_inst (
		.CLKIN(sys_reset_50_), .CE(1'b1), .CLKOUT(sys_reset_50)
	);
//assign sys_reset_50 = sys_reset_50_;

wire sd_cmd_out, sd_cmd_en;

wire sdram_write, sdram_read;
wire [7:0] sdram_din, sdram_dout;
wire [24:0] sdram_adrs;
wire sdram_manual_refresh, sdram_refresh_go;
wire sdram_ack;

wire [15:0] sdram_Din;
wire sdram_Din_En;

	core CU (
		.p_reset(sys_reset_50), .m_clock(core_clk),
		.BTN(~button_n), .LED(LED), .PMOD(PMOD0),
		// SD card
	//	.SD_CSn(SD_CSn), .SD_CLK(SD_CLK),
	//	.SD_CMD(SD_CMD), .SD_DAT(SD_DAT),
		.SD_CLK(SD_CLK), .SD_CMD_en(sd_cmd_en), .SD_CMD(sd_cmd_out),
		.SD_RES(SD_CMD), .SD_DAT(SD_DAT),
		.UART_RX(UART_rx), .UART_TX(UART_tx),
		// SDRAM
	//	.SDRAM_Din(IO_sdram_dq), .SDRAM_ADDR(O_sdram_addr), .SDRAM_BA(O_sdram_ba), .SDRAM_CSn(O_sdram_cs_n),
	//	.SDRAM_WEn(O_sdram_wen_n), .SDRAM_RASn(O_sdram_ras_n), .SDRAM_CASn(O_sdram_cas_n), .SDRAM_DEn(sdram_Dout_En),
	//	.SDRAM_Dout(sdram_Dout), .SDRAM_DQM(O_sdram_dqm),
		.sdram_write(sdram_write), .sdram_din(sdram_din),
		.sdram_adrs(sdram_adrs), .sdram_read(sdram_read), .sdram_dout(sdram_dout),
		.sdram_manual_refresh(sdram_manual_refresh), .sdram_refresh_go(sdram_refresh_go),
		.sdram_ack(sdram_ack),
		.DVI_VS(rgb_vs), .DVI_HS(rgb_hs), .DVI_DE(rgb_de),
		.DVI_R(rgb_r), .DVI_G(rgb_g), .DVI_B(rgb_b),
		.Sound_Left(Audio[0]), .Sound_Right(Audio[1])
	);

	// SD mode
	assign SD_CMD = sd_cmd_en ? sd_cmd_out : 1'bz; // SPI:コマンド出力、SD:コマンド出力とレスポンス入力

	sdram8_ctrl_50 sdram_inst (
		.p_reset(sys_reset_50), .m_clock(core_clk),
		.CSn(O_sdram_cs_n), .RASn(O_sdram_ras_n), .CASn(O_sdram_cas_n),
		.WEn(O_sdram_wen_n), .DQM(O_sdram_dqm), .DEn(sdram_Din_En),
		.BA(O_sdram_ba), .A(O_sdram_addr),
		.Din(sdram_Din), .Dout(IO_sdram_dq),
		.write(sdram_write), .din(sdram_din), .adrs(sdram_adrs),
		.read(sdram_read), .dout(sdram_dout),
		.manual_refresh(sdram_manual_refresh), .refresh_go(sdram_refresh_go),
		.ack(sdram_ack)
	);

	assign O_sdram_cke = 1'b1;
	assign O_sdram_clk = sdram_clk_p;
	assign IO_sdram_dq = sdram_Din_En==1'b0 ? sdram_Din : 32'bz;

endmodule

`default_nettype wire
