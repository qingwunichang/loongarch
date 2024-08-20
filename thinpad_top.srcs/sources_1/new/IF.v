`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:26:14
// Design Name: 
// Module Name: IF
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

`define START 2'b00
`define PROCESS 2'b01
`define HOLD 2'b10
module IF(
    input wire clk,
    input wire rst,
    output reg [31:0] pcFS,
    output reg [31:0] instrFS,
    
    output reg [31:0] nextPc,
    input wire [31:0] instrIC,
    input wire hitIC,
    
    input wire [31:0] branchAddrBTB,
    input wire branchValidBTB,
    input wire [31:0] predPcBTB,
    input wire predValidBTB,
       
    output  reg ifCeFS, 
    output  reg ifWeFS, 
    output  reg [3:0]  ifBselFS, 
    output  reg [31:0] ifVaddrFS,
    input   wire [31:0] ifRdataBC, 
    output  reg [31:0] ifWdataFS, //32'b0
 
    input   wire doneFSAccessBC,
     
    input wire idAllowIn,
    output reg ifBusy

 );
    
    wire stall;
    assign ifAllowIn= (!ifBusy) & idAllowIn; 
    assign stall=  !ifAllowIn; 

    reg branchAddrBufferValid;
    reg [31:0] branchAddrBuffer;
    wire Ce= rst==1'b1 ? 1'b0 : 1'b1;
    wire We=1'b0;
    reg[31:0] pc;
    
    always @ (posedge clk,posedge rst) begin
        if(rst==1'b1) begin
            pc<=32'h80000000;
            branchAddrBufferValid<=1'b0;
            branchAddrBuffer<=32'h00000000;
        end
        else begin
            pc<=nextPc;
            if(branchValidBTB ==1'b1 & stall==1'b1)begin
                branchAddrBufferValid<=1'b1;
                branchAddrBuffer<=branchAddrBTB;            
            end            
            else if (stall==1'b0) begin
                branchAddrBufferValid<=1'b0; 
                branchAddrBuffer<=32'h00000000;        
            end
            else begin
                branchAddrBufferValid<=branchAddrBufferValid;
                branchAddrBuffer<=branchAddrBuffer;
            end
        end
    end
    
    always @ (*) begin
        if(rst==1'b1) begin
            nextPc = 32'h80000000;
        end
        else if(stall==1'b1) begin
            nextPc=pc;
        end
        else if(stall==1'b0 & branchAddrBufferValid==1'b1)begin
            nextPc=branchAddrBuffer;
        end
        else if( stall==1'b0  & branchAddrBufferValid==1'b0 & branchValidBTB==1'b1) begin
            nextPc= branchAddrBTB;
         end 
         else if(stall==1'b0 & predValidBTB) begin
            nextPc=predPcBTB;
         end
         else begin
            nextPc=pc+4;
         end
    end
    reg [1:0]  state;
    reg [1:0]  nextState;  
    reg [31:0] rdataBuffer;
    reg [31:0] nextRdataBuffer;
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
            instrFS= (hitIC ? instrIC : ifRdataBC) & {32{!branchAddrBufferValid}};
            pcFS =pc  & {32{!branchAddrBufferValid}};
            ifCeFS= Ce && (!hitIC);  
            ifWeFS= We; 
            ifBusy=1'b0; 
            ifBselFS=4'b1111;  
            ifVaddrFS=pc; 
            ifWdataFS=32'b0; 
            case (state)
                `START: begin
                             {nextState,ifBusy} = ifCeFS ? {`PROCESS, 1'b1} : {`START,1'b0};
                 end
                `PROCESS: begin                             
                        if (doneFSAccessBC==1'b1) begin                  
                               ifBusy = 1'b0;                            
                               if (idAllowIn) begin                        
                                   nextState = `START;   
                               end 
                                else begin
                                   nextRdataBuffer=ifRdataBC;
                                   nextState = `HOLD;     
                               end
                        end else begin                         
                                ifBusy = 1'b1;
                                nextState = `PROCESS;
                        end
                 end
                `HOLD: begin          
                     ifBusy = 1'b0;
                     instrFS=  rdataBuffer & {32{!branchAddrBufferValid}};
                     ifCeFS=1'b0;         
                     if (ifAllowIn) begin
                         nextState = `START;   
                     end 
                     else begin
                         nextState = `HOLD; 
                     end                 
                 end
            endcase
      end


endmodule
