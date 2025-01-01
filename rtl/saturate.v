module saturate #(
    parameter BIT_WIDTH = 16,
    parameter FRAC_WIDTH = 8
) (
    input clk, rst_n,
	input [2*BIT_WIDTH-1:0] in,
	output [BIT_WIDTH-1:0] out
);

wire [1:0] sel, temp_sel;

assign sel[0] = |in[2*BIT_WIDTH-2:BIT_WIDTH+FRAC_WIDTH];
assign sel[1] = in[2*BIT_WIDTH-1];

register #(2) reg0 (.clk(clk),.rst_n(rst_n),.in(sel),.out(temp_sel));

assign out = sel[1]? 
    (sel[0]? in[BIT_WIDTH+FRAC_WIDTH-1:FRAC_WIDTH] : {1'b1,{BIT_WIDTH-1{1'b0}}}) :
    (sel[0]? {1'b0,{BIT_WIDTH-1{1'b1}}} : in[BIT_WIDTH+FRAC_WIDTH-1:FRAC_WIDTH]) ;
    
endmodule