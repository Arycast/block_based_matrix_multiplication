module pe #(
    parameter BIT_WIDTH = 16,
    parameter FRAC_WIDTH = 8
) (
    input clk, rst_n,
	input [BIT_WIDTH-1:0] data_north, data_west,
	output reg [BIT_WIDTH-1:0] data_south, data_east, result
);

wire [2*BIT_WIDTH - 1:0] mult_result;
wire [2*BIT_WIDTH - 1:0] mac_result;
wire [BIT_WIDTH-1:0] temp_acc;

always @(posedge clk) begin
	if (!rst_n) begin
		data_south <= 0;
		data_east <= 0;
		result <= 0;
	end
	else begin
		data_south <= data_north;
		data_east <= data_west;
		result <= temp_acc;
	end
end

assign mult_result = data_west * data_north;
assign mac_result = mult_result + {result,{FRAC_WIDTH{1'b0}}};

saturate #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) sat_block (.in(mac_result), .out(temp_acc));
    
endmodule