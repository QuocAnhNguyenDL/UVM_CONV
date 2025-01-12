`ifndef ENVIROMENT_SV
`define ENVIROMENT_SV

`include "uvm_macros.svh"
`include "agent.sv"
`include "refmodel.sv"
`include "scoreboard.sv"
import uvm_pkg::*;


class conv_env extends uvm_env;
    `uvm_component_utils(conv_env)

    conv_agent a1;
    conv_refmodel r1;
    conv_scoreboard sb1;

    function new(input string name = "conv_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        a1 = conv_agent::type_id::create("a1", this);
        r1 = conv_refmodel::type_id::create("r1", this);
        sb1 = conv_scoreboard::type_id::create("sb1", this);
    endfunction

    function void connect_phase(input uvm_phase phase);
        super.connect_phase(phase);
        a1.d1.drv2rm_port.connect(r1.dr2rm_export);
        a1.m1.mon2sb_port.connect(sb1.mon2sb_export);
        r1.rm2sb_port.connect(sb1.rm2sb_export);
    endfunction
    
endclass


`endif