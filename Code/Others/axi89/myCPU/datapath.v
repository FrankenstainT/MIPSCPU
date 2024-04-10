`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2020 09:11:24 AM
// Design Name: 
// Module Name: datapath
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
`include "defines2.vh"
/*module datapath(input clk,input reset,input MemtoReg, input PCSrc, input ALUSrc, input RegDst,input RegWrite,input jump,
                 input[2:0] ALUControl, output zero,output [31:0] cpc, input[31:0] Instr,output [31:0] ALUResult, 
                 output [31:0] WriteData,input[31:0] ReadData,output[31:0] SrcA,output[31:0]Result,output [31:0] SrcB);*/
module datapath(input clk,reset,input ALUSrcD,RegDstD,RegWriteD, MemtoRegD, PCSrc, jump,branch, 
input[7:0] ALUControlD, //new 2 to 7
output zero,flushE, output[31:0]pcF,input[31:0]Instr,ReadData, 
output [31:0] ALUResultM2, output[31:0]WriteDataM,SrcAD,SrcBD,npc,ResultW1,whii,//whatch hii
ResultW4,SignImmD,immsl,PCBranch,PCPlus4,
output stallF,stallD,MemtoRegE,RegWriteM,MemtoRegM,
RegWriteW,output[4:0]rsD,rtD,rsE,rtE2,
WriteRegE,output[1:0] forwardAD,forwardBD,forwardAE,forwardBE,output [31:0] SrcA2E,SrcB2E,
InstrD,output ALUSrcE,RegDstE,RegWriteE,
output[7:0]ALUControlE, //new 2 to 7
output[31:0]SignImmE,output[4:0]WriteRegM,WriteRegW,output MemtoRegW,
output[31:0]ReadDataW,ALUResultW,SrcA2D,SrcB2D,PCPlus4D,output[4:0]rdD,
output[31:0] ALUResultE,WriteDataE,SrcBE,input hilo_writeD,hilo_readD,hlD,
output[31:0] wloi,whio,wloo,rsW,reg2,output hilo_writeW,output[31:0]reg4,
output[63:0]hilo_tempE,input multD,output[31:0] reg1,reg3,hi_divoW,lo_divoW,
output div_readyE,output reg signed_divE,start_divE,stall_divE,output hlW,multW,div_signalW,
input balD,jalD,jrD,output[31:0]reg31,pcPlus8W,output balW,jalW,balE,balM,
output[31:0]pcPlus8E,pcPlus8M,pcW,output branchJrstallD,bjfromE,bjfromM,jalE,flushD,
output[4:0]rdE,output[31:0]ALUResultM1,PCJump2,input invalidD,adelM,adesM,
input [31:0] bad_addrM,input syscallD,breakD,eretD,input[5:0]ext_int,input cp0weD,is_mfc0D,
output flush_except,output[`RegBus]excepttypeM,cp0dataiM,data_o,cp0dataE,output forwardcp0E,
is_mfc0W,output[`RegBus] cp0dataW,cp0dataM,output flushW,stallM,flushM,fpc,input istall,dstall,output stallE);
/*module datapath(input clk,reset,input ALUSrcD,RegDstD,RegWriteD, MemtoRegD, PCSrc, jump,branch, input[2:0] ALUControlD, output zero,flushE, output[31:0]cpc,input[31:0]Instr,ReadData, 
output [31:0] ALUResultM, output[31:0]WriteDataM,SrcA,SrcB,npc,Result,v0,a1,SignImmD,immsl,PCBranch,PCPlus4,output stallF);*/
//wire[31:0] npc,SignImm,immsl,PCPlus4,PCBranch;
//wire[4:0] WriteRegE;
wire[31:0]PCJump1,PCSrcin,fvMtE,soft_pcM;//forward value M to E//SignImmD,PCPlus4,PCPlus4D,immsl,PCBranch,ReadData,
wire[27:0]insl2;
//wire[31:0]SrcB2D;//InstrD;SrcBD,SrcA2D,SrcAD,
wire[4:0]rdM,rdW,rtM;//aldstW,
wire[4:0]sa,rtE1;// newrdE,rsE,rtE,
wire[31:0]SrcAE;//SrcA2E,SrcB2E;//,WriteDataESrcBE,SignImmE,,ALUResultE
//wire RegDstE,flushE;//ALUSrcE,RegWriteE,MemtoRegE,
//wire[2:0]ALUControlE;
//wire RegWriteM,MemtoRegM;
wire[31:0] pcPlus8D;//ALUOutM,
//wire[4:0] WriteRegM;
//wire[4:0] WriteRegW;//WriteRegW2;
wire stallF1,annul_iE,flushpcE;//,forwardBD;//,forwardBD1;//stallD,stallFstallE,
//wire [1:0] forwardAE;//forwardAE1;//,forwardBE1;//forwardBE,
wire [31:0] ALUResutW,pcJ;
wire [63:0] hilo_iW,hilo_oW;//new
wire hilo_writeE,hilo_writeM,hlE,hlM,hilo_readE,hilo_readM,//hlW,
	hilo_readW,forwardHD,forwardHE,forwardHM,forwardHW,forwardrdM;//new hilo_writeW,
