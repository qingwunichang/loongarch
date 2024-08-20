`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 10:45:28
// Design Name: 
// Module Name: EXE
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

`define ALU_PROCESS 2'b00
`define MULT_PROCESS 2'b01
`define PROCESS 2'b11
`define HOLD 2'b10
module EXE(
    input wire clk,
    input wire rst,
    //ºÍDS
    input wire [31:0] pcDS,
    input wire [31:0] src1DataDS,
    input wire [31:0] src2DataDS,
    input wire [10:0] exeCtrlsDS,
    input wire [31:0] regdata1DS,
    input wire [31:0] regdata2DS,
    input wire [5:0]  exeBranchInstrsDS,
    input wire [31:0] instrDS,
    
    input wire [31:0] memWdataDS,
    input wire [2:0]  memCtrlsDS,
    
    input wire [6:0]  weCtrlsDS,
    
    input wire branchFlush,
    output reg [31:0] pcES,
    output reg [31:0] regdata1ES,
    output reg [31:0] regdata2ES,
    output reg [5:0]  exeBranchInstrsES,
    output reg [31:0] instrES,
    
    output reg [31:0] exeResultES,
    output reg [31:0] memWdataES,
    output reg [2:0]  memCtrlsES,
     
    output reg [6:0]  wbCtrlsES,
  
    input wire memAllowIn,
    output reg exeBusy,
    output wire exeAllowIn,
    input wire idBusy   
   
);

    wire stall;
    wire flush;
    reg dataValidReg;
    wire nextDataValidReg;
    assign exeAllowIn=( !exeBusy) & memAllowIn; 
    assign stall= !exeAllowIn; 
    assign flush =  (idBusy | branchFlush) &&  exeAllowIn ; 
    assign nextDataValidReg= !idBusy & exeAllowIn;
    
    always @(posedge clk,posedge rst) begin
        if(rst==1'b1) begin
            dataValidReg<=1'b1;
        end else begin
            dataValidReg<=nextDataValidReg;
        end
     end
     
    reg [10:0]  exeCtrlsES;
    reg [31:0] src1DataES;
    reg [31:0] src2DataES;  
    reg [1:0] state;
    reg [1:0] nextState;
    reg [2:0] mpCount;
    reg [2:0] nextmpCount;
    wire [31:0] aluResult;
    wire [31:0] mulResult;
    wire [63:0] divResult;
    reg [31:0] aluSrc1Reg;
    reg [31:0] aluSrc2Reg;
    reg [31:0] nextAluSrc1Reg;
    reg [31:0] nextAluSrc2Reg;
    reg [31:0] resultBuffer;
    reg [31:0] nextResultBuffer;
    wire opMul;
    wire opDiv;
    wire PV;

    assign opMul = exeCtrlsES[9]; 
    assign opDiv = exeCtrlsES[10];
    //BUFFER
    always @(posedge clk,posedge rst) begin
        if(rst==1'b1) begin 
            pcES<=32'b0;
            src1DataES<=32'b0;
            src2DataES<=32'b0;
            exeCtrlsES<=10'b0;
            regdata1ES<=32'b0;
            regdata2ES<=32'b0;
            exeBranchInstrsES<=6'b0;
            instrES<=32'b0;
            
            memCtrlsES<=3'b0;
            memWdataES<=32'b0;
            
            wbCtrlsES<=7'b0;
        end
            else if(flush==1'b1) begin 
            pcES<=32'b0;
            src1DataES<=32'b0;
            src2DataES<=32'b0;
            exeCtrlsES<=10'b0;
            regdata1ES<=32'b0;
            regdata2ES<=32'b0;
            exeBranchInstrsES<=6'b0;
            instrES<=32'b0;
            
            memCtrlsES<=3'b0;
            memWdataES<=32'b0;
            
            wbCtrlsES<=7'b0;         
        end
        else if(stall==1'b1) begin
            pcES<=pcES;
            src1DataES<=src1DataES;
            src2DataES<=src2DataES;
            exeCtrlsES<=exeCtrlsES;
            regdata1ES<=regdata1ES;
            regdata2ES<=regdata2ES;
            exeBranchInstrsES<=exeBranchInstrsES;
            instrES<=instrES;
            
            memCtrlsES<=memCtrlsES;
            memWdataES<=memWdataES;
            
            wbCtrlsES<=wbCtrlsES;
       end
        else begin
            pcES<=pcDS;
            src1DataES<=src1DataDS;
            src2DataES<=src2DataDS;
            exeCtrlsES<=exeCtrlsDS;
            regdata1ES<=regdata1DS;
            regdata2ES<=regdata2DS;
            exeBranchInstrsES<=exeBranchInstrsDS;
            instrES<=instrDS;
                                    
            memCtrlsES<=memCtrlsDS;
            memWdataES<=memWdataDS;
            
            wbCtrlsES<=weCtrlsDS;
        end
    end

    
    // ALUÊµÀý
    ALU alu_inst (
        .aluOps(exeCtrlsES[8:0]),
        .aluSrc1Data(src1DataES),
        .aluSrc2Data(src2DataES),
        .aluResult(aluResult)
    );

    // ³Ë·¨Æ÷ÊµÀý

    mult_gen_0 uut (
    .A(src1DataES), 
    .B(src2DataES), 
    .P(mulResult)
     );

    div_gen_0 dut (
    .aclk(clk),
    .s_axis_divisor_tvalid(opDiv),
    .s_axis_divisor_tdata(src2DataES),
    .s_axis_dividend_tvalid(opDiv),
    .s_axis_dividend_tdata(src1DataES),
    .m_axis_dout_tvalid(PV),   
    .m_axis_dout_tdata(divResult)
        );
    wire [31:0] quotient;
    wire [31:0] remainder;
    assign {quotient, remainder} = divResult;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= `PROCESS;
            mpCount <= 0;
            aluSrc1Reg<=32'b0;
            aluSrc2Reg<=32'b0;
            resultBuffer<=32'b0;
        end else begin
            state <= nextState;
            mpCount <= nextmpCount;
            aluSrc1Reg<=nextAluSrc1Reg;
            aluSrc2Reg<=nextAluSrc2Reg;
            resultBuffer<=nextResultBuffer;
        end
    end

 always @(*) begin
        nextState = state;
        exeBusy = 1'b0;
        nextAluSrc1Reg=aluSrc1Reg;
        nextAluSrc2Reg=aluSrc2Reg;
        exeResultES=32'b0;
        nextmpCount=3'b0;
        nextResultBuffer=resultBuffer;
        case (state)
            `PROCESS: begin
                 if(dataValidReg) begin
                      exeBusy = 1'b0;
                           if (memAllowIn) begin 
                               exeResultES = opMul ? mulResult : opDiv ? quotient : aluResult;
                               nextState = `PROCESS;
                           end else begin
                               nextResultBuffer=opMul ? mulResult : opDiv ? quotient : aluResult;
                               nextState = `HOLD;    
                           end
                      end
                 end
            `HOLD: begin          
                 exeBusy = 1'b0;
                 exeResultES = resultBuffer;
                 if (memAllowIn) begin
                     nextState = `PROCESS;   
                 end 
                 else begin
                     nextState = `HOLD; 
                 end                 
             end
        endcase
    end
