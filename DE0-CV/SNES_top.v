// SNES on FPGA feat. DE0-CV Top Module
// Copyright (c) 2014 pgate1

`default_nettype none

module SNES_top
(
	input wire RESET_N,
	////////////////////	Clock Input	 	////////////////////
	input wire CLOCK_50,  //	50 MHz
	input wire CLOCK2_50, //	50 MHz
	input wire CLOCK3_50, //	50 MHz
	input wire CLOCK4_50, //	50 MHz
	////////////////////	Push Button		////////////////////
	input wire [3:0] KEY_n, //	Pushbutton[3:0]
	////////////////////	DPDT Switch		////////////////////
	input wire [9:0] SW, //	Toggle Switch[9:0]
	////////////////////	7-SEG Dispaly	////////////////////
	output wire [6:0] HEX0, //	Seven Segment Digit 0
	output wire [6:0] HEX1, //	Seven Segment Digit 1
	output wire [6:0] HEX2,	//	Seven Segment Digit 2
	output wire [6:0] HEX3, //	Seven Segment Digit 3
	output wire [6:0] HEX4, //	Seven Segment Digit 4
	output wire [6:0] HEX5, //	Seven Segment Digit 5
	////////////////////////	LED		////////////////////////
	output wire [9:0] LEDR, //	LED Green[9:0]
	/////////////////////	SDRAM Interface		////////////////
	inout wire [15:0] DRAM_DQ, //	SDRAM Data bus 16 Bits
	output wire [12:0] DRAM_ADDR, //	SDRAM Address bus 13 Bits
	output wire DRAM_LDQM, //	SDRAM Low-byte Data Mask 
	output wire DRAM_UDQM, //	SDRAM High-byte Data Mask
	output wire DRAM_WE_N, //	SDRAM Write Enable
	output wire DRAM_CAS_N, //	SDRAM Column Address Strobe
	output wire DRAM_RAS_N, //	SDRAM Row Address Strobe
	output wire DRAM_CS_N, //	SDRAM Chip Select
	output wire [1:0] DRAM_BA, //	SDRAM Bank Address
	output wire DRAM_CLK, //	SDRAM Clock
	output wire DRAM_CKE, //	SDRAM Clock Enable
	////////////////////	SD_Card Interface	////////////////
	input wire [3:0] SD_DATA, //	SD Card Data
	inout wire SD_CMD, //	SD Card Command Signal
	output wire SD_CLK, //	SD Card Clock
	////////////////////	PS2		////////////////////////////
	input wire PS2_CLK, //	PS2 
	input wire PS2_DAT, //	PS2 
	input wire PS2_CLK2, //	PS2
	input wire PS2_DAT2, //	PS2
	////////////////////	VGA		////////////////////////////
	output wire VGA_HS, //	VGA H_SYNC
	output wire VGA_VS, //	VGA V_SYNC
	output wire [3:0] VGA_R, //	VGA Red[3:0]
	output wire [3:0] VGA_G, //	VGA Green[3:0]
	output wire [3:0] VGA_B, //	VGA Blue[3:0]
	////////////////////	GPIO	////////////////////////////
	inout wire [35:0] GPIO_0, //	GPIO Connection 0 Data Bus
	inout wire [35:0] GPIO_1  //	GPIO Connection 1 Data Bus
);

wire p_reset, g_reset;

wire [15:0] sdram_Din;
wire sdram_Din_En;

wire sd_cmd_out, sd_cmd_en;

wire sound_L, sound_R;

	sys_reset RSTU (
		.RSTn(RESET_N), .CLK(CLOCK_50), .DOUT(p_reset)
	);

	GLOBAL rst_GU (
		.IN(p_reset), .OUT(g_reset)
	);

	core CU (
		.p_reset(g_reset),
		.m_clock(CLOCK_50),
		.KEY(~KEY_n), .SW(SW),
		.HEX0(HEX0), //	Seven Segment Digit 0
		.HEX1(HEX1), //	Seven Segment Digit 1
		.HEX2(HEX2), //	Seven Segment Digit 2
		.HEX3(HEX3), //	Seven Segment Digit 3
		.HEX4(HEX4), //	Seven Segment Digit 4
		.HEX5(HEX5), //	Seven Segment Digit 5
		.LEDR(LEDR),
//--------------------- SDRAM Interface --------------------
		.SDRAM_CSn(DRAM_CS_N), .SDRAM_WEn(DRAM_WE_N), .SDRAM_DEn(sdram_Din_En),
		.SDRAM_RASn(DRAM_RAS_N), .SDRAM_CASn(DRAM_CAS_N),
		.SDRAM_BA(DRAM_BA), .SDRAM_ADDR(DRAM_ADDR),
		.SDRAM_LDQM(DRAM_LDQM), .SDRAM_UDQM(DRAM_UDQM),
		.SDRAM_Dout(DRAM_DQ), .SDRAM_Din(sdram_Din),
//--------------------- SD_Card Interface ------------------
//		SD_CSn => SD_DAT3, SD_CLK => SD_CLK, -- SPI mode
//		SD_CMD => SD_CMD,  SD_DAT => SD_DAT0 -- SPI mode
		.SD_CLK(SD_CLK), .SD_CMD_en(sd_cmd_en), // SD mode
		.SD_CMD(sd_cmd_out), .SD_RES(SD_CMD), .SD_DAT(SD_DATA), // SD mode
//-------------------- PS/2 --------------------------------
		.PS2_KBCLK(PS2_CLK), .PS2_KBDAT(PS2_DAT),
//--------------------- VGA --------------------------------
		.VGA_HS(VGA_HS), .VGA_VS(VGA_VS),
		.VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
//--------------------- Sound ------------------------------
		.Sound_Left(sound_L), .Sound_Right(sound_R)
	);

	assign DRAM_CKE = 1'b1;
	sdram_pll sdram_pll_inst (
		.refclk(CLOCK_50), .outclk_0(DRAM_CLK)
	);
	assign DRAM_DQ = sdram_Din_En==1'b0 ? sdram_Din : 16'hzzzz;

	// CMD SPI:コマンド出力、SD:コマンド出力とレスポンス入力
	assign SD_CMD = sd_cmd_en==1'b1 ? sd_cmd_out : 1'bz;

	assign GPIO_0 = 36'b0;

	// for EXT-1
	assign GPIO_1[16:0] = 17'b0;
	assign GPIO_1[17] = sound_L;
	assign GPIO_1[18] = 1'b0;
	assign GPIO_1[19] = sound_R;
	assign GPIO_1[35:20] = 16'b0;

endmodule

`default_nettype wire
