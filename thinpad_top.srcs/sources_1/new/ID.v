`timescale 1ns / 1ps


`define BRANCH_OP_JIRL 3'd0
`define BRANCH_OP_BGEU  3'd1
`define BRANCH_OP_B    3'd2
`define BRANCH_OP_BEQ  3'd3
`define BRANCH_OP_BNE  3'd4
`define BRANCH_OP_BL   3'd5



`define ALU_OP_ADD 4'd0
`define ALU_OP_SUB 4'd1
`define ALU_OP_OR  4'd2
`define ALU_OP_AND 4'd3
`define ALU_OP_XOR 4'd4
`define ALU_OP_SRL 4'd5
`define ALU_OP_SLL 4'd6
`define ALU_OP_SLT 4'd7
`define ALU_OP_SRA 4'd8
`define ALU_OP_MUL 4'd9
`define ALU_OP_DIV 4'd10

`define T_REG  2'b00
`define T_PC   2'b01
`define T_IMM  2'b10
`define T_NULL 2'b11
`define WB_ALU_DATA  1'b0
`define WB_MEM_DATA  1'b1
`define BYTE  1'b1
`define WORD  1'b0

module ID(
    input wire clk,
    input wire rst,
    input wire[31:0] pcFS,
    input wire[31:0] instrFS,
    output reg [31:0] pcDS,
    output reg [31:0] instrDS, 

    //与DS的信号
    output wire [31:0] src1DataDS,
    output wire [31:0] src2DataDS,
    output wire [10:0] exeCtrlsDS,
    output wire [31:0] regdata1DS,
    output wire [31:0] regdata2DS,
    output wire [5:0]  exeBranchInstrsDS,
    output wire [31:0] memWdataDS,
    output wire [2:0]  memCtrlsDS,
    output wire [6:0]  weCtrlsDS,

    //与ES的信号
    input wire [31:0] exeResultES,
    input wire [6:0]  wbCtrlsES,
    
    //与MS的信号
    input wire [31:0] exeResultMS,
    input wire [31:0] memRdataMS,
    input wire [6:0]  wbCtrlsMS,


    //与regfile之间的端口
    output wire [4:0] regRaddr1DS,
    input wire [31:0] rdata1RF,
    output wire [4:0] regRaddr2DS,
    input wire [31:0] rdata2RF,

    input wire branchFlush,
    input wire exeAllowIn,
    output wire idBusy,
    output wire idAllowIn,
    input wire ifBusy 
    );
     wire stall;
     wire flush;
     reg dataValidReg;
     wire nextDataValidReg;   
     assign idAllowIn= (!idBusy) & exeAllowIn; 
     assign stall= ~idAllowIn; 
     assign flush =  (ifBusy|branchFlush )  &&  idAllowIn; 
     assign nextDataValidReg= !ifBusy & idAllowIn;
    always @(posedge clk,posedge rst) begin
        if(rst==1'b1) begin
            dataValidReg<=1'b1;
        end else begin
            dataValidReg<=nextDataValidReg;
        end
     end
    always @(posedge clk,posedge rst) begin
        if(rst==1'b1) begin
            pcDS<=32'h00000000;
            instrDS<=32'b0;
        end
        else if(flush==1'b1) begin 
            pcDS<=32'h00000000;
            instrDS<=32'b0;
        end
        else if(stall==1'b1) begin
            pcDS<=pcDS;
            instrDS<=instrDS;
        end
        else begin
            pcDS<=pcFS;
            instrDS<=instrFS;
        end
    end  
    
    wire [4:0] rd   = instrDS[ 4: 0];
    wire [4:0] rj   = instrDS[ 9: 5];
    wire [4:0] rk   = instrDS[14:10];
    wire [11:0] i12  = instrDS[21:10];
    wire [13:0] i14  = instrDS[23:10];
    wire [19:0] i20  = instrDS[24: 5];
    wire [15:0] i16  = instrDS[25:10];
    wire [25:0] i26  = {instrDS[ 9: 0], instrDS[25:10]};
    wire [4:0] i5   =  instrDS[14:10];  
    // ALU Operations
    wire instrAddiW     = instrDS[31:22]==10'b0000_0010_10;         
    wire instrAddW      = instrDS[31:15]==17'b0000_0000_0001_0000_0;
    wire instrSubW      = instrDS[31:15]==17'b0000_0000_0001_0001_0;
    wire instrOr        = instrDS[31:15]==17'b0000_0000_0001_0101_0; 
    wire instrOri       = instrDS[31:22]==10'b0000_0011_10;           
    wire instrAnd       = instrDS[31:22]==10'b0000_0011_01;           
    wire instrAndi      = instrDS[31:15]==17'b0000_0000_0001_0100_1;  
    wire instrXor       = instrDS[31:15]==17'b0000_0000_0001_0101_1;  
    wire instrSrliW     = instrDS[31:15]==17'b0000_0000_0100_0100_1;  
    wire instrSlliW     = instrDS[31:15]==17'b0000_0000_0100_0000_1;  
    wire instrMulW      = instrDS[31:15]==17'b0000_0000_0001_1100_0;
    wire instrDivW      = instrDS[31:15]==17'b0000_0000_0010_0000_0;
    wire instrSlti      = instrDS[31:22]==10'b0000_0010_00;         
    wire instrSraiW     = instrDS[31:15]==17'b0000_0000_0100_1000_1;
    
    // Load/Store Operations
    wire instrStW       = instrDS[31:22]==10'b0010_1001_10;
    wire instrStB       = instrDS[31:22]==10'b0010_1001_00;
    wire instrLdW       = instrDS[31:22]==10'b0010_1000_10;
    wire instrLdB       = instrDS[31:22]==10'b0010_1000_00;
    
    // Branch Operations
    wire instrJirl      = instrDS[31:26]==6'b0100_11;
    wire instrB         = instrDS[31:26]==6'b0101_00;
    wire instrBeq       = instrDS[31:26]==6'b0101_10;
    wire instrBne       = instrDS[31:26]==6'b0101_11;
    wire instrBl        = instrDS[31:26]==6'b0101_01;
    wire instrBge       = instrDS[31:26]==6'b0110_01;
    wire instrBgeu      = instrDS[31:26]==6'b0110_11;
    
    // Other Operations
    wire instrLu12iW    = instrDS[31:25]==7'b0001_010;
    wire instrPcaddu12i = instrDS[31:25]==7'b0001_110;
    
    wire [24:0] csignals;
    assign csignals = 
        ({32{instrAddiW    }} & 25'b0010000001110010100000110) |
        ({32{instrAddW     }} & 25'b0000000001110000110000110) |
        ({32{instrSubW     }} & 25'b0000000010110000110000110) |
        ({32{instrLu12iW   }} & 25'b0110000001001110000000110) |
        ({32{instrPcaddu12i}} & 25'b0110000001000110000000110) |
        ({32{instrOr       }} & 25'b0000000011110000110000110) |
        ({32{instrOri      }} & 25'b0100000011100010100000110) |
        ({32{instrAnd      }} & 25'b0100000100100010100000110) |
        ({32{instrAndi     }} & 25'b0000000100110000110000110) |
        ({32{instrXor      }} & 25'b0000000101110000110000110) |
        ({32{instrSrliW    }} & 25'b1000000110100010100000110) |
        ({32{instrSlliW    }} & 25'b1000000111100010100000110) |
        ({32{instrJirl     }} & 25'b1011100001100110100000110) |
        ({32{instrB        }} & 25'b0000100000001111000000000) |
        ({32{instrBeq      }} & 25'b0000110000101111110000000) |
        ({32{instrBne      }} & 25'b0000010000101111110000000) |
        ({32{instrBl       }} & 25'b1011000001000110000001110) |
        ({32{instrStW      }} & 25'b0010000001100010111100000) |
        ({32{instrStB      }} & 25'b0010000001100010111110000) |
        ({32{instrLdW      }} & 25'b0010000001110010101000111) |
        ({32{instrLdB      }} & 25'b0010000001110010101010111) |
        ({32{instrMulW     }} & 25'b0000001010110000110000110) |
        ({32{instrDivW     }} & 25'b0000001011110000110000110) |
        ({32{instrSlti     }} & 25'b0010001000100010100000110) |
        ({32{instrSraiW    }} & 25'b1000001001100010100000110) |
        ({32{instrBgeu      }} & 25'b0001010000101111110000000);
    
    wire [2:0] imm = csignals[24:22];      
    wire [2:0] branch_op = csignals[21:19];
    wire [3:0] alu_op = csignals[18:15];   
    wire raddr1_f = csignals[14]; 
    wire raddr2_f  = csignals[13];
    wire [1:0] src1Type = csignals[12:11];
    wire [1:0] src2Type = csignals[10:9]; 
    wire use_raddr1 = csignals[8];    
    wire use_raddr2 = csignals[7];    
    wire memCeDS = csignals[6];    
    wire memWeDS = csignals[5];    
    wire WoBSelDS = csignals[4];
    wire [1:0]wb_reg = csignals[3:2];
    wire weWS = csignals[1];       
    wire wdataSelWS = csignals[0];
    //////生成src1和src2,以及相关信息
    assign regRaddr1DS = raddr1_f ? rj : 5'b0; 
    assign regRaddr2DS = raddr2_f ? rk: rd;   
    assign src1DataDS= src1Type==`T_REG ? regdata1DS:
                       src1Type==`T_PC  ? pcDS : 32'b0 ;    
                          
    wire [31:0] s32_i12 = i12[11] ? {{20{1'b1}},{i12}}:{{20{1'b0}},{i12}};
    wire [31:0] u32_i12 = {{20{1'b0}},i12}; 
    wire [31:0] s_i20_32= {i20,{12{1'b0}}};
    wire [31:0] u32_i5={{27{1'b0}},i5};
    wire [31:0] u_4=32'd4;
    wire [31:0] imm_src;
    assign imm_src=( imm == 3'b100 ) ? u32_i5 :         
                   ( imm == 3'b010 ) ? u32_i12 :        
                   ( imm == 3'b001 ) ? s32_i12 :        
                   ( imm == 3'b101 ) ? u_4:             
                   ( imm == 3'b011 ) ? s_i20_32 : 32'b0;
                   
    assign src2DataDS= src2Type==`T_REG ? regdata2DS:
                       src2Type==`T_IMM  ? imm_src : 32'b0 ;
                        
    wire [4:0] wregIdES;
    wire weES;
    wire wdataSelES;
    wire [4:0] wregIdMS;
    wire weMS;
    wire wdataSelMS;
    assign {wregIdES,weES,wdataSelES}= wbCtrlsES;
    assign {wregIdMS,weMS,wdataSelMS}= wbCtrlsMS;  
    
    assign regdata1DS=  (use_raddr1==1'b1)&&(regRaddr1DS==wregIdES)&&(weES==1'b1)&&(wdataSelES==`WB_ALU_DATA)? exeResultES:  
                        (use_raddr1==1'b1)&&(regRaddr1DS==wregIdMS)&&(weMS==1'b1)&&(wdataSelMS==`WB_ALU_DATA)? exeResultMS:
                        (use_raddr1==1'b1)&&(regRaddr1DS==wregIdMS)&&(weMS==1'b1)&&(wdataSelMS==`WB_MEM_DATA)? memRdataMS : rdata1RF;                              
    assign regdata2DS=  (use_raddr2==1'b1)&&(regRaddr2DS==wregIdES)&&(weES==1'b1)&&(wdataSelES==`WB_ALU_DATA)? exeResultES:  
                        (use_raddr2==1'b1)&&(regRaddr2DS==wregIdMS)&&(weMS==1'b1)&&(wdataSelMS==`WB_ALU_DATA)? exeResultMS:
                        (use_raddr2==1'b1)&&(regRaddr2DS==wregIdMS)&&(weMS==1'b1)&&(wdataSelMS==`WB_MEM_DATA)? memRdataMS : rdata2RF; 
    
    assign idBusy=(use_raddr1==1'b1)&&(regRaddr1DS==wregIdES)&&(weES==1'b1)&&(wdataSelES==`WB_MEM_DATA) ||
                  (use_raddr2==1'b1)&&(regRaddr2DS==wregIdES)&&(weES==1'b1)&&(wdataSelES==`WB_MEM_DATA);
       
    //////生成EXE段控制信号
    wire [10:0] alu_op_ctrls;
    assign alu_op_ctrls[`ALU_OP_ADD] = alu_op == 4'b0001; 
    assign alu_op_ctrls[`ALU_OP_SUB] = alu_op == 4'b0010; 
    assign alu_op_ctrls[`ALU_OP_OR ] = alu_op == 4'b0011; 
    assign alu_op_ctrls[`ALU_OP_AND] = alu_op == 4'b0100; 
    assign alu_op_ctrls[`ALU_OP_XOR] = alu_op == 4'b0101; 
    assign alu_op_ctrls[`ALU_OP_SRL] = alu_op == 4'b0110; 
    assign alu_op_ctrls[`ALU_OP_SLL] = alu_op == 4'b0111; 
    assign alu_op_ctrls[`ALU_OP_SLT] = alu_op == 4'b1000; 
    assign alu_op_ctrls[`ALU_OP_SRA] = alu_op == 4'b1001; 
    assign alu_op_ctrls[`ALU_OP_MUL] = alu_op == 4'b1010;
    assign alu_op_ctrls[`ALU_OP_DIV] = alu_op == 4'b1011;
    assign exeCtrlsDS={alu_op_ctrls};
    //////生成MEM段控制信号
    assign memCtrlsDS = {memCeDS,memWeDS,WoBSelDS};
    assign memWdataDS= ( memWeDS == 1'b1 ) ? regdata2DS: 32'b0;
    wire [32:0] tmp;
    assign tmp=src1DataDS+src1DataDS;
    assign mem_waddr = ( memWeDS == 1'b1 ) ? tmp[31:0] : 32'b0;
    
    //////生成WB段控制信号
    wire [4:0] wregIdWS;
    assign wregIdWS = ( wb_reg == 2'b01 ) ? rd:
                       ( wb_reg == 2'b11 ) ? 5'b00001 : 5'b0;
    assign weCtrlsDS={wregIdWS,weWS,wdataSelWS};
    
    wire [5:0] branch_op_ctrls;
    assign branch_op_ctrls[`BRANCH_OP_JIRL] = branch_op == 3'b110;
    assign branch_op_ctrls[`BRANCH_OP_BGEU ] = branch_op == 3'b101;
    assign branch_op_ctrls[`BRANCH_OP_B   ] = branch_op == 3'b010;
    assign branch_op_ctrls[`BRANCH_OP_BEQ ] = branch_op == 3'b011;
    assign branch_op_ctrls[`BRANCH_OP_BNE ] = branch_op == 3'b001;
    assign branch_op_ctrls[`BRANCH_OP_BL  ] = branch_op == 3'b100;
    assign exeBranchInstrsDS={branch_op_ctrls};

endmodule

