`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:35:19
// Design Name: 
// Module Name: WB
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


module WB(
  input wire clk,
  input wire rst,
  input wire [31:0] pcMS,
  input wire [31:0] memRdataMS, 
  input wire [31:0] exeResultMS, 
  input wire [6:0]  wbCtrlsMS, 
  
  output reg [31:0] pcWS,
  output reg [4:0] wregIdWS,
  output reg [31:0] wregDataWS,
  output reg weWS,

  output wire wbAllowIn,
  input wire memBusy
);
    wire stall;
    wire flush;
    reg dataValidReg;
    wire nextDataValidReg; 
    
    assign wbAllowIn=1'b1;  
    assign stall=!wbAllowIn;
    assign flush= memBusy && wbAllowIn; 
    assign nextDataValidReg= !memBusy & wbAllowIn;
    
    always @(posedge clk,posedge rst) begin
        if(rst==1'b1) begin
             dataValidReg<=1'b1;
         end else begin
             dataValidReg<=nextDataValidReg;
         end
    end
    
    reg [6:0]  wbCtrlsWS;
    reg [31:0] memRdataWS;
    reg [31:0] exeResultWS; 
    reg wdataSelWS;
    
    always @(posedge clk,posedge rst) begin
        if(rst==1'b1) begin
              pcWS<=32'b0;
              memRdataWS<=32'b0;
              exeResultWS<=32'b0;
              wbCtrlsWS<=7'b0;
        end
        else if(flush==1'b1) begin    
              pcWS<=32'b0;
              memRdataWS<=32'b0;
              exeResultWS<=32'b0;
              wbCtrlsWS<=7'b0;      
        end
        else begin
               pcWS<=pcMS;
               memRdataWS<=memRdataMS;
               exeResultWS<=exeResultMS;
               wbCtrlsWS<=wbCtrlsMS;
        end
    end
    always @(*) begin
        if(dataValidReg) begin
            {wregIdWS,weWS,wdataSelWS}=wbCtrlsWS;
             wregDataWS =wdataSelWS ?  memRdataWS :exeResultWS ;
        end
        else begin
            {wregIdWS,weWS,wdataSelWS}={5'b0,1'b0,1'b0};
            wregDataWS=32'b0;
        end
    end   

endmodule
