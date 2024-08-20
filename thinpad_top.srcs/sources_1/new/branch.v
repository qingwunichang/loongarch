`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:34:26
// Design Name: 
// Module Name: branch
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

module branch(
input wire [31:0] pcES,
input wire [31:0] instrES,
input wire [5:0] exeBranchInstrsES,
input wire [31:0] regdata1ES,
input wire [31:0] regdata2ES,
output wire branchFlagES,
output wire [31:0] branchAddrES,
output wire isBranchInstrES
    );
    wire instr_jirl;
    wire instr_bge;
    wire instr_b;
    wire instr_beq;
    wire instr_bne;
    wire instr_bl;
    wire instr_bgeu;
    assign {instr_bl,instr_bne,instr_beq,instr_b,instr_bgeu,instr_jirl}=exeBranchInstrsES;
    assign isBranchInstrES= |exeBranchInstrsES;
    ////Ìø×ªÅÐ¶ÏÂß¼­
    wire [31:0] offs16_rj;
    wire [31:0] offs26_pc;
    wire [31:0] offs16_pc;
    wire [31:0] si16;
    wire [15:0] i16;
    wire [25:0] i26;
    assign i16  = instrES[25:10];
    assign i26  = {instrES[ 9: 0], instrES[25:10]};
    assign si16= i16[15]==1'b1 ? {{14{1'b1}},{i16},2'b0} : {{14{1'b0}}, {i16} , 2'b0};
    assign offs16_rj= si16+regdata1ES;
    wire [31:0] si26;
    assign si26= i26[25]==1'b1 ? {{4{1'b1}},{i26},2'b0} : {{4{1'b0}}, {i26} , 2'b0};
    assign offs26_pc= si26+pcES;
    assign offs16_pc=  si16+pcES;
    
    assign branchFlagES= ( instr_jirl & 1'b1 ) |
                    ( instr_bgeu &  (regdata1ES >= regdata2ES)) |
                    ( instr_b )& 1'b1 |
                    ( instr_beq )& (regdata1ES==regdata2ES) |
                    ( instr_bne )& (regdata1ES!=regdata2ES) |
                    ( instr_bl& 1'b1 ) ;
    assign branchAddrES= ( {32{instr_jirl}} & offs16_rj  ) | 
                    ( {32{instr_bgeu}} & offs16_pc  ) |
                    ( {32{instr_b}}    & offs26_pc  ) |
                    ( {32{instr_beq}}  & offs16_pc  ) |
                    ( {32{instr_bne}}  & offs16_pc  ) |
                    ( {32{instr_bl}}   & offs26_pc  ) ;

endmodule

