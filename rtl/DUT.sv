`timescale 1ns / 1ps

module DUT #(parameter COL = 5, BIT_WIDTH = 8, IN_WIDTH = 8, OUT_WIDTH = 32) (
    input clk, 
    input [IN_WIDTH-1:0] pixel,
    input [0:PARAMS_NUM*BIT_WIDTH-1] kernel,
    output [OUT_WIDTH-1: 0] result,
    output valid
    );
    
    parameter IMG_SIZE = 32;
    parameter PARAMS_NUM = 26;
    
    reg [BIT_WIDTH-1:0] bufToC1_1, bufToC1_2, bufToC1_3, bufToC1_4, bufToC1_5;
    
    //Control signal for buffers
    reg data_valid;
    assign valid = data_valid;
    
    
    valid_data v1(
        .clk(clk),
        .valid(data_valid)
    );
    
    //IMG ---> buffer_C1
    row4buf #(.COL(IMG_SIZE), .BIT_WIDTH(BIT_WIDTH)) rb1(
        .clk(clk),
        .en(1'b1),
        .in(pixel),
        .out1(bufToC1_1), .out2(bufToC1_2), .out3(bufToC1_3), .out4(bufToC1_4), .out5(bufToC1_5)
    );

    //CONV
    reg [OUT_WIDTH-1:0] result_conv, conv_result, conv_plus_bias, conv_relu;
    conv #(.COL(COL), .BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) c1(
        .clk(clk),
        .en(1'b1),
        .kernel(kernel),
        .in1(bufToC1_5), .in2(bufToC1_4), .in3(bufToC1_3), .in4(bufToC1_2), .in5(bufToC1_1),
        .conv_result(conv_result)
    );
    assign conv_plus_bias = conv_result + kernel[(PARAMS_NUM-1)*BIT_WIDTH+:8];
    assign conv_relu = (conv_plus_bias < 0) ? 0 : conv_plus_bias; 
    assign result_conv = conv_relu;
    assign result = result_conv;
    
endmodule