`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:29:57
// Design Name: 
// Module Name: regfile
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
module regfile(
    input wire clk,
    input wire rst,
    input  wire [ 4:0] regRaddr1DS,
    output wire [31:0] rdata1RF,
    input  wire [ 4:0] regRaddr2DS,
    output wire [31:0] rdata2RF,
    input  wire       weWS,      
    input  wire [ 4:0] wregIdWS,
    input  wire [31:0] wregDataWS
);
    reg [31:0] regs [31:0];
    integer i;
    always @(posedge clk , posedge rst) begin
        if(rst==1'b1) begin
            for(i = 0; i < 32; i = i + 1) begin
                regs[i] <=32'b0;
            end  
        end
        else if (weWS && (wregIdWS!=5'b0)) begin 
                 regs[wregIdWS]<= wregDataWS;
        end
    end
    assign rdata1RF = ((regRaddr1DS == wregIdWS) && weWS) ? wregDataWS : regs[regRaddr1DS];
    assign rdata2RF = ((regRaddr2DS == wregIdWS) && weWS) ? wregDataWS : regs[regRaddr2DS];
endmodule
