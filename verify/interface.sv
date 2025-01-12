`ifndef INTERFACE_SV
`define INTERFACE_SV

`include "define.sv"

interface conv_interface(input bit clk, rstn); // @suppress "Design unit name 'conv_if' does not match file name 'interface'" // @suppress "Design unit name 'fifo_interface' does not match file name 'interface'" // @suppress "Design unit name 'conv_interface' does not match file name 'interface'"
    
    logic [0:(`BIT_WIDTH*(`COL*`COL+1))-1] kernel;
    logic [`IN_WIDTH-1:0] pixel;
    logic [`OUT_WIDTH-1:0] result;
    logic valid;

    // clocking block for driver
    clocking dr_cb@(posedge clk);
        output kernel;
        output pixel;
        input result;
        input valid;
    endclocking
    
    modport DRV (clocking dr_cb, input clk, rstn);

    // clocking block for monitor
    clocking rc_cb@(negedge clk);
        input kernel;
        input pixel;
        input result;
        input valid;
    endclocking
    
    modport RCV (clocking rc_cb, input clk, rstn);

endinterface

`endif