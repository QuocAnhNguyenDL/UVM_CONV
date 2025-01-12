`ifndef REFMODEL_SV
`define REFMODEL_SV

`include "uvm_macros.svh"
`include "define.sv"
import uvm_pkg::*;

class conv_refmodel extends uvm_component;
    `uvm_component_utils(conv_refmodel)

    uvm_analysis_export#(conv_seqitem) dr2rm_export;
    uvm_analysis_port#(conv_seqitem) rm2sb_port;
    conv_seqitem exp_trans, rm_trans;
    uvm_tlm_analysis_fifo#(conv_seqitem) rm_exp_fifo;

    int queue[$];
    int count = 0;
    int img [`IMG_SIZE-1][`IMG_SIZE-1];
    int S;
    int i,j,x,y;

    function new(input string name = "conv_refmodel", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        dr2rm_export = new("dr2rm_export", this);
        rm2sb_port = new("rm2sb", this);
        rm_exp_fifo = new("rm_exp_fifo", this);
    endfunction

    function void connect_phase(input uvm_phase phase);
        super.connect_phase(phase);
        dr2rm_export.connect(rm_exp_fifo.analysis_export);
    endfunction

    task run_phase(input uvm_phase phase);
        super.run_phase(phase);
        forever begin
            rm_exp_fifo.get(rm_trans);
            get_expected_transaction();
            rm2sb_port.write(exp_trans);
        end
    endtask

    task get_expected_transaction();
         exp_trans = rm_trans;
         img[count/32][count%32] = exp_trans.pixel;
         
         x = count/32;
         y = count%32;
         if(x>=4 && x<=31 && y>=4 && y<=31) begin
            exp_trans.valid = 1;
         end
         
         S = 0;
         
         if(exp_trans.valid == 1) begin
            for(i=0; i<5; i = i+1) begin
                for(j=0; j<5 ;j = j+1) begin
                    S = S + img[x-4+i][y-4+j]*exp_trans.kernel[(j*8 + 40*i)+:8];
                end
            end
            S = S+exp_trans.kernel[25*`BIT_WIDTH+:8];
            if(S<0) S = 0;
         end
         
         exp_trans.result = S;
         
         count = count+1;
    endtask

endclass

`endif