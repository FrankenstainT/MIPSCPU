`timescale 1ns / 1ps


module hazard(
	output wire stallF,
	input wire[4:0] rsD,rtD,
	input wire branchD,
	output reg[1:0] forwardaD,forwardbD,
	output wire stallD,
	input wire[4:0] rsE,rtE,
	input wire[4:0] writeregE,
	input wire regwriteE,
	input wire memtoregE,
	output reg[1:0] forwardaE,forwardbE,
	output wire flushE,
	input wire[4:0] writeregM,
	input wire regwriteM,
	input wire memtoregM,
	input wire[4:0] writeregW,
	input wire regwriteW,
	input hilo_writeE, hilo_writeM, hilo_writeW, hilo_readE,hilo_readM,hilo_readW,multE, multM, multW,
	output forwardHD,
	input stall_divE,
	output stallE,
	input div_signalE, div_signalM,div_signalW,jumpD,balE,balM,balW,jalE,jalM,jalW,jrD,
	output branchJrstallD,bjfromE,bjfromM,flushD,
	input pcsrcD,clk,rst,flush_except,
	output flushF,flushM,stallM,flushW,input eretD,balD,jalD,cp0weD,cp0weM,
	output forwardrdM,input[4:0] rtM,input memtoregW,is_mfc0E,output forwardcp0E,
	input[4:0]rdE,rdM,output flushpcE
    );
	wire lwstallD,flushedE,flushedM;
	// forwardaD,forwardbD
	always @(*) begin
		if(rst)begin
			forwardaD = 2'b00;
			forwardbD = 2'b00;
		end
		forwardaD = 2'b00;
		forwardbD = 2'b00;
		if(rsD!=0)begin
			if(rsD == writeregE & regwriteE & (balE|jalE)) begin// if E is ALU inst, then stall D
				forwardaD = 2'b01;
			end else if(rsD == writeregM & regwriteM) begin
				forwardaD = 2'b10;	
			end else if(rsD == writeregW & regwriteW) begin
				forwardaD = 2'b11;
			end
		end
		if(rtD!=0)begin
			if(rtD == writeregE & regwriteE & (balE|jalE)) begin
				forwardbD = 2'b01;
			end else if(rtD == writeregM & regwriteM) begin
				forwardbD = 2'b10;	
			end else if(rtD == writeregW & regwriteW) begin
				forwardbD = 2'b11;
			end
		end
	end
	// forwardaE,forwardbE
	always @(*) begin
		if(rst)begin
			forwardaE = 2'b00;
			forwardbE = 2'b00;
		end else begin// it's said to be wrong, so comment if(~stallE)
			forwardaE = 2'b00;
			forwardbE = 2'b00;	
			if(rsE != 0) begin
				if(rsE == writeregM & regwriteM) begin
					forwardaE = 2'b10;
				end else if(rsE == writeregW & regwriteW) begin
					forwardaE = 2'b01;	
				end
			end
			if(rtE != 0) begin
				if(rtE == writeregM & regwriteM) begin
					forwardbE = 2'b10;
				end else if(rtE == writeregW & regwriteW) begin
					forwardbE = 2'b01;
				end
			end
		end
	end
	// D stall due to lw before, no need to stall when D is mtc0, ignore other wrong stall from insts that don't read rsD,rtD 
	assign #1 lwstallD = memtoregE & (rtE == rsD | rtE == rtD ) & ~cp0weD;// no need to add stall for lw at M, it's dealt in branchJrstallD
	//wire bjfromE,bjfromM;
	//flopenr #(1) flushedDE(clk,rst,~stallE,flushD,flushedE); // for flushing delay slot, shielding forward from delay slot, not used
	//flopr #(1) flushedEM(clk,reset,flushedE,flushedM);// for flushing delay slot, shielding forward from delay slot, not used
	assign #1 bjfromE = regwriteE & (writeregE == rsD | writeregE == rtD) 
						& ~balE & ~jalE & writeregE!=5'b0;// & ~flushedM;
	assign #1 bjfromM = (memtoregM | hilo_readM) & (writeregM == rsD | writeregM == rtD) & writeregM!=5'b0;// deal with lw at M
	assign #1 branchJrstallD = (branchD|jrD) & ( bjfromE | bjfromM	);	// situation where D must stall due to branch or jr in D stage
	assign #1 flushF = flush_except;			
	assign #1 stallD = lwstallD | stall_divE | branchJrstallD;//  ; comment branch
	assign #1 flushD = flush_except|(eretD&~stallD);//flush delay slot after eret//(pcsrcD|jumpD)&~stallD;// flush instruction in delay slot, not used
	assign #1 stallF = stallD;
	assign #1 flushE = ((lwstallD | branchD & ~balD | jumpD & ~jalD | branchJrstallD) & ~stallE)|flush_except;// |jumpD added // comment  
	assign #1 flushpcE = ((lwstallD | branchJrstallD) & ~stallE) | flush_except;// for pc
	assign #1 stallE = stall_divE;//|lwstallD|branchJrstallD; // new, add |lwstallD|branchJrstallD, new, comment |lwstallD|branchJrstallD,
	assign #1 flushM = flush_except | stallE; // add stallE for regwrite not flow
	assign #1 stallM = stall_divE;
	assign #1 flushW = flush_except;
	assign forwardcp0E = is_mfc0E & cp0weM & (rdE==rdM);
	assign forwardrdM = cp0weM & memtoregW & (rtM==regwriteW);
	assign forwardHD = hilo_writeE | hilo_writeM | hilo_writeW | multE | multM | multW | 
			div_signalE | div_signalM | div_signalW;// new, forward hilo
endmodule
