`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:27:33
// Design Name: 
// Module Name: icache
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
`define LSB_INDEX 2
`define MSB_INDEX 5
`define LSB_TAG `MSB_INDEX+1
`define MSB_TAG 21
`define INDEX_BITS `MSB_INDEX:`LSB_INDEX
`define TAG_BITS `MSB_TAG:`LSB_TAG
`define TAG_STORE_BITS (`MSB_TAG+32):(`LSB_TAG+32)
`define INDEX_TAG_BITS `MSB_TAG:`LSB_INDEX
`define INDEX_TAG_STORE_BITS (`MSB_TAG+32):(`LSB_INDEX+32)
`define Index_RANGE (`MSB_INDEX-2):(`LSB_INDEX-2)
module icache(
    input wire clk,
    input wire rst,
    input wire [31:0] nextPc,
    input  wire [31:0] ifVaddrFS,
    input wire [31:0] ifRdataBC, 
    input  wire [31:0] memVaddrMS,
    input  wire memCeMS,
    input  wire memWeMS,
    input wire doneFSAccessBC,
    output wire [31:0] instrIC,
    output wire hitIC
  );
     wire [`Index_RANGE] addra;
     wire [`Index_RANGE] addrb;
     wire [63:0] dina;
     wire [63:0] doutb;
     wire wea;
     wire weaMem;
     reg  [15:0] icacheFlag;
     reg  [15:0] nextIcacheFlag;
     always @ (posedge clk,posedge rst) begin
       if(rst) begin
         icacheFlag<=16'b0; //
       end 
       else begin
         icacheFlag<=nextIcacheFlag;
       end
     end
     always @(*) begin
       nextIcacheFlag=icacheFlag;
       if(rst) begin
            nextIcacheFlag=16'b0;//
       end
        else if (wea) begin
            nextIcacheFlag[ifVaddrFS[`INDEX_BITS]]=1'b1;
       end
     end
    blk_mem_gen_0 icahe_bram (
        .clka(clk), // IN STD_LOGIC;
        .wea(wea), // IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        .addra(addra), // IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        .dina(dina), //IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        .clkb(clk), // IN STD_LOGIC;
        .addrb(nextPc[`INDEX_BITS]), // IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        .doutb(doutb) // OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      );

    assign wea = doneFSAccessBC ;
    assign addra = ifVaddrFS[`INDEX_BITS];
    assign dina  = {ifVaddrFS[31:0],ifRdataBC};      
    assign hitIC= ( doutb[`TAG_STORE_BITS]==ifVaddrFS[`TAG_BITS]) & icacheFlag[ifVaddrFS[`INDEX_BITS]]==1'b1;
    assign instrIC= doutb[31:0];                 
endmodule