/*


    mult_gen_0 uut (
    .CLK(clk), 
    .A(aluSrc1Reg), 
    .B(aluSrc2Reg), 
    .P(mulResult)
     );
    // ×´Ì¬×ªÒÆÂß¼­  
    always @(*) begin
        nextState = state;
        exeBusy = 1'b0;
        nextAluSrc1Reg=aluSrc1Reg;
        nextAluSrc2Reg=aluSrc2Reg;
        exeResultES=32'b0;
        nextmpCount=3'b0;
        nextResultBuffer=resultBuffer;
        case (state)
            `ALU_PROCESS: begin
                    if(dataValidReg) begin
                            if (opMul) begin
                                    nextmpCount =  3'b0;
                                    exeBusy = 1'b1;
                                    nextState = `MULT_PROCESS;
                                    nextAluSrc1Reg=src1DataES;
                                    nextAluSrc2Reg=src2DataES;
                                
                            end else begin
                                   nextmpCount =  3'b0;
                                   exeBusy = 1'b0;
                                   if (memAllowIn) begin 
                                        exeResultES = aluResult;
                                        nextState = `ALU_PROCESS;
                                    end else begin
                                        nextResultBuffer=aluResult;
                                        nextState = `HOLD;    
                                    end
                            end
                    end
             end
            `MULT_PROCESS: begin
                    exeResultES = mulResult;
                    if (mpCount ==3'd1) begin  
                            nextmpCount = 3'b0;                  
                            exeBusy = 1'b0;        
                            if (memAllowIn) begin
                                nextState = `ALU_PROCESS;   
                            end 
                            else begin
                                nextResultBuffer=mulResult;
                                nextState = `HOLD;     
                            end
                    end else begin
                            nextmpCount = mpCount + 1;
                            exeBusy = 1'b1;
                            nextState = `MULT_PROCESS;
                    end
             end
            `HOLD: begin          
                 nextmpCount = 3'b0;
                 exeBusy = 1'b0;
                 exeResultES = resultBuffer;
                 if (memAllowIn) begin
                     nextState = `ALU_PROCESS;   
                 end 
                 else begin
                     nextState = `HOLD; 
                 end                 
             end
        endcase
    end
    */
endmodule
