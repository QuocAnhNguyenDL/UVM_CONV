`ifndef TOP_SV
`define TOP_SV

`include "uvm_macros.svh"
`include "test.sv"
`include "interface.sv"
import uvm_pkg::*;

module top;

    parameter cycle = 10;
    bit clk;
    bit rstn;
    
    assign #1 d_clk = clk;

    initial begin
        forever begin
            #(cycle/2) clk = ~clk; 
        end
    end

    initial begin
        rstn = 1;
    end

    conv_interface conv_interface(clk, rstn);

    DUT #(.COL(`COL), .BIT_WIDTH(8), .IN_WIDTH(`IN_WIDTH), .OUT_WIDTH(`OUT_WIDTH)) uut (
        .clk(d_clk),
        .kernel(conv_interface.kernel),
        .pixel(conv_interface.pixel),
        .result(conv_interface.result),
        .valid(conv_interface.valid)
    );

    initial begin
        clk = 0;
        uvm_config_db#(virtual conv_interface)::set(uvm_root::get(),"*", "conv_interface", conv_interface);
        run_test("conv_test");
    end

endmodule

`endif