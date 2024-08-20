`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:41:04
// Design Name: 
// Module Name: bridges
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

`define WAIT 2'b00
`define PMEM 2'b01
`define PIF  2'b10
`define PBOTH 2'B11
`define RstEnable 1'b1
module bridgesCtrl(
input  wire clk,
 input  wire rst,
 input  wire [31:0] ifWdataFS, 
 output wire [31:0] ifRdataBC, 
 input  wire ifCeFS,
 input  wire ifWeFS, 
 input  wire [3:0]  ifBselFS, 
 input  wire [31:0] ifVaddrFS,
 output wire doneFSAccessBC,
 //与cpu MEM段接口 
 input  wire [31:0] memWdataMS,
 output wire [31:0] memRdataBC,
input  wire memCeMS,
 input  wire memWeMS,
input  wire [3:0]  memBselMS,
 input  wire [31:0] memVaddrMS,
 output wire doneMSAccessBC,
 //与baseRamCtrl接口
 input  wire finish_f_baseRamCtrl,
 input wire allowIn_f_baseRamCtrl,
 input  wire [31:0] rdata_f_baseRamCtrl,
 output wire ce_t_baseRamCtrl,
 output wire we_t_baseRamCtrl,
 output wire [3:0] bsel_t_baseRamCtrl,
 output wire [19:0] paddr_t_baseRamCtrl,
 output wire [31:0] wdata_t_baseRamCtrl,
 
 //与extRamCtrl接口
 input  wire finish_f_extRamCtrl,
 input wire allowIn_f_extRamCtrl,
 input  wire [31:0] rdata_f_extRamCtrl,
 output wire ce_t_extRamCtrl,
 output wire we_t_extRamCtrl,
 output wire [3:0] bsel_t_extRamCtrl,
 output wire [19:0] paddr_t_extRamCtrl,
 output wire [31:0] wdata_t_extRamCtrl,
 //与uartCtrl接口
 input  wire finish_f_uartCtrl,
 input wire allowIn_f_uartCtrl,
 input  wire [7:0] rdata_f_uartCtrl,
 output wire ce_t_uartCtrl,
 output wire we_t_uartCtrl,
 output wire [31:0] vaddr_t_uartCtrl,
 output wire [7:0]  wdata_t_uartCtrl

    );

BridgesCtrlChiselToVerilog uut(
  .clock(clk),
  .reset(rst),
  .io_ceIF(ifCeFS),
  .io_weIF(ifWeFS),
  .io_bselIF(ifBselFS),
  .io_vaddrIF(ifVaddrFS),
  .io_wdataIF(),
  .io_rdataIF(ifRdataBC),
  .io_doneIF(doneFSAccessBC),

  
  .io_ceMEM(memCeMS),
  .io_weMEM(memWeMS),
  .io_bselMEM(memBselMS),
  .io_vaddrMEM(memVaddrMS),
  .io_wdataMEM(memWdataMS),
  .io_rdataMEM(memRdataBC),
  .io_doneMEM(doneMSAccessBC),

  
  .io_baseRam_rdata( rdata_f_baseRamCtrl),
  .io_baseRam_ce(ce_t_baseRamCtrl),
  .io_baseRam_we(we_t_baseRamCtrl),
  .io_baseRam_bsel(bsel_t_baseRamCtrl),
  .io_baseRam_paddr(paddr_t_baseRamCtrl),
  .io_baseRam_wdata(wdata_t_baseRamCtrl),
  .io_baseRam_done(finish_f_baseRamCtrl),
  .io_baseRam_allowIn(allowIn_f_baseRamCtrl),
  
  .io_extRam_rdata(rdata_f_extRamCtrl),
  .io_extRam_ce(ce_t_extRamCtrl),
  .io_extRam_we(we_t_extRamCtrl),
  .io_extRam_bsel(bsel_t_extRamCtrl),
  .io_extRam_paddr(paddr_t_extRamCtrl),
  .io_extRam_wdata(wdata_t_extRamCtrl),
  .io_extRam_done(finish_f_extRamCtrl),
  .io_extRam_allowIn(allowIn_f_extRamCtrl),
  
  .io_uart_rdata(rdata_f_uartCtrl),
  .io_uart_ce(ce_t_uartCtrl),
  .io_uart_we(we_t_uartCtrl),
  .io_uart_vaddr(vaddr_t_uartCtrl),
  .io_uart_wdata(wdata_t_uartCtrl),
  .io_uart_done(finish_f_uartCtrl),
  .io_uart_allowIn(allowIn_f_uartCtrl)
);




