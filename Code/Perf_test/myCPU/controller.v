`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2020 07:58:13 PM
// Design Name: 
// Module Name: controller
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


module controller(input[31:0] instD,output jump,PCSrc,alusrc,memwriteM,
memtoreg,regwrite,regdst,branch, output[7:0] alucontrol,input flushE,clk,
rst,zero,output memwriteE, hilo_writeD,hilo_readD,hl,multD,output[5:0]entermfhi,output balD,
jalD,jrD,memenM,memenD,memenE,invalidD,syscallD,breakD,eretD,cp0weD,is_mfc0D,input stallE,stallM,flushM);
//wire [1:0] aluop;
wire memwriteD;//memwriteE // jal,jr,bal for future
main_decoder maind(.opcode(instD[31:26]),.funct(instD[5:0]),
                    /*.aluop(aluop),*/
                    .jump(jump),.branch(branch),
                    .alusrc(alusrc),.memwrite(memwriteD),
                    .memtoreg(memtoreg),.regwrite(regwrite),
                    .regdst(regdst),.jal(jalD),.jr(jrD),.bal(balD),
                    .hilo_writeD(hilo_writeD),.hilo_readD(hilo_readD),
                    .hl(hl),.multD(multD),.entermfhi(entermfhi),.rtD(instD[20:16]),
                    .rdD(instD[15:11]),.memen(memenD),.invalidD(invalidD),.syscallD(syscallD),
                    .breakD(breakD),.eretD(eretD),.instrD(instD),.cp0weD(cp0weD),
                    .is_mfc0D(is_mfc0D));
alu_dec alud(.op(instD[31:26]),.funct(instD[5:0]),.rsD(instD[25:21]),.alucontrol(alucontrol));
assign PCSrc=zero&branch;
flopenrc #(2) md(clk,rst,~stallE,flushE,{memwriteD,memenD},{memwriteE,memenE});// axi add stallE
flopenrc #(2) me(clk,rst,~stallM,flushM,{memwriteE,memenE},{memwriteM,memenM});
//floprc #(1) memde(clk,rst,flushE,memenD,memenE);

endmodule
