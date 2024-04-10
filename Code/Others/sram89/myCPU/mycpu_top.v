`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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
`include "defines.vh"


module mycpu_top(input clk,resetn,// low active
	input[5:0] int,//interrupt
    output       inst_sram_en, //output 1'b1
    output[3:0]  inst_sram_wen, //output only read 4'b0000
    output[31:0] inst_sram_addr, //output pc
    output[31:0] inst_sram_wdata,  //output 32'b0
    input[31:0]  inst_sram_rdata,  //input instr

    output       data_sram_en,  //output 访存时置为1
    output[3:0]  data_sram_wen,  //output 控制字节
    output[31:0] data_sram_addr,   //output the adress cpu calculate
    output[31:0] data_sram_wdata,   //output 写入的数据
    input[31:0]  data_sram_rdata,   //input 读取的数据

    output[31:0] debug_wb_pc,
    output[3:0]  debug_wb_rf_wen,
    output[4:0]  debug_wb_rf_wnum,
    output[31:0] debug_wb_rf_wdata
	);
	wire [31:0] pcF,instrF,addr,ReadData,dataaddr,WriteData,ResultW4,pcW,inst_paddr,
		data_paddr,excepttypeM;
	wire [7:0] ALUControlE,ALUControlM;
	//wire [5:0] ext_int; // unused
	wire [4:0] WriteRegW;
	wire flushW,rst,stallM,flushM,RegWriteW,clkn,no_dcache;
	reg [3:0] sel;
	//wire clki,clkd;
	reg adelM,adesM;
	reg[31:0] ReadData2,writedata2,bad_addrM;

	//assign #1 clki=clk;
	//assign #3 clkd=clk;
	assign rst = ~resetn;
	assign clkn = ~clk;
	assign inst_sram_en = 1'b1;
	assign inst_sram_wen = 4'b0000;
	//assign inst_sram_addr = pcF;
	//assign inst_sram_addr = (pcF==32'h0)?32'hbfc00000:pcF;
	assign inst_sram_addr = inst_paddr;//((pcF[31:28] == 4'hB)|(pcF[31:28]==4'h9)) ? {4'h1,pcF[27:0]}:
					//((pcF[31:28] == 4'h8)|(pcF[31:28] == 4'hA)) ? {4'h0,pcF[27:0]}:pcF;//if_addr;     //pcF需要经过地址映射
	//assign if_addr = 
	assign inst_sram_wdata = 32'b0;
	assign instrF = inst_sram_rdata; //变量名可能不一致

	assign data_sram_en = memenM & ~(|excepttypeM);  //变量名可能不一致 // | A 归约或，A有一位为1则为1
	assign data_sram_wen = sel;  //变量名可能不一致
	assign data_sram_addr = data_paddr;//addr; //变量名可能不一致
	assign data_sram_wdata = writedata2; //变量名可能不一致
	assign ReadData = data_sram_rdata;  //变量名可能不一致
	
	//floprc #(4) r1W(clk,rst,flushW,sel,selW);
	//pc每级传递最好使用单独的旁路
	assign debug_wb_pc = pcW;  //cpu写回级的pc 32bit 变量名可能不一致
	assign debug_wb_rf_wen = {4{RegWriteW}};// cpu写回级的使能? 4bit扩展 变量名可能不一致 ?
	assign debug_wb_rf_wnum = WriteRegW;//cpu写回级的寄存器号? 5bit 变量名可能不一致
	assign debug_wb_rf_wdata = ResultW4;//cpu写回级的数据? 32bit 变量名可能不一致	

	mmu mm(.inst_vaddr(pcF),.inst_paddr(inst_paddr),.data_vaddr(addr),
			.data_paddr(data_paddr),.no_dcache(no_dcache));
	mips mips(.clk(clkn),.rst(rst),.pcF(pcF),.instrF(instrF),.ReadData(ReadData2),
	.ALUResultM2(dataaddr),.WriteData(WriteData), .ResultW4(ResultW4),
	.RegWriteW(RegWriteW),
    .ALUControlE(ALUControlE),.WriteRegW(WriteRegW), 
	.pcW(pcW),.memenM(memenM),.adelM(adelM),.adesM(adesM),
	.bad_addrM(bad_addrM),.ext_int(int),.excepttypeM(excepttypeM),
	.flushW(flushW),.stallM(stallM),.flushM(flushM));
	
