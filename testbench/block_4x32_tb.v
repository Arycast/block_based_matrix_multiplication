`timescale 1ns/1ps

module block_4x32_tb ();

    /****************************************************************************
    * Parameter
    ***************************************************************************/
	parameter BIT_WIDTH = 16;
	parameter FRAC_WIDTH = 8;
	localparam T = 2;
	localparam in_length = 15;
	integer i;
	integer file,ft;

   /****************************************************************************
    * Signals
    ***************************************************************************/

   reg clk, rst_n;

   reg signed [4*BIT_WIDTH-1:0] north_in[0:7];
   reg signed [4*BIT_WIDTH-1:0] west_in[0:7];
   wire signed[4*BIT_WIDTH-1:0] row[0:3];
   wire done;

   reg signed [4*BIT_WIDTH-1:0] data_north[0:in_length*8-1];
   reg signed [4*BIT_WIDTH-1:0] data_west[0:in_length*8-1];

	reg test;

   /****************************************************************************
    * Generate Clock Signals
    ***************************************************************************/

	initial clk = 1'b1;
   always #(T/2) clk = ~clk;

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

	block_4x32 #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) block (
		.clk(clk), .rst_n(rst_n),
        .north_in0(north_in[0]), .north_in1(north_in[1]), .north_in2(north_in[2]), .north_in3(north_in[3]), 
        .north_in4(north_in[4]), .north_in5(north_in[5]), .north_in6(north_in[6]), .north_in7(north_in[7]),
        .west_in0(west_in[0]), .west_in1(west_in[1]), .west_in2(west_in[2]), .west_in3(west_in[3]), 
        .west_in4(west_in[4]), .west_in5(west_in[5]), .west_in6(west_in[6]), .west_in7(west_in[7]),
        .row0 (row[0]),  .row1 (row[1]),  .row2 (row[2]),  .row3 (row[3]),
        .done(done)
	);

   /****************************************************************************
    * Apply Stimulus
    ***************************************************************************/
   initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,block_4x32_tb);
		for (i=0; i < in_length*8; i=i+1) begin
			$dumpvars(0,data_north[i]);
			$dumpvars(0,data_west[i]);
		end
		for (i=0; i < 8; i=i+1) begin
			$dumpvars(0,north_in[i]);
			$dumpvars(0,west_in[i]);
		end

		$readmemh("data_north.txt", data_north);
		$readmemh("data_west.txt", data_west);

		file = $fopen("out_val.txt","w");
		if (file == 0) begin
			$display("Error opening file");
			$finish;
		end

		test = 0;
		for (i=0; i<in_length; i=i+1) begin
			north_in[0] <= data_north[i];
			north_in[1] <= data_north[in_length*1+i];
			north_in[2] <= data_north[in_length*2+i];
			north_in[3] <= data_north[in_length*3+i];
			north_in[4] <= data_north[in_length*4+i];
			north_in[5] <= data_north[in_length*5+i];
			north_in[6] <= data_north[in_length*6+i];
			north_in[7] <= data_north[in_length*7+i];

			west_in[0] <= data_west[i];
			west_in[1] <= data_west[in_length*1+i];
			west_in[2] <= data_west[in_length*2+i];
			west_in[3] <= data_west[in_length*3+i];
			west_in[4] <= data_west[in_length*4+i];
			west_in[5] <= data_west[in_length*5+i];
			west_in[6] <= data_west[in_length*6+i];
			west_in[7] <= data_west[in_length*7+i];

			#T; test = ~test;
		end
		// for (i = 0; i < 4; i = i + 1) begin
		// 	$fwrite(file, "%h\n", row[i]);  // Write the value in hexadecimal format followed by a newline
		// end
		
		#(20*T);
		$fclose(file);
		$finish;

   end

	always @(posedge clk ) begin
		if (done == 1) begin
			#T;
			$display("This is run");
			for (i = 0; i < 4; i = i + 1) begin
				$fwrite(file, "%h\n", row[i]);  // Write the value in hexadecimal format followed by a newline
			end

			// file = $fopen("out_val.txt","w");
			// if (file == 0) begin
			// 	$display("Error opening file");
			// 	$finish;
			// end
			// else $display("File is open");

			// for (i = 0; i < 4; i = i + 1) begin
			// 	$fwrite(file, "%h\n", row[i]);  // Write the value in hexadecimal format followed by a newline
			// end

			// $fclose(file);
		end
	end

	initial begin
		rst_n = 0; 
		#(T/2);
		rst_n = 1;
		$monitor ("Time:%0t\t Done: %b",$time, done);
	end


endmodule
