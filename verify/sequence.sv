`ifndef SEQUENCE_SV
`define SEQUENCE_SV

`include "uvm_macros.svh"
`include "seqitem.sv"
import uvm_pkg::*;

class conv_sequence extends uvm_sequence#(conv_seqitem);
    `uvm_object_utils(conv_sequence)

    function new(input string name = "conv_sequence");
        super.new(name);
    endfunction

    virtual task body();
        logic [0:(`BIT_WIDTH*(`COL*`COL+1))-1] kernel[0:0];
        logic [`BIT_WIDTH-1:0] image [0:`IMG_SIZE*`IMG_SIZE-1];
        $readmemh("/home/quocna/project/uvm_conv/data/kernel.list", kernel);
        $readmemh("/home/quocna/project/uvm_conv/data/image32x32.list", image);
        
        for(int i = 0 ; i < `IMG_SIZE*`IMG_SIZE+1 ; i++) begin
            req = conv_seqitem::type_id::create("req");
            start_item(req);
            req.kernel = kernel[0];
            req.pixel = image[i];
            req.valid = 0;
            req.result = 0;
            //assert(req.randomize());
            finish_item(req);
            get_response(rsp);
        end
    endtask

endclass
`endif