/*
	inst_mem imem (
  .clka(clki),    // input wire clka
  //.wea(4'b0000),      // input wire [3 : 0] wea
  .addra(pc),  // input wire [31 : 0] addra
  //.dina(32'b0),    // input wire [31 : 0] dina
  .douta(instr)  // output wire [31 : 0] douta
);*/
	// logic for byte and half word
	flopenrc alucontrolem(clkn,rst,~stallM,flushM,ALUControlE,ALUControlM);
	// Parts of codes below are copied from ppt
	always@(*)begin
		if(rst)begin
			ReadData2<=32'b0;
			writedata2<=32'b0;
			sel<=4'b0;
			adelM<=1'b0;
			adesM<=1'b0;
			bad_addrM<=32'b0;
		end
		else begin
			case(ALUControlM)
				`EXE_LW_OP:begin
					sel<=4'b0000;
					writedata2<=32'b0;
					ReadData2<=ReadData;
					// adel exception, copied from video 
					if(dataaddr[1:0]!=2'b00)begin
						adelM<=1'b1;
						bad_addrM <= dataaddr;
					end else begin
						adelM<=1'b0;
					end
				end
				`EXE_LB_OP:begin
					sel<=4'b0000;
					writedata2<=32'b0;
					case(dataaddr[1:0])// big end or little end
						2'b11:ReadData2<={{24{ReadData[31]}},ReadData[31:24]};
						2'b10:ReadData2<={{24{ReadData[23]}},ReadData[23:16]};
						2'b01:ReadData2<={{24{ReadData[15]}},ReadData[15:8]};
						2'b00:ReadData2<={{24{ReadData[7]}},ReadData[7:0]};
						default:ReadData2<=ReadData;
					endcase
				end
				`EXE_LBU_OP:begin
					sel<=4'b0000;
					writedata2<=32'b0;
					case(dataaddr[1:0])
						2'b11:ReadData2<={{24{0}},ReadData[31:24]};
						2'b10:ReadData2<={{24{0}},ReadData[23:16]};
						2'b01:ReadData2<={{24{0}},ReadData[15:8]};
						2'b00:ReadData2<={{24{0}},ReadData[7:0]};
						default:ReadData2<=ReadData;
					endcase
				end
				`EXE_LH_OP:begin
					sel<=4'b0000;
					writedata2<=32'b0;
					case(dataaddr[1:0])
						2'b10:begin 
							ReadData2<={{16{ReadData[31]}},ReadData[31:16]};
							adelM<=1'b0;
						end
						2'b00:begin 
							ReadData2<={{16{ReadData[15]}},ReadData[15:0]};
							adelM<=1'b0;
						end
						default:begin
							ReadData2<=ReadData;
							adelM<=1'b1;
							bad_addrM <= dataaddr;
						end
					endcase
				end
				`EXE_LHU_OP:begin
					sel<=4'b0000;
					writedata2<=32'b0;
					case(dataaddr[1:0])
						2'b10:begin
							ReadData2<={{16{0}},ReadData[31:16]};
							adelM<=1'b0;
						end
						2'b00:begin
							ReadData2<={{16{0}},ReadData[15:0]};
							adelM<=1'b0;
						end
						default:begin 
							ReadData2<=ReadData;
							adelM<=1'b1;
							bad_addrM <= dataaddr;
						end
					endcase
				end
				`EXE_SW_OP:begin
					sel=4'b1111;
					writedata2<=WriteData;
					ReadData2<=ReadData;
					if(dataaddr[1:0]!=2'b00)begin
						sel=4'b0000;
						adesM<=1'b1;
						bad_addrM <= dataaddr;
					end else begin
						adesM<=1'b0;
					end
				end
				`EXE_SH_OP:begin
					writedata2 <={WriteData[15:0],WriteData[15:0]};
					case(dataaddr[1:0])
						2'b10:begin
							sel<=4'b1100;
							adesM<=1'b0;
						end
						2'b00:begin
							sel<=4'b0011;
							adesM<=1'b0;
						end
						default:begin
							sel<=4'b0000;
							adesM<=1'b1;
							bad_addrM <= dataaddr;
						end
					endcase
				end
				`EXE_SB_OP:begin
					writedata2 <={4{WriteData[7:0]}};
					case(dataaddr[1:0])
						2'b11:sel<=4'b1000;
						2'b10:sel<=4'b0100;
						2'b01:sel<=4'b0010;
						2'b00:sel<=4'b0001;
						default:sel<=4'b0000;
					endcase
					//sel<=4'b1111;
				end
				default:begin
					adelM<=1'b0;
					adesM<=1'b0;
				end
			endcase
		end
	end
	assign addr={dataaddr[31:2],2'b00};
	//inst_mem imem(.clka(clk),.wea(4'b0000),.addra(pc[9:0]),.douta(instr));
	// WriteData is WriteDataM 
	//data_mem dmem(.clka(clkd),.ena(memenM),.wea(sel),.addra(addr),.dina(writedata2),.douta(ReadData));// WriteData is WriteDataM
endmodule
/*
output[31:0]instr,pc,output memtoreg,memwrite,pcsrc,alusrc,regdst,regwrite,jump,
zero, output[7:0]alucontrol,// new 2 to 7
output[31:0]dataaddr,WriteData,output reg[31:0]ReadData2, output [31:0]SrcAD,SrcBD,npc,Result,v0,a1,SignImm,immsl,PCBranch,PCPlus4,
output StallF,branchD,stallD,MemtoRegE,flushE,RegWriteM,MemtoRegM,RegWriteW,output[4:0]rsD,rtD,rsE,rtE,WriteRegE,
output[1:0] forwardAD,forwardBD,forwardAE,forwardBE,output[31:0]SrcA2E,SrcB2E,InstrD,output MemWriteE,ALUSrcE,RegDstE,RegWriteE,
output[7:0]ALUControlE,// new 2 to 7
output[31:0]SignImmE,output[4:0]WriteRegM,WriteRegW,output MemtoRegW,
output[31:0]ReadDataW,ALUResultW,SrcA2D,SrcB2D,PCPlus4D,output[4:0]rdD,
output[31:0] ALUResultE,WriteDataE,SrcBE,wloi,whio,wloo,rsW,reg2,
output hilo_writeW, hilo_writeD,output[5:0]entermfhi,output[31:0]reg4,
output[63:0]hilo_tempE,output[31:0]reg1,reg3,hi_divoW,lo_divoW,output div_readyE,
output signed_divE,start_divE,stall_divE,hlW,multW,div_signalW,output[31:0]reg31,pcPlus8W,
output balW,jalW,balD,balE,balM,output[31:0]pcE,pcM,pcW,output branchJrstallD,bjfromE,
bjfromM,jalE,flushD,output[4:0]rdE,output[31:0]ALUResultM1,output memenD,
output reg[31:0]writedata2,output reg[3:0]sel,output [31:0]ReadData,output [31:0]addr,
output memenE,memenM,output[31:0]PCJump2,input [5:0] ext_int,output flush_except,
output[31:0]excepttypeM,output invalidD,output[31:0]cp0dataiM,data_o,cp0dataE,
output forwardcp0E,is_mfc0W,output[31:0]cp0dataW,cp0dataM,output flushW*/
/*module top(input clk,rst,output[31:0]dataadr, instr,pc,output memtoreg,memwrite,pcsrc,alusrc,regdst,regwrite,jump,
zero, output[2:0]alucontrol,output[31:0]dataaddr,WriteData,ReadData, SrcA,SrcB,npc,Result,v0,a1,SignImm,immsl,PCBranch,PCPlus4,output StallF);*/
//module top(input clk,rst,output[31:0]writedata,dataadr,output memwrite,output[31:0]instr,pc,SrcA,Result,SrcB);	
	//wire [3:0] memwrite4;
	//wire [31:0] addr; // aligned by word
	/*mips mips(clk,rst,pc,instr,ReadData,memtoreg,memwrite,pcsrc,alusrc,regdst,regwrite,jump, zero, alucontrol,
	dataaddr,WriteData, SrcA,SrcB,npc,Result,v0,a1,SignImm,immsl,PCBranch,PCPlus4,StallF);*/
	//module top(input clk,rst,output [31:0] writedata,dataadr,output memwrite,output [31:0] instr,pc,SrcA,output[31:0]Result,output[31:0]SrcB);