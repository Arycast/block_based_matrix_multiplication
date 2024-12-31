module block_32x4 #(
    parameter BIT_WIDTH = 16,
    parameter FRAC_WIDTH = 8
) (
    input clk, rst_n,
	input [4*BIT_WIDTH-1:0] north_in0, north_in1, north_in2, north_in3, north_in4, north_in5, north_in6, north_in7,
    input [4*BIT_WIDTH-1:0] west_in0, west_in1, west_in2, west_in3, west_in4, west_in5, west_in6, west_in7,
	output reg [4*BIT_WIDTH-1:0] row0, row1, row2, row3, 
    output reg [4*BIT_WIDTH-1:0] row4, row5, row6, row7,
    output reg [4*BIT_WIDTH-1:0] row8, row9, row10, row11,
    output reg [4*BIT_WIDTH-1:0] row12, row13, row14, row15,
    output reg [4*BIT_WIDTH-1:0] row16, row17, row18, row19,
    output reg [4*BIT_WIDTH-1:0] row20, row21, row22, row23,
    output reg [4*BIT_WIDTH-1:0] row24, row25, row26, row27,
    output reg [4*BIT_WIDTH-1:0] row28, row29, row30, row31
);

wire [4*BIT_WIDTH-1:0] north_in[0:7];
wire [4*BIT_WIDTH-1:0] west_in[0:7];
wire [4*BIT_WIDTH-1:0] row[0:31];

// Change wire input to 2d wire for easier handling
assign north_in[0] = north_in0; assign north_in[1] = north_in1;
assign north_in[2] = north_in2; assign north_in[3] = north_in3;
assign north_in[4] = north_in4; assign north_in[5] = north_in5;
assign north_in[6] = north_in6; assign north_in[7] = north_in7;

assign west_in[0] = west_in0; assign west_in[1] = west_in1;
assign west_in[2] = west_in2; assign west_in[3] = west_in3;
assign west_in[4] = west_in4; assign west_in[5] = west_in5;
assign west_in[6] = west_in6; assign west_in[7] = west_in7;

// Change reg output to 2d reg for easier handling

assign row[0]  = row0;    assign row[1]  = row1;   assign row[2]  = row2;  assign row[3]  = row3; 
assign row[4]  = row4;    assign row[5]  = row5;   assign row[6]  = row6;  assign row[7]  = row7;
assign row[8]  = row8;    assign row[9]  = row9;   assign row[8]  = row10; assign row[11] = row11;
assign row[12] = row12;   assign row[13] = row13;  assign row[12] = row14; assign row[15] = row15;
assign row[16] = row16;   assign row[17] = row17;  assign row[16] = row18; assign row[19] = row19;
assign row[20] = row20;   assign row[21] = row21;  assign row[20] = row22; assign row[23] = row23;
assign row[24] = row24;   assign row[25] = row25;  assign row[24] = row26; assign row[27] = row27;
assign row[28] = row28;   assign row[29] = row29;  assign row[28] = row30; assign row[31] = row31;


systolic_array_4x4 #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) sys0 (
    .clk(clk), .rst_n(rst_n),
    .north_in0(north_in[0][4*BIT_WIDTH-1:3*BIT_WIDTH]), .north_in1(north_in[0][3*BIT_WIDTH-1:2*BIT_WIDTH]), .north_in2(north_in[0][2*BIT_WIDTH-1:BIT_WIDTH]), .north_in3(north_in[0][BIT_WIDTH-1:0]), 
    .west_in0(west_in[0][4*BIT_WIDTH-1:3*BIT_WIDTH]), .west_in1(west_in[0][3*BIT_WIDTH-1:2*BIT_WIDTH]), .west_in2(west_in[0][2*BIT_WIDTH-1:BIT_WIDTH]), .west_in3(west_in[0][BIT_WIDTH-1:0]),
    .row0(row[0]), .row1(row[1]), .row2(row[2]), .row3(row[3])
);

genvar i;
generate
    for (i = 1; i < 8; i = i+1) begin
        systolic_array_4x4 #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) sys (
            .clk(clk), .rst_n(rst_n),
            .north_in0(north_in[i][4*BIT_WIDTH-1:3*BIT_WIDTH]), .north_in1(north_in[i][3*BIT_WIDTH-1:2*BIT_WIDTH]), .north_in2(north_in[i][2*BIT_WIDTH-1:BIT_WIDTH]), .north_in3(north_in[i][BIT_WIDTH-1:0]), 
            .west_in0(west_in[i][4*BIT_WIDTH-1:3*BIT_WIDTH]), .west_in1(west_in[i][3*BIT_WIDTH-1:2*BIT_WIDTH]), .west_in2(west_in[i][2*BIT_WIDTH-1:BIT_WIDTH]), .west_in3(west_in[i][BIT_WIDTH-1:0]),
            .row0(row[4*i]), .row1(row[4*i+1]), .row2(row[4*i+2]), .row3(row[4*i+3])
        );
    end
endgenerate

    
endmodule