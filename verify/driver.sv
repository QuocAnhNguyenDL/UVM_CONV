`ifndef DRIVER_SV
`define DRIVER_SV

`include "uvm_macros.svh"
`include "seqitem.sv"
`include "interface.sv"
import uvm_pkg::*;


class conv_driver extends uvm_driver #(conv_seqitem);
    `uvm_component_utils(conv_driver)

    virtual conv_interface conv_if;
    uvm_analysis_port#(conv_seqitem) drv2rm_port;

    function new(input string name = "conv_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual conv_interface)::get(this,"","conv_interface",conv_if))
            `uvm_fatal("DRIVER_NO_IF", {get_full_name(), "not found the interface"});
        drv2rm_port = new("drv2rm_port", this);
    endfunction

    virtual task run_phase(input uvm_phase phase);
        reset();
        forever begin
            //`uvm_info("test_d", "DUNG1", UVM_LOW)
            seq_item_port.get_next_item(req);
            drive(req);
            $cast(rsp, req.clone());
            rsp.set_id_info(req);
            drv2rm_port.write(rsp);
            seq_item_port.item_done();
            seq_item_port.put(rsp);
        end
    endtask

    virtual task reset();
        conv_if.dr_cb.kernel <= 0;
        conv_if.dr_cb.pixel <= 0;
    endtask

    virtual task drive(input conv_seqitem item);
        wait(conv_if.rstn);
        @(conv_if.dr_cb);
        conv_if.dr_cb.kernel <= item.kernel;
        conv_if.dr_cb.pixel <= item.pixel;
    endtask

endclass  

`endif