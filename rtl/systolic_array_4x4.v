module systolic_array_4x4 #(
    parameter BIT_WIDTH = 16,
    parameter FRAC_WIDTH = 8
) (
    input clk, rst_n,
	input [BIT_WIDTH-1:0] north_in0, north_in1, north_in2, north_in3, 
    input [BIT_WIDTH-1:0] west_in0, west_in1, west_in2, west_in3, 
	output reg [4*BIT_WIDTH-1:0] row0, row1, row2, row3
);
/*PE Position
  00 01 02 03
  10 11 12 13
  20 21 22 23
  30 31 32 33*/

wire [BIT_WIDTH-1:0] out_south00, out_south01, out_south02, out_south03;
wire [BIT_WIDTH-1:0] out_south10, out_south11, out_south12, out_south13;
wire [BIT_WIDTH-1:0] out_south20, out_south21, out_south22, out_south23;
wire [BIT_WIDTH-1:0] out_south30, out_south31, out_south32, out_south33;

wire [BIT_WIDTH-1:0] out_east00, out_east01, out_east02, out_east03;
wire [BIT_WIDTH-1:0] out_east10, out_east11, out_east12, out_east13;
wire [BIT_WIDTH-1:0] out_east20, out_east21, out_east22, out_east23;
wire [BIT_WIDTH-1:0] out_east30, out_east31, out_east32, out_east33;

wire [BIT_WIDTH-1:0] row00, row01, row02, row03;
wire [BIT_WIDTH-1:0] row10, row11, row12, row13;
wire [BIT_WIDTH-1:0] row20, row21, row22, row23;
wire [BIT_WIDTH-1:0] row30, row31, row32, row33;

//=============================== Column 0
pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe00 (
    .clk(clk), .rst_n(rst_n),
    .data_north(north_in0), .data_west(west_in0),
    .data_south(out_south00), .data_east(out_east00),
    .result(row00)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe10 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south00), .data_west(west_in1),
    .data_south(out_south10), .data_east(out_east10),
    .result(row10)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe20 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south10), .data_west(west_in2),
    .data_south(out_south20), .data_east(out_east20),
    .result(row20)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe30 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south20), .data_west(west_in3),
    .data_south(out_south30), .data_east(out_east30),
    .result(row30)
);

//=============================== Column 1
pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe01 (
    .clk(clk), .rst_n(rst_n),
    .data_north(north_in1), .data_west(out_east00),
    .data_south(out_south01), .data_east(out_east01),
    .result(row01)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe11 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south01), .data_west(out_east10),
    .data_south(out_south11), .data_east(out_east11),
    .result(row11)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe21 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south11), .data_west(out_east20),
    .data_south(out_south21), .data_east(out_east21),
    .result(row21)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe31 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south21), .data_west(out_east30),
    .data_south(out_south31), .data_east(out_east31),
    .result(row31)
);

//=============================== Column 2
pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe02 (
    .clk(clk), .rst_n(rst_n),
    .data_north(north_in2), .data_west(out_east01),
    .data_south(out_south02), .data_east(out_east02),
    .result(row02)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe12 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south02), .data_west(out_east11),
    .data_south(out_south12), .data_east(out_east12),
    .result(row12)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe22 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south12), .data_west(out_east21),
    .data_south(out_south22), .data_east(out_east22),
    .result(row22)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe32 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south22), .data_west(out_east31),
    .data_south(out_south32), .data_east(out_east32),
    .result(row32)
);

//=============================== Column 3
pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe03 (
    .clk(clk), .rst_n(rst_n),
    .data_north(north_in3), .data_west(out_east02),
    .data_south(out_south03), .data_east(out_east03),
    .result(row03)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe13 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south03), .data_west(out_east12),
    .data_south(out_south13), .data_east(out_east13),
    .result(row13)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe23 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south13), .data_west(out_east22),
    .data_south(out_south23), .data_east(out_east23),
    .result(row23)
);

pe #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) pe33 (
    .clk(clk), .rst_n(rst_n),
    .data_north(out_south23), .data_west(out_east32),
    .data_south(out_south33), .data_east(out_east33),
    .result(row33)
);

always @(posedge clk ) begin
    row0 <= {row00,row01,row02,row03};
    row1 <= {row10,row11,row12,row13};
    row2 <= {row20,row21,row22,row23};
    row3 <= {row30,row31,row32,row33};
end
    
endmodule