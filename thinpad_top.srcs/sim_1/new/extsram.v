`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/23 15:09:17
// Design Name: 
// Module Name: extsram
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


module extsram(
input wire clk,
input wire rst,
input wire ce_n,
input wire oe_n,
input wire we_n,
input wire [3:0] bsel_n,
input wire [19:0] addr,
inout wire [31:0] data_bus
    );
    
reg [31:0] regs[256:0];
integer i;
//inout信号作为输入信号
wire [31:0] in_data;
reg [31:0] out_data;
assign in_data =  (we_n==1'b0) ?data_bus: 32'hz;
//inout信号作为输出信号
assign  data_bus = (oe_n==1'b0) ? out_data : 32'hz;
//WRITE
always @(posedge clk , posedge rst) begin
    if(rst==1'b1) begin
      for(i = 0; i < 256; i = i + 1) begin
        regs[i] <= 32'h0;     
      end 
      out_data<=32'b0;   
    end
    else begin
        case ({ce_n,oe_n,we_n})
            3'b111,3'b110,3'b101,3'b100,3'b011,3'b000: begin
              out_data<=32'b0;    
            end
            3'b001:begin
                    if((bsel_n)==4'b1110||(bsel_n)==4'b1101 ||(bsel_n)==4'b1011 ||(bsel_n)==4'b0111||bsel_n==4'b0000) begin
                          out_data<=regs[addr[7:0]];
                    end
                    else begin
                          out_data<=32'b0;
                    end            
                end
            3'b010:begin
                 if(((bsel_n)==4'b1110||(bsel_n)==4'b1101 ||(bsel_n)==4'b1011 ||(bsel_n)==4'b0111)) begin
                    if((bsel_n)==4'b1110) regs[addr[7:0]][7:0]<=in_data[7:0];
                    else if((bsel_n)==4'b1101) regs[addr[7:0]][15:8]<=in_data[7:0];
                    else if((bsel_n)==4'b1011) regs[addr[7:0]][23:16]<=in_data[7:0];
                    else if ((bsel_n)==4'b0111) regs[addr[7:0]][31:24]<=in_data[7:0];
                 end
                 else  if(bsel_n==4'b0000) begin
                     regs[addr[7:0]]<=in_data;
                 end
                 else begin             
                 end
                 out_data<=32'b0;       
            end   
        endcase  
    end
 end
endmodule
