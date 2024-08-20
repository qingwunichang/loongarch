`timescale 1ns / 1ps

module ALU(
  input  wire [8:0] aluOps,
  input  wire [31:0] aluSrc1Data,
  input  wire [31:0] aluSrc2Data,
  output wire [31:0] aluResult
);
  
    wire opSra, opSlt, opSll, opSrl, opXor, opAnd, opOr, opSub, opAdd;
    assign {opSra, opSlt, opSll, opSrl, opXor, opAnd, opOr, opSub, opAdd} = aluOps;
    
    wire [31:0] addSubResult; 
    wire [31:0] orResult;
    wire [31:0] andResult;
    wire [31:0] xorResult;
    wire [31:0] srlResult; 
    wire [31:0] sllResult;
    wire [31:0] sltResult;
    wire [31:0] sltuResult;
    wire [31:0] sraResult;
    wire [31:0] divResult;
    
    // ADD, SUB result
    wire [31:0] adderA;
    wire [31:0] adderB;
    wire adderCin;
    wire [31:0] adderResult;
    wire adderCout;
     //
    assign adderA = aluSrc1Data;
    assign adderB = (opSub | opSlt) ? ~aluSrc2Data : aluSrc2Data;
    assign adderCin = (opSub | opSlt) ? 1'b1 : 1'b0;
    assign {adderCout, adderResult} = adderA + adderB + adderCin;
    assign addSubResult = adderResult;
    
    // SLTU result
    assign sltuResult[31:1] = 31'b0;
    assign sltuResult[0] = ~adderCout;
    // SLT result
    assign sltResult[0] = (aluSrc1Data[31] & ~aluSrc2Data[31]) | ((aluSrc1Data[31] ~^ aluSrc2Data[31]) & adderResult[31]);
    assign sltResult[31:1] = 31'b0;
    assign orResult = aluSrc1Data | aluSrc2Data;
    assign xorResult = aluSrc1Data ^ aluSrc2Data; 
    assign andResult = aluSrc1Data & aluSrc2Data;
    // SRL, SRA result
    wire [63:0] sr64Result;
    assign sr64Result = (opSra && aluSrc1Data[31]) ? {{32{1'b1}}, aluSrc1Data} >> aluSrc2Data[4:0] :
                                                     {{32{1'b0}}, aluSrc1Data} >> aluSrc2Data[4:0];
    assign srlResult = sr64Result[31:0];
    assign sraResult = sr64Result[31:0]; 
    // SLL result 
    assign sllResult = aluSrc1Data << aluSrc2Data[4:0]; 
    //  DIV result
    assign aluResult = ({32{opAdd | opSub}} & addSubResult)
                     | ({32{opAnd}} & andResult)
                     | ({32{opOr}} & orResult)
                     | ({32{opXor}} & xorResult)
                     | ({32{opSlt}} & sltResult)
                     | ({32{opSll}} & sllResult)
                     | ({32{opSrl | opSra}} & srlResult);

endmodule
