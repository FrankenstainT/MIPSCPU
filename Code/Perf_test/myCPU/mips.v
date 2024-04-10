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

module mips(input clk,rst,output[31:0] pcF,input[31:0]instrF,ReadData,
output[31:0]ALUResultM2,WriteData,ResultW4,output RegWriteW,output[7:0]ALUControlE,
output[4:0]WriteRegW,output[31:0] pcW,output memenM,input adelM,adesM,
input [31:0] bad_addrM,input[5:0]ext_int,output[31:0]excepttypeM,
output flushW,stallM,flushM,fpcF,stallF,input istall,dstall);

	wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero,flushE,memwrite,MemWriteE,branch,
		hilo_readD,balD,hlD,multD,jalD,jrD,syscallD,eretD,breakD,cp0weD,is_mfc0D,
		hilo_writeD,memenD,memenE,invalidD,stallE;
	wire[31:0] InstrD;
	wire[7:0] alucontrol;
	wire [5:0] entermfhi;
	
	controller c(.instD(InstrD),.memtoreg(memtoreg),
		.memwriteM(memwrite),.zero(zero),.PCSrc(pcsrc),.alusrc(alusrc),
		.regdst(regdst),.regwrite(regwrite),
		.jump(jump),.branch(branch),.alucontrol(alucontrol),.flushE(flushE),
		.clk(clk),.rst(rst),.memwriteE(MemWriteE),.hilo_writeD(hilo_writeD),
		.hilo_readD(hilo_readD),.hl(hlD),.multD(multD),.entermfhi(entermfhi),.balD(balD),
		.jalD(jalD),.jrD(jrD),.memenM(memenM),.memenD(memenD),.memenE(memenE),
		.invalidD(invalidD),.syscallD(syscallD),.breakD(breakD),.eretD(eretD),
		.cp0weD(cp0weD),
		.is_mfc0D(is_mfc0D),.stallE(stallE),.stallM(stallM),.flushM(flushM));
	
	datapath dp(.clk(clk),.reset(rst),.ALUSrcD(alusrc),.RegDstD(regdst),
	.RegWriteD(regwrite),.MemtoRegD(memtoreg),.PCSrc(pcsrc), .jump(jump),
	.branch(branch),
	.ALUControlD(alucontrol),.zero(zero),.flushE(flushE),.pcF(pcF),
	.Instr(instrF),.ReadData(ReadData), .ALUResultM2(ALUResultM2),
	.WriteDataM(WriteData),
	.SrcAD(SrcAD),.SrcBD(SrcBD),.npc(npc),.ResultW1(Result),.whii(v0),.ResultW4(ResultW4),
	.SignImmD(SignImm),.immsl(immsl),.PCBranch(PCBranch),.PCPlus4(PCPlus4),.stallF(stallF),
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
	.pcPlus8M(pcM),.pcW(pcW),.branchJrstallD(branchJrstallD),.bjfromE(bjfromE),
	.bjfromM(bjfromM),.jalE(jalE),.flushD(flushD),.rdE(rdE),.ALUResultM1(ALUResultM1),
	.PCJump2(PCJump2),.invalidD(invalidD),.adelM(adelM),.adesM(adesM),.bad_addrM(bad_addrM),
	.syscallD(syscallD),.breakD(breakD),.eretD(eretD),.ext_int(ext_int),.cp0weD(cp0weD),
	.is_mfc0D(is_mfc0D),.flush_except(flush_except),.excepttypeM(excepttypeM),
	.cp0dataiM(cp0dataiM),.data_o(data_o),.cp0dataE(cp0dataE),.forwardcp0E(forwardcp0E),
	.is_mfc0W(is_mfc0W),.cp0dataW(cp0dataW),.cp0dataM(cp0dataM),.flushW(flushW),.stallM(stallM),.flushM(flushM),
	.fpc(fpcF),.istall(istall),.dstall(dstall),.stallE(stallE));
endmodule
