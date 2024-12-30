`timescale 1ns/1ps

module saturate_tb ();

    /****************************************************************************
    * Parameter
    ***************************************************************************/
	parameter BIT_WIDTH = 16;
	parameter FRAC_WDITH = 8;

   /****************************************************************************
    * Signals
    ***************************************************************************/

   reg signed [BIT_WIDTH*2 - 1:0] in;
   wire signed[BIT_WIDTH-1:0] out;

   /****************************************************************************
    * Generate Clock Signals
    ***************************************************************************/

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

   saturate #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WDITH(FRAC_WDITH)) sat_block (.in(in), .out(out));

   /****************************************************************************
    * Apply Stimulus
    ***************************************************************************/

   initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,saturate_tb);		

		#1 in = 32'h001fff23;
		$monitor ("In: 0x%0h out: 0x%0h", in,out);
		#1 in = 32'h051fff23;
		#1 in = 32'h851fff23;
		#1;

		$finish;

   end


endmodule
