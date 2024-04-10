`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:54:42
// Design Name: 
// Module Name: testbench
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


module testbench();
	reg clk;
	reg rst;
    wire memtoreg,memwrite,pcsrc,alusrc,regdst,regwrite,jump,zero,StallF,branchD,forwardAD,forwardBD,stallD,MemtoRegE,flushE,RegWriteM,MemtoRegM,RegWriteW;
    wire MemWriteE,ALUSrcE,RegDstE,RegWriteE;
    wire[2:0] ALUControlE;
    wire [4:0] rsD,rtD,rsE,rtE,WriteRegE,rdD;
    wire [1:0] forwardAE,forwardBE;
    wire[2:0]alucontrol;
	//wire[31:0] writedata,dataadr,instr,pc,SrcA,Result,SrcB;
	wire[31:0] instr,pc,writedata,SrcAD,SrcBD,npc,ReadData,Result,dataadr,v0,a1,SignImm,immsl,PCBranch,
	PCPlus4,SrcA2E,SrcB2E,InstrD,SignImmE;
	wire[4:0]WriteRegM,WriteRegW;
	wire MemtoRegW;
	wire[31:0]ReadDataW,ALUResultW,SrcA2D,SrcB2D,PCPlus4D;
	//wire memwrite;
    //wire[31:0]rf[31:0];
	//top dut(clk,rst,writedata,dataadr,memwrite,instr,pc,SrcA,Result,SrcB);
	//
	
    top dut(.clk(clk),.rst(rst),.instr(instr),.pc(pc),.memtoreg(memtoreg),.memwrite(memwrite),.pcsrc(pcsrc),
    .alusrc(alusrc),.regdst(regdst),.regwrite(regwrite), .jump(jump), .zero(zero), .alucontrol(alucontrol),
    .dataaddr(dataadr),.WriteData(writedata),.ReadData(ReadData),.SrcAD(SrcAD),.SrcBD(SrcBD),.npc(npc),
    .Result(Result),.v0(v0),.a1(a1),.SignImm(SignImm),.immsl(immsl),.PCBranch(PCBranch),.PCPlus4(PCPlus4),
    .StallF(StallF),.branchD(branchD),.forwardAD(forwardAD),.forwardBD(forwardBD),.stallD(stallD),
    .MemtoRegE(MemtoRegE),.flushE(flushE),.RegWriteM(RegWriteM),.MemtoRegM(MemtoRegM),.RegWriteW(RegWriteW),
    .rsD(rsD),.rtD(rtD),.rsE(rsE),.rtE(rtE),.WriteRegE(WriteRegE),.forwardAE(forwardAE),.forwardBE(forwardBE),
    .SrcA2E(SrcA2E),.SrcB2E(SrcB2E),.InstrD(InstrD),.MemWriteE(MemWriteE),.ALUSrcE(ALUSrcE),.RegDstE(RegDstE),.RegWriteE(RegWriteE),
	.ALUControlE(ALUControlE),.SignImmE(SignImmE),.WriteRegM(WriteRegM),.WriteRegW(WriteRegW),
	.MemtoRegW(MemtoRegW),.ReadDataW(ReadDataW),.ALUResultW(ALUResultW),.SrcA2D(SrcA2D),.SrcB2D(SrcB2D),
	.PCPlus4D(PCPlus4D),.rdD(rdD));
    /*top dut(.clk(clk),.rst(rst),.instr(instr),.pc(pc),.memtoreg(memtoreg),.memwrite(memwrite),.pcsrc(pcsrc),
    .alusrc(alusrc),.regdst(regdst),.regwrite(regwrite), .jump(jump), .zero(zero), .alucontrol(alucontrol),
    .dataaddr(dataadr),.WriteData(writedata),.ReadData(ReadData),.SrcA(SrcA),.SrcB(SrcB),.npc(npc),
    .Result(Result),.v0(v0),.a1(a1),.SignImm(SignImm),.immsl(immsl),.PCBranch(PCBranch),.PCPlus4(PCPlus4),.StallF(StallF));*/
    //top dut(.clk(clk),.rst(rst),.instr(instr));
	initial begin 
		rst <= 1;
		#200;
		rst <= 0;
	end

	always begin
		clk <= 1;
		#10;
		clk <= 0;
		#10;
	
	end

	always @(negedge clk) begin
		if(memwrite) begin
			/* code */
			if(dataadr === 84 & writedata === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end else if(dataadr !== 80) begin
				/* code */
				$display("Simulation Failed");
				$stop;
			end
		end
	end
endmodule
