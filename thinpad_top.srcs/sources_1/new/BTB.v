`timescale 1ns / 1ps

module BTB(
    input wire clk,
    input wire rst,
    input wire [31:0] pcFS,

    input wire [31:0] pcDS,
    input wire [31:0] pcES, 

    input wire [31:0] branchAddrES,
    input wire branchFlagES,
    input wire isBranchInstrES,
    output wire [31:0] predPcBTB,
    output reg branchValidBTB,
    output reg [31:0] branchAddrBTB,
    output wire branchFlushBTB,
   output wire predValidBTB
);

    // 定义BTB表项结构
    reg [63:0] BTBTable[3:0]; // 2张4项，每项64位，高32位存指令，低32位存预测的下一地址   
    // 写使能信号
    reg writeEnable;
    reg [1:0] writeItemIndex;
    reg [63:0] writeItemData;

    reg [3:0] matchFlagIF;
    reg [3:0] matchFlagEXE;
    
    // 提取低位索引
    reg [1:0] ifItemIndex ;
    reg ifItemExist;
    reg [1:0] exeItemIndex;
    reg exeItemExist;
    integer i;
    always @(*)begin
        for (i = 0; i < 4; i = i + 1) begin
              matchFlagIF[i] = BTBTable[i][63:32] == pcFS;
              matchFlagEXE[i] = BTBTable[i][63:32] == pcES;
        end  
        ifItemExist=1'b1;
        exeItemExist='b1;
        casez(matchFlagIF) 
           4'b???1: ifItemIndex=2'd0;
           4'b??10: ifItemIndex=2'd1;
           4'b?100: ifItemIndex=2'd2;
           4'b1000: ifItemIndex=2'd3;
           default: begin
                ifItemIndex=2'd0; 
                ifItemExist=1'b0;  
           end
        endcase
         casez(matchFlagEXE) 
           4'b???1: exeItemIndex=2'd0;
           4'b??10: exeItemIndex=2'd1;
           4'b?100: exeItemIndex=2'd2;
           4'b1000: exeItemIndex=2'd3;
           default: begin
                exeItemIndex=2'd0;  
                exeItemExist='b0; 
           end
        endcase
    end

    // 用于IF异步读取BTB表内容
   reg [31:0] ifItemPcBTB;
   reg [31:0] ifItemPcpredBTB;
   reg [31:0] exeItemPcBTB;
   reg [31:0] exeItemPcpredBTB;
      
    always @(*) begin
        if (writeEnable && (writeItemIndex == ifItemIndex) && ifItemExist) begin
            {ifItemPcBTB, ifItemPcpredBTB} = writeItemData; // 写地址和读地址一样，直接读取写的数据
        end 
        else if (ifItemExist) begin
            {ifItemPcBTB, ifItemPcpredBTB} = BTBTable[ifItemIndex];    
        end 
        else begin    
            {ifItemPcBTB, ifItemPcpredBTB} =64'b0;  
        end
        
        if (exeItemExist) begin
            {exeItemPcBTB, exeItemPcpredBTB} = BTBTable[exeItemIndex];    
        end 
        else begin    
            {exeItemPcBTB, exeItemPcpredBTB} =64'b0;  
        end        
    end
    assign predPcBTB = ifItemPcpredBTB;
    assign predValidBTB = ifItemExist;
    

    // 判断条件

    wire condA = isBranchInstrES && ( pcDS != 32'b0) && (exeItemExist && exeItemPcpredBTB==pcDS) &&(pcDS == branchAddrES && branchFlagES == 1'b1);
    wire condB = isBranchInstrES && ( pcDS != 32'b0) && (exeItemExist && exeItemPcpredBTB==pcDS) && (pcDS  == (pcES+4) && branchFlagES == 1'b0);
    wire condC = isBranchInstrES && ( pcDS != 32'b0) &&(pcDS != branchAddrES && branchFlagES == 1'b1);
    wire condD = isBranchInstrES && ( pcDS != 32'b0) &&(pcDS != (pcES+4) && branchFlagES == 1'b0);
    wire condE = isBranchInstrES &&  ( pcDS == 32'b0) && (exeItemExist && exeItemPcpredBTB==pcFS) && (pcFS == branchAddrES && branchFlagES == 1'b1);
    wire condF = isBranchInstrES &&  ( pcDS == 32'b0) && (exeItemExist && exeItemPcpredBTB==pcFS) &&(pcFS  == (pcES+4) && branchFlagES == 1'b0);
    wire condG = isBranchInstrES &&  ( pcDS == 32'b0) &&(pcFS != branchAddrES && branchFlagES == 1'b1);
    wire condH = isBranchInstrES &&  ( pcDS == 32'b0) &&(pcFS != (pcES+4) && branchFlagES == 1'b0);
  //计算write addr
    reg [1:0] queue [3:0];
    reg [1:0] nextQueue [3:0];
    always @(*) begin
       if(exeItemExist) begin
          writeItemIndex=exeItemIndex;
       end
       else begin
          writeItemIndex=queue[3];     
       end
    end
    // 组合逻辑来生成写使能、写地址和写数据
   
   
    integer k;
    always @(*) begin
        writeEnable = 1'b0;
        writeItemData = 64'b0;
        branchValidBTB = 1'b0;
        branchAddrBTB = 32'b0;
        for (k = 0; k< 4; k = k + 1) begin
           nextQueue[k]=queue[k] ;   
        end   
        if( condA|condE|condB | condF) begin
             writeEnable = 1'b1;
             writeItemData = {pcES, (condA|condE)? branchAddrES : (pcES+4)};
             if(queue[3]==exeItemIndex) begin
                {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[2],queue[1],queue[0],queue[3]};
             end
             else if(queue[2]==exeItemIndex) begin
               {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[3],queue[1],queue[0],queue[2]};
             end
             else if(queue[1]==exeItemIndex) begin
                {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[3],queue[2],queue[0],queue[1]};
             end       
             else if(queue[0]==exeItemIndex) begin
                {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[3],queue[2],queue[1],queue[0]};
             end         
        end 
        else if (condC | condG|condD | condH ) begin
              if((!exeItemExist)) begin
                  {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[2],queue[1],queue[0],queue[3]};
                   writeEnable = 1'b1;
                   writeItemData = {pcES,(condC|condG)? branchAddrES : (pcES+4)};  
              end 
              else if (exeItemExist) begin
                 if(queue[3]==exeItemIndex) begin
                      {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[2],queue[1],queue[0],queue[3]};
                 end
                 else if(queue[2]==exeItemIndex) begin
                      {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[3],queue[1],queue[0],queue[2]};
                 end
                 else if(queue[1]==exeItemIndex) begin
                      {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[3],queue[2],queue[0],queue[1]};
                 end       
                 else if(queue[0]==exeItemIndex) begin
                      {nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]}={queue[3],queue[2],queue[1],queue[0]};
                 end 
                 writeEnable = 1'b1;
                 writeItemData = {pcES,(condC|condG)? branchAddrES : (pcES+4)}; 
              end
              branchValidBTB = 1'b1;
              branchAddrBTB = (condC|condG)? branchAddrES : (pcES+4);
          
        
        end
       
    end
    
    // 写入BTB（同步写）
    integer j;
    always @(posedge clk or posedge rst) begin
        if (rst==1'b1) begin            
            for (j = 0; j < 4; j = j + 1) begin
                BTBTable[j] <= 64'b0;
                queue[j]<=j;
            end         
        end 
        else begin
            if (writeEnable) begin
                BTBTable[writeItemIndex] <= writeItemData;                   
            end
             {queue[3],queue[2],queue[1],queue[0]}<={nextQueue[3],nextQueue[2],nextQueue[1],nextQueue[0]};
        end
    end
    assign branchFlushBTB=branchValidBTB;
endmodule