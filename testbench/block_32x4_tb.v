`timescale 1ns/1ps

module block_32x4_tb ();

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

   reg signed [4*BIT_WIDTH-1:0] north_in[0:7];
   reg signed [4*BIT_WIDTH-1:0] west_in[0:7];
   wire signed[4*BIT_WIDTH-1:0] row[0:31];

   /****************************************************************************
    * Generate Clock Signals
    ***************************************************************************/

	initial clk = 1'b1;
   always #(T/2) clk = ~clk;

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

	block_32x4 #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) block (
		.clk(clk), .rst_n(rst_n),
        .north_in0(north_in[0]), .north_in1(north_in[1]), .north_in2(north_in[2]), .north_in3(north_in[3]), 
        .north_in4(north_in[4]), .north_in5(north_in[5]), .north_in6(north_in[6]), .north_in7(north_in[7]),
        .west_in0(west_in[0]), .west_in1(west_in[1]), .west_in2(west_in[2]), .west_in3(west_in[3]), 
        .west_in4(west_in[4]), .west_in5(west_in[5]), .west_in6(west_in[6]), .west_in7(west_in[7]),
        .row0 (row[0]),  .row1 (row[1]),  .row2 (row[2]),  .row3 (row[3]), 
        .row4 (row[4]),  .row5 (row[5]),  .row6 (row[6]),  .row7 (row[7]),
        .row8 (row[8]),  .row9 (row[9]),  .row10(row[10]), .row11(row[11]), 
        .row12(row[12]), .row13(row[13]), .row14(row[14]), .row15(row[15]),
        .row16(row[16]), .row17(row[17]), .row18(row[18]), .row19(row[19]), 
        .row20(row[20]), .row21(row[21]), .row22(row[22]), .row23(row[23]),
        .row24(row[24]), .row25(row[25]), .row26(row[26]), .row27(row[27]), 
        .row28(row[28]), .row29(row[29]), .row30(row[30]), .row31(row[31])
	);

   /****************************************************************************
    * Apply Stimulus
    ***************************************************************************/

   initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,block_32x4_tb);

		
		

		
		#(10*T);
		$finish;

   end

	initial begin
		rst_n = 0; 
		#(T/2);
		rst_n = 1;
	end


endmodule
