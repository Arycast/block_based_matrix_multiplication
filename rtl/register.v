module register #(parameter BIT_WIDTH = 16) (
    input clk, rst_n,
    input [BIT_WIDTH-1:0] in,
    output reg [BIT_WIDTH-1:0] out
);

always @(posedge clk) begin
    if (!rst_n) out <= 0;
    else out <= in;
end
    
endmodule