`ifndef SEQITEM_SV
`define SEQITEM_SV

`include "uvm_macros.svh"
`include "define.sv"

import uvm_pkg::*;

class conv_seqitem extends uvm_sequence_item;

    bit [0:(`BIT_WIDTH*(`COL*`COL+1))-1] kernel;
    bit [`IN_WIDTH-1:0] pixel;
    bit [`OUT_WIDTH-1:0] result;
    bit valid;


    `uvm_object_utils_begin(conv_seqitem)
        `uvm_field_int(kernel , UVM_ALL_ON)
        `uvm_field_int(pixel, UVM_ALL_ON)
        `uvm_field_int(result, UVM_ALL_ON)
        `uvm_field_int(valid, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(input string name = "conv_seqitem");
        super.new(name);
    endfunction

    constraint c_kernel { kernel inside {[(`BIT_WIDTH*(`COL*`COL+1))-1:0]}; }
    constraint c_pixel  { pixel  inside {[0:2**(`IN_WIDTH)-1]};            }
    constraint c_result { result inside {[0:(`OUT_WIDTH)-1]};              }
    constraint c_valid  { valid  inside {[0:1]};                           }
    
endclass


`endif