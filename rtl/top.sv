`timescale 1ns / 1ps

module top(
        input clk,
        output [OUT_WIDTH-1:0 ] result,
        output valid
    );
    
    parameter NUMPIXELS = 1024;
    parameter BIT_WIDTH = 8;
    parameter PARAMS_NUM = 26;
    parameter FILTER_NUM = 6;
    parameter COL = 5;
    parameter IN_WIDTH = 8;
    parameter OUT_WIDTH = 32;
    parameter IMAGE_PATH = "/home/quocna/project/uvm_conv/data/image32x32.list";
    parameter PARAM_PATH = "/home/quocna/project/uvm_conv/data/kernel.list";
    
    reg [BIT_WIDTH-1:0] nextPixel;
    image_reader #(.NUMPIXELS(NUMPIXELS), .BIT_WIDTH(BIT_WIDTH), .FILE(IMAGE_PATH)) r_img(
        .clk(clk),
        .rst(),
        .nextPixel(nextPixel)
    );

    //Read params
    reg [0:PARAMS_NUM*BIT_WIDTH-1] kernel;
    
    params #(.BIT_WIDTH(BIT_WIDTH), .SIZE(PARAMS_NUM), .FILE(PARAM_PATH)) param_C1(
        .clk(clk),
        .read(1'b1),
        .read_out(kernel)
    );
    
    DUT #(
        .COL(COL),
        .BIT_WIDTH(BIT_WIDTH),
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH)
    ) DUT_instance (
        .clk(clk),
        .pixel(nextPixel),
        .kernel(kernel),
        .result(result),
        .valid(valid)
    );
endmodule