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
    wire memtoreg,memwrite,pcsrc,alusrc,regdst,regwrite,jump,zero;
    wire[2:0]alucontrol;
	//wire[31:0] writedata,dataadr,instr,pc,SrcA,Result,SrcB;
	wire[31:0] instr,pc,writedata,SrcA,SrcB,npc,ReadData,Result,dataadr,v0,a1,SignImm,immsl,PCBranch,PCPlus4;
	//wire memwrite;
    //wire[31:0]rf[31:0];
	//top dut(clk,rst,writedata,dataadr,memwrite,instr,pc,SrcA,Result,SrcB);
    top dut(.clk(clk),.rst(rst),.instr(instr),.pc(pc),.memtoreg(memtoreg),.memwrite(memwrite),.pcsrc(pcsrc),
    .alusrc(alusrc),.regdst(regdst),.regwrite(regwrite), .jump(jump), .zero(zero), .alucontrol(alucontrol),
    .dataaddr(dataadr),.WriteData(writedata),.ReadData(ReadData),.SrcA(SrcA),.SrcB(SrcB),.npc(npc),
    .Result(Result),.v0(v0),.a1(a1),.SignImm(SignImm),.immsl(immsl),.PCBranch(PCBranch),.PCPlus4(PCPlus4));
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
