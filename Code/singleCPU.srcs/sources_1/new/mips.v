`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


/*module mips(
	input wire clk,rst,
	output wire[31:0] pc,
	input wire[31:0] instr,
	output wire memwrite,
	output wire[31:0] aluout,writedata,
	input wire[31:0] readdata,
	output wire[31:0] SrcA,
	output wire[31:0] Result,
	output [31:0]SrcB
	//output [31:0] rf[31:0] 
    );*/
module mips(input clk,rst,output[31:0] pc,input[31:0]instr,ReadData, output memtoreg,memwrite,pcsrc,alusrc,regdst,
regwrite,jump,zero, output[7:0]alucontrol,// new 2 to 7
output[31:0]ALUResultM,WriteData,SrcAD,SrcBD,npc,Result,v0,a1,SignImm,immsl,PCBranch,PCPlus4,
output StallF,branchD,stallD,MemtoRegE,flushE,RegWriteM,MemtoRegM,RegWriteW,output[4:0]rsD,rtD,rsE,rtE,WriteRegE,
output[1:0] forwardAD,forwardBD,forwardAE,forwardBE,output[31:0]SrcA2E,SrcB2E,InstrD,
output MemWriteE,ALUSrcE,RegDstE,RegWriteE,
output[7:0]ALUControlE,// new 2 to 7
output[31:0]SignImmE,output[4:0]WriteRegM,WriteRegW,output MemtoRegW,
output[31:0]ReadDataW,ALUResultW,SrcA2D,SrcB2D,PCPlus4D,output[4:0]rdD,
output[31:0] ALUResultE,WriteDataE,SrcBE,wloi,whio,wloo,rsW,reg2,
output hilo_writeW,hilo_writeD,output[5:0] entermfhi,output[31:0]reg4,
output[63:0]hilo_tempE,output[31:0]reg1,reg3,hi_divoW,lo_divoW,output div_readyE,
output signed_divE, start_divE, stall_divE,hlW,multW,div_signalW,output[31:0]reg31,pcPlus8W,
output balW,jalW,balD,balE,balM,output[31:0]pcE,pcM,pcW,output branchJrstallD,bjfromE,
bjfromM,jalE,flushD,output[4:0]rdE,output[31:0]ALUResultM1,output memenD,memenE,memenM,
output[31:0]PCJump2,input adelM, adesM, input[31:0] bad_addrM,input[5:0] ext_int,
output flush_except,output[31:0]excepttypeM,output invalidD,output[31:0]cp0dataiM,data_o,
cp0dataE,output forwardcp0E,is_mfc0W,output[31:0]cp0dataW,cp0dataM,output flushW);

/*module mips(input clk,rst,output[31:0] pc,input[31:0]instr,ReadData, output memtoreg,memwrite,pcsrc,alusrc,regdst,
regwrite,jump,zero, output[2:0]alucontrol,output[31:0]ALUResult,WriteData,SrcA,SrcB,npc,Result,v0,a1,SignImm,immsl,PCBranch,PCPlus4,output StallF);*/
	/*wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero;
	wire[2:0] alucontrol;*/
    wire branch,hilo_readD,hlD,multD,jalD,jrD,syscallD,eretD,breakD,cp0weD,is_mfc0D;//hilo_writeD,
    assign branchD=branch;
	controller c(.instD(InstrD),.memtoreg(memtoreg),
		.memwriteM(memwrite),.zero(zero),.PCSrc(pcsrc),.alusrc(alusrc),
		.regdst(regdst),.regwrite(regwrite),
		.jump(jump),.branch(branch),.alucontrol(alucontrol),.flushE(flushE),
		.clk(clk),.rst(rst),.memwriteE(MemWriteE),.hilo_writeD(hilo_writeD),
		.hilo_readD(hilo_readD),.hl(hlD),.multD(multD),.entermfhi(entermfhi),.balD(balD),
		.jalD(jalD),.jrD(jrD),.memenM(memenM),.memenD(memenD),.memenE(memenE),
		.invalidD(invalidD),.syscallD(syscallD),.breakD(breakD),.eretD(eretD),.cp0weD(cp0weD),
		.is_mfc0D(is_mfc0D));
	/*datapath dp(clk,rst,memtoreg,pcsrc,alusrc,
		regdst,regwrite,jump,alucontrol,zero,pc,instr,aluout,writedata,readdata,SrcA,Result,SrcB);*/
	datapath dp(.clk(clk),.reset(rst),.ALUSrcD(alusrc),.RegDstD(regdst),
	.RegWriteD(regwrite),.MemtoRegD(memtoreg),.PCSrc(pcsrc), .jump(jump),
	.branch(branch),
	.ALUControlD(alucontrol),.zero(zero),.flushE(flushE),.pcF(pc),
	.Instr(instr),.ReadData(ReadData), .ALUResultM2(ALUResultM),
	.WriteDataM(WriteData),
	.SrcAD(SrcAD),.SrcBD(SrcBD),.npc(npc),.ResultW1(Result),.whii(v0),.ResultW4(a1),
	.SignImmD(SignImm),.immsl(immsl),.PCBranch(PCBranch),.PCPlus4(PCPlus4),.stallF(StallF),
	.forwardAD(forwardAD),.forwardBD(forwardBD),.stallD(stallD),.MemtoRegE(MemtoRegE),.RegWriteM(RegWriteM),.MemtoRegM(MemtoRegM),.RegWriteW(RegWriteW),
	.rsD(rsD),.rtD(rtD),.rsE(rsE),.rtE2(rtE),.WriteRegE(WriteRegE),.forwardAE(forwardAE),.forwardBE(forwardBE),
	.SrcA2E(SrcA2E),.SrcB2E(SrcB2E),.InstrD(InstrD),.ALUSrcE(ALUSrcE),.RegDstE(RegDstE),.RegWriteE(RegWriteE),
	.ALUControlE(ALUControlE),.SignImmE(SignImmE),.WriteRegM(WriteRegM),.WriteRegW(WriteRegW),
	.MemtoRegW(MemtoRegW),.ReadDataW(ReadDataW),.ALUResultW(ALUResultW),
	.SrcA2D(SrcA2D),.SrcB2D(SrcB2D),.PCPlus4D(PCPlus4D),.rdD(rdD),
	.ALUResultE(ALUResultE),.WriteDataE(WriteDataE),.SrcBE(SrcBE),
	.hilo_writeD(hilo_writeD),.hilo_readD(hilo_readD),.hlD(hlD),.wloi(wloi),
	.whio(whio),.wloo(wloo),.rsW(rsW),.reg2(reg2),.hilo_writeW(hilo_writeW),.reg4(reg4),
	.hilo_tempE(hilo_tempE),.multD(multD),.reg1(reg1),.reg3(reg3),
	.hi_divoW(hi_divoW),.lo_divoW(lo_divoW),.div_readyE(div_readyE),
	.signed_divE(signed_divE),.start_divE(start_divE),.stall_divE(stall_divE),.hlW(hlW),
	.multW(multW),.div_signalW(div_signalW),.balD(balD),.jalD(jalD),.jrD(jrD),.reg31(reg31),
	.pcPlus8W(pcPlus8W),.balW(balW),.jalW(jalW),.balE(balE),.balM(balM),.pcPlus8E(pcE),
	.pcPlus8M(pcM),.pcPlus8D(pcW),.branchJrstallD(branchJrstallD),.bjfromE(bjfromE),
	.bjfromM(bjfromM),.jalE(jalE),.flushD(flushD),.rdE(rdE),.ALUResultM1(ALUResultM1),
	.PCJump2(PCJump2),.invalidD(invalidD),.adelM(adelM),.adesM(adesM),.bad_addrM(bad_addrM),
	.syscallD(syscallD),.breakD(breakD),.eretD(eretD),.ext_int(ext_int),.cp0weD(cp0weD),
	.is_mfc0D(is_mfc0D),.flush_except(flush_except),.excepttypeM(excepttypeM),
	.cp0dataiM(cp0dataiM),.data_o(data_o),.cp0dataE(cp0dataE),.forwardcp0E(forwardcp0E),
	.is_mfc0W(is_mfc0W),.cp0dataW(cp0dataW),.cp0dataM(cp0dataM),.flushW(flushW));
	/*datapath dp(.clk(clk),.reset(rst),.ALUSrcD(alusrc),.RegDstD(regdst),.RegWriteD(regwrite),.MemtoRegD(memtoreg),.PCSrc(pcsrc), .jump(jump),.branch(branch),
	.ALUControlD(alucontrol),.zero(zero),.flushE(flushE),.cpc(pc),.Instr(instr),.ReadData(ReadData), .ALUResultM(ALUResult),.WriteDataM(WriteData),
	.SrcA(SrcA),.SrcB(SrcB),.npc(npc),.Result(Result),.v0(v0),.a1(a1),.SignImmD(SignImm),.immsl(immsl),.PCBranch(PCBranch),.PCPlus4(PCPlus4),.stallF(StallF));*/
endmodule
