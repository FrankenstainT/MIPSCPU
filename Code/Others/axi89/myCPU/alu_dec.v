`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2020 03:13:51 PM
// Design Name: 
// Module Name: alu_dec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// funct EXE_ for R-type
// alucontrol EXE_  _OP
// op EXE_ _INST for R-type, EXE_ for I-type
module alu_dec(input [5:0]op, input [5:0]funct, input[4:0] rsD,output [7:0]alucontrol);
// Arithmetic logic
assign alucontrol=// logic
                  (op==`EXE_ANDI)?    `EXE_ANDI_OP:
                  (op==6'b111111)? 8'b00110101:
                  (op==`EXE_XORI)?    `EXE_XORI_OP:
                  (op==`EXE_LUI)?     `EXE_LUI_OP:
                  (op==`EXE_ORI)?     `EXE_ORI_OP:
                  // arithmetic 
                  (op==`EXE_ADDI)?    `EXE_ADDI_OP:
                  (op==`EXE_ADDIU)?   `EXE_ADDIU_OP:
                  (op==`EXE_SLTI)?    `EXE_SLTI_OP:
                  (op==`EXE_SLTIU)?   `EXE_SLTIU_OP:
                  // J type
                  /*(op==`EXE_J)?       `EXE_J_OP:
                  (op==`EXE_JAL)?     `EXE_JAL_OP:
                  (op==`EXE_BEQ)?     `EXE_BEQ_OP:
                  (op==`EXE_BGTZ)?    `EXE_BGTZ_OP:
                  (op==`EXE_BLEZ)?    `EXE_BLEZ_OP:
                  (op==`EXE_BNE)?     `EXE_BNE_OP:*/
                  //lw,sw
                  (op==`EXE_LB)?      `EXE_LB_OP:
                  (op==`EXE_LBU)?     `EXE_LBU_OP:
                  (op==`EXE_LH)?      `EXE_LH_OP:
                  (op==`EXE_LHU)?     `EXE_LHU_OP:
                  (op==`EXE_LW)?      `EXE_LW_OP:
                  (op==`EXE_SB)?      `EXE_SB_OP:
                  (op==`EXE_SH)?      `EXE_SH_OP:
                  (op==`EXE_SW)?      `EXE_SW_OP:
                  //EXE_SPECIAL_INST= 6'b000000
                  (op==`EXE_SPECIAL_INST)?  // logic
                                            ((funct==`EXE_AND)?   `EXE_AND_OP:
                                            (funct==`EXE_OR)?    `EXE_OR_OP:
                                            (funct==`EXE_XOR)?   `EXE_XOR_OP:
                                            (funct==`EXE_NOR)?   `EXE_NOR_OP:
                                            // sll etc
                                            (funct==`EXE_SLL)?   `EXE_SLL_OP:
                                            (funct==`EXE_SRL)?   `EXE_SRL_OP:
                                            (funct==`EXE_SRA)?   `EXE_SRA_OP:
                                            (funct==`EXE_SLLV)?  `EXE_SLLV_OP:
                                            (funct==`EXE_SRLV)?  `EXE_SRLV_OP:
                                            (funct==`EXE_SRAV)?  `EXE_SRAV_OP:
                                            //hilo
                                            /*(funct==`EXE_MFHI)?  `EXE_MFHI_OP:
                                            (funct==`EXE_MFLO)?  `EXE_MFLO_OP:
                                            (funct==`EXE_MTHI)?  `EXE_MTHI_OP:
                                            (funct==`EXE_MTLO)?  `EXE_MTLO_OP:*/
                                            //arithmetic
                                            (funct==`EXE_ADD)?   `EXE_ADD_OP:
                                            (funct==`EXE_ADDU)?  `EXE_ADDU_OP:
                                            (funct==`EXE_SUB)?   `EXE_SUB_OP:
                                            (funct==`EXE_SUBU)?  `EXE_SUBU_OP:
                                            (funct==`EXE_SLT)?   `EXE_SLT_OP:
                                            (funct==`EXE_SLTU)?  `EXE_SLTU_OP:
                                            (funct==`EXE_MULT)?  `EXE_MULT_OP:
                                            (funct==`EXE_MULTU)? `EXE_MULTU_OP:
                                            (funct==`EXE_DIV)?   `EXE_DIV_OP:
                                            (funct==`EXE_DIVU)?  `EXE_DIVU_OP:
                                            //J tpye
                                            (funct==`EXE_JR)?    `EXE_JR_OP:
                                            (funct==`EXE_JALR)?  `EXE_JALR_OP:8'b0): 
                    // privilege inst
                    (op==6'b010000)?
                                    //mtc0
                                    ((rsD==5'b00100)?  `EXE_MTC0_OP://8'b01100000://
                                    // mfc0
                                    (rsD==5'b00000)?  `EXE_MFC0_OP:8'b0):
                   //EXE_REGIMM_INST=2'b000000
                   //(op==`EXE_REGIMM_INST)?
                                            /*(rt==`EXE_BLTZ)?     `EXE_BLTZ_OP:
                                            (rt==`EXE_BLTZAL)?   `EXE_BLTZAL_OP:
                                            (rt==`EXE_BGEZ)?     `EXE_BGEZ_OP:
                                            (rt==`EXE_BGEZAL)?   `EXE_BGEZAL_OP:*/
                                            //8'b0:
                   8'b0;//
/*// sll etc
// lw sw
// conditional
assign alucontrol=(op==2'b00)?3'b010:
                  (op==2'b01)?3'b110:
                  (op==2'b10)?(funct==6'b100000)?3'b010:
                              (funct==6'b100010)?3'b110:
                              (funct==`EXE_AND)?`EXE_AND_OP:
                              (funct==`EXE_OR)?`EXE_OR_OP:
                              (funct==6'b101010)?3'b111:3'b000:3'b00;*/
endmodule
/*
module alu_dec(
    input wire[5:0] op,
    input wire[5:0] funct,
    output reg [7:0] alucontrol
    );
    always @(*) begin
        case(op)
        
    end
endmodule*/