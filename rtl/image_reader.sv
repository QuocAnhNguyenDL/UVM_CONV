
`timescale 1ns / 1ps

module image_reader #(parameter NUMPIXELS = 1024, BIT_WIDTH = 8, FILE = "image.list")(
	input clk, rst,
	output reg [7:0] nextPixel
);

reg [BIT_WIDTH-1:0] image[0:NUMPIXELS-1];	
integer i = 0;

initial begin
	$readmemh(FILE, image);
end

always_ff @ (posedge clk or rst) begin
		nextPixel <= image[i];
		i <= i + 1;
end

endmodule
