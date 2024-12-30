`timescale 1ns/1ps

module systolic_array_4x4_tb ();

    /****************************************************************************
    * Parameter
    ***************************************************************************/
	parameter BIT_WIDTH = 16;
	parameter FRAC_WIDTH = 8;
	localparam T = 2;

   /****************************************************************************
    * Signals
    ***************************************************************************/

   reg clk, rst_n;

   reg signed [BIT_WIDTH-1:0] north_in0, north_in1, north_in2, north_in3;
   reg signed [BIT_WIDTH-1:0] west_in0, west_in1, west_in2, west_in3;
   wire signed[4*BIT_WIDTH-1:0] row0, row1, row2, row3;

   /****************************************************************************
    * Generate Clock Signals
    ***************************************************************************/

	initial clk = 1'b1;
   always #(T/2) clk = ~clk;

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

	systolic_array_4x4 #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) sys_array_4x4 (
		.clk(clk), .rst_n(rst_n),
		.north_in0(north_in0), .north_in1(north_in1), .north_in2(north_in2), .north_in3(north_in3),
		.west_in0(west_in0), .west_in1(west_in1), .west_in2(west_in2), .west_in3(west_in3),
		.row0(row0), .row1(row1), .row2(row2), .row3(row3)
	);

   /****************************************************************************
    * Apply Stimulus
    ***************************************************************************/

   initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,systolic_array_4x4_tb);

		
		// #(T/2);

		   north_in0 <= 16'h0100; north_in1 <= 16'h0000; north_in2 <= 16'h0000; north_in3 <= 16'h0000;
		   west_in0  <= 16'h0100; west_in1  <= 16'h0000; west_in2  <= 16'h0000; west_in3  <= 16'h0000;
		
		#T north_in0 <= 16'h0100; north_in1 <= 16'h0200; north_in2 <= 16'h0000; north_in3 <= 16'h0000;
		   west_in0  <= 16'h0200; west_in1  <= 16'h0100; west_in2  <= 16'h0000; west_in3  <= 16'h0000;

		#T north_in0 <= 16'h0100; north_in1 <= 16'h0200; north_in2 <= 16'h0300; north_in3 <= 16'h0000;
		   west_in0  <= 16'h0300; west_in1  <= 16'h0200; west_in2  <= 16'h0100; west_in3  <= 16'h0000;

		#T north_in0 <= 16'h0100; north_in1 <= 16'h0200; north_in2 <= 16'h0300; north_in3 <= 16'h0400;
		   west_in0  <= 16'h0400; west_in1  <= 16'h0300; west_in2  <= 16'h0200; west_in3  <= 16'h0100;

		#T north_in0 <= 16'h0000; north_in1 <= 16'h0200; north_in2 <= 16'h0300; north_in3 <= 16'h0400;
		   west_in0  <= 16'h0000; west_in1  <= 16'h0400; west_in2  <= 16'h0300; west_in3  <= 16'h0200;

		#T north_in0 <= 16'h0000; north_in1 <= 16'h0000; north_in2 <= 16'h0300; north_in3 <= 16'h0400;
		   west_in0  <= 16'h0000; west_in1  <= 16'h0000; west_in2  <= 16'h0400; west_in3  <= 16'h0300;

		#T north_in0 <= 16'h0000; north_in1 <= 16'h0000; north_in2 <= 16'h0000; north_in3 <= 16'h0400;
		   west_in0  <= 16'h0000; west_in1  <= 16'h0000; west_in2  <= 16'h0000; west_in3  <= 16'h0400;

		#T north_in0 <= 16'h0000; north_in1 <= 16'h0000; north_in2 <= 16'h0000; north_in3 <= 16'h0000;
		   west_in0  <= 16'h0000; west_in1  <= 16'h0000; west_in2  <= 16'h0000; west_in3  <= 16'h0000;

		
		#(10*T);
		$finish;

   end

	initial begin
		rst_n = 0; 
		#(T/2);
		$monitor ("Time:Row1:%0t\t 0x%0h |Row1: 0x%0h |Row2: 0x%0h |Row3: 0x%0h",$time, row0,row1,row2,row3);
		rst_n = 1;
	end


endmodule
