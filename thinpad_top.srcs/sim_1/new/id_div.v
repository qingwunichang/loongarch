`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/14 17:37:35
// Design Name: 
// Module Name: id_div
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


module id_div;

    reg clk;
    reg rst;
    reg [31:0] pcFS;
    reg [31:0] instrFS;
    wire [31:0] pcDS;
    wire [31:0] instrDS;
    
    //与DS的信号
    wire [31:0] src1DataDS;
    wire [31:0] src2DataDS;
    wire [10:0] exeCtrlsDS;
    wire [31:0] regdata1DS;
    wire [31:0] regdata2DS;
    wire [5:0]  exeBranchInstrsDS;
    wire [31:0] memWdataDS;
    wire [2:0]  memCtrlsDS;
    wire [6:0]  weCtrlsDS;
    
    //与ES的信号
    reg [31:0] exeResultES;
    reg [6:0]  wbCtrlsES;
    
    //与MS的信号
    reg [31:0] exeResultMS;
    reg [31:0] memRdataMS;
    reg [6:0]  wbCtrlsMS;
    
    
    //与regfile之间的端口
    wire [4:0] regRaddr1DS;
    reg [31:0] rdata1RF;
    wire [4:0] regRaddr2DS;
    reg [31:0] rdata2RF;
    
    reg branchFlush;
    reg exeAllowIn;
    wire idBusy;
    wire idAllowIn;
    reg ifBusy;
    
    ID id_stage(  
    .clk(clk),
    .rst(rst),
    .pcFS(pcFS),
    .instrFS(instrFS),
    .pcDS(pcDS),
    .instrDS(instrDS),  
    .src1DataDS(src1DataDS),
    .src2DataDS(src2DataDS),
    .exeCtrlsDS(exeCtrlsDS),
    .regdata1DS(regdata1DS),
    .regdata2DS(regdata2DS),
    .exeBranchInstrsDS(exeBranchInstrsDS),
    .memWdataDS(memWdataDS),
    .memCtrlsDS(memCtrlsDS),
    .weCtrlsDS(weCtrlsDS),  
    .exeResultES(exeResultES),
    .wbCtrlsES(wbCtrlsES), 
    .exeResultMS(exeResultMS),
    .memRdataMS(memRdataMS),
    .wbCtrlsMS(wbCtrlsMS),
    .regRaddr1DS(regRaddr1DS),
    .rdata1RF(rdata1RF),
    .regRaddr2DS(regRaddr2DS),
    .rdata2RF(rdata2RF), 
    .branchFlush(branchFlushBTB),
    .exeAllowIn(exeAllowIn),
    .idBusy(idBusy),
    .idAllowIn(idAllowIn),
    .ifBusy(ifBusy) 
);
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock period = 10 time units
end

initial begin
    
//    clk;
    rst = 1'b0;
    pcFS    = 32'b00000000000000000000000000000000;
    instrFS = 32'b000000001000000011010110001110;
    exeResultES = 32'b00000000000000000000000000000000;
    wbCtrlsES = 7'b0000000;
    exeResultMS = 32'b00000000000000000000000000000000;
    memRdataMS = 32'b00000000000000000000000000000000;
    wbCtrlsMS = 7'b0000000;
    rdata1RF = 32'h00000019;
    rdata2RF = 32'h00000005;
    branchFlush = 1'b0;
    exeAllowIn = 1'b1;
    ifBusy = 1'b0;
    #100;
    $stop;
end

endmodule
