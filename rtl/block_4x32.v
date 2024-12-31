module block_4x32 #(
    parameter BIT_WIDTH = 16,
    parameter FRAC_WIDTH = 8
) (
    input clk, rst_n,
	input [4*BIT_WIDTH-1:0] north_in0, north_in1, north_in2, north_in3, north_in4, north_in5, north_in6, north_in7,
    input [4*BIT_WIDTH-1:0] west_in0, west_in1, west_in2, west_in3, west_in4, west_in5, west_in6, west_in7,
	output reg [4*BIT_WIDTH-1:0] row0, row1, row2, row3,
    output reg done
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

genvar i;
generate
    for (i = 0; i < 8; i = i+1) begin
        systolic_array_4x4 #(.BIT_WIDTH(BIT_WIDTH), .FRAC_WIDTH(FRAC_WIDTH)) sys (
            .clk(clk), .rst_n(rst_n),
            .north_in0(north_in[i][4*BIT_WIDTH-1:3*BIT_WIDTH]), .north_in1(north_in[i][3*BIT_WIDTH-1:2*BIT_WIDTH]), .north_in2(north_in[i][2*BIT_WIDTH-1:BIT_WIDTH]), .north_in3(north_in[i][BIT_WIDTH-1:0]), 
            .west_in0(west_in[i][4*BIT_WIDTH-1:3*BIT_WIDTH]), .west_in1(west_in[i][3*BIT_WIDTH-1:2*BIT_WIDTH]), .west_in2(west_in[i][2*BIT_WIDTH-1:BIT_WIDTH]), .west_in3(west_in[i][BIT_WIDTH-1:0]),
            .row0(row[4*i]), .row1(row[4*i+1]), .row2(row[4*i+2]), .row3(row[4*i+3])
        );
    end
endgenerate

// Counter and FSM
reg [3:0] state_reg, state_next;
reg [3:0] cnt_reg, cnt_next;
wire do_sum;

always @(posedge clk) begin
    if (!rst_n) begin
        state_reg <= 0;
        cnt_reg <= 0;
        done <= 0;
    end else begin
        state_reg <= state_next;
        cnt_reg <= cnt_next;
    end
end

always @(*) begin
    state_next = state_reg;
    cnt_next = cnt_reg;
    case (state_reg)
        0: begin
            if (cnt_reg > 14) begin
                state_next = 1;
                cnt_next = 0;
            end 
            else begin
                cnt_next = cnt_reg + 1;
                done = 1'b0;
            end 
        end
        1: begin
            if (cnt_reg > 4) begin
                state_next = 2;
                cnt_next = 0;
            end 
            else cnt_next = cnt_reg + 1;
        end
        2: begin
            done = 1'b1;
            state_next = 0;
        end
        default: begin
            state_next = 0;
            cnt_next = 0;
        end
    endcase
end

// Tree sum
assign do_sum = state_reg == 1;

wire [4*BIT_WIDTH-1:0] sum_tree00[0:3], out_tree00[0:3];
wire [4*BIT_WIDTH-1:0] sum_tree10[0:3], out_tree10[0:3];
wire [4*BIT_WIDTH-1:0] sum_tree20[0:3], out_tree20[0:3];
wire [4*BIT_WIDTH-1:0] sum_tree30[0:3], out_tree30[0:3];

wire [4*BIT_WIDTH-1:0] sum_tree01[0:1], out_tree01[0:1];
wire [4*BIT_WIDTH-1:0] sum_tree11[0:1], out_tree11[0:1];
wire [4*BIT_WIDTH-1:0] sum_tree21[0:1], out_tree21[0:1];
wire [4*BIT_WIDTH-1:0] sum_tree31[0:1], out_tree31[0:1];

generate
    for (i=0; i<4; i=i+1) begin
        assign sum_tree00[i] = row[8*i] + row[8*i + 4];
        assign sum_tree10[i] = row[8*i + 1] + row[8*i + 5];
        assign sum_tree20[i] = row[8*i + 2] + row[8*i + 6];
        assign sum_tree30[i] = row[8*i + 3] + row[8*i + 7];

        register #(.BIT_WIDTH(4*BIT_WIDTH)) reg_tree00 (.clk(clk),.rst_n(do_sum),.in(sum_tree00[i]),.out(out_tree00[i]));
        register #(.BIT_WIDTH(4*BIT_WIDTH)) reg_tree10 (.clk(clk),.rst_n(do_sum),.in(sum_tree10[i]),.out(out_tree10[i]));
        register #(.BIT_WIDTH(4*BIT_WIDTH)) reg_tree20 (.clk(clk),.rst_n(do_sum),.in(sum_tree20[i]),.out(out_tree20[i]));
        register #(.BIT_WIDTH(4*BIT_WIDTH)) reg_tree30 (.clk(clk),.rst_n(do_sum),.in(sum_tree30[i]),.out(out_tree30[i]));
    end

    for (i=0; i<2; i=i+1) begin
        assign sum_tree01[i] = sum_tree00[2*i] + sum_tree00[2*i + 1];
        assign sum_tree11[i] = sum_tree10[2*i] + sum_tree10[2*i + 1];
        assign sum_tree21[i] = sum_tree20[2*i] + sum_tree20[2*i + 1];
        assign sum_tree31[i] = sum_tree30[2*i] + sum_tree30[2*i + 1];

        register #(.BIT_WIDTH(4*BIT_WIDTH)) reg_tree01 (.clk(clk),.rst_n(do_sum),.in(sum_tree01[i]),.out(out_tree01[i]));
        register #(.BIT_WIDTH(4*BIT_WIDTH)) reg_tree11 (.clk(clk),.rst_n(do_sum),.in(sum_tree11[i]),.out(out_tree11[i]));
        register #(.BIT_WIDTH(4*BIT_WIDTH)) reg_tree21 (.clk(clk),.rst_n(do_sum),.in(sum_tree21[i]),.out(out_tree21[i]));
        register #(.BIT_WIDTH(4*BIT_WIDTH)) reg_tree31 (.clk(clk),.rst_n(do_sum),.in(sum_tree31[i]),.out(out_tree31[i]));
    end
endgenerate

always @(posedge clk) begin
    row0 <= out_tree01[0] + out_tree01[1];
    row1 <= out_tree11[0] + out_tree11[1];
    row2 <= out_tree21[0] + out_tree21[1];
    row3 <= out_tree31[0] + out_tree31[1];
end

endmodule