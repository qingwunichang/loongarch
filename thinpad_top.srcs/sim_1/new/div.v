`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/14 17:18:17
// Design Name: 
// Module Name: div
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

module div;

reg [10:0] exeCtrlsES;
reg [31:0] src1DataES;
reg [31:0] src2DataES;
wire [31:0] aluResult;

ALU alu_inst (
    .aluOps(exeCtrlsES),
    .aluSrc1Data(src1DataES),
    .aluSrc2Data(src2DataES),
    .aluResult(aluResult)
);

// Clock generation
initial begin
    exeCtrlsES = 11'b10000000000;
    src1DataES = 32'h00000019;
    src2DataES = 32'h00000005;
end

endmodule
