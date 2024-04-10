`timescale 1ns / 1ps
module i_sram2sraml(
    input wire clk,rst,

    //sram
    input wire inst_sram_en,
    input wire[31:0] inst_sram_addr,
    output wire[31:0] inst_sram_rdata,
    input wire[3:0] inst_sram_wen,
    input wire[31:0] inst_sram_wdata,
    output wire i_stall,
    input wire longest_stall,

    //sramlike
    output wire inst_req,
    output wire inst_wr,
    output wire [1:0] inst_size,
    output wire [31:0] inst_addr,
    output wire [31:0] inst_wdata,
    input wire [31:0] inst_rdata,
    input wire inst_addr_ok,
    input wire inst_data_ok
);

    reg addr_rcv;   //地址握手成功
    reg do_finish;   //读写事务结束
    assign inst_req = inst_sram_en & ~addr_rcv & ~do_finish;
    assign inst_wr = inst_sram_en & |inst_sram_wen;
    assign inst_size = (inst_sram_wen == 4'b0001 ||
                        inst_sram_wen == 4'b0010 ||
                        inst_sram_wen == 4'b0100 ||
                        inst_sram_wen == 4'b1000 ) ? 2'b00 :
                       (inst_sram_wen == 4'b0011 ||
                        inst_sram_wen == 4'b1100 ) ? 2'b01 :
                        2'b10;
    assign inst_addr = inst_sram_addr;
    assign inst_wdata =inst_sram_wdata;
    //save rdata
    reg [31:0] inst_rdata_save;
    always @(posedge clk) begin
        inst_rdata_save <= rst ? 31'b0 :
                           inst_data_ok ? inst_rdata :
                           inst_rdata_save;
    end
    assign inst_sram_rdata = inst_rdata_save;
    assign i_stall = inst_sram_en & ~do_finish;

    always @(posedge clk) begin
        addr_rcv <= rst  ?  1'b0 :
                    inst_req & inst_addr_ok & ~inst_data_ok ? 1'b1 : 
                    inst_data_ok ? 1'b0 : addr_rcv;
                    //保证先data_req再addr_rcv
                    //如果addr_ok同时data_ok，优先data_ok
    end

    always @(posedge clk) begin
        do_finish <= rst ? 1'b0 :
                     inst_data_ok ? 1'b1 :
                     ~longest_stall ? 1'b0 : do_finish;
    end


endmodule