wire [31:0] hii1,loi1,hii2,loi2,hii3,loi3,rsM,hiloresultD,hiloresultE,hiloresultM,hiloresultW1,//rsW,
			hiloresultW2,hlwRef;// forward hilo, hilo Writeback Result Forwardhlo,
wire multE,multM,cp0weE,cp0weM,is_mfc0E,is_mfc0M;//,multW;// new,is_mfc0W
wire [63:0] hilo_tempM,hilo_tempW;//new
//reg signed_divE,start_divE,stall_divE;// new
wire div_signalE,div_signalM,div_readyM,div_readyW;// new, div_readyE is ready_odiv_signalW,
wire[31:0] hi_divoE,lo_divoE,hi_divoM,lo_divoM;// new
wire jrE,jrM,jrW,is_in_delayslotF,is_in_delayslotD,is_in_delayslotE,is_in_delayslotM,stallW,
flushF,timer_int_o;//,jalE;//balW,jalW,balE,balM,jalM,flush_except,flushW,flushM,stallM,
wire[31:0] ResultW2,pcD,branchForwardM1,branchForwardM2,status_o,cause_o,pcE,pcM,ResultW3;////pcW,;pcPlus8WexcepttypeM,
wire[7:0] exceptF,exceptD,exceptE,exceptM;
//wire [5:0] opD,functD;
wire[`RegBus] badvaddr,epc_o,bad_addriM,count_o,compare_o,config_o,prid_o;//,cp0dataW,cp0dataM
reg [31:0] newpcM,divSrcAE,divSrcBE;
assign stallF=reset?0:stallF1;

PC pc(clk,reset,~stallF,flush_except,npc,pcF,fpc);// add flush_except
mux2 #(5)rtE2mux(5'b11111,rtE1,balE|jalE,rtE2);
mux2 #(5)regdstm(rdE,rtE2,RegDstE,WriteRegE);
mux2 memtoregm(ReadDataW,ALUResultW,MemtoRegW,ResultW1);
sign_extend signextend(InstrD[15:0],InstrD[29:28],SignImmD);
mux2 ALUSrcm(SignImmE,WriteDataE,ALUSrcE,SrcB2E);// ALUSrcE=1,ScrB2E=SignImmE;
sl2 sl(SignImmD,immsl);
//mux2 #(5) aldstWmux(rdW,5'b11111,(rdW!=5'b0)&jrW,aldstW);
//mux2 #(5) writeregw2(aldstW,WriteRegW1,balW|jalW,WriteRegW2);
mux2 #(32) resultw3(pcPlus8W,ResultW2,balW|jalW,ResultW3);
mux2 #(32) resultW4(cp0dataW,ResultW3,is_mfc0W,ResultW4);
regfile reg32(.clk(clk),.rst(reset),.we3(RegWriteW),.ra1(InstrD[25:21]),.ra2(InstrD[20:16]),
.wa3(WriteRegW),.wd3(ResultW4),.rd1(SrcAD),
.rd2(SrcBD),.reg1(reg1),.reg2(reg2),.reg3(reg3),.reg4(reg4),.reg31(reg31));//,.a1(a1),.v0(v0)
ALU alu(SrcA2E,SrcB2E,ALUControlE,sa,ALUResultE,hilo_tempE,overflowE);// new

// divider state machine
always@(reset,ALUControlE,div_readyE)begin
	if(reset)begin
		start_divE <= 1'b0;
		signed_divE <= 1'b0;
		stall_divE <= 1'b0;

	end
	case(ALUControlE)
		`EXE_DIV_OP:begin
			if(div_readyE==1'b0)begin
				start_divE <= 1'b1;
				signed_divE <= 1'b1;
				stall_divE <= 1'b1;
				//divSrcAE<=SrcA2E;
		 		//divSrcBE<=SrcB2E;
			end else if(div_readyE == 1'b1) begin
				start_divE <= 1'b0;
				signed_divE <= 1'b1;
				stall_divE <= 1'b0;
			end else begin
				start_divE <= 1'b0;
				signed_divE <= 1'b0;
				stall_divE <= 1'b0;
			end
		end
		`EXE_DIVU_OP:begin
			if(div_readyE==1'b0)begin
				start_divE <= 1'b1;
				signed_divE <= 1'b0;
				stall_divE <= 1'b1;
				
			end else if(div_readyE == 1'b1) begin
				start_divE <= 1'b0;
				signed_divE <= 1'b0;
				stall_divE <= 1'b0;
			end else begin
				start_divE <= 1'b0;
				signed_divE <= 1'b0;
				stall_divE <= 1'b0;
			end
		end
		default:begin
			start_divE <= 1'b0;
			signed_divE <= 1'b0;
			stall_divE <= 1'b0;
		end
	endcase
end
always@(stallE,reset,SrcA2E,SrcB2E)begin
	if(reset)begin
		divSrcAE<=32'b0;
		divSrcBE<=32'b1;
	end
	if(~stallE)begin
		divSrcAE<=SrcA2E;
		divSrcBE<=SrcB2E;
	end
end
// Divider new
/*input	wire										clk,
	input wire										rst,
	
	input wire                    signed_div_i,
	input wire[31:0]              opdata1_i,
	input wire[31:0]		   				opdata2_i,
	input wire                    start_i,
	input wire                    annul_i,
	
	output reg[63:0]             result_o,
	output reg			             ready_o*/
assign div_signalE=((ALUControlE==`EXE_DIV_OP)|(ALUControlE==`EXE_DIVU_OP))?1:0;
div Div(clk,reset,signed_divE,divSrcAE,divSrcBE,start_divE,annul_iE,{hi_divoE,lo_divoE},div_readyE);
Adder adder4(pcF,32'h4,PCPlus4);
Adder adderB(immsl,PCPlus4D,PCBranch);
mux2 PCSrcm(PCBranch,PCPlus4,PCSrc,PCSrcin);// PCSrc=branch and equal
sl2 slj(InstrD[25:0],insl2);
assign PCJump1={PCPlus4D[31:28],insl2};
mux2 #(32)pcjump2mux(SrcA2D,PCJump1,jrD,PCJump2);
mux2 Jumpm(PCJump2,PCSrcin,jump,pcJ);
mux2 excpm(newpcM,pcJ,excepttypeM!=32'b0,npc);
flopenrc#(32)r1D(clk,reset,~stallD,flushD,PCPlus4,PCPlus4D);
Adder #(32)adder8(PCPlus4D,32'h4,pcPlus8D);
//flopenrc#(32)r2D(clk,reset,~stallD,flushD,Instr,InstrD);
flopenrc#(32)r2D(clk,reset,~stallD,flushD,Instr,InstrD);// don't flush delay slot
flopenrc#(32)r3D(clk,reset,~stallD,flushD,pcF,pcD); 
assign rsD=InstrD[25:21];
assign rtD=InstrD[20:16];
assign rdD=InstrD[15:11];

// exception module, copied from video
assign exceptF=(pcF[1:0]==2'b00)?8'b0000_0000:8'b1000_0000;// adel
assign is_in_delayslotF = (jump|branch);
//assign opD=InstrD[31:26];
//assign funcD=InstrD[5:0];
assign flush_except=(excepttypeM!=32'b0);
assign annul_iE = flush_except;// terminate div
//assign syscallD = ( opD == 6'b000000 && funcD == 6'b001100);
//assign breakD   = ( opD == 6'b000000 && funcD == 6'b001101);
//assign eretD    = ( InstrD == 32'b01000010000000000000000000011000);
flopenrc #(8) reD(clk,reset,~stallD,flushD,exceptF,exceptD);
flopenrc #(1) rdelayD(clk,reset,~stallD,flushD,is_in_delayslotF,is_in_delayslotD);
flopenrc #(8) reE(clk,reset,~stallE,flushE,
				{exceptD[7],syscallD,breakD,eretD,invalidD,exceptD[2:0]},exceptE);
flopenrc #(1) rdelayE(clk,reset,~stallE,flushE,is_in_delayslotD,is_in_delayslotE);
flopenrc #(8) reM(clk,reset,~stallM,flushM,{exceptE[7:3],overflowE,exceptE[1:0]},exceptM);
flopenrc #(1) rdelayM(clk,reset,~stallM,flushM,is_in_delayslotE,is_in_delayslotM);
exception exp(reset,exceptM,adelM,adesM,status_o,cause_o,excepttypeM);
mux2 #(32) bad_addri(pcM,bad_addrM,exceptM[7],bad_addriM);
mux2 #(32) cp0dataiMmux(ResultW4,fvMtE,forwardrdM,cp0dataiM);
assign soft_pcM=(excepttypeM==32'h00000001)?pcW+4:pcM;
cp0_reg cp0(.clk(clk),.rst(reset),.we_i(cp0weM),.waddr_i(rdM),.raddr_i(rdE),
.data_i(cp0dataiM),
.int_i(ext_int),//hardware interrupt // comment ext_int
.excepttype_i(excepttypeM),.current_inst_addr_i(soft_pcM),.is_in_delayslot_i(is_in_delayslotM),
.bad_addr_i(bad_addriM),.data_o(data_o),.count_o(count_o),.compare_o(compare_o),
.status_o(status_o),
.cause_o(cause_o),.epc_o(epc_o),.config_o(config_o),.prid_o(prid_o),.badvaddr(badvaddr),
.timer_int_o(timer_int_o));
mux2 #(32) cp0dataEmux(cp0dataiM,data_o,forwardcp0E,cp0dataE);
//assign cp0dataE = data_o;
//jump from cp0
always@(*)begin
	if(reset)begin
		newpcM<=32'hbfc00000;
	end else begin
		if(excepttypeM!=32'b0)begin// not Int 
			case(excepttypeM)
				32'h00000001:begin
					newpcM <=32'hBFC00380;
				end
				32'h00000004:begin// adel
					newpcM <=32'hBFC00380;
				end
				
				32'h00000008:begin// syscall
					newpcM <=32'hBFC00380;
				end
				32'h00000009:begin// break
					newpcM <=32'hBFC00380;
				end
				32'h0000000a:begin// undefined inst
					newpcM <=32'hBFC00380;
				end
				32'h0000000c:begin// overflow
					newpcM <=32'hBFC00380;
				end
				32'h00000005:begin// ades
					newpcM <=32'hBFC00380;
				end
				32'h0000000d:begin
					newpcM <=32'hBFC00380;
				end
				32'h0000000e:begin// eret
					newpcM <=epc_o;
				end
				default:newpcM<=pcM;
			endcase
		end
	end
end
//

eqcmp comp(SrcA2D,SrcB2D,InstrD[31:26],rtD,zero);// new

mux2 #(32) forwardbranchM1mux(pcPlus8M,fvMtE,balM|jalM,branchForwardM1);//?
mux2 #(32) forwardbranchM2mux(cp0dataM,branchForwardM1,is_mfc0M,branchForwardM2);
mux4 #(32) forwardamux(SrcAD,pcPlus8E,branchForwardM2,ResultW4,forwardAD,SrcA2D);
mux4 #(32) forwardbmux(SrcBD,pcPlus8E,branchForwardM2,ResultW4,forwardBD,SrcB2D);
//mux2 #(32) forwardamux(ALUResultM,SrcAD,forwardAD,SrcA2D);
//mux2 #(32) forwardbmux(ALUResultM,SrcBD,forwardBD,SrcB2D);

wire[4:0] rsD1,rtD1,rsE1,WriteRegE1,WriteRegM1;//,WriteRegW1;
wire branch1,RegWriteE1,MemtoRegE1,RegWriteM1,MemtoRegM1,RegWriteW1;
assign rsD1=reset?5'b0:rsD;
assign rtD1=reset?5'b0:rtD;
assign rsE1=reset?5'b0:rsE;
//assign rtE1=reset?5'b0:rtE;
assign WriteRegE1=reset?5'b0:WriteRegE;
assign WriteRegM1=reset?5'b0:WriteRegM;
//assign WriteRegW1=reset?5'b0:WriteRegW;
assign branch1=reset?0:branch;
assign RegWriteE1=reset?0:RegWriteE;
assign MemtoRegE1=reset?0:MemtoRegE;
assign RegWriteM1=reset?0:RegWriteM;
assign MemtoRegM1=reset?0:MemtoRegM;
assign RegWriteW1=reset?0:RegWriteW;

hazard h(
		//fetch stage
		stallF1,
		//decode stage
		rsD1,rtD1,branch1,forwardAD,forwardBD,stallD,
		//execute stage
		rsE1,rtE2,WriteRegE1,RegWriteE1,MemtoRegE1,forwardAE,forwardBE,flushE,
		//mem stage
		WriteRegM1,RegWriteM1,MemtoRegM1,
		//write back stage
		WriteRegW,RegWriteW1,
		// hilo forward
		hilo_writeE,hilo_writeM,hilo_writeW,hilo_readE,hilo_readM,hilo_readW,multE,multM,multW, forwardHD,
		stall_divE,
		stallE,// new for div stall
		div_signalE,div_signalM,div_signalW,jump,balE,balM,balW,jalE,jalM,jalW,jrD,
		branchJrstallD,bjfromE,bjfromM,flushD,PCSrc,clk,reset,flush_except,flushF,flushM,
		stallM,flushW,eretD,balD,jalD,cp0weD,cp0weM,forwardrdM,rtM,MemtoRegW,is_mfc0E,
		forwardcp0E,rdE,rdM,flushpcE,istall,dstall,stallW// new for div forward
		);
flopenrc #(32) r1E(clk,reset,~stallE,flushE,SrcAD,SrcAE);
flopenrc #(32) r2E(clk,reset,~stallE,flushE,SrcBD,SrcBE);
flopenrc #(32) r3E(clk,reset,~stallE,flushE,SignImmD,SignImmE);
flopenrc #(5) r4E(clk,reset,~stallE,flushE,rsD,rsE);
flopenrc #(5) r5E(clk,reset,~stallE,flushE,rtD,rtE1);
//flopenrc #(5) r6E(clk,reset,~stallE,flushE,rdD,rdE);
flopenrc #(5) r7E(clk,reset,~stallE,flushE,InstrD[10:6],sa);// new
flopenrc #(1) r8E(clk,reset,~stallE,flushE,hilo_writeD,hilo_writeE);//new
flopenrc #(1) r9E(clk,reset,~stallE,flushE,hlD,hlE);//new
flopenrc #(10) regE(
		clk,
		reset,
		~stallE,
		flushE,
		{MemtoRegD,ALUSrcD,ALUControlD},
		{MemtoRegE,ALUSrcE,ALUControlE}
		);
flopenrc #(32) r10E(clk,reset,~stallE,flushE,hiloresultD,hiloresultE);//new
flopenrc #(1) r11E(clk,reset,~stallE,flushE,hilo_readD,hilo_readE);// new
flopenrc #(1) r12E(clk,reset,~stallE,flushE,forwardHD,forwardHE);//new
flopenrc #(1) r13E(clk,reset,~stallE,flushE,multD,multE);//new
flopenrc #(2) r14E(clk,reset,~stallE,flushE,{balD,jalD},{balE,jalE});//new for branch al, jump al
flopenrc #(32) r15E(clk,reset,~stallE,flushE,pcPlus8D,pcPlus8E);
flopenrc #(5) r16E(clk,reset,~stallE,flushE,rdD,rdE);
flopenrc #(1) r17E(clk,reset,~stallE,flushE,jrD,jrE);
flopenrc #(1) r18E(clk,reset,~stallE,flushE,RegWriteD,RegWriteE);
flopenrc #(1) r19E(clk,reset,~stallE,flushE,RegDstD,RegDstE);
flopenrc #(32) r20E(clk,reset,~stallE,flushpcE,pcD,pcE);
flopenrc #(1) r21E(clk,reset,~stallE,flushE,cp0weD,cp0weE);
flopenrc #(1) r22E(clk,reset,~stallE,flushE,is_mfc0D,is_mfc0E);

flopenrc #(4) regM(// revised, hilo and hl added
		clk,reset,~stallM,flushM,
		{MemtoRegE,RegWriteE,hilo_writeE, hlE},
		{MemtoRegM,RegWriteM,hilo_writeM, hlM}
		);
flopenrc #(32) r1M(clk,reset,~stallM,flushM,WriteDataE,WriteDataM);
flopenrc #(32) r2M(clk,reset,~stallM,flushM,ALUResultE,ALUResultM1);
flopenrc #(5) r3M(clk,reset,~stallM,flushM,WriteRegE,WriteRegM);
flopenrc #(32) r4M(clk,reset,~stallM,flushM,SrcA2E,rsM);
flopenrc #(32) r5M(clk,reset,~stallM,flushM,hiloresultE,hiloresultM);// new
flopenrc #(1) r6M(clk,reset,~stallM,flushM,hilo_readE,hilo_readM);// new
flopenrc #(1) r7M(clk,reset,~stallM,flushM,forwardHE,forwardHM);// new
flopenrc #(1) r8M(clk,reset,~stallM,flushM,multE,multM);// new
flopenrc #(64) r9M(clk,reset,~stallM,flushM,hilo_tempE,hilo_tempM);//new
flopenrc #(1) r10M(clk,reset,~stallM,flushM,div_signalE,div_signalM); // new
flopenrc #(32) r11M(clk,reset,~stallM,flushM,hi_divoE,hi_divoM); // new
flopenrc #(32) r12M(clk,reset,~stallM,flushM,lo_divoE,lo_divoM); // new
flopenrc #(1) r13M(clk,reset,~stallM,flushM,div_readyE,div_readyM); // new
flopenrc #(2) r14M(clk,reset,~stallM,flushM,{balE,jalE},{balM,jalM}); // new
flopenrc #(32) r15M(clk,reset,~stallM,flushM,pcPlus8E,pcPlus8M);
flopenrc #(5) r16M(clk,reset,~stallM,flushM,rdE,rdM);
flopenrc #(1) r17M(clk,reset,~stallM,flushM,jrE,jrM);
flopenrc #(32) r18M(clk,reset,~stallM,flushM,pcE,pcM);
flopenrc #(1) r19M(clk,reset,~stallM,flushM,cp0weE,cp0weM);
flopenrc #(5) r20M(clk,reset,~stallM,flushM,rtE2,rtM);// rtE to rtE2
flopenrc #(1) r21M(clk,reset,~stallM,flushM,is_mfc0E,is_mfc0M);
flopenrc #(32) r22M(clk,reset,~stallM,flushM,cp0dataE,cp0dataM);
//writeback stage
flopenrc #(4) regW(// revised, hilo and hl added
		clk,reset,~stallW,flushW,
		{MemtoRegM,RegWriteM,hilo_writeM, hlM},
		{MemtoRegW,RegWriteW,hilo_writeW, hlW}
		);
flopenrc #(32) r1W(clk,reset,~stallW,flushW,fvMtE,ALUResultW);// change ALUResultM2 to fvMtE
flopenrc #(32) r2W(clk,reset,~stallW,flushW,ReadData,ReadDataW);
flopenrc #(5) r3W(clk,reset,~stallW,flushW,WriteRegM,WriteRegW);
flopenrc #(32) r4W(clk,reset,~stallW,flushW,rsM,rsW);
flopenrc #(32) r5W(clk,reset,~stallW,flushW,hiloresultM,hiloresultW1);// new hiloresultW to hiloresultW1
flopenrc #(1) r6W(clk,reset,~stallW,flushW,hilo_readM,hilo_readW); // new
flopenrc #(1) r7W(clk,reset,~stallW,flushW,forwardHM,forwardHW);// new
flopenrc #(1) r8W(clk,reset,~stallW,flushW,multM,multW);// new
flopenrc #(64) r9W(clk,reset,~stallW,flushW,hilo_tempM,hilo_tempW);//new
flopenrc #(1) r10W(clk,reset,~stallW,flushW,div_signalM,div_signalW); // new
flopenrc #(32) r11W(clk,reset,~stallW,flushW,hi_divoM,hi_divoW); // new
flopenrc #(32) r12W(clk,reset,~stallW,flushW,lo_divoM,lo_divoW); // new
flopenrc #(1) r13W(clk,reset,~stallW,flushW,div_readyM,div_readyW); // new // 32 to 1
flopenrc #(2) r14W(clk,reset,~stallW,flushW,{jalM,balM},{jalW,balW});
flopenrc #(32) r15W(clk,reset,~stallW,flushW,pcPlus8M,pcPlus8W);
flopenrc #(5) r16W(clk,reset,~stallW,flushW,rdM,rdW);
flopenrc #(1) r17W(clk,reset,~stallW,flushW,jrM,jrW);
flopenrc #(1) r18W(clk,reset,~stallW,flushW,is_mfc0M,is_mfc0W);
flopenrc #(32) r19W(clk,reset,~stallW,flushW,cp0dataM,cp0dataW);
flopenrc #(32) r20W(clk,reset,~stallW,flushW,pcM,pcW);
flopenrc #(32) r21W(clk,reset,~stallW,flushW,hiloresultM,hiloresultW1);

mux2 #(32) aluresultm2mux(pcPlus8M,ALUResultM1,balM|jalM,ALUResultM2);
mux2 #(32) aluresultm3mux(cp0dataM,ALUResultM2,is_mfc0M,fvMtE);
mux3 #(32) forwardaemux(SrcAE,ResultW4,fvMtE,forwardAE,SrcA2E);// 1 to 3

// forwardBE=0,1,2   WriteDataE=SrcBE,Result,ALUResultM
mux3 #(32) forwardbemux(SrcBE,ResultW4,fvMtE,forwardBE,WriteDataE);// 1 to 3

// new
// mt hilo
mux2 #(32) hii1mux(rsW,hilo_oW[63:32],hlW,hii1);// rsD1 wrong, not reg number, it should be reg value, and should be executed in writeback stage
mux2 #(32) loi1mux(hilo_oW[31:0],rsW,hlW,loi1);
mux2 #(32) hii2Wmux(hii1,hilo_oW[63:32],hilo_writeW,hii2);
mux2 #(32) loi2Wmux(loi1,hilo_oW[31:0],hilo_writeW,loi2);
mux2 #(32) hii3mux(hilo_tempW[63:32],hii2,multW,hii3);// mult
mux2 #(32) loi3mux(hilo_tempW[31:0],loi2,multW,loi3);// mult
mux2 #(32) hiiWmux(hi_divoW,hii3,div_signalW,hilo_iW[63:32]);// div hi
mux2 #(32) loiWmux(lo_divoW,loi3,div_signalW,hilo_iW[31:0]);// div lo
//mf hilo
mux2 #(32) hiloomux(hilo_oW[63:32],hilo_oW[31:0],hlD,hiloresultD);
// forward hilo
mux2 #(32) hlwRefmux(hilo_oW[63:32],hilo_oW[31:0],hlW,hlwRef);
mux2 #(32) hlRW2mux(hlwRef,hiloresultW1,forwardHW,hiloresultW2);
// hilo reg
hilo_reg hilo(clk,reset,hilo_writeW|multW|(div_signalW&div_readyW),hilo_iW[63:32],hilo_iW[31:0],hilo_oW[63:32],hilo_oW[31:0]);// we or multW 
mux2 #(32) resmux(hiloresultW2,ResultW1,hilo_readW,ResultW2);
assign whii=hilo_iW[63:32];
assign wloi=hilo_iW[31:0];
assign whio=hilo_oW[63:32];
assign wloo=hilo_oW[31:0];
endmodule
