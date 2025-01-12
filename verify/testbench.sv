`timescale 1ns / 1ps

`include "define.sv"

module conv_tb;

    // Inputs
    reg rstn;
    reg clk;
    reg [(`BIT_WIDTH*`COL*`COL)-1:0] kernel;
    reg [`IN_WIDTH-1:0] pixel;

    // Outputs
    wire [`OUT_WIDTH-1:0] result;
    wire valid;

    // Instantiate the conv
    DUT #(.COL(`COL), .BIT_WIDTH(8), .IN_WIDTH(`IN_WIDTH), .OUT_WIDTH(`OUT_WIDTH)) uut (
        .clk(clk),
        .kernel(kernel),
        .pixel(pixel),
        .result(result),
        .valid(valid),
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10ns
    end

    // Test sequence
    initial begin
        // // Initialize signals
        // rstn = 0;
        // wr_en = 0;
        // rd_en = 0;
        // din = 0;

        // // Apply reset
        // #10 rstn = 1;

        // // Write data into conv
        // $display("Writing data into conv...");
        // repeat (DEPTH) begin
        //     @(posedge clk);
        //     wr_en = 1;
        //     din = $random; // Generate random data
        // end
        // wr_en = 0;
        // din = 0;

        // // Check if conv is full
        // @(posedge clk);
        // if (full) $display("conv is full as expected.");
        // else $display("conv is NOT full, unexpected behavior!");

        // // Read data from conv
        // $display("Reading data from conv...");
        // repeat (DEPTH) begin
        //     @(posedge clk);
        //     rd_en = 1;
        // end
        // rd_en = 0;

        // // Check if conv is empty
        // @(posedge clk);
        // if (empty) $display("conv is empty as expected.");
        // else $display("conv is NOT empty, unexpected behavior!");

        // // End simulation
        // $stop;
    end

endmodule