
`timescale 1ns / 1ps

module row4buf #(parameter COL = 5, BIT_WIDTH = 8) (
    input clk,
    input en,
    input [0:BIT_WIDTH - 1] in,
    output reg [0:BIT_WIDTH - 1] out1, out2, out3, out4, out5
);

reg [0:BIT_WIDTH - 1] reg_out1, reg_out2, reg_out3, reg_out4;

rowbuf #(.COL(COL), .BIT_WIDTH(BIT_WIDTH)) rb1(
    .clk(clk),
    .en(en),
    .in(in),
    .out(reg_out1)
);

rowbuf #(.COL(COL), .BIT_WIDTH(BIT_WIDTH)) rb2(
    .clk(clk),
    .en(en),
    .in(reg_out1),
    .out(reg_out2)
);

rowbuf #(.COL(COL), .BIT_WIDTH(BIT_WIDTH)) rb3( 
    .clk(clk),
    .en(en),
    .in(reg_out2),
    .out(reg_out3)
);

rowbuf #(.COL(COL), .BIT_WIDTH(BIT_WIDTH)) rb4(
    .clk(clk),
    .en(en),
    .in(reg_out3),
    .out(reg_out4)
);

assign out1 = in;
assign out2 = reg_out1;
assign out3 = reg_out2;
assign out4 = reg_out3;
assign out5 = reg_out4;

endmodule
