`timescale 1ns / 1ps

module rowbuf #(parameter COL = 5, BIT_WIDTH = 8) (
    input clk,
    input en,
    input [BIT_WIDTH - 1:0] in,
    output reg [BIT_WIDTH - 1:0] out
);

reg [BIT_WIDTH - 1:0] rowbuf [0:COL-1];
integer i;

always_ff @(posedge clk)
begin
    if(en)
    begin
        for(i = COL - 1; i > 0; i = i -1)
        begin
            rowbuf[i] <= rowbuf[i-1];
        end
        rowbuf[0] <= in;   
    end
end

assign out = rowbuf[COL-1];

endmodule