/*
reg[1:0] state_ff;
wire [1:0] next_state;
wire [31:0] rdata_t_bridgeCtrl_IF;

assign ifRdataBC = rdata_t_bridgeCtrl_IF;
wire [31:0] rdata_t_bridgeCtrl_MEM;
assign memRdataBC=rdata_t_bridgeCtrl_MEM;


wire [3:0] next_sd;
wire start_bif;
wire start_bmem;
wire brc_ce_IF,erc_ce_IF;
wire brc_ce_MEM,erc_ce_MEM,urc_ce_MEM;
wire rescol;
wire [1:0] ces;
wire ce_if;
wire ce_mem;
wire [21:0] combres;


always @(posedge clk,posedge rst) begin
    if(rst==1'b1) begin
        state_ff<=`WAIT;
    end
    else begin   
        state_ff<=next_state;   
    end
end


assign ce_if=ifCeFS ;
assign ce_mem=memCeMS;//(memCeMS && memWeMS==1'b1) || (memCeMS && memWeMS==1'b0 && (!dcache_hit));
assign ces={ce_if,ce_mem};


assign combres[2]=ces==2'b00 && state_ff==`WAIT;
assign combres[3]=ces==2'b01 && state_ff==`WAIT;
assign combres[4]=ces==2'b10 && state_ff==`WAIT; 
assign combres[5]=ces==2'b11 && rescol==1'b0 && state_ff==`WAIT;
assign combres[6]=ces==2'b11 && rescol==1'b1 && state_ff==`WAIT;
assign combres[8]=ces==2'b01 && state_ff==`PMEM;
assign combres[10]=ces==2'b11 && rescol==1'b1 &&  state_ff==`PMEM;
assign combres[14]=ces==2'b11 && rescol==1'b0 && state_ff==`PBOTH ; 
assign combres[18]=ces==2'b10 && state_ff==`PIF;
assign combres[19]=ces==2'b11 && rescol==1'b0 && state_ff==`PIF;
assign combres[20]=ces==2'b11 && rescol==1'b1 && state_ff==`PIF;

assign next_sd[0]   = combres[2] | combres[8] | combres[10] | combres[14] | combres[18] | combres[19] | combres[20]; 
assign next_sd[1]   = combres[3] | combres[6]  ;
assign next_sd[2]   = combres[4]  ; 
assign next_sd[3]   = combres[5] ; 

assign next_state = next_sd == 4'b0001 ? `WAIT :
                    next_sd == 4'b0010 ? `PMEM :
                    next_sd == 4'b0100 ? `PIF  :
                    next_sd == 4'b1000 ? `PBOTH : `WAIT; 

//assign stallFSBC=(combres[4]  | combres[5]  | combres[6] |combres[19] |combres[20] | combres[10] ) ;
//assign stallMSBC=combres[3] | combres[5]  | combres[6] |combres[19] |combres[20] ;
assign start_bif=( !rescol) & ce_if & (state_ff==`WAIT);// || state_ff==`PBOTH ||state_ff==`PIF  );
assign start_bmem= ce_mem & (state_ff==`WAIT);//|| state_ff==`PBOTH ||state_ff==`PMEM);
assign doneFSAccessBC=(combres[14]  | combres[18]);//(state_ff==`PBOTH ||state_ff==`PIF );
assign doneMSAccessBC=combres[8]  | combres[10] | combres[14] ;//(state_ff==`PBOTH ||state_ff==`PMEM );

assign {brc_ce_IF,erc_ce_IF}= {ce_if,ce_if} 
                               & { (!ifVaddrFS[27]) & (!ifVaddrFS[22]) ,
                                   (!ifVaddrFS[27]) & (ifVaddrFS[22])};     
assign {brc_ce_MEM,erc_ce_MEM,urc_ce_MEM} = {ce_mem,ce_mem,ce_mem} 
                                  &{  (!memVaddrMS[27]) & (!memVaddrMS[22]) ,
                                   (!memVaddrMS[27]) & (memVaddrMS[22]),
                                  memVaddrMS[27]==1'b1}; 

assign rescol=(!memVaddrMS[27]) & (!memVaddrMS[22]) & ce_mem  & ce_if;
assign ce_t_uartCtrl= start_bmem & urc_ce_MEM;
assign we_t_uartCtrl= memWeMS;
assign  wdata_t_uartCtrl= memWdataMS[7:0];
assign vaddr_t_uartCtrl =memVaddrMS; 
assign ce_t_baseRamCtrl=  (!rescol && ce_if) ? start_bif & brc_ce_IF : start_bmem & brc_ce_MEM;
assign we_t_baseRamCtrl=  (!rescol && ce_if) ? ifWeFS : memWeMS;
assign bsel_t_baseRamCtrl= (!rescol && ce_if) ? ifBselFS : memBselMS ;
assign paddr_t_baseRamCtrl= (!rescol && ce_if)  ? ifVaddrFS[21:2] :memVaddrMS[21:2] ;
assign wdata_t_baseRamCtrl= (!rescol && ce_if) ? ifWdataFS : memWdataMS ;

assign ce_t_extRamCtrl= start_bmem & erc_ce_MEM ;
assign we_t_extRamCtrl=memWeMS ;
assign bsel_t_extRamCtrl= memBselMS;
assign paddr_t_extRamCtrl= memVaddrMS[21:2];
assign wdata_t_extRamCtrl= memWdataMS ;
assign rdata_t_bridgeCtrl_IF= ( brc_ce_IF) ? rdata_f_baseRamCtrl: 
                   ( erc_ce_IF) ? rdata_f_extRamCtrl:32'b0;
assign rdata_t_bridgeCtrl_MEM= ( brc_ce_MEM) ? rdata_f_baseRamCtrl: 
                   ( erc_ce_MEM) ? rdata_f_extRamCtrl:
                   (urc_ce_MEM) ? 
                    (rdata_f_uartCtrl[7]==1'b0 ? {{24{1'b0}},rdata_f_uartCtrl} : {{24{1'b1}},rdata_f_uartCtrl} ):
                   32'b0;
*/

endmodule
