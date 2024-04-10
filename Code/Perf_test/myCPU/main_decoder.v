`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2020 03:04:12 PM
// Design Name: 
// Module Name: main_decoder
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
module main_decoder(input[5:0]opcode, input[5:0] funct, 
                  input[4:0] rtD,rdD, 
                  //output reg[1:0] aluop, 
                  output reg jump,jal,jr,bal,
                             branch,alusrc,
                             memwrite,memtoreg,
                             regwrite,regdst,hilo_writeD,hilo_readD,hl,multD,memen,invalidD,
                             syscallD,breakD,cp0weD,is_mfc0D,output eretD,
                  output reg[5:0] entermfhi,
                  input [31:0] instrD);// 
   assign eretD=(instrD==`EXE_ERET)?1'b1:1'b0;
     //always@(opcode,funct,rtD,rdD,instrD)begin
   always@(*)begin
        syscallD = 1'b0;
        breakD = 1'b0;
         cp0weD = 1'b0;
         is_mfc0D = 1'b0;
      case(opcode)
         // R-type
         `EXE_SPECIAL_INST:begin
            case(funct)
               // arithmetic
               `EXE_ADD,`EXE_ADDU,`EXE_SUB,`EXE_SUBU,`EXE_SLT,`EXE_SLTU,
               `EXE_SLL,`EXE_SLLV,`EXE_SRL,`EXE_SRA,`EXE_SRLV,`EXE_SRAV,
               `EXE_AND,`EXE_OR,`EXE_XOR,`EXE_NOR:begin// nop here
                  regwrite <= (|instrD)?1'b1:1'b0;// for nop regwrite is 0
                  memtoreg <= 1'b0;
                  regdst<=1'b1;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               `EXE_MULT,`EXE_MULTU:begin
                  regwrite <= 1'b0;
                  memtoreg <= 1'b0;
                  regdst<=1'b0;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b1;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               `EXE_DIV,`EXE_DIVU:begin
                  regwrite <= 1'b0;
                  memtoreg <= 1'b0;
                  regdst<=1'b0;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               //hilo mf
               `EXE_MFHI:begin
                  regwrite <= 1'b1;
                  memtoreg <= 1'b0;
                  regdst<=1'b1;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;// ? not 1
                  jal<=1'b0;
                  jr<=1'b0;// ? not 1
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b1;
                  hl<=1'b1;
                  multD<=1'b0;
                  entermfhi<=`EXE_MFHI;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               `EXE_MFLO:begin
                  regwrite <= 1'b1;
                  memtoreg <= 1'b0;
                  regdst<=1'b1;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;// ? not 1
                  jal<=1'b0;
                  jr<=1'b0;// ? not 1
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b1;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               // hilo mt
               `EXE_MTHI:begin
                  regwrite <= 1'b1;
                  memtoreg <= 1'b0;
                  regdst<=1'b1;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;//
                  jal<=1'b0;
                  jr<=1'b0;//
                  bal<=1'b0;
                  hilo_writeD<=1'b1;
                  hilo_readD<=1'b0;
                  hl=1'b1;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               `EXE_MTLO:begin
                  regwrite <= 1'b1;
                  memtoreg <= 1'b0;
                  regdst<=1'b1;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;//
                  jal<=1'b0;
                  jr<=1'b0;//
                  bal<=1'b0;
                  hilo_writeD<=1'b1;
                  hilo_readD<=1'b0;
                  hl=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               `EXE_JR:begin
                  regwrite <= 1'b0;
                  memtoreg <= 1'b0;
                  regdst<=1'b0;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b1;
                  jal<=1'b0;
                  jr<=1'b1;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
                  entermfhi<=`EXE_JR;
               end
               `EXE_JALR:begin
                  regwrite <= 1'b1;
                  memtoreg <= 1'b0;
                  regdst<=(rdD!=5'b0);
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b1;
                  jal<=1'b1;
                  jr<=1'b1;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               // trap inst
               `EXE_BREAK:begin
                  regwrite <= 1'b0;
                  memtoreg <= 1'b0;
                  regdst<=1'b0;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
                  breakD=1'b1;
               end
               `EXE_SYSCALL:begin
                  regwrite <= 1'b0;
                  memtoreg <= 1'b0;
                  regdst<=1'b0;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
                  syscallD=1'b1;
               end
               default:begin// R-type undefined inst
                  regwrite <= 1'b0;//0 for security
                  memtoreg <= 1'b0;
                  regdst<=1'b1;
                  alusrc<=1'b0;
                  branch<=1'b0;
                  memwrite<=1'b0;
                  jump<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b1;
               end
            endcase
         end
         // ori,lui,xori,andi
         `EXE_ORI,`EXE_LUI,`EXE_XORI,`EXE_ANDI:begin
            regwrite<=1'b1;
            memtoreg<=1'b0;
            regdst<=1'b0;
            alusrc<=1'b1;
            branch<=1'b0;
            jump<=1'b0;
            memwrite<=1'b0;
            jal<=1'b0;
            jr<=1'b0;
            bal<=1'b0;
            hilo_writeD<=1'b0;
            hilo_readD<=1'b0;
            hl<=1'b0;
            multD<=1'b0;
            memen<=1'b0;
            invalidD<=1'b0;
         end

         //addi
         `EXE_ADDI,`EXE_ADDIU,`EXE_SLTI,`EXE_SLTIU:begin
            regwrite<=1'b1;
            memtoreg<=1'b0;
            regdst<=1'b0;
            alusrc<=1'b1;
            branch<=1'b0;
            jump<=1'b0;
            memwrite<=1'b0;
            jal<=1'b0;
            jr<=1'b0;
            bal<=1'b0;
            hilo_writeD<=1'b0;
            hilo_readD<=1'b0;
            hl<=1'b0;
            multD<=1'b0;
            memen<=1'b0;
            invalidD<=1'b0;
         end
         // lw
         `EXE_LW,`EXE_LB,`EXE_LBU,`EXE_LH,`EXE_LHU:begin
            regwrite<=1'b1;
            //aluop<=2'b00;
            memtoreg<=1'b1;
            regdst<=1'b0;
            alusrc<=1'b1;
            branch<=1'b0;
            jump<=1'b0;
            memwrite<=1'b0;
            jal<=1'b0;
            jr<=1'b0;
            bal<=1'b0;
            hilo_writeD<=1'b0;
            hilo_readD<=1'b0;
            hl<=1'b0;
            multD<=1'b0;
            memen<=1'b1;
            invalidD<=1'b0;
         end
         // sw
         `EXE_SW,`EXE_SB,`EXE_SH:begin
            regwrite<=1'b0;
            //aluop<=2'b00;
            memtoreg<=1'b0;
            regdst<=1'b0;
            alusrc<=1'b1;
            branch<=1'b0;
            jump<=1'b0;
            memwrite<=1'b1;
            jal<=1'b0;
            jr<=1'b0;
            bal<=1'b0;
            hilo_writeD<=1'b0;
            hilo_readD<=1'b0;
            hl<=1'b0;
            multD<=1'b0;
            memen<=1'b1;
            invalidD<=1'b0;
         end
         // beq
         `EXE_BEQ,`EXE_BGTZ,`EXE_BLEZ,`EXE_BNE:begin
            regwrite <= 1'b0;
            memtoreg<=1'b0;
            regdst<=1'b0;
            alusrc<=1'b0;
            branch<=1'b1;
            jump<=1'b0;
            memwrite<=1'b0;
            jal<=1'b0;
            jr<=1'b0;
            bal<=1'b0;
            hilo_writeD<=1'b0;
            hilo_readD<=1'b0;
            hl<=1'b0;
            multD<=1'b0;
            memen<=1'b0;
            invalidD<=1'b0;
         end
         `EXE_REGIMM_INST:begin//6'b000001
            case(rtD)
               `EXE_BGEZ,`EXE_BLTZ:begin
                  regwrite <= 1'b0;
                  //aluop<=2'b01;
                  memtoreg<=1'b0;
                  regdst<=1'b0;
                  alusrc<=1'b0;
                  branch<=1'b1;
                  jump<=1'b0;
                  memwrite<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
               `EXE_BGEZAL,`EXE_BLTZAL:begin
                  regwrite <= 1'b1;
                  memtoreg<=1'b0;
                  regdst<=1'b0;
                  alusrc<=1'b0;
                  branch<=1'b1;
                  jump<=1'b0;
                  memwrite<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b1;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  entermfhi<={`EXE_BLTZAL,0};
                  memen<=1'b0;
                  invalidD<=1'b0;
               end
            endcase
         end
         // j
         `EXE_J:begin
            regwrite<=1'b0;
            memtoreg<=1'b0;
            regdst<=1'b0;
            alusrc<=1'b0;
            branch<=1'b0;
            jump<=1'b1;
            memwrite<=1'b0;
            jal<=1'b0;
            jr<=1'b0;
            bal<=1'b0;
            hilo_writeD<=1'b0;
            hilo_readD<=1'b0;
            hl<=1'b0;
            multD<=1'b0;
            memen<=1'b0;
            invalidD<=1'b0;
         end
         `EXE_JAL:begin
            regwrite<=1'b1;
            memtoreg<=1'b0;
            regdst<=1'b0;
            alusrc<=1'b0;
            branch<=1'b0;
            jump<=1'b1;
            memwrite<=1'b0;
            jal<=1'b1;
            jr<=1'b0;
            bal<=1'b0;
            hilo_writeD<=1'b0;
            hilo_readD<=1'b0;
            hl<=1'b0;
            multD<=1'b0;
            memen<=1'b0;
            invalidD<=1'b0;
         end
         // privilege inst
         6'b010000:begin
            case(instrD[25:21])
               // mtc0
               5'b00100:begin
                  regwrite<=1'b0;
                  memtoreg<=1'b0;
                  regdst<=1'b0;
                  alusrc<=1'b0;// choose rt
                  branch<=1'b0;
                  jump<=1'b0;
                  memwrite<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  cp0weD=1'b1;
                  invalidD<=1'b0;
                  entermfhi<=5'b00100;
               end
               // mfc0
               5'b00000:begin
                  regwrite<=1'b1;
                  memtoreg<=1'b0;
                  regdst<=1'b0;// choose rt to write
                  alusrc<=1'b0;
                  branch<=1'b0;
                  jump<=1'b0;
                  memwrite<=1'b0;
                  jal<=1'b0;
                  jr<=1'b0;
                  bal<=1'b0;
                  hilo_writeD<=1'b0;
                  hilo_readD<=1'b0;
                  hl<=1'b0;
                  multD<=1'b0;
                  memen<=1'b0;
                  is_mfc0D = 1'b1;
                  invalidD<=1'b0;
               end
               default:begin
                  if(instrD==`EXE_ERET)begin
                     invalidD<=1'b0;
                  end else begin
                     invalidD<=1'b1;
                  end
               end
            endcase
         end
         default:begin
            regwrite<=1'b0;
            memtoreg<=1'b0;
            regdst<=1'b0;
            alusrc<=1'b0;
            branch<=1'b0;
            jump<=1'b0;
            memwrite<=1'b0;
            jal<=1'b0;
            jr<=1'b0;
            bal<=1'b0;
            hilo_writeD<=1'b0;
            hilo_readD<=1'b0;
            hl<=1'b0;
            multD<=1'b0;
            memen<=1'b0;
            invalidD<=1'b1;
         end
      endcase
   end
endmodule
