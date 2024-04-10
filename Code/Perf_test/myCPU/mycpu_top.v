`timescale 1ns / 1ps
`include "defines.vh"
module mycpu_top(
	input wire[5:0] ext_int,
	input wire aclk,aresetn,
	
	// axi port
    //ar
    output wire[3:0] arid,      //read request id, fixed 4'b0
    output wire[31:0] araddr,   //read request address
    output wire[7:0] arlen,     //read request transfer length(beats), fixed 4'b0
    output wire[2:0] arsize,    //read request transfer size(bytes per beats)
    output wire[1:0] arburst,   //transfer type, fixed 2'b01
    output wire[1:0] arlock,    //atomic lock, fixed 2'b0
    output wire[3:0] arcache,   //cache property, fixed 4'b0
    output wire[2:0] arprot,    //protect property, fixed 3'b0
    output wire arvalid,        //read request address valid
    input wire arready,         //slave end ready to receive address transfer
    //r              
    input wire[3:0] rid,        //equal to arid, can be ignored
    input wire[31:0] rdata,     //read data
    input wire[1:0] rresp,      //this read request finished successfully, can be ignored
    input wire rlast,           //the last beat data for this request, can be ignored
    input wire rvalid,          //read data valid
    output wire rready,         //master end ready to receive data transfer
    //aw           
    output wire[3:0] awid,      //write request id, fixed 4'b0
    output wire[31:0] awaddr,   //write request address
    output wire[7:0] awlen,     //write request transfer length(beats), fixed 4'b0
    output wire[2:0] awsize,    //write request transfer size(bytes per beats)
    output wire[1:0] awburst,   //transfer type, fixed 2'b01
    output wire[1:0] awlock,    //atomic lock, fixed 2'b01
    output wire[3:0] awcache,   //cache property, fixed 4'b01
    output wire[2:0] awprot,    //protect property, fixed 3'b01
    output wire awvalid,        //write request address valid
    input wire awready,         //slave end ready to receive address transfer
    //w          
    output wire[3:0] wid,       //equal to awid, fixed 4'b0
    output wire[31:0] wdata,    //write data
    output wire[3:0] wstrb,     //write data strobe select bit
    output wire wlast,          //the last beat data signal, fixed 1'b1
    output wire wvalid,         //write data valid
    input wire wready,          //slave end ready to receive data transfer
    //b              
    input  wire[3:0] bid,       //equal to wid,awid, can be ignored
    input  wire[1:0] bresp,     //this write request finished successfully, can be ignored
    input wire bvalid,          //write data valid
    output wire bready,          //master end ready to receive write response

	//debug signals
	output wire [31:0] debug_wb_pc,
	output wire [3 :0] debug_wb_rf_wen,
	output wire [4 :0] debug_wb_rf_wnum,
	output wire [31:0] debug_wb_rf_wdata
);	

    wire [31:0] pcF,instrF,ReadData,dataaddr,WriteData,ResultW4,pcW,inst_paddr,
		data_paddr,excepttypeM,inst_sram_addr,inst_sram_wdata,inst_sram_rdata,data_sram_addr,
		data_sram_wdata,data_sram_rdata,inst_addr,inst_wdata,inst_rdata,data_addr,data_wdata,data_rdata;
	wire [7:0] ALUControlE,ALUControlM;//addr,
	//wire [5:0] int;
	wire [4:0] WriteRegW;
	wire [3:0] inst_sram_wen,data_sram_wen;
	wire [1:0] inst_size,data_size;
	wire flushW,rst,stallM,flushM,RegWriteW,clkn,no_dcache,inst_sram_en,data_sram_en,fpc,
		inst_addr_ok,inst_data_ok,data_addr_ok,data_data_ok,stallF,i_stall,d_stall,
		inst_wr,inst_req,data_req,data_wr,except,i_stall_e,i_longest;// i_stall exception version
	reg [3:0] sel;
	reg [1:0] exwa;//except waiting,
	reg adelM,adesM;//,exec except executing

	reg[31:0] ReadData2,writedata2,bad_addrM;

	assign rst = ~aresetn;
	assign clkn = aclk;// try not ~

	assign except = |excepttypeM;

	assign inst_sram_en = fpc;// mention, ignore & ~(|excepttypeM) ,// fpc is always1
	assign inst_sram_wen = 4'b0000;
	assign inst_sram_addr = inst_paddr;
	assign inst_sram_wdata = 32'b0;
	assign instrF = inst_sram_rdata; //变量名可能不一致

	// don't visit ram if except
	assign data_sram_en = memenM & ~except;  //变量名可能不一致 // | A 归约或，A有一位为1则为1
	assign data_sram_wen = sel;  //变量名可能不一致
	assign data_sram_addr = data_paddr;//addr; //变量名可能不一致
	assign data_sram_wdata = writedata2; //变量名可能不一致
	assign ReadData = data_sram_rdata;  //变量名可能不一致
	always@(rst,i_stall, posedge except)begin
		if(rst)begin
			exwa<=2'b00;
			//exec<=1'b0;
		end else begin
			if(i_stall)begin
				if(except)begin
					exwa<=2'b10;
				end
			end else begin
				if(exwa==2'b10)begin
					exwa<=2'b01;
				end else begin
					exwa<=2'b00;
				end
			end
		end
	end
	assign i_stall_e = (|exwa)?1'b1:i_stall;
	assign i_longest = (exwa==2'b01)?1'b0:stallF;
	i_sram_to_sram_like iinterface(
    .clk(clkn),
	.rst(rst),
	//sram
    .inst_sram_en(inst_sram_en),
    .inst_sram_addr(inst_sram_addr),
    .inst_sram_rdata(inst_sram_rdata),// output
    //.inst_sram_wen(inst_sram_wen),
    //.inst_sram_wdata(inst_sram_wdata),
    .i_stall(i_stall),
    .longest_stall(i_longest),
    //sramlike
    .inst_req(inst_req),
    .inst_wr(inst_wr),
    .inst_size(inst_size),
    .inst_addr(inst_addr),//output wire [31:0]
    .inst_wdata(inst_wdata),//output wire [31:0]
    .inst_rdata(inst_rdata),//input wire [31:0] from axi
    .inst_addr_ok(inst_addr_ok),//input wire from axi
    .inst_data_ok(inst_data_ok)//input wire from axi
);
d_sram_to_sram_like dinterface(
    .clk(clkn),
	.rst(rst),
	//sram
    .data_sram_en(data_sram_en),//input wire
    .data_sram_addr(data_sram_addr),//input wire [31:0] 
    .data_sram_rdata(data_sram_rdata),//output wire [31:0] 
    .data_sram_wen(data_sram_wen),//input wire [3:0] 
    .data_sram_wdata(data_sram_wdata),//input wire [31:0] 
    .d_stall(d_stall),//output wire 
    .longest_stall(stallM),
    //sramlike
    .data_req(data_req),//output wire
    .data_wr(data_wr),//output wire
    .data_size(data_size),//output wire [1:0]
    .data_addr(data_addr),//output wire [31:0]
    .data_wdata(data_wdata),//output wire [31:0]
    .data_rdata(data_rdata),//input wire [31:0]
    .data_addr_ok(data_addr_ok),//input wire
    .data_data_ok(data_data_ok)//input wire
);

cpu_axi_interface interface(
    .clk(aclk),
    .resetn(aresetn), 

    //inst sram-like 
    .inst_req(inst_req),
    .inst_wr(inst_wr),
    .inst_size(inst_size),
    .inst_addr(inst_addr),
    .inst_wdata(inst_wdata),
    .inst_rdata(inst_rdata),
    .inst_addr_ok(inst_addr_ok),
    .inst_data_ok(inst_data_ok),
    
    //data sram-like 
    .data_req(data_req),
    .data_wr(data_wr),
    .data_size(data_size),
    .data_addr(data_addr),
    .data_wdata(data_wdata),
    .data_rdata(data_rdata),
    .data_addr_ok(data_addr_ok),
    .data_data_ok(data_data_ok),

    //axi
    .arid      (arid      ),
	.araddr    (araddr    ),
	.arlen     (arlen     ),
	.arsize    (arsize    ),
	.arburst   (arburst   ),
	.arlock    (arlock    ),
	.arcache   (arcache   ),
	.arprot    (arprot    ),
	.arvalid   (arvalid   ),
	.arready   (arready   ),
					
	.rid       (rid       ),
	.rdata     (rdata     ),
	.rresp     (rresp     ),
	.rlast     (rlast     ),
	.rvalid    (rvalid    ),
	.rready    (rready    ),
				
	.awid      (awid      ),
	.awaddr    (awaddr    ),
	.awlen     (awlen     ),
	.awsize    (awsize    ),
	.awburst   (awburst   ),
	.awlock    (awlock    ),
	.awcache   (awcache   ),
	.awprot    (awprot    ),
	.awvalid   (awvalid   ),
	.awready   (awready   ),
		
	.wid       (wid       ),
	.wdata     (wdata     ),
	.wstrb     (wstrb     ),
	.wlast     (wlast     ),
	.wvalid    (wvalid    ),
	.wready    (wready    ),
		
	.bid       (bid       ),
	.bresp     (bresp     ),
	.bvalid    (bvalid    ),
	.bready    (bready    )
);

	//pc每级传递最好使用单独的旁路
	assign debug_wb_pc = pcW;  //cpu写回级的pc 32bit 变量名可能不一致
	assign debug_wb_rf_wen = {4{RegWriteW}};// cpu写回级的使能? 4bit扩展 变量名可能不一致 ?
	assign debug_wb_rf_wnum = WriteRegW;//cpu写回级的寄存器号? 5bit 变量名可能不一致
	assign debug_wb_rf_wdata = ResultW4;//cpu写回级的数据? 32bit 变量名可能不一致	


	mmu mm(.inst_vaddr(pcF),.inst_paddr(inst_paddr),.data_vaddr(dataaddr),
			.data_paddr(data_paddr),.no_dcache(no_dcache));
	mips mips(.clk(clkn),.rst(rst),.pcF(pcF),.instrF(instrF),.ReadData(ReadData2),
	.ALUResultM2(dataaddr),.WriteData(WriteData), .ResultW4(ResultW4),
	.RegWriteW(RegWriteW),
    .ALUControlE(ALUControlE),.WriteRegW(WriteRegW), 
	.pcW(pcW),.memenM(memenM),.adelM(adelM),.adesM(adesM),
	.bad_addrM(bad_addrM),.ext_int(ext_int),.excepttypeM(excepttypeM),
	.flushW(flushW),.stallM(stallM),.flushM(flushM),.fpcF(fpc),.stallF(stallF),.istall(i_stall_e),.dstall(d_stall));
	
	// ignore received data when except
	/*
	****
	*/
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
	//assign addr={dataaddr[31:2],2'b00};

endmodule