`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:35:19
// Design Name: 
// Module Name: MEM
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


`define BYTE 1'b1
`define WORD 1'b0

`define START 2'b00
`define PROCESS 2'b01
`define HOLD 2'b10

module MEM(
    input wire clk,
    input wire rst,
    input wire [31:0] pcES,
    input wire [31:0] exeResultES,
    input wire [31:0] memWdataES,
    input wire [2:0]  memCtrlsES,
    input wire [6:0]  wbCtrlsES,
    
    output reg [31:0] pcMS,
    output reg [31:0] memWdataMS,
    output reg [2:0] memCtrlsMS,
    output reg [31:0] memRdataMS,
    output reg [31:0] exeResultMS,  
    output reg [6:0]  wbCtrlsMS,
    
    output  reg memCeMS,
    output  reg memWeMS, 
    output  reg [3:0]  memBselMS, 
    output  reg [31:0] memVaddrMS,
    input wire [31:0]  memRdataBC, 
  
    input wire doneMSAccessBC,
 
    input wire  wbAllowIn,
    output reg  memBusy,
    output wire memAllowIn,
    input wire  exeBusy
);
     wire stall;
     wire flush;
     reg  dataValidReg;
     wire nextDataValidReg; 
     
     assign memAllowIn= (!memBusy) & wbAllowIn; 
     assign stall= ~memAllowIn; 
     assign flush =  exeBusy &  memAllowIn; 
     assign nextDataValidReg = !exeBusy & memAllowIn;
     always @(posedge clk,posedge rst) begin
        if(rst==1'b1) begin
            dataValidReg <= 1'b1;
        end else begin
            dataValidReg <= nextDataValidReg;
        end
     end

    always @(posedge clk,posedge rst) begin
        if(rst==1'b1) begin
             pcMS<=32'b0;
             exeResultMS<=32'b0;
             memWdataMS<=32'b0;  
             memCtrlsMS<=3'b0;  
             wbCtrlsMS<=7'b0;   
        end 
        else if(flush==1'b1) begin 
             pcMS<=32'b0;
             exeResultMS<=32'b0;
             memWdataMS<=32'b0;
             memCtrlsMS<=3'b0;     
             wbCtrlsMS<=7'b0;   
        end
        else if(stall==1'b1) begin
             pcMS<=pcMS;
             exeResultMS<=exeResultMS;
             memWdataMS<=memWdataMS;
             memCtrlsMS<=memCtrlsMS;
             wbCtrlsMS<=wbCtrlsMS;
        end
        else begin
             pcMS<=pcES;
             exeResultMS<=exeResultES;
             memWdataMS<=memWdataES;
             memCtrlsMS<=memCtrlsES;
             wbCtrlsMS<=wbCtrlsES;
        end
    end  
        
    reg [1:0]  state;
    reg [1:0]  nextState;  
    reg [31:0] rdataBuffer;
    reg [31:0] nextRdataBuffer;
   

    reg WoBSel;
    // ×´Ì¬»ú
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= `START;
            rdataBuffer    <= 32'b0;

        end else begin
            state <= nextState;
            rdataBuffer    <=  nextRdataBuffer;

        end
    end

    always @(*) begin
        nextState = state;
        nextRdataBuffer = rdataBuffer;
        memRdataMS=memRdataBC;      
        memVaddrMS = exeResultMS;
        { memCeMS,memWeMS,WoBSel}=memCtrlsMS;
        memBselMS=WoBSel == `WORD ? 4'hf: exeResultMS[1:0] == 2'd0 ? 4'h1 :
                                            exeResultMS[1:0] == 2'd1 ? 4'h2: 
                                            exeResultMS[1:0] == 2'd2 ? 4'h4: 
                                            exeResultMS[1:0] == 2'd3 ? 4'h8: 4'h0;
        
         memBusy=1'b0; 
       
         case (state)
            `START: begin
                    if(dataValidReg) begin
                         {nextState,memBusy} = memCeMS ? {`PROCESS, 1'b1} : {`START,1'b0};
                    end
                    else begin
                       { memCeMS,memWeMS,WoBSel}=3'b0;
                        memBusy = 1'b0;
                        nextState = `START;              
                    end
             end
            `PROCESS: begin      
                            
                    if (doneMSAccessBC==1'b1) begin                  
                           memBusy = 1'b0;                            
                           if (wbAllowIn) begin                        
                               nextState = `START;   
                           end 
                            else begin
                               nextRdataBuffer=memRdataBC;
                               nextState = `HOLD;     
                           end
                    end else begin                         
                            memBusy = 1'b1;
                            nextState = `PROCESS;
                    end
             end
            `HOLD: begin          
                 memBusy = 1'b0;
                 memRdataMS = rdataBuffer;
                  { memCeMS,memWeMS,WoBSel}=3'b0;
                  memVaddrMS=32'b0;
                    
                 if (wbAllowIn) begin
                     nextState = `START;   
                 end 
                 else begin
                     nextState = `HOLD; 
                 end                 
             end
             default: begin
             
             end
        endcase
    end
    
endmodule