`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:15:46
// Design Name: 
// Module Name: MyCpu
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


module MyCpu(
    input wire clk,
    input wire rst,
        //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共享
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire base_ram_ce_n,       //BaseRAM片选，低有效
    output wire base_ram_oe_n,       //BaseRAM读使能，低有效
    output wire base_ram_we_n,       //BaseRAM写使能，低有效
        //ExtRAM信号
    inout wire[31:0] ext_ram_data,  //ExtRAM数据
    output wire[19:0] ext_ram_addr, //ExtRAM地址
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire ext_ram_ce_n,       //ExtRAM片选，低有效
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有效
    output wire ext_ram_we_n,       //ExtRAM写使能，低有效

    //直连串口信号
    output wire txd,  //直连串口发送端
    input  wire rxd  //直连串口接收端
 );


wire [31:0] pcFS;
wire [31:0] nextPc;
wire [31:0] instrFS;
wire ifCeFS;
wire ifWeFS;
wire [3:0] ifBselFS;
wire [31:0] ifWdataFS;
wire [31:0] ifVaddrFS;
wire [31:0] rdata1RF;
wire [31:0] rdata2RF;
wire [31:0] instrIC;
wire hitIC;

wire [31:0] pcDS;
wire [31:0] instrDS;
wire [4:0] regRaddr1DS;
wire [4:0] regRaddr2DS;
wire [31:0] src1DataDS;
wire [31:0] src2DataDS;
wire [10:0] exeCtrlsDS;
wire [2:0] memCtrlsDS;
wire [31:0] memWdataDS;
wire [5:0] weCtrlsDS;
wire [31:0] regdata1DS;
wire [31:0] regdata2DS;
wire [5:0] exeBranchInstrsDS;

wire [31:0] pcES;
wire [31:0] instrES;
wire [31:0] exeResultES;
wire[31:0] memWdataES; 
wire [2:0] memCtrlsES; 
wire [6:0] wbCtrlsES;
wire [31:0] regdata1ES;
wire [31:0] regdata2ES;
wire [6:0] exeBranchInstrsES;
wire isBranchInstrES;
wire branchFlagES;
wire [31:0] branchAddrES;
wire [31:0] predPcBTB;
wire predValidBTB;
wire branchValidBTB;
wire [31:0]  branchAddrBTB; 
wire branchFlushBTB;

wire [31:0] pcMS;
wire[31:0] memWdataMS; 
wire [31:0] exeResultMS;
wire [2:0] memCtrlsMS;
wire [6:0] wbCtrlsMS;
wire memCeMS;
wire memWeMS;
wire [3:0] memBselMS;
wire [31:0] memVaddrMS;
wire [31:0] memRdataMS;

wire [31:0] pcWS;
wire [31:0] wregDataWS;
wire [4:0] wregIdWS;
wire weWS;


wire [31:0] memRdataBC;
wire [31:0] ifRdataBC;

wire doneFSAccessBC;
wire doneMSAccessBC;

wire finish_BRC_t_BC;
wire allowIn_BRC_t_BC;
wire [31:0] rdata_BRC_t_BC;
wire ce_BC_t_BRC;
wire we_BC_t_BRC;
wire [3:0] bsel_BC_t_BRC;
wire [19:0] paddr_BC_t_BRC;
wire [31:0] wdata_BC_t_BRC;

wire finish_ERC_t_BC;
wire allowIn_ERC_t_BC;
wire [31:0] rdata_ERC_t_BC;
wire ce_BC_t_ERC;
wire we_BC_t_ERC;
wire [3:0] bsel_BC_t_ERC;
wire [19:0] paddr_BC_t_ERC;
wire [31:0] wdata_BC_t_ERC;

wire finish_UC_t_BC;
wire allowIn_UC_t_BC;
wire [7:0] rdata_UC_t_BC;
wire ce_BC_t_UC;
wire we_BC_t_UC;
wire [31:0] vaddr_BC_t_UC;
wire [7:0] wdata_BC_t_UC;

wire ce_n_t_br,oe_n_t_br,we_n_t_br;
wire [3:0] bsel_n_t_br;
wire [19:0] paddr_t_br;
wire [31:0] data_bus_t_br; 

wire ifBusy;
wire idAllowIn;
wire idBusy;
wire exeAllowIn;
wire exeBusy;
wire memAllowIn;
wire memBusy;
wire wbAllowIn;



IF if_stage(
    .clk(clk),
    .rst(rst),
    .pcFS(pcFS),
    .instrFS(instrFS), 
    .nextPc(nextPc),
    .instrIC(instrIC),
    .hitIC(hitIC),  
    .branchAddrBTB(branchAddrBTB),
    .branchValidBTB(branchValidBTB),
    .predPcBTB(predPcBTB),
    .predValidBTB(predValidBTB),       
    .ifCeFS(ifCeFS), 
    .ifWeFS(ifWeFS), 
    .ifBselFS(ifBselFS), 
    .ifVaddrFS(ifVaddrFS),
    .ifRdataBC(ifRdataBC), 
    .ifWdataFS(ifWdataFS), 
  
    .doneFSAccessBC(doneFSAccessBC),    
    .idAllowIn(idAllowIn),
    .ifBusy(ifBusy)
 );

icache icache_unit(
    .clk(clk),
    .rst(rst),
    .nextPc(nextPc),
    .ifVaddrFS(ifVaddrFS),
    .ifRdataBC(ifRdataBC), 
    .memVaddrMS(memVaddrMS),
    .memCeMS(memCeMS),
    .memWeMS(memWeMS),
    .doneFSAccessBC(doneFSAccessBC),
    .instrIC(instrIC),
    .hitIC(hitIC)
    );   


    


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


regfile  regfile_unit(
    .clk(clk),
    .rst(rst),
    .regRaddr1DS(regRaddr1DS), 
    .rdata1RF(rdata1RF), 
    .regRaddr2DS(regRaddr2DS), 
    .rdata2RF(rdata2RF),
    .wregIdWS(wregIdWS), 
    .wregDataWS(wregDataWS),
    .weWS(weWS)      
);





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


branch branch_unit(
    .pcES(pcES),
    .instrES(instrES),
    .exeBranchInstrsES(exeBranchInstrsES),
    .regdata1ES(regdata1ES),
    .regdata2ES(regdata2ES),
    .branchFlagES(branchFlagES),
    .branchAddrES(branchAddrES),
    .isBranchInstrES(isBranchInstrES)
);  


BTB btb_unit(
    .clk(clk),
    .rst(rst),
    .pcFS(pcFS),
    .pcDS(pcDS),
    .pcES(pcES), 
    .branchAddrES(branchAddrES),
    .branchFlagES(branchFlagES),
    .isBranchInstrES(isBranchInstrES),
    .predPcBTB(predPcBTB),
    .branchValidBTB(branchValidBTB),
    .branchAddrBTB(branchAddrBTB),
    .branchFlushBTB(branchFlushBTB),
    .predValidBTB(predValidBTB)
);   
    
   


MEM mem_stage(
    .clk(clk),
    .rst(rst),
    .pcES(pcES),
    .exeResultES(exeResultES),
    .memWdataES(memWdataES),
    .memCtrlsES(memCtrlsES),
    .wbCtrlsES(wbCtrlsES),      
    .pcMS(pcMS),
    .memWdataMS(memWdataMS),
    .memCtrlsMS(memCtrlsMS),
    .memRdataMS(memRdataMS),
    .exeResultMS(exeResultMS),  
    .wbCtrlsMS(wbCtrlsMS),      
    .memCeMS(memCeMS),
    .memWeMS(memWeMS), 
    .memBselMS(memBselMS), 
    .memVaddrMS(memVaddrMS),
    .memRdataBC(memRdataBC), 
   
    .doneMSAccessBC(doneMSAccessBC),  
    .wbAllowIn(wbAllowIn),
    .memBusy(memBusy),
    .memAllowIn(memAllowIn),
    .exeBusy(exeBusy)
);   
     

 WB wb_stage(
     .clk(clk),
     .rst(rst),
     .pcMS(pcMS),
     .memRdataMS(memRdataMS),
     .exeResultMS(exeResultMS),
     .wbCtrlsMS(wbCtrlsMS),
     .pcWS(pcWS),
     .wregIdWS(wregIdWS),
     .wregDataWS(wregDataWS),
     .weWS(weWS),
     .wbAllowIn(wbAllowIn),
     .memBusy(memBusy)
);




bridgesCtrl bridges_ctrl_unit(
    .clk(clk),
    .rst(rst),
    .ifWdataFS(ifWdataFS),
    .ifRdataBC(ifRdataBC), 
    .ifCeFS(ifCeFS),
    .ifWeFS(ifWeFS), 
    .ifBselFS(ifBselFS), 
    .ifVaddrFS(ifVaddrFS),
  
    .doneFSAccessBC(doneFSAccessBC),
    .memWdataMS(memWdataMS),
    .memRdataBC(memRdataBC),
    .memCeMS(memCeMS),
    .memWeMS(memWeMS),
    .memBselMS(memBselMS),
    .memVaddrMS(memVaddrMS),
    .doneMSAccessBC(doneMSAccessBC),
    .finish_f_baseRamCtrl(finish_BRC_t_BC), 
     .allowIn_f_baseRamCtrl(allowIn_BRC_t_BC),
    .rdata_f_baseRamCtrl(rdata_BRC_t_BC),
    .ce_t_baseRamCtrl(ce_BC_t_BRC),
    .we_t_baseRamCtrl(we_BC_t_BRC),  
    .bsel_t_baseRamCtrl(bsel_BC_t_BRC),  
    .paddr_t_baseRamCtrl(paddr_BC_t_BRC),  
    .wdata_t_baseRamCtrl(wdata_BC_t_BRC),  
    .finish_f_extRamCtrl(finish_ERC_t_BC), 
    .allowIn_f_extRamCtrl(allowIn_ERC_t_BC),
    .rdata_f_extRamCtrl(rdata_ERC_t_BC),
    .ce_t_extRamCtrl(ce_BC_t_ERC), 
    .we_t_extRamCtrl(we_BC_t_ERC),  
    .bsel_t_extRamCtrl(bsel_BC_t_ERC),  
    .paddr_t_extRamCtrl(paddr_BC_t_ERC),  
    .wdata_t_extRamCtrl(wdata_BC_t_ERC),  
    .finish_f_uartCtrl(finish_UC_t_BC), 
    .allowIn_f_uartCtrl(allowIn_UC_t_BC),   
    .rdata_f_uartCtrl(rdata_UC_t_BC),  
    .ce_t_uartCtrl(ce_BC_t_UC),  
    .we_t_uartCtrl(we_BC_t_UC), 
    .vaddr_t_uartCtrl(vaddr_BC_t_UC),  
    .wdata_t_uartCtrl(wdata_BC_t_UC)  
);
 
ram_ctrl baseram_ctrl_unit(
    .clk(clk),
    .rst(rst),
    .ce_f_bridge(ce_BC_t_BRC),  
    .we_f_bridge(we_BC_t_BRC),  
    .bsel_f_bridge(bsel_BC_t_BRC), 
    .paddr_f_bridge(paddr_BC_t_BRC), 
    .wdata_f_bridge(wdata_BC_t_BRC), 
    .rdata_f_ramCtrl(rdata_BRC_t_BC), 
    .finish_f_ramCtrl(finish_BRC_t_BC), 
    .allowIn_f_ramCtrl(allowIn_BRC_t_BC),  
    .ce_n_t_ram(base_ram_ce_n), 
    .oe_n_t_ram(base_ram_oe_n), 
    .we_n_t_ram(base_ram_we_n), 
    .bsel_n_t_ram(base_ram_be_n), 
    .paddr_t_ram(base_ram_addr), 
    .data_bus(base_ram_data) 
);
     
ram_ctrl extram_ctrl_unit(
    .clk(clk),
    .rst(rst),
    .ce_f_bridge(ce_BC_t_ERC),  
    .we_f_bridge(we_BC_t_ERC),  
    .bsel_f_bridge(bsel_BC_t_ERC), 
    .paddr_f_bridge(paddr_BC_t_ERC), 
    .wdata_f_bridge(wdata_BC_t_ERC), 
    .rdata_f_ramCtrl(rdata_ERC_t_BC), 
    .finish_f_ramCtrl(finish_ERC_t_BC),  
    .allowIn_f_ramCtrl(allowIn_ERC_t_BC),  
    .ce_n_t_ram(ext_ram_ce_n),
    .oe_n_t_ram(ext_ram_oe_n),
    .we_n_t_ram(ext_ram_we_n), 
    .bsel_n_t_ram(ext_ram_be_n),
    .paddr_t_ram(ext_ram_addr), 
    .data_bus(ext_ram_data) 
);

uart_ctrl uart_ctrl_unit(
    .clk(clk),
    .rst(rst),
    .ce_f_bridge(ce_BC_t_UC),
    .we_f_bridge(we_BC_t_UC), 
    .vaddr_f_bridge(vaddr_BC_t_UC), 
    .wdata_f_bridge(wdata_BC_t_UC), 
    .rdata_t_bridge(rdata_UC_t_BC), 
    .finish_t_bridge(finish_UC_t_BC), 
    .allowIn_t_bridge(allowIn_UC_t_BC),  
    .rxd_f_pin(rxd), 
    .txd_t_pin(txd)    
);
endmodule
