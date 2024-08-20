`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/14 22:36:14
// Design Name: 
// Module Name: test_exe
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


module test_exe;

    reg clk;
    reg rst;
    //ºÍDS
    reg [31:0] pcDS;
    reg [31:0] src1DataDS;
    reg [31:0] src2DataDS;
    reg [10:0] exeCtrlsDS;
    reg [31:0] regdata1DS;
    reg [31:0] regdata2DS;
    reg [5:0]  exeBranchInstrsDS;
    reg [31:0] instrDS;
    
    reg [31:0] memWdataDS;
    reg [2:0]  memCtrlsDS;
    
    reg [6:0]  weCtrlsDS;
    
    reg branchFlush;
    wire [31:0] pcES;
    wire [31:0] regdata1ES;
    wire [31:0] regdata2ES;
    wire [5:0]  exeBranchInstrsES;
    wire [31:0] instrES;
    
    wire [31:0] exeResultES;
    wire [31:0] memWdataES;
    wire [2:0]  memCtrlsES;
     
    wire [6:0]  wbCtrlsES;
  
    reg memAllowIn;
    wire exeBusy;
    wire exeAllowIn;
    reg idBusy;

EXE  exe_stage(
    .clk(clk),
    .rst(rst),
    .pcDS(pcDS),
    .src1DataDS(src1DataDS),
    .src2DataDS(src2DataDS), 
    .exeCtrlsDS(exeCtrlsDS), 
    .regdata1DS(regdata1DS),
    .regdata2DS(regdata2DS),
    .exeBranchInstrsDS(exeBranchInstrsDS), 
    .instrDS(instrDS),     
    .memCtrlsDS(memCtrlsDS), 
    .memWdataDS(memWdataDS), 
    .weCtrlsDS(weCtrlsDS),  
    .branchFlush( branchFlushBTB),
    .pcES(pcES),
    .regdata1ES(regdata1ES),
    .regdata2ES(regdata2ES),
    .exeBranchInstrsES(exeBranchInstrsES),
    .instrES(instrES),   
    .exeResultES(exeResultES),    
    .memCtrlsES(memCtrlsES), 
    .memWdataES(memWdataES), 
    .wbCtrlsES(wbCtrlsES),
    .memAllowIn(memAllowIn),
    .exeBusy(exeBusy),
    .exeAllowIn(exeAllowIn),
    .idBusy(idBusy)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock period = 10 time units
end

initial begin
    #5
    rst = 1'b1;
    pcDS = 32'b00000000000000000000000000000000;         
    src1DataDS = 32'h00000019;       
    src2DataDS = 32'h00000005;       
    exeCtrlsDS = 11'b10000000000;       
    regdata1DS = 32'h00000019;       
    regdata2DS = 32'h00000005;        
    exeBranchInstrsDS = 6'b000000;
    instrDS = 32'b000000001000000011010110001110;
    memWdataDS = 32'b00000000000000000000000000000000;
    memCtrlsDS = 3'b000;    
    weCtrlsDS = 7'b0000000;
    branchFlush = 1'b0;
    memAllowIn = 1'b1;
    idBusy = 1'b0;
    #5
    rst = 1'b0;
    pcDS = 32'b00000000000000000000000000000000;         
    src1DataDS = 32'h00000019;       
    src2DataDS = 32'h00000005;       
    exeCtrlsDS = 11'b10000000000;       
    regdata1DS = 32'h00000019;       
    regdata2DS = 32'h00000005;        
    exeBranchInstrsDS = 6'b000000;
    instrDS = 32'b000000001000000011010110001110;
    memWdataDS = 32'b00000000000000000000000000000000;
    memCtrlsDS = 3'b000;    
    weCtrlsDS = 7'b0000000;
    branchFlush = 1'b0;
    memAllowIn = 1'b1;
    idBusy = 1'b0;
end
endmodule
