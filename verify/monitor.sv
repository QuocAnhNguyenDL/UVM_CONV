`ifndef MONITOR_SV
`define MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class conv_monitor extends uvm_monitor;
    `uvm_component_utils(conv_monitor)

    virtual conv_interface conv_if;
    uvm_analysis_port#(conv_seqitem) mon2sb_port;
    conv_seqitem act_trans;
    bit is_first;

    function new(input string name = "conv_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual conv_interface)::get(this, "", "conv_interface", conv_if))
            `uvm_fatal("MONITOR_NO_IF", {get_full_name(), "not found interface"});
        mon2sb_port = new("mon2sb_port", this);
        act_trans = new("act_trans");;
    endfunction

    virtual task run_phase(input uvm_phase phase);
        forever begin
            collect_trans();
            mon2sb_port.write(act_trans);
        end
    endtask

    task collect_trans();
        
        wait(conv_if.rstn);
        @(conv_if.rc_cb);
    
        act_trans.kernel = conv_if.rc_cb.kernel;
        act_trans.pixel = conv_if.rc_cb.pixel;
        act_trans.result = conv_if.rc_cb.result;
        act_trans.valid = conv_if.rc_cb.valid;

    endtask
endclass

`endif