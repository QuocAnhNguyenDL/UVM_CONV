`ifndef SEQUENCER_SV
`define SEQUENCER_SV

`include "uvm_macros.svh"
`include "seqitem.sv"
import uvm_pkg::*;

class conv_sequencer extends uvm_sequencer#(conv_seqitem);

    `uvm_component_utils(conv_sequencer)

    function new(input string name = "conv_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass

`endif