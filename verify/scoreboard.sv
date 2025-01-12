`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "uvm_macros.svh"
`include "seqitem.sv"
import uvm_pkg::*;

class conv_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(conv_scoreboard)
    
    uvm_analysis_export#(conv_seqitem) rm2sb_export, mon2sb_export;
    uvm_tlm_analysis_fifo#(conv_seqitem) rm2sb_fifo, mon2sb_fifo;
    conv_seqitem act_trans_fifo[$], exp_trans_fifo[$];
    conv_seqitem act_trans, exp_trans;
    int count = 0;

    function new(input string name = "conv_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        rm2sb_export = new("rm2sb_export", this);
        mon2sb_export = new("mon2sb_export", this);
        rm2sb_fifo = new("rm2sb_fifo", this);
        mon2sb_fifo = new("mon2sb_fifo", this);
    endfunction

    function void connect_phase(input uvm_phase phase);
        super.connect_phase(phase);
        rm2sb_export.connect(rm2sb_fifo.analysis_export);
        mon2sb_export.connect(mon2sb_fifo.analysis_export);
    endfunction

    virtual task run_phase(input uvm_phase phase);
        forever begin
            #10ns

            mon2sb_fifo.get(act_trans);
            if(act_trans == null) $stop;
            act_trans_fifo.push_back(act_trans); 
            rm2sb_fifo.get(exp_trans);
            if(exp_trans == null) $stop;
            exp_trans_fifo.push_back(exp_trans);
            
            compare_trans();
        end
    endtask

    bit error = 0;

    virtual task compare_trans();
        conv_seqitem act_trans, exp_trans;
        if(act_trans_fifo.size() != 0) begin
            act_trans = act_trans_fifo.pop_front();
            if(exp_trans_fifo.size() != 0) begin
                exp_trans = exp_trans_fifo.pop_front();
                
                `uvm_info("SB",$sformatf("%d",count),UVM_LOW);
                
//                `uvm_info("SB",$sformatf("EXP_TRANS"),UVM_LOW);
//                exp_trans.print();
//                `uvm_info("SB",$sformatf("ACT_TRANS"),UVM_LOW);
//                act_trans.print();
                
                count = count + 1;

                if(act_trans.valid == 1 && exp_trans.valid == 1) begin
                    if(act_trans.result != exp_trans.result) begin
                        error = 1;
                        `uvm_info("SB",$sformatf("EXP_TRANS"),UVM_LOW);
                        exp_trans.print();
                        `uvm_info("SB",$sformatf("ACT_TRANS"),UVM_LOW);
                        act_trans.print();
                        `uvm_error(get_full_name(),$sformatf("COUT MIS-MATCHES"));
                    end
                end
                else if(act_trans.valid == 0 && exp_trans.valid == 0) begin
                end 
                else begin
                   error = 1;
                   `uvm_error(get_full_name(),$sformatf("COUT MIS-MATCHES"));
                end
            end
        end 
    endtask

    function void report_phase(input uvm_phase phase);
        if(error==0) begin
          $display("-------------------------------------------------");
          $display("------ INFO : TEST CASE PASSED ------------------");
          $display("-----------------------------------------");
        end else begin
          $display("---------------------------------------------------");
          $display("------ ERROR : TEST CASE FAILED ------------------");
          $display("---------------------------------------------------");
        end
      endfunction 
endclass

`endif