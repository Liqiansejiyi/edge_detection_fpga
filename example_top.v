`timescale 1ns/1ps

//`include "ddr3_controller.vh"


module example_top 
(
	////////////////////////////////////////////////////////////////
	//	External Clock & Reset
	//input 			nrst, 			//	Button K2
	input 			clk_24m,			//	24MHz Crystal
	input 			clk_25m,			//	25MHz Crystal 
	
	
	////////////////////////////////////////////////////////////////
	//	System Clock
	output 			sys_pll_rstn_o, 		
	
	input 			clk_sys,			//	Sys PLL 96MHz 
	input 			clk_pixel,			//	Sys PLL 74.25MHz
	input 			clk_pixel_2x,		//	Sys PLL 148.5MHz
	input 			clk_pixel_10x,		//	Sys PLL 742.5MHz
	
	input 			sys_pll_lock,		//	Sys PLL Lock
	
	////////////////////////////////////////////////////////////////
	//	MIPI-DSI Clock & Reset
	output 			dsi_pll_rstn_o,
	
	input 			dsi_refclk_i,		//	48MHz Reference Clock (for DSI PLL)
	input 			dsi_byteclk_i,		//	DSI Byte Clock (1X)
	input 			dsi_serclk_i,		//	DSI Serial Clock (4X 45)
	input 			dsi_txcclk_i,		//	DSI Serial Clock (4X 135)
	
	input 			dsi_pll_lock,
	
	////////////////////////////////////////////////////////////////
	//	DDR Clock
	output 			ddr_pll_rstn_o, 
	
	input 			tdqss_clk,			
	input 			core_clk,			//	DDR PLL 200MHz
	input 			tac_clk,			
	input 			twd_clk,			
	
	input 			ddr_pll_lock,		//	DDR PLL Lock
	
	////////////////////////////////////////////////////////////////
	//	DDR PLL Phase Shift Interface
	output 	[2:0] 	shift,
	output 	[4:0] 	shift_sel,
	output 			shift_ena,
	
	
	
	////////////////////////////////////////////////////////////////
	//	LVDS Clock
	output 			lvds_pll_rstn_o, 
	
	input 			clk_lvds_1x, 
	input 			clk_lvds_7x, 
	input 			clk_27m, 			//	RGB 1X Clock (16MHz)
	input 			clk_54m, 			//	RGB 2X Clock (32MHz, for export control)
	
	input 			lvds_pll_lock, 
	
	
	
	////////////////////////////////////////////////////////////////
	//	DDR Interface Ports
	output 	[15:0] 	addr,
	output 	[2:0] 	ba,
	output 			we,
	output 			reset,
	output 			ras,
	output 			cas,
	output 			odt,
	output 			cke,
	output 			cs,
	
	//	DQ I/O
	input 	[15:0] 	i_dq_hi,
	input 	[15:0] 	i_dq_lo,
	
	output 	[15:0] 	o_dq_hi,
	output 	[15:0] 	o_dq_lo,
	output 	[15:0] 	o_dq_oe,
	
	//	DM O
	output 	[1:0] 	o_dm_hi,
	output 	[1:0] 	o_dm_lo,
	
	//	DQS I/O
	input 	[1:0] 	i_dqs_hi,
	input 	[1:0] 	i_dqs_lo,
	
	input 	[1:0] 	i_dqs_n_hi,
	input 	[1:0] 	i_dqs_n_lo,
	
	output 	[1:0] 	o_dqs_hi,
	output 	[1:0] 	o_dqs_lo,
	
	output 	[1:0] 	o_dqs_n_hi,
	output 	[1:0] 	o_dqs_n_lo,
	
	output 	[1:0] 	o_dqs_oe,
	output 	[1:0] 	o_dqs_n_oe,
	
	//	CK
	output 			clk_p_hi, 
	output 			clk_p_lo, 
	output 			clk_n_hi, 
	output 			clk_n_lo, 
	
	
	
	////////////////////////////////////////////////////////////////
	//	MIPI-CSI Ctl / I2C
	output 			csi_ctl0_o,
	output 			csi_ctl0_oe,
	input 			csi_ctl0_i,
	
	output 			csi_ctl1_o,
	output 			csi_ctl1_oe,
	input 			csi_ctl1_i,
	
	output 			csi_scl_o,
	output 			csi_scl_oe,
	input 			csi_scl_i,
	
	output 			csi_sda_o,
	output 			csi_sda_oe,
	input 			csi_sda_i,
	
	//	MIPI-CSI RXC 
	input 			csi_rxc_lp_p_i,
	input 			csi_rxc_lp_n_i,
	output 			csi_rxc_hs_en_o,
	output 			csi_rxc_hs_term_en_o,
	input 			csi_rxc_i,
	
	//	MIPI-CSI RXD0
	output 			csi_rxd0_rst_o,
	output 			csi_rxd0_hs_en_o,
	output 			csi_rxd0_hs_term_en_o,
	
	input 			csi_rxd0_lp_p_i,
	input 			csi_rxd0_lp_n_i,
	input 	[7:0] 	csi_rxd0_hs_i,
	
	//	MIPI-CSI RXD1
	output 			csi_rxd1_rst_o,
	output 			csi_rxd1_hs_en_o,
	output 			csi_rxd1_hs_term_en_o,
	
	input 			csi_rxd1_lp_n_i,
	input 			csi_rxd1_lp_p_i,
	input 	[7:0] 	csi_rxd1_hs_i,
	
	//	MIPI-CSI RXD2
	output 			csi_rxd2_rst_o,
	output 			csi_rxd2_hs_en_o,
	output 			csi_rxd2_hs_term_en_o,
	
	input 			csi_rxd2_lp_p_i,
	input 			csi_rxd2_lp_n_i,
	input 	[7:0] 	csi_rxd2_hs_i,
	
	//	MIPI-CSI RXD3
	output 			csi_rxd3_rst_o,
	output 			csi_rxd3_hs_en_o,
	output 			csi_rxd3_hs_term_en_o,
	
	input 			csi_rxd3_lp_p_i,
	input 			csi_rxd3_lp_n_i,
	input 	[7:0] 	csi_rxd3_hs_i,
	
	//output 			csi_rxd0_fifo_rd_o, 
	//input 			csi_rxd0_fifo_empty_i, 
	//output 			csi_rxd1_fifo_rd_o, 
	//input 			csi_rxd1_fifo_empty_i, 
	//output 			csi_rxd2_fifo_rd_o, 
	//input 			csi_rxd2_fifo_empty_i, 
	//output 			csi_rxd3_fifo_rd_o, 
	//input 			csi_rxd3_fifo_empty_i, 
	
	
	
	////////////////////////////////////////////////////////////////
	//	DSI PWM & Reset Control 
	output 			dsi_pwm_o,			//	MIPI-DSI LCD PWM
	output 			dsi_resetn_o,		//	MIPI-DSI LCD Reset
	
	//	MIPI-DSI TXC / TXD
	output 			dsi_txc_rst_o,
	output 			dsi_txc_lp_p_oe,
	output 			dsi_txc_lp_p_o,
	output 			dsi_txc_lp_n_oe,
	output 			dsi_txc_lp_n_o,
	output 			dsi_txc_hs_oe,
	output 	[7:0] 	dsi_txc_hs_o,
	
	output 			dsi_txd0_rst_o,
	output 			dsi_txd0_hs_oe,
	output 	[7:0] 	dsi_txd0_hs_o,
	output 			dsi_txd0_lp_p_oe,
	output 			dsi_txd0_lp_p_o,
	output 			dsi_txd0_lp_n_oe,
	output 			dsi_txd0_lp_n_o,
	
	output 			dsi_txd1_rst_o,
	output 			dsi_txd1_lp_p_oe,
	output 			dsi_txd1_lp_p_o,
	output 			dsi_txd1_lp_n_oe,
	output 			dsi_txd1_lp_n_o,
	output 			dsi_txd1_hs_oe,
	output 	[7:0] 	dsi_txd1_hs_o,
	
	output 			dsi_txd2_rst_o,
	output 			dsi_txd2_lp_p_oe,
	output 			dsi_txd2_lp_p_o,
	output 			dsi_txd2_lp_n_oe,
	output 			dsi_txd2_lp_n_o,
	output 			dsi_txd2_hs_oe,
	output 	[7:0] 	dsi_txd2_hs_o,
	
	output 			dsi_txd3_rst_o,
	output 			dsi_txd3_lp_p_oe,
	output 			dsi_txd3_lp_p_o,
	output 			dsi_txd3_lp_n_oe,
	output 			dsi_txd3_lp_n_o,
	output 			dsi_txd3_hs_oe,
	output 	[7:0] 	dsi_txd3_hs_o,
	
	input 			dsi_txd0_lp_p_i,
	input 			dsi_txd0_lp_n_i,
	input 			dsi_txd1_lp_p_i,
	input 			dsi_txd1_lp_n_i,
	input 			dsi_txd2_lp_p_i,
	input 			dsi_txd2_lp_n_i,
	input 			dsi_txd3_lp_p_i,
	input 			dsi_txd3_lp_n_i,
	
	
	////////////////////////////////////////////////////////////////
	//	UART Interface
	input 		 	uart_rx_i,			//	Support 460800-8-N-1. 
	output 		 	uart_tx_o, 
	
	
	output 	[5:0] 	led_o,			//	
	
	
	////////////////////////////////////////////////////////////////
	//	CMOS Sensor
	output 			cmos_sclk,
	input 			cmos_sdat_IN,
	output 			cmos_sdat_OUT,
	output 			cmos_sdat_OE,
	
	//	CMOS Interface
	input 			cmos_pclk,
	input 			cmos_vsync,
	input 			cmos_href,
	input 	[7:0] 	cmos_data,
	
	output 			cmos_ctl1_o, 
	output 			cmos_ctl1_oe, 
	input 			cmos_ctl1_i,
	output 			cmos_ctl2_o,
	output 			cmos_ctl2_oe, 
	input 			cmos_ctl2_i, 
	output 			cmos_ctl3_o,
	output 			cmos_ctl3_oe, 
	input 			cmos_ctl3_i, 
	
	
	////////////////////////////////////////////////////////////////
	//	HDMI Interface
	output 			hdmi_txc_oe,
	output 			hdmi_txd0_oe,
	output 			hdmi_txd1_oe,
	output 			hdmi_txd2_oe,
	
	output 			hdmi_txc_rst_o,
	output 			hdmi_txd0_rst_o,
	output 			hdmi_txd1_rst_o,
	output 			hdmi_txd2_rst_o,
	
	output 	[9:0] 	hdmi_txc_o,
	output 	[9:0] 	hdmi_txd0_o,
	output 	[9:0] 	hdmi_txd1_o,
	output 	[9:0] 	hdmi_txd2_o,
	
	
	////////////////////////////////////////////////////////////////
	//	LVDS Interface
	output 			lvds_txc_oe,
	output 	[6:0] 	lvds_txc_o,
	output 			lvds_txc_rst_o,
	
	output 			lvds_txd0_oe,
	output 	[6:0] 	lvds_txd0_o,
	output 			lvds_txd0_rst_o,
	
	output 			lvds_txd1_oe,
	output 	[6:0] 	lvds_txd1_o,
	output 			lvds_txd1_rst_o,
	
	output 			lvds_txd2_oe,
	output 	[6:0] 	lvds_txd2_o,
	output 			lvds_txd2_rst_o,
	
	output 			lvds_txd3_oe,
	output 	[6:0] 	lvds_txd3_o,
	output 			lvds_txd3_rst_o,
	
	
	////////////////////////////////////////////////////////////////
	//	RGB LCD 5Inch 800x480
	output 			lcd_tp_sda_o,		//	TP SDA
	output 			lcd_tp_sda_oe,
	input 			lcd_tp_sda_i,
	
	output 			lcd_tp_scl_o,		//	TP SCL
	output 			lcd_tp_scl_oe,
	input 			lcd_tp_scl_i,
	
	output 			lcd_tp_int_o,		//	TP INT
	output 			lcd_tp_int_oe,
	input 			lcd_tp_int_i,
	
	output 			lcd_tp_rst_o,		//	TP RST
	
	output 			lcd_pwm_o,			//	Backlight
	output 			lcd_blen_o,
	
	//output 			lcd_pclk_o,			//	PCLK & SCK Mux
	output 			lcd_vs_o,			//	VS & SSN Mux. Fixed to 1. Use DE-Only mode. 
	output 			lcd_hs_o,			//	HS. Fixed to 1. Use DE-Only mode. 
	//output 			lcd_de_o,			//	DE. 

	output 	[7:0] 	lcd_b7_0_o,			//	B7:B0. 
	output 	[7:0] 	lcd_g7_0_o,			//	G7:G0. Must output 8'hFF when access SPI. 
	output 	[7:0] 	lcd_r7_0_o,			//	R7:R0. 
	
	output 	[7:0] 	lcd_b7_0_oe,		//	B7:B0. 
	output 	[7:0] 	lcd_g7_0_oe,		//	G7:G0. Must output 8'hFF when access SPI. 
	output 	[7:0] 	lcd_r7_0_oe,		//	R7:R0. 

	input 	[7:0] 	lcd_b7_0_i,			//	B7:B0. 
	input 	[7:0] 	lcd_g7_0_i,			//	G7:G0. Must output 8'hFF when access SPI. 
	input 	[7:0] 	lcd_r7_0_i,			//	R7:R0. 
	
	//	SPI Pins
	output 			spi_sck_o, 
	output 			spi_ssn_o,

	//key调节
    input [1:0]     key
);
	
	wire 			csi_rxd0_fifo_rd_o; 
	wire 			csi_rxd0_fifo_empty_i = 0;  
	wire 			csi_rxd1_fifo_rd_o;  
	wire 			csi_rxd1_fifo_empty_i = 0;  
	wire 			csi_rxd2_fifo_rd_o;  
	wire 			csi_rxd2_fifo_empty_i = 0;  
	wire 			csi_rxd3_fifo_rd_o;  
	wire 			csi_rxd3_fifo_empty_i = 0;  
	
	
	parameter 	SIM_DATA 	= 0; 
	
	//	Hardware Configuration
	assign clk_p_hi = 1'b0;	//	DDR3 Clock requires 180 degree shifted. 
	assign clk_p_lo = 1'b1;
	assign clk_n_hi = 1'b1;
	assign clk_n_lo = 1'b0; 
	
	assign cmos_ctl1_o = 0; 
	assign cmos_ctl1_oe = 1; 
	assign cmos_ctl2_o = 0; 
	assign cmos_ctl2_oe = 1; 
	assign cmos_ctl3_o = 0; 
	assign cmos_ctl3_oe = 1; 
	
	//	System Clock Tree Control
	assign sys_pll_rstn_o = 1'b1; 	//	nrst; 	//	Reset whole system when nrst (K2) is pressed. 
	
	assign dsi_pll_rstn_o = sys_pll_lock; 
	assign ddr_pll_rstn_o = sys_pll_lock; 
	assign lvds_pll_rstn_o = sys_pll_lock; 
	
	wire 			w_pll_lock = sys_pll_lock && dsi_pll_lock && ddr_pll_lock && lvds_pll_lock; 
	
	//	Synchronize System Resets. 
	reg 			rstn_sys = 0, rstn_pixel = 0; 
	wire 			rst_sys = ~rstn_sys, rst_pixel = ~rstn_pixel; 
	
	reg 			rstn_dsi_refclk = 0, rstn_dsi_byteclk = 0; 
	wire 			rst_dsi_refclk = ~rstn_dsi_refclk, rst_dsi_byteclk = ~rstn_dsi_byteclk; 
	
	reg 			rstn_lvds_1x = 0; 
	wire 			rst_lvds_1x = ~rstn_lvds_1x; 
	
	reg 			rstn_27m = 0, rstn_54m = 0; 
	wire 			rst_27m = ~rstn_27m, rst_54m = ~rstn_54m; 
	
	//	Clock Gen
	always @(posedge clk_27m or negedge w_pll_lock) begin if(~w_pll_lock) rstn_27m <= 0; else rstn_27m <= 1; end
	always @(posedge clk_54m or negedge w_pll_lock) begin if(~w_pll_lock) rstn_54m <= 0; else rstn_54m <= 1; end
	always @(posedge clk_sys or negedge w_pll_lock) begin if(~w_pll_lock) rstn_sys <= 0; else rstn_sys <= 1; end
	always @(posedge clk_pixel or negedge w_pll_lock) begin if(~w_pll_lock) rstn_pixel <= 0; else rstn_pixel <= 1; end
	always @(posedge dsi_refclk_i or negedge w_pll_lock) begin if(~w_pll_lock) rstn_dsi_refclk <= 0; else rstn_dsi_refclk <= 1; end
	always @(posedge dsi_byteclk_i or negedge w_pll_lock) begin if(~w_pll_lock) rstn_dsi_byteclk <= 0; else rstn_dsi_byteclk <= 1; end
	always @(posedge clk_lvds_1x or negedge w_pll_lock) begin if(~w_pll_lock) rstn_lvds_1x <= 0; else rstn_lvds_1x <= 1; end
	
	
	localparam 	CLOCK_MAIN 	= 96000000; 	//	System clock using 96MHz. 
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	Flash Burner Control
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	wire 			w_ustick, w_mstick; 
	
	wire  [7:0] 	w_dev_index_o;  
	wire  [7:0] 	w_dev_cmd_o;  
	wire  [31:0] 	w_dev_wdata_o;  
	wire  		w_dev_wvalid_o;  
	wire  		w_dev_rvalid_o;  
	wire 	[31:0] 	w_dev_rdata_i;  
	
	wire 			w_spi_ssn_o, w_spi_sck_o; 
	wire 	[3:0] 	w_spi_data_o, w_spi_data_oe; 
	wire 	[3:0] 	w_spi_data_i; 
	
	//	Flash Control
	reg 			r_flash_en = 0; 		//	0x00:0x00 Enable Flash
	
	always @(posedge clk_sys) begin
		r_flash_en <= (w_dev_wvalid_o && (w_dev_index_o == 8'h00) && (w_dev_cmd_o == 8'h00)) ? w_dev_wdata_o : r_flash_en; 
	end
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	LCD Data Mux
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	wire 	[7:0] 	w_lcd_b_o, w_lcd_g_o, w_lcd_r_o; 
	
	assign lcd_b7_0_o = r_flash_en ? {4'b0, w_spi_data_o[3:2], 2'b0} : w_lcd_b_o; 
	assign lcd_g7_0_o = r_flash_en ? {6'h0, w_spi_data_o[1:0]} : w_lcd_g_o; 
	assign lcd_r7_0_o = r_flash_en ? {8'h00} : w_lcd_r_o; 
	
	assign lcd_b7_0_oe = r_flash_en ? {4'b0, w_spi_data_oe[3:2], 2'b0} : 8'hFF; 
	assign lcd_g7_0_oe = r_flash_en ? {6'h0, w_spi_data_oe[1:0]} : 8'hFF; 
	assign lcd_r7_0_oe = r_flash_en ? {8'h00} : 8'hFF; 
	
	assign spi_sck_o = w_spi_sck_o; 
	assign spi_ssn_o = w_spi_ssn_o; 
	assign w_spi_data_i = {lcd_b7_0_i[3:2], lcd_g7_0_i[1:0]}; 
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	DDR3 Controller
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire			w_ddr3_ui_clk = clk_sys;
	wire			w_ddr3_ui_rst = rst_sys;
	wire			w_ddr3_ui_areset = rst_sys;
	wire			w_ddr3_ui_aresetn = rstn_sys;
	

	//	General AXI Interface 
	wire	[3:0] 	w_ddr3_awid;
	wire	[31:0]	w_ddr3_awaddr;
	wire	[7:0]		w_ddr3_awlen;
	wire			w_ddr3_awvalid;
	wire			w_ddr3_awready;
	
	wire 	[3:0]  	w_ddr3_wid;
	wire 	[127:0] 	w_ddr3_wdata;
	wire 	[15:0]	w_ddr3_wstrb;
	wire			w_ddr3_wlast;
	wire			w_ddr3_wvalid;
	wire			w_ddr3_wready;
	
	wire 	[3:0] 	w_ddr3_bid;
	wire 	[1:0] 	w_ddr3_bresp;
	wire			w_ddr3_bvalid;
	wire			w_ddr3_bready;
	
	wire	[3:0] 	w_ddr3_arid;
	wire	[31:0]	w_ddr3_araddr;
	wire	[7:0]		w_ddr3_arlen;
	wire			w_ddr3_arvalid;
	wire			w_ddr3_arready;
	
	wire 	[3:0] 	w_ddr3_rid;
	wire 	[127:0] 	w_ddr3_rdata;
	wire			w_ddr3_rlast;
	wire			w_ddr3_rvalid;
	wire			w_ddr3_rready;
	wire 	[1:0] 	w_ddr3_rresp;
	
	
	//	AXI Interface Request
	wire 	[3:0] 	w_ddr3_aid;
	wire 	[31:0] 	w_ddr3_aaddr;
	wire 	[7:0]  	w_ddr3_alen;
	wire 	[2:0]  	w_ddr3_asize;
	wire 	[1:0]  	w_ddr3_aburst;
	wire 	[1:0]  	w_ddr3_alock;
	wire			w_ddr3_avalid;
	wire			w_ddr3_aready;
	wire			w_ddr3_atype;
	
	wire 			w_ddr3_cal_done, w_ddr3_cal_pass; 
	
	//	Do not issue DDR read / write when ~cal_done. 
	reg 			r_ddr_unlock = 0; 
	always @(posedge w_ddr3_ui_clk or negedge w_ddr3_ui_aresetn) begin
		if(~w_ddr3_ui_aresetn)
			r_ddr_unlock <= 0; 
		else
			r_ddr_unlock <= w_ddr3_cal_done; 
	end
	
	DdrCtrl ddr3_ctl_axi (	
		.core_clk		(core_clk),
		.tac_clk		(tac_clk),
		.twd_clk		(twd_clk),	
		.tdqss_clk		(tdqss_clk),
		
		.reset		(reset),
		.cs			(cs),
		.ras			(ras),
		.cas			(cas),
		.we			(we),
		.cke			(cke),    
		.addr			(addr),
		.ba			(ba),
		.odt			(odt),
		
		.o_dm_hi		(o_dm_hi),
		.o_dm_lo		(o_dm_lo),
		
		.i_dq_hi		(i_dq_hi),
		.i_dq_lo		(i_dq_lo),
		.o_dq_hi		(o_dq_hi),
		.o_dq_lo		(o_dq_lo),
		.o_dq_oe		(o_dq_oe),
		
		.i_dqs_hi		(i_dqs_hi),
		.i_dqs_lo		(i_dqs_lo),
		.i_dqs_n_hi		(i_dqs_n_hi),
		.i_dqs_n_lo		(i_dqs_n_lo),
		.o_dqs_hi		(o_dqs_hi),
		.o_dqs_lo		(o_dqs_lo),
		.o_dqs_n_hi		(o_dqs_n_hi),
		.o_dqs_n_lo		(o_dqs_n_lo),
		.o_dqs_oe		(o_dqs_oe),
		.o_dqs_n_oe		(o_dqs_n_oe),
		
		.clk			(w_ddr3_ui_clk),
		.reset_n		(w_ddr3_ui_aresetn),
		
		.axi_avalid		(w_ddr3_avalid),	//	Enable command only when unlocked. 
		.axi_aready		(w_ddr3_aready),
		.axi_aaddr		(w_ddr3_aaddr),
		.axi_aid		(w_ddr3_aid),
		.axi_alen		(w_ddr3_alen),
		.axi_asize		(w_ddr3_asize),
		.axi_aburst		(w_ddr3_aburst),
		.axi_alock		(w_ddr3_alock),
		.axi_atype		(w_ddr3_atype),
		
		.axi_wid		(w_ddr3_wid),
		.axi_wvalid		(w_ddr3_wvalid),
		.axi_wready		(w_ddr3_wready),
		.axi_wdata		(w_ddr3_wdata),
		.axi_wstrb		(w_ddr3_wstrb),
		.axi_wlast		(w_ddr3_wlast),
		
		.axi_bvalid		(w_ddr3_bvalid),
		.axi_bready		(w_ddr3_bready),
		.axi_bid		(w_ddr3_bid),
		.axi_bresp		(w_ddr3_bresp),
		
		.axi_rvalid		(w_ddr3_rvalid),
		.axi_rready		(w_ddr3_rready),
		.axi_rdata		(w_ddr3_rdata),
		.axi_rid		(w_ddr3_rid),
		.axi_rresp		(w_ddr3_rresp),
		.axi_rlast		(w_ddr3_rlast),
		
		.shift		(shift),
		.shift_sel		(),
		.shift_ena		(shift_ena),
		
		.cal_ena		(1'b1),
		.cal_done		(w_ddr3_cal_done),
		.cal_pass		(w_ddr3_cal_pass)
	);
	
	assign w_ddr3_bready = 1'b1; 
	assign shift_sel = 5'b00100; 		//	ddr_tac_clk always use PLLOUT[2]. 
	
	
	AXI4_AWARMux #(.AID_LEN(4), .AADDR_LEN(32)) axi4_awar_mux (
		.aclk_i			(w_ddr3_ui_clk), 
		.arst_i			(w_ddr3_ui_rst), 
		
		.awid_i			(w_ddr3_awid),
		.awaddr_i			(w_ddr3_awaddr),
		.awlen_i			(w_ddr3_awlen),
		.awvalid_i			(w_ddr3_awvalid && r_ddr_unlock),
		.awready_o			(w_ddr3_awready),
		
		.arid_i			(w_ddr3_arid),
		.araddr_i			(w_ddr3_araddr),
		.arlen_i			(w_ddr3_arlen),
		.arvalid_i			(w_ddr3_arvalid && r_ddr_unlock),
		.arready_o			(w_ddr3_arready),
		
		.aid_o			(w_ddr3_aid),
		.aaddr_o			(w_ddr3_aaddr),
		.alen_o			(w_ddr3_alen),
		.atype_o			(w_ddr3_atype),
		.avalid_o			(w_ddr3_avalid),
		.aready_i			(w_ddr3_aready)
	);
	
	assign w_ddr3_asize = 4; 		//	Fixed 128 bits (16 bytes, size = 4)
	assign w_ddr3_aburst = 1; 
	assign w_ddr3_alock = 0; 
	
	//assign led_o[1:0] = {w_ddr3_cal_pass, w_ddr3_cal_done}; 
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////
	//	I2C Config (OV5640)
	
	//  i2c timing controller module of 16Bit
	wire            [ 7:0]          ov5640_i2c_config_index;
	wire            [23:0]          ov5640_i2c_config_data;
	wire            [ 7:0]          ov5640_i2c_config_size;
	wire                            ov5640_i2c_config_done;
	wire            [15:0]          ov5640_i2c_rdata;                              //  i2c register data

	i2c_timing_ctrl_16bit
	#(
	    .CLK_FREQ           (CLOCK_MAIN),                              //  100 MHz
	    .I2C_FREQ           (50_000    )                               //  10 KHz(<= 400KHz)
	) 
	u_i2c_timing_ctrl_16bit 
	(
	    //global clock
	    .clk                (clk_sys                 ),                          //  96MHz
	    .rst_n              (rstn_sys                ),                          //  system reset

	    //i2c interface
	    .i2c_sclk           (cmos_sclk                  ),                  //  i2c clock
		.i2c_sdat_OUT 	(cmos_sdat_OUT), 
		.i2c_sdat_OE	(cmos_sdat_OE), 
		.i2c_sdat_IN 	(cmos_sdat_IN), 
		
	    //i2c config data
	    .i2c_config_index   (ov5640_i2c_config_index           ),                  //  i2c config reg index, read 2 reg and write xx reg
	    .i2c_config_data    ({8'h78, ov5640_i2c_config_data}   ),                  //  i2c config data
	    .i2c_config_size    (ov5640_i2c_config_size            ),                  //  i2c config data counte
	    .i2c_config_done    (ov5640_i2c_config_done            ),                  //  i2c config timing complete
	    .i2c_rdata          (ov5640_i2c_rdata                  )                   //  i2c register data while read i2c slave
	);
	
	//----------------------------------------------------------------------
	//  I2C Configure Data of OV5640
	I2C_OV5640_1280720_Config u_I2C_OV5640_1280720_Config
	(
	    .LUT_INDEX  (ov5640_i2c_config_index   ),
	    .LUT_DATA   (ov5640_i2c_config_data    ),
	    .LUT_SIZE   (ov5640_i2c_config_size    )
	); 
	
	
	//	CMOS Interface
	//input 			cmos_pclk,
	//input 			cmos_vsync,
	//input 			cmos_href,
	//input 	[7:0] 	cmos_data,
	
	wire 			w_cmos_pclk = cmos_pclk; 
	
	
	
	//	Output LED
	reg 	[3:0]		r_cmos_fv_o = 0; 
	reg 	[1:0] 	r_cmos_rx_vsync0_in = 0; 
	always @(posedge w_cmos_pclk) begin
		r_cmos_rx_vsync0_in <= {r_cmos_rx_vsync0_in, cmos_vsync}; 
		r_cmos_fv_o <= r_cmos_fv_o + ((r_cmos_rx_vsync0_in == 2'b01) ? 1 : 0); 
	end
	assign led_o[5] = r_cmos_fv_o[3]; 
	
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////
	//	System Control. Can be removed for public. 
	
	localparam 	CLK_FREQ 	= 96_000_000; 	//	clk_sys is 96MHz. 
	localparam 	BAUD_RATE 	= 460_800; 		//	Use 460800-8-N-1. 
	
	
	//	SFR I/O Interface
	wire 	[7:0] 	w_sfr_addr_o; 	//	SFR Address (0xFF00 ~ 0xFFFF). 00:Power; 40~5F:Stream0; 60~7F:Stream1. 
	wire 	[7:0] 	w_sfr_wdata_o; 	//	SFR Write Data. 
	wire 			w_sfr_we_o; 		//	SFR WE. 
	reg 	[7:0] 	w_sfr_rdata_i; 	//	Must be valid after sfr_rd_o. 
	wire 			w_sfr_rd_o; 		//	SFR RD. 
	
	
	//	System Control Registers
	reg 			r_dsi_tx_rstn = 0; 	//	DSI TX Reset
	reg 	[7:0] 	r_dsi_pwm = 64; 		//	[6:0]PWM, [7]Pol
	reg 			r_dsi_resetn_o = 0; 	//	DSI Panel Reset
	reg 			r_dsi_data_rstn = 0; 	//	DSI TX Reset
	
	reg 	[3:0] 	r_dsi_lp_p_ovr = 0; 	
	reg 	[3:0] 	r_dsi_lp_n_ovr = 0; 	
	
	
	
	//	AXI-Lite Interface Bridge
	localparam 	CSI_AXILITE_ID 	= 0; 				//	Select DSI_TX when r_axi_sel = DSI_AXILITE_ID. 
	localparam 	DSI_AXILITE_ID 	= 1; 				//	Select DSI_TX when r_axi_sel = DSI_AXILITE_ID. 
	
	reg 	[7:0] 	r_axi_addr = 8'h18; 		//	0xE0 (RW)
	reg 	[31:0] 	r_axi_wdata = 32'h0000000A; 	//	0xE1~0xE4 (RW)
	wire 	[31:0] 	w_axi_rdata; 			//	0xE5~0xE8 (RO)
	reg 	[0:0] 	r_axi_sel = 1; 			//	0xE9[7:2] (RW)
	reg 			r_axi_r1w0 = 0; 			//	0xE9[1] (RW)
	reg 			r_axi_req = 0; 			//	0xE9[0] (WO, Single Cycle)
	reg 			r_axi_req_o = 0; 			//	Delayed of r_axi_req. 
	
	
	//	Buffered AXI Read Data
	reg 	[31:0] 	r_axi_rdata = 0; 		//	Use state machine
	reg 			r_axi_idle = 0; 		//	AXI Idle 
	
	reg 	[3:0] 	rs_axilite = 0; 		//	AXI Access
	wire 	[3:0] 	ws_axilite_idle = 0; 		
	wire 	[3:0] 	ws_axilite_write = 1; 
	wire 	[3:0] 	ws_axilite_read = 2; 
	wire 	[3:0] 	ws_axilite_endread = 3; 
	
	reg 			r_axi_awvalid = 0, r_axi_wvalid = 0, r_axi_arvalid = 0; 
	wire 			w_axi_awready, w_axi_wready, w_axi_arready, w_axi_rvalid; 
	
	
	reg 	[3:0] 	rc_axi_init = 0; 

	always @(posedge clk_sys or posedge rst_sys) begin
		if(rst_sys) begin
			r_dsi_tx_rstn <= 0; 
			r_dsi_pwm <= 64; 
			r_axi_req <= 0; 
			r_dsi_resetn_o <= 0; 
			r_dsi_data_rstn <= 0; 
			
			rs_axilite <= 0; 
			r_axi_awvalid <= 0; 
			r_axi_wvalid <= 0;
			r_axi_arvalid <= 0; 
			
			r_dsi_lp_p_ovr <= 0; 
			r_dsi_lp_n_ovr <= 0; 
			
			rc_axi_init <= 0; 
			r_axi_idle <= 0; 
			
		end else begin
			r_dsi_tx_rstn <= 1; 
			r_dsi_resetn_o <= 1; 
			r_dsi_data_rstn <= 1; 
			
		end
	end
	
	assign dsi_resetn_o = r_dsi_resetn_o; 
	
	assign csi_ctl0_oe = 0; 
	assign csi_ctl1_oe = 0; 
	
	
	PWMLite dsi_pwm (		//	#(.ENABLE_TICK(0), .PWM_BITS(7)) 
		.clk_i			(clk_sys),
		.rst_i			(rst_sys),
		.pwm_i			(r_dsi_pwm[6:0]),
		.pol_i			(r_dsi_pwm[7]), 
		.pwm_o			(dsi_pwm_o)
	);






	////////////////////////////////////////////////////////////////
	//	MIPI CSI RX
	
	//	The CSI RXC shall not be inverted. Data can be inverted with swapped LP data and flipped HS data. 
	localparam 	CSI_RXD_INV 	= 4'b1111; 
	localparam 	CSI_DATA_WIDTH 	= 8;		
	localparam 	CSI_STRB_WIDTH 	= CSI_DATA_WIDTH / 8; 

	
	////////////////////////////////////////////////////////////////
	//	MIPI-CSI Crop
	
	wire			XYCrop_frame_vsync; 
	wire			XYCrop_frame_href;
	wire			XYCrop_frame_de;
	wire	[63:0]	XYCrop_frame_Gray;

	Sensor_Image_XYCrop
	#(
		//	RGB width doubled. 
		.IMAGE_HSIZE_SOURCE (1280 * 2 / CSI_STRB_WIDTH),
		.IMAGE_VSIZE_SOURCE (720	 ),
		.IMAGE_HSIZE_TARGET (1280 * 2 / CSI_STRB_WIDTH),
		.IMAGE_YSIZE_TARGET (720 	 ),
		.PIXEL_DATA_WIDTH	(CSI_DATA_WIDTH) 		//	32		 )
	)
	u_Sensor_Image_XYCrop
	(
		//	globel clock
		.clk			(w_cmos_pclk),			//	image pixel clock
		.rst_n		(rstn_sys),			//	system reset
		
		//CMOS Sensor interface
		.image_in_vsync (cmos_vsync		),			//H : Data Valid; L : Frame Sync(Set it by register)
		.image_in_href	(cmos_href		),			//H : Data vaild, L : Line Sync
		.image_in_de	(cmos_href		), 			//H : Data Enable, L : Line Sync
		.image_in_data	(cmos_data),			//8 bits cmos data input
		
		.image_out_vsync(XYCrop_frame_vsync ),			//H : Data Valid; L : Frame Sync(Set it by register)
		.image_out_href (XYCrop_frame_href	),			//H : Data vaild, L : Line Sync
		.image_out_de	(XYCrop_frame_de	), 			//H : Data Enable, L : Line Sync
		.image_out_data (XYCrop_frame_Gray	)			//8 bits cmos data input	
	);

	reg			r_XYCrop_frame_vsync = 0; 
	reg			r_XYCrop_frame_href = 0;
	reg			r_XYCrop_frame_de = 0;
	reg	[63:0]	r_XYCrop_frame_Gray = 0;
	//改动，将原本的XYCrop_frame_*信号全部换成转完灰度后的信号
	always @(posedge w_cmos_pclk) begin
		r_XYCrop_frame_vsync<= post_frame_vsync;
		r_XYCrop_frame_href <= post_frame_href ;
		r_XYCrop_frame_de   <= post_frame_de   ;
		r_XYCrop_frame_Gray <= post_rgb        ;
	end
	
	//	Data Write Assignment
	wire			cmos_frame_vsync = r_XYCrop_frame_vsync;                     //  cmos frame data vsync valid signal
	wire			cmos_frame_href = r_XYCrop_frame_href && r_XYCrop_frame_de;	 //  cmos frame data href vaild  signal
	wire	[63:0]	cmos_frame_Gray = r_XYCrop_frame_Gray; 
	wire 			cmos_vsync_end;

	












	////////////////////////////////////////////////////////////////
	//	DDR R/W Control
	

	wire                            lcd_de;
	wire                            lcd_hs;      
	wire                            lcd_vs;
	wire 					  lcd_request; 
	wire            [7:0]           lcd_red, lcd_red2;
	wire            [7:0]           lcd_green, lcd_green2;
	wire            [7:0]           lcd_blue, lcd_blue2;
	wire            [15:0]          lcd_data;


	assign w_ddr3_awid = 0; 
	assign w_ddr3_wid = 0; 
	
	wire 			w_wframe_vsync; 
	wire 	[7:0] 	w_axi_tp; 
	wire 			w_frame_ready;
	//	Write in 8 bits. Read in 16 bits.        //此处做出修改，修改成写16
	axi4_ctrl #(.C_RD_END_ADDR(1280 * 2 * 720), .C_W_WIDTH(16), .C_R_WIDTH(16), .C_ID_LEN(4),.C_BURST_LEN(80)) u_axi4_ctrl (

		.axi_clk        (w_ddr3_ui_clk            ),
		.axi_reset      (w_ddr3_ui_rst            ),

		.axi_awaddr     (w_ddr3_awaddr       ),
		.axi_awlen      (w_ddr3_awlen        ),
		.axi_awvalid    (w_ddr3_awvalid      ),
		.axi_awready    (w_ddr3_awready      ),

		.axi_wdata      (w_ddr3_wdata        ),
		.axi_wstrb      (w_ddr3_wstrb        ),
		.axi_wlast      (w_ddr3_wlast        ),
		.axi_wvalid     (w_ddr3_wvalid       ),
		.axi_wready     (w_ddr3_wready       ),

		.axi_bid        (0          ),
		.axi_bresp      (0        ),
		.axi_bvalid     (1       ),

		.axi_arid       (w_ddr3_arid         ),
		.axi_araddr     (w_ddr3_araddr       ),
		.axi_arlen      (w_ddr3_arlen        ),
		.axi_arvalid    (w_ddr3_arvalid      ),
		.axi_arready    (w_ddr3_arready      ),

		.axi_rid        (w_ddr3_rid          ),
		.axi_rdata      (w_ddr3_rdata        ),
		.axi_rresp      (0        ),
		.axi_rlast      (w_ddr3_rlast        ),
		.axi_rvalid     (w_ddr3_rvalid       ),
		.axi_rready     (w_ddr3_rready       ),

		.wframe_pclk    (w_cmos_pclk          ),
		.wframe_vsync   (cmos_frame_vsync), //w_wframe_vsync   ),		//	Writter VSync. Flush on rising edge. Connect to EOF. 
		.wframe_data_en (cmos_frame_href   ),
		.wframe_data    (cmos_frame_Gray),
		
		.rframe_pclk    (clk_pixel            ),
		.rframe_vsync   (~lcd_vs             ),		//	Reader VSync. Flush on rising edge. Connect to ~EOF. 
		.rframe_data_en (lcd_request             ),
		.rframe_data    (lcd_data           ),
		
        // 新增：帧控制
        .freeze_i       (w_freeze), 
        .cmp_en_i       (w_cmp_en), 
        .cmp_win_i      (w_cmp_win), 
        .frame_a_i      (w_frame_a), 
        .frame_b_i      (w_frame_b),
        .cmp_offset_a_i (w_cmp_offset_a),
        .cmp_offset_b_i (w_cmp_offset_b),
        
		.tp_o 		    (w_axi_tp),
        .o_frame_ready  (w_frame_ready)
	);
	assign led_o[3:0] = w_axi_tp; 
	
	
	
	
	////////////////////////////////////////////////////////////////
	//  LCD Timing Driver
	/*wire 	[15:0] 	w_lcd_data_swap = {lcd_data[7:0], lcd_data[15:8]}; 
	wire 	[7:0] 	lcd_data_r = {lcd_data[15:11], 3'b0}; 
	wire 	[7:0] 	lcd_data_g = {lcd_data[10:5], 2'b0}; 
	wire 	[7:0] 	lcd_data_b = {lcd_data[4:0], 3'b0}; */
    //============================================================
// DDR 读出后的 OSD：帧号叠加（关键位置）
//============================================================
//============================================================
// DDR 读出后的 OSD 坐标计数器
//============================================================
reg [11:0] dsp_x, dsp_y;
reg        dsp_hs_d;
always @(posedge clk_pixel or negedge rstn_pixel) begin
    if(!rstn_pixel) begin
        dsp_x    <= 12'd0;
        dsp_y    <= 12'd0;
        dsp_hs_d <= 1'b0;
    end else begin
        dsp_hs_d <= lcd_hs;

        if(!lcd_vs)                 dsp_y <= 12'd0;
        else if(lcd_hs & ~dsp_hs_d) dsp_y <= dsp_y + 1'b1;

        if(!lcd_hs)          dsp_x <= 12'd0;
        else if(lcd_request) dsp_x <= dsp_x + 1'b1;
    end
end
//============================================================
// FPS 计数（像素时钟域，直接测 lcd_vs）
//============================================================
wire [15:0] w_fps;
wire [3:0]  w_fps_ones, w_fps_tens, w_fps_huns;

fps_meter #(
    .CLK_FREQ (74_250_000)
) u_fps_meter (
    .clk      (clk_pixel),
    .rst_n    (rstn_pixel),
    .vsync    (lcd_vs),
    .fps      (w_fps),
    .bcd_ones (w_fps_ones),
    .bcd_tens (w_fps_tens),
    .bcd_huns (w_fps_huns)
);

//============================================================
// OSD FPS：右上角显示 "FPS: xxx"
//============================================================
wire        osd_fps_px;
wire [15:0] osd_fps_col;
osd_fps_small u_osd_fps (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),       // 与 lcd_driver 数据请求对齐
    .x         (dsp_x),
    .y         (dsp_y),
    .fps_huns  (w_fps_huns),
    .fps_tens  (w_fps_tens),
    .fps_ones  (w_fps_ones),
    .osd_pixel (osd_fps_px),
    .osd_color (osd_fps_col)
);
//============================================================
// cmos_pclk -> clk_pixel 域同步（慢变量，两拍）
//============================================================
reg        w_freeze_s0,   w_freeze_s1;
reg        w_cmp_en_s0,   w_cmp_en_s1;
reg [3:0]  w_frame_a_s0,  w_frame_a_s1;
reg [3:0]  w_frame_b_s0,  w_frame_b_s1;

always @(posedge clk_pixel or negedge rstn_pixel) begin
    if(!rstn_pixel) begin
        w_freeze_s0  <= 1'b0;  w_freeze_s1  <= 1'b0;
        w_cmp_en_s0  <= 1'b0;  w_cmp_en_s1  <= 1'b0;
        w_frame_a_s0 <= 4'd0;  w_frame_a_s1 <= 4'd0;
        w_frame_b_s0 <= 4'd0;  w_frame_b_s1 <= 4'd0;
    end else begin
        w_freeze_s0  <= w_freeze;    w_freeze_s1  <= w_freeze_s0;
        w_cmp_en_s0  <= w_cmp_en;    w_cmp_en_s1  <= w_cmp_en_s0;
        w_frame_a_s0 <= w_frame_a;   w_frame_a_s1 <= w_frame_a_s0;
        w_frame_b_s0 <= w_frame_b;   w_frame_b_s1 <= w_frame_b_s0;
    end
end
//============================================================
// OSD 帧号 左：左上角显示左半屏帧号（仅对比模式显示）
//============================================================
wire        osd_frame_l_px;
wire [15:0] osd_frame_l_col;
osd_digit u_osd_frame_l (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .base_x    (12'd20),          // 左上角
    .base_y    (12'd30),
    .valid     (w_freeze_s1 && w_cmp_en_s1),
    .digit     (w_frame_a_s1),
    .osd_pixel (osd_frame_l_px),
    .osd_color (osd_frame_l_col)
);

//============================================================
// OSD 帧号 右：右上角显示右半屏帧号（对比模式）；非对比模式显示主帧号
//============================================================
wire        osd_frame_r_px;
wire [15:0] osd_frame_r_col;
osd_digit u_osd_frame_r (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .base_x    (12'd1196),        // 右上角
    .base_y    (12'd20),
    .valid     (w_freeze_s1),
    .digit     (w_cmp_en_s1 ? w_frame_b_s1 : w_frame_a_s1),
    .osd_pixel (osd_frame_r_px),
    .osd_color (osd_frame_r_col)
);
//============================================================
// OSD 阈值：仅 Sobel 模式（模式 0）显示
//   w_sobel_th = 20~1000，步长 10
//   显示 4 位十进制，个位恒 0，前导零消隐
//============================================================
// w_th_bcd 在 cmos_pclk 域，OSD 在 clk_pixel 域，慢变量打两拍
reg [15:0] w_th_bcd_s0, w_th_bcd_s1;
always @(posedge clk_pixel or negedge rstn_pixel) begin
    if(!rstn_pixel) begin
        w_th_bcd_s0 <= 16'hFFFF;
        w_th_bcd_s1 <= 16'hFFFF;
    end else begin
        w_th_bcd_s0 <= w_th_bcd;
        w_th_bcd_s1 <= w_th_bcd_s0;
    end
end

wire [15:0] th_bcd = w_th_bcd_s1;

wire        osd_th_px;
wire [15:0] osd_th_col;
// 阈值标签"阈值："
wire        osd_th_lbl_px;
wire [15:0] osd_th_lbl_col;
reg [2:0] w_mode_s0, w_mode_s1;
always @(posedge clk_pixel or negedge rstn_pixel) begin
    if(!rstn_pixel) begin
        w_mode_s0 <= 3'd0;
        w_mode_s1 <= 3'd0;
    end else begin
        w_mode_s0 <= w_mode;
        w_mode_s1 <= w_mode_s0;
    end
end
osd_th_label u_osd_th_lbl (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .base_x    (12'd1051),
    .base_y    (12'd60),
    .valid     (w_mode_s1 == 3'd0),      // 仅 Sobel 模式显示
    .char_sel  (2'd0),                   // ★ 阈值：
    .osd_pixel (osd_th_lbl_px),
    .osd_color (osd_th_lbl_col)
);
osd_digits #(.BASE_X(12'd1147), .BASE_Y(12'd60),.COLOR (16'h07FF)) 
u_osd_th (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .valid     (w_mode_s1 == 3'd0),
    .digits    (th_bcd),
    .osd_pixel (osd_th_px),
    .osd_color (osd_th_col)
);
//============================================================
// Canny 双阈值 OSD（high 上 / low 下）
//============================================================
function [15:0] bin2bcd11;
    input [10:0] bin;
    reg   [26:0] z;
    integer i;
    begin
        z = {16'd0, bin};
        for (i = 0; i < 11; i = i + 1) begin
            if (z[14:11] >= 5) z[14:11] = z[14:11] + 3;
            if (z[18:15] >= 5) z[18:15] = z[18:15] + 3;
            if (z[22:19] >= 5) z[22:19] = z[22:19] + 3;
            if (z[26:23] >= 5) z[26:23] = z[26:23] + 3;
            z = z << 1;
        end
        bin2bcd11 = z[26:11];
    end
endfunction

reg [10:0] w_cl_s0, w_cl_s1;
reg [10:0] w_ch_s0, w_ch_s1;
always @(posedge clk_pixel or negedge rstn_pixel) begin
    if(!rstn_pixel) begin
        w_cl_s0 <= 11'd60;  w_cl_s1 <= 11'd60;
        w_ch_s0 <= 11'd90;  w_ch_s1 <= 11'd90;
    end else begin
        w_cl_s0 <= w_canny_low;   w_cl_s1 <= w_cl_s0;
        w_ch_s0 <= w_canny_high;  w_ch_s1 <= w_ch_s0;
    end
end

wire [15:0] low_bcd  = bin2bcd11(w_cl_s1);
wire [15:0] high_bcd = bin2bcd11(w_ch_s1);

wire [3:0] low_d3  = (low_bcd[15:12] == 0) ? 4'hF : low_bcd[15:12];
wire [3:0] low_d2  = (low_d3 == 4'hF && low_bcd[11:8] == 0) ? 4'hF : low_bcd[11:8];
wire [3:0] low_d1  = (low_d2 == 4'hF && low_bcd[7:4]  == 0) ? 4'hF : low_bcd[7:4];
wire [3:0] low_d0  = low_bcd[3:0];

wire [3:0] high_d3 = (high_bcd[15:12] == 0) ? 4'hF : high_bcd[15:12];
wire [3:0] high_d2 = (high_d3 == 4'hF && high_bcd[11:8] == 0) ? 4'hF : high_bcd[11:8];
wire [3:0] high_d1 = (high_d2 == 4'hF && high_bcd[7:4]  == 0) ? 4'hF : high_bcd[7:4];
wire [3:0] high_d0 = high_bcd[3:0];

wire [15:0] low_digits  = {low_d3,  low_d2,  low_d1,  low_d0};
wire [15:0] high_digits = {high_d3, high_d2, high_d1, high_d0};

wire        osd_canny_hi_px;
wire [15:0] osd_canny_hi_col;
osd_digits #(.BASE_X(12'd1147), .BASE_Y(12'd60), .COLOR(16'h07FF))
u_osd_canny_hi (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .valid     (w_mode_s1 == 3'd1),
    .digits    (high_digits),
    .osd_pixel (osd_canny_hi_px),
    .osd_color (osd_canny_hi_col)
);

wire        osd_canny_lo_px;
wire [15:0] osd_canny_lo_col;
osd_digits #(.BASE_X(12'd1147), .BASE_Y(12'd94), .COLOR(16'h07FF))
u_osd_canny_lo (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .valid     (w_mode_s1 == 3'd1),
    .digits    (low_digits),
    .osd_pixel (osd_canny_lo_px),
    .osd_color (osd_canny_lo_col)
);
//============================================================
// Canny 高/低阈值汉字标签（"高阈：" 上 / "低阈：" 下）
//============================================================
wire        osd_canny_hi_lbl_px;
wire [15:0] osd_canny_hi_lbl_col;
osd_th_label u_osd_canny_hi_lbl (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .base_x    (12'd1051),
    .base_y    (12'd60),
    .valid     (w_mode_s1 == 3'd1),
    .char_sel  (2'd1),              // ★ 高阈：
    .osd_pixel (osd_canny_hi_lbl_px),
    .osd_color (osd_canny_hi_lbl_col)
);

wire        osd_canny_lo_lbl_px;
wire [15:0] osd_canny_lo_lbl_col;
osd_th_label u_osd_canny_lo_lbl (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .base_x    (12'd1051),
    .base_y    (12'd94),
    .valid     (w_mode_s1 == 3'd1),
    .char_sel  (2'd2),              // ★ 低阈：
    .osd_pixel (osd_canny_lo_lbl_px),
    .osd_color (osd_canny_lo_lbl_col)
);
//============================================================
// 噪声密度 OSD（模式 2 显示，与 Sobel 阈值完全同一行）
//============================================================
reg [2:0] w_nd_s0, w_nd_s1;
always @(posedge clk_pixel or negedge rstn_pixel) begin
    if(!rstn_pixel) begin
        w_nd_s0 <= 3'd2;  w_nd_s1 <= 3'd2;
    end else begin
        w_nd_s0 <= w_noise_density;
        w_nd_s1 <= w_nd_s0;
    end
end

reg [3:0] noise_tens, noise_ones;
always @(*) begin
    case(w_nd_s1)
        3'd0: begin noise_tens = 4'd0; noise_ones = 4'd0; end   // 0%
        3'd1: begin noise_tens = 4'd0; noise_ones = 4'd1; end   // 1%
        3'd2: begin noise_tens = 4'd0; noise_ones = 4'd3; end   // 3%
        3'd3: begin noise_tens = 4'd0; noise_ones = 4'd6; end   // 6%
        3'd4: begin noise_tens = 4'd1; noise_ones = 4'd2; end   // 12%
        3'd5: begin noise_tens = 4'd2; noise_ones = 4'd5; end   // 25%
        default: begin noise_tens = 4'd5; noise_ones = 4'd0; end // 50%
    endcase
end

// ★ "密度：" 汉字标签（与 Sobel 的"阈值："同一位置 Y=60）
wire        osd_noise_lbl_px;
wire [15:0] osd_noise_lbl_col;
osd_th_label u_osd_noise_lbl (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .base_x    (12'd1051),
    .base_y    (12'd60),
    .valid     (w_mode_s1 == 3'd2),   // 仅椒盐噪声模式
    .char_sel  (2'd3),                // ★ "密度："
    .osd_pixel (osd_noise_lbl_px),
    .osd_color (osd_noise_lbl_col)
);

// ★ "X%" 数字（紧跟在"密度："后面，X=1147）
wire        osd_noise_px;
wire [15:0] osd_noise_col;
osd_noise u_osd_noise (
    .clk       (clk_pixel),
    .rst_n     (rstn_pixel),
    .de        (lcd_request),
    .x         (dsp_x),
    .y         (dsp_y),
    .base_x    (12'd1275),            // ★ 紧跟"密度："之后
    .base_y    (12'd60),              // ★ 与"密度："同 Y=60
    .valid     (w_mode_s1 == 3'd2),
    .tens      (noise_tens),
    .ones      (noise_ones),
    .osd_pixel (osd_noise_px),
    .osd_color (osd_noise_col)
);
//============================================================
// 合并所有 OSD：FPS > 帧号 L > 帧号 R
//   ★ 冻结时（回放/对比）屏蔽 FPS 显示
//============================================================
wire        osd_fps_px_masked = osd_fps_px & ~w_freeze_s1;   // ★ 冻结时 FPS 不显示

wire        osd_all_px  = osd_fps_px_masked    | osd_frame_l_px
                        | osd_th_lbl_px        | osd_th_px
                        | osd_canny_hi_lbl_px  | osd_canny_lo_lbl_px
                        | osd_canny_hi_px      | osd_canny_lo_px
                        | osd_noise_lbl_px     | osd_noise_px      // ★ 两个
                        | osd_frame_r_px;

wire [15:0] osd_all_col = osd_fps_px_masked    ? osd_fps_col        :
                          osd_frame_l_px       ? osd_frame_l_col    :
                          osd_th_lbl_px        ? osd_th_lbl_col     :
                          osd_th_px            ? osd_th_col         :
                          osd_canny_hi_lbl_px  ? osd_canny_hi_lbl_col :
                          osd_canny_lo_lbl_px  ? osd_canny_lo_lbl_col :
                          osd_canny_hi_px      ? osd_canny_hi_col   :
                          osd_canny_lo_px      ? osd_canny_lo_col   :
                          osd_noise_lbl_px     ? osd_noise_lbl_col  :  // ★
                          osd_noise_px         ? osd_noise_col      :  // ★
                                                 osd_frame_r_col;
//============================================================
// OSD 2：对比模式，只保留中间分界线（去掉左右边框）
//============================================================
wire cmp_active = w_cmp_en_s1;
wire cmp_mid    = cmp_active && (dsp_x >= 12'd638) && (dsp_x < 12'd642);

wire [15:0] cmp_rgb = 16'hFFFF;   // 中间白线
wire cmp_overlay    = cmp_mid;

//============================================================
// 叠加到 lcd_data
//============================================================
    // ★ 新增：跨到 clk_pixel 域打两拍
reg w_frame_ready_s0, w_frame_ready_s1;
always @(posedge clk_pixel or negedge rstn_pixel) begin
    if(!rstn_pixel) begin
        w_frame_ready_s0 <= 1'b0;
        w_frame_ready_s1 <= 1'b0;
    end else begin
        w_frame_ready_s0 <= w_frame_ready;
        w_frame_ready_s1 <= w_frame_ready_s0;
    end
end

// ★ 修改：第一帧写完前强制黑屏，避免 DDR 垃圾数据送 LCD
wire [15:0] lcd_data_osd_raw = osd_all_px    ? osd_all_col :
                               cmp_overlay   ? cmp_rgb     :
                                               lcd_data;
wire [15:0] lcd_data_osd = w_frame_ready_s1 ? lcd_data_osd_raw : 16'h0000;


wire 	[7:0] 	lcd_data_r = {lcd_data_osd[15:11], 3'b0}; 
wire 	[7:0] 	lcd_data_g = {lcd_data_osd[10:5], 2'b0}; 
wire 	[7:0] 	lcd_data_b = {lcd_data_osd[4:0], 3'b0}; 
	
	lcd_driver u_lcd_driver
	(
	    //  global clock
	    .clk        (clk_pixel   ),
	    .rst_n      (rstn_pixel), 
	    
	    //  lcd interface
	    .lcd_dclk   (               ),
	    .lcd_blank  (               ),
	    .lcd_sync   (               ),
	    .lcd_request(lcd_request    ), 	//	Request data 1 cycle ahead. 
	    .lcd_hs     (lcd_hs         ),
	    .lcd_vs     (lcd_vs         ),
	    .lcd_en     (lcd_de         ),
	    .lcd_rgb    ({lcd_red2,lcd_green2,lcd_blue2, lcd_red,lcd_green,lcd_blue}),
	    
	    //  user interface
	    .lcd_data   ({lcd_data_r, lcd_data_g, lcd_data_b}  )
	);
	
	
	
	////////////////////////////////////////////////////////////////
	//	HDMI Interface. 
	
	//	HDMI requires specific timing, thus is not compatible with LCD & LVDS & DSI. Must implement standalone. 
	
	assign hdmi_txd0_rst_o = rst_pixel; 
	assign hdmi_txd1_rst_o = rst_pixel; 
	assign hdmi_txd2_rst_o = rst_pixel; 
	assign hdmi_txc_rst_o = rst_pixel; 
	
	assign hdmi_txd0_oe = 1'b1; 
	assign hdmi_txd1_oe = 1'b1; 
	assign hdmi_txd2_oe = 1'b1; 
	assign hdmi_txc_oe = 1'b1; 
	
	//-------------------------------------
	//Digilent HDMI-TX IP Modified by CB elec.
	rgb2dvi #(.ENABLE_OSERDES(0)) u_rgb2dvi 
	(
		//.TMDS_Clk_p		(hdmio_txc_p_o), 	//	w_hdmio_txc), 
		//.TMDS_Clk_n		(hdmio_txc_n_o), 
		//.TMDS_Data_p	(hdmio_txd_p_o), 	//	w_hdmio_txd), 
		//.TMDS_Data_n 	(hdmio_txd_n_o), 
		
		.oe_i 		(1), 			//	Always enable output
		.bitflip_i 		(4'b0000), 		//	Reverse clock & data lanes. 
		
		.aRst			(1'b0), 
		.aRst_n		(1'b1), 
		
		.PixelClk		(clk_pixel        ),//pixel clk = 74.25M
		.SerialClk		(     ),//pixel clk *5 = 371.25M
		
		.vid_pVSync		(lcd_vs), 
		.vid_pHSync		(lcd_hs), 
		.vid_pVDE		(lcd_de), 
		.vid_pData		({lcd_red, lcd_green, lcd_blue}), 
		
		.txc_o			(hdmi_txc_o), 
		.txd0_o			(hdmi_txd0_o), 
		.txd1_o			(hdmi_txd1_o), 
		.txd2_o			(hdmi_txd2_o)
	); 
		
        
        
//新增：在Sensor_Image_XYCrop模块后面，所以用的信号是Sensor_Image_XYCrop之后的一些信号
//8位数据转16位RGB565数据
reg byte_flag=0;
reg [15:0] cmos_data_t;
reg [7:0] cam_data_d0;
//i2c初始化完成后复位结束,打两拍消除亚稳态
//assign rst_transform=ov5640_i2c_config_done;
reg [1:0] r_i2c_done_sync = 0;
always @(posedge w_cmos_pclk)begin
    r_i2c_done_sync <= {r_i2c_done_sync[0], ov5640_i2c_config_done};
end
wire rst_transform = r_i2c_done_sync[1];   // 同步后的复位释放

always @(posedge w_cmos_pclk or negedge rst_transform) begin
    if(!rst_transform) begin
        cmos_data_t <= 16'd0;
        cam_data_d0 <= 8'd0;
        byte_flag   <= 1'b0;
    end
    //每两个周期后得到一个有效rgb565数据
    else if(XYCrop_frame_href) begin
        byte_flag   <= ~byte_flag;
        cam_data_d0 <= XYCrop_frame_Gray;
        if(byte_flag)
            cmos_data_t <= {cam_data_d0,XYCrop_frame_Gray[7:0]};//得到16位rgb565数据
        else;
    end
    else begin
        byte_flag <= 1'b0;
        cam_data_d0 <= 8'b0;
    end
end
reg XYCrop_frame_href_d0;
reg XYCrop_frame_href_d1;
reg XYCrop_frame_de_d0;
reg XYCrop_frame_de_d1;
reg XYCrop_frame_vsync_d0;
reg XYCrop_frame_vsync_d1;
//打两拍使XYCrop_frame_href_d1和rgb565数据同步
always @(posedge w_cmos_pclk or negedge rst_transform) begin
    if(!rst_transform) begin
        XYCrop_frame_href_d0<=0;
        XYCrop_frame_href_d1<=0;
        XYCrop_frame_de_d0<=0;
        XYCrop_frame_de_d1<=0;
        XYCrop_frame_vsync_d0<=0;
        XYCrop_frame_vsync_d1<=0;
    end
    else begin
        XYCrop_frame_href_d0<=XYCrop_frame_href;
        XYCrop_frame_href_d1<=XYCrop_frame_href_d0;
        XYCrop_frame_de_d0<=XYCrop_frame_de;
        XYCrop_frame_de_d1<=XYCrop_frame_de_d0;
        XYCrop_frame_vsync_d0<=XYCrop_frame_vsync;
        XYCrop_frame_vsync_d1<=XYCrop_frame_vsync_d0;
    end
end  
               
wire        post_frame_vsync;
wire        post_frame_href ;
wire        post_frame_de   ;
wire [15:0] post_rgb        ;
//新增：例化转灰度模块
//XYCrop_frame_de这个信号是用href来充当数据有效信号，但是传输到
//灰度里面的是拼接好的数据，也就是byte_flag来充当有效信号
//但是byte_flag=1时是将数据拼接好,真正数据传输出来是下一个周期
reg byte_flag_d0;
wire byte_flag_d1;
always @(posedge w_cmos_pclk or negedge rst_transform) begin
    if(!rst_transform)
        byte_flag_d0<=0;
    else
        byte_flag_d0<=byte_flag;
end
assign byte_flag_d1=byte_flag_d0 && XYCrop_frame_de_d1;
wire        w_overlay;
//----------------------------------------------------
// 按键控制：模式切换 + 阈值调节
//----------------------------------------------------
wire [2:0]  w_mode;
wire [10:0] w_sobel_th;
wire [10:0] w_canny_low;
wire [10:0] w_canny_high;
wire        w_freeze, w_cmp_en, w_cmp_win; 
wire [3:0]  w_frame_a, w_frame_b;
wire        w_cmp_view; 
wire        w_digit_mode;    //模式3数字识别子模式
wire [1:0]  w_frame_style;    // ★ 新增：帧风格
wire        w_u_style_pulse;  // ★ 新增：串口风格脉冲
wire [1:0]  w_u_style_val;    // ★ 新增：串口风格值
// ★ 新增：对比窗口 X 偏移
wire [15:0] w_th_bcd;
wire        w_u_cof_a_pulse;
wire [10:0] w_u_cof_a_val;
wire        w_u_cof_b_pulse;
wire [10:0] w_u_cof_b_val;
wire [10:0] w_cmp_offset_a;
wire [10:0] w_cmp_offset_b;
wire [2:0]  w_noise_density;
wire        w_u_noise_pulse;
wire [2:0]  w_u_noise_val; 
wire        w_u_bs_pulse;      
wire [1:0]  w_u_bs_val;
// ================================================================
// UART 上位机控制通路
// ================================================================
wire [7:0] w_uart_rx_data;
wire       w_uart_rx_valid;

uart_rx #(
    .CLK_FREQ  (96_000_000),
    .BAUD_RATE (115200)
) u_uart_rx (
    .clk     (clk_sys),
    .rst_n   (rstn_sys),
    .rx_i    (uart_rx_i),
    .rx_data (w_uart_rx_data),
    .rx_valid(w_uart_rx_valid)
);

wire        w_u_mode_pulse;    wire [2:0]  w_u_mode_val;
wire        w_u_freeze_pulse;  wire        w_u_freeze_val;
wire        w_u_cmpen_pulse;   wire        w_u_cmpen_val;
wire        w_u_fa_pulse;      wire [3:0]  w_u_fa_val;
wire        w_u_fb_pulse;      wire [3:0]  w_u_fb_val;
wire        w_u_cw_pulse;      wire        w_u_cw_val;
wire        w_u_th_pulse;      wire [3:0]  w_u_th_d3, w_u_th_d2, w_u_th_d1;
wire        w_u_cl_pulse;      wire [10:0] w_u_cl_val;
wire        w_u_ch_pulse;      wire [10:0] w_u_ch_val;
wire        w_u_ov_pulse;      wire        w_u_ov_val;
wire        w_u_cv_pulse;      wire        w_u_cv_val;
wire        w_u_dm_pulse;      wire        w_u_dm_val;
wire [1:0]  w_base_submode;
uart_cmd_proc u_uart_cmd (
    .clk                 (clk_sys),
    .rst_n               (rstn_sys),
    .rx_data             (w_uart_rx_data),
    .rx_valid            (w_uart_rx_valid),

    .set_mode_pulse      (w_u_mode_pulse),
    .set_mode_val        (w_u_mode_val),
    .set_freeze_pulse    (w_u_freeze_pulse),
    .set_freeze_val      (w_u_freeze_val),
    .set_cmp_en_pulse    (w_u_cmpen_pulse),
    .set_cmp_en_val      (w_u_cmpen_val),
    .set_frame_a_pulse   (w_u_fa_pulse),
    .set_frame_a_val     (w_u_fa_val),
    .set_frame_b_pulse   (w_u_fb_pulse),
    .set_frame_b_val     (w_u_fb_val),
    .set_cmp_win_pulse   (w_u_cw_pulse),
    .set_cmp_win_val     (w_u_cw_val),
    .set_sobel_th_pulse  (w_u_th_pulse),
    .set_sobel_d3        (w_u_th_d3),
    .set_sobel_d2        (w_u_th_d2),
    .set_sobel_d1        (w_u_th_d1),
    .set_canny_low_pulse (w_u_cl_pulse),
    .set_canny_low_val   (w_u_cl_val),
    .set_canny_high_pulse(w_u_ch_pulse),
    .set_canny_high_val  (w_u_ch_val),
    .set_overlay_pulse   (w_u_ov_pulse),
    .set_overlay_val     (w_u_ov_val),
    .set_cmp_view_pulse  (w_u_cv_pulse),
    .set_cmp_view_val    (w_u_cv_val),
    .set_digit_mode_pulse(w_u_dm_pulse),
    .set_digit_mode_val  (w_u_dm_val),
    .set_frame_style_pulse (w_u_style_pulse),
    .set_frame_style_val   (w_u_style_val),
    .set_cmp_offset_a_pulse(w_u_cof_a_pulse),
    .set_cmp_offset_a_val  (w_u_cof_a_val),
    .set_cmp_offset_b_pulse(w_u_cof_b_pulse),
    .set_cmp_offset_b_val  (w_u_cof_b_val),
    .set_noise_pulse       (w_u_noise_pulse),  
    .set_noise_val         (w_u_noise_val),
    .set_base_sub_pulse    (w_u_bs_pulse),
    .set_base_sub_val      (w_u_bs_val)
);
key_ctrl u_key_ctrl (
    .clk_sys (clk_sys),
    .rst_n   (rstn_sys),
    .key_i   (key),

    .clk_pix  (w_cmos_pclk),
    .rst_pix_n(rst_transform),

    .mode_o       (w_mode),
    .sobel_th_o   (w_sobel_th),
    .th_bcd_o     (w_th_bcd),
    .canny_low_o  (w_canny_low),
    .canny_high_o (w_canny_high),
    .overlay_o    (w_overlay),

    .freeze_o     (w_freeze),
    .cmp_en_o     (w_cmp_en),
    .cmp_win_o    (w_cmp_win),
    .frame_a_o    (w_frame_a),
    .frame_b_o    (w_frame_b),
    .cmp_view_o   (w_cmp_view),
    .digit_mode_o (w_digit_mode),
    .frame_style_o  (w_frame_style), 
    .cmp_offset_a_o (w_cmp_offset_a),
    .cmp_offset_b_o (w_cmp_offset_b),
    .base_submode_o (w_base_submode),
    .mode_show_valid (w_mode_show_valid),
    .mode_show_digit (w_mode_show_digit),

    // ★ 新增 UART
    .uart_set_mode_pulse      (w_u_mode_pulse),
    .uart_set_mode_val        (w_u_mode_val),
    .uart_set_freeze_pulse    (w_u_freeze_pulse),
    .uart_set_freeze_val      (w_u_freeze_val),
    .uart_set_cmp_en_pulse    (w_u_cmpen_pulse),
    .uart_set_cmp_en_val      (w_u_cmpen_val),
    .uart_set_frame_a_pulse   (w_u_fa_pulse),
    .uart_set_frame_a_val     (w_u_fa_val),
    .uart_set_frame_b_pulse   (w_u_fb_pulse),
    .uart_set_frame_b_val     (w_u_fb_val),
    .uart_set_cmp_win_pulse   (w_u_cw_pulse),
    .uart_set_cmp_win_val     (w_u_cw_val),
    .uart_set_sobel_th_pulse  (w_u_th_pulse),
    .uart_set_sobel_d3        (w_u_th_d3),
    .uart_set_sobel_d2        (w_u_th_d2),
    .uart_set_sobel_d1        (w_u_th_d1),
    .uart_set_canny_low_pulse (w_u_cl_pulse),
    .uart_set_canny_low_val   (w_u_cl_val),
    .uart_set_canny_high_pulse(w_u_ch_pulse),
    .uart_set_canny_high_val  (w_u_ch_val),
    .uart_set_overlay_pulse   (w_u_ov_pulse),
    .uart_set_overlay_val     (w_u_ov_val),
    .uart_set_cmp_view_pulse  (w_u_cv_pulse),
    .uart_set_cmp_view_val    (w_u_cv_val),
    .uart_set_digit_mode_pulse(w_u_dm_pulse),
    .uart_set_digit_mode_val  (w_u_dm_val),
    .uart_set_frame_style_pulse (w_u_style_pulse),
    .uart_set_frame_style_val   (w_u_style_val),
    .uart_set_cmp_offset_a_pulse(w_u_cof_a_pulse),
    .uart_set_cmp_offset_a_val  (w_u_cof_a_val),
    .uart_set_cmp_offset_b_pulse(w_u_cof_b_pulse),
    .uart_set_cmp_offset_b_val  (w_u_cof_b_val),
    .uart_set_noise_pulse       (w_u_noise_pulse),
    .uart_set_noise_val         (w_u_noise_val),  
    .noise_density_o            (w_noise_density),
    .uart_set_base_sub_pulse    (w_u_bs_pulse),
    .uart_set_base_sub_val      (w_u_bs_val)
);
uart_tx #(
    .CLK_FREQ  (96_000_000),
    .BAUD_RATE (115200)
) u_uart_tx (
    .clk      (clk_sys),
    .rst_n    (rstn_sys),
    .tx_data  (w_uart_rx_data),
    .tx_valid (w_uart_rx_valid),  // 收到什么字节，就原样发回去！
    .tx_o     (uart_tx_o)         // 接到物理引脚 E10
);
wire        w_mode_show_valid;
wire [2:0]  w_mode_show_digit;
vip u_vip(
    //module clock
    .clk             (w_cmos_pclk  ),   // 时钟信号
    .rst_n           (rst_transform),   // 复位信号（低有效）
                     
    .pre_frame_vsync (XYCrop_frame_vsync_d1),
    .pre_frame_href  (XYCrop_frame_href_d1 ),
    .pre_frame_de    (byte_flag_d1         ),//像素有效信号
    .pre_rgb         (cmos_data_t	       ),
     
    // 新增：模式与三组阈值
    .mode_i          (w_mode),
    .sobel_th_i      (w_sobel_th),
    .canny_low_i     (w_canny_low),
    .canny_high_i    (w_canny_high),
    .overlay_i       (w_overlay),      // 新增
    
    .freeze_i        (w_freeze),
    .replay_en_i     (1'b0),           // 悬空，vip 内部不用
    .replay_sel_i    (2'd0),           // 悬空
    .compare_en_i    (w_cmp_en),       // 改名 w_cmp_en
    .cmp_view_i      (w_cmp_view),     // ★ 新增
    .digit_mode_i    (w_digit_mode),   // ★ 新增
    .frame_style_i   (w_frame_style),   // ★ 新增
    .base_submode_i  (w_base_submode),
    .noise_density_i (w_noise_density), 
    
    .mode_show_valid (w_mode_show_valid),
    .mode_show_digit (w_mode_show_digit),
    
    .post_frame_vsync(post_frame_vsync),  // 场同步信号
    .post_frame_href (post_frame_href ),  // 行同步信号
    .post_frame_de   (post_frame_de   ),  // 数据输出使能
    .post_rgb        (post_rgb        )   // RGB565颜色数据
);

endmodule


