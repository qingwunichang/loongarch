`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/24 14:41:04
// Design Name: 
// Module Name: ram_ctrl
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


`define WAIT 2'b00
`define READ 2'b01
`define WRITE 2'b10

module ram_ctrl(
input wire clk,
input wire rst,
input wire ce_f_bridge,
input wire we_f_bridge,
input wire [3:0] bsel_f_bridge,
input wire [19:0] paddr_f_bridge,
input wire [31:0] wdata_f_bridge,
output wire [31:0] rdata_f_ramCtrl,
output wire finish_f_ramCtrl,
output reg allowIn_f_ramCtrl,

output wire ce_n_t_ram,
output wire oe_n_t_ram,
output wire we_n_t_ram,
output wire [3:0] bsel_n_t_ram,
output wire [19:0] paddr_t_ram,
inout wire[31:0] data_bus
    );
wire [31:0] in_data;
reg [31:0] out_data;
//inout信号作为输入信号
assign in_data = (oe_n_t_ram==1'b0) ?data_bus: 32'hz;
//inout信号作为输出信号
assign  data_bus = (we_n_t_ram==1'b0) ? out_data : 32'hz;


reg [31:0] rdata_f_ramCtrl_r;
reg finish_f_ramCtrl_r;
reg ce_t_ram_r;
reg oe_t_ram_r;
reg we_t_ram_r;
reg ce_n_t_ram_r,oe_n_t_ram_r,we_n_t_ram_r;


reg [1:0] state_ff; //`WAIT, `PMEM, `PIF
reg [1:0] next_state;
reg [3:0] next_bsel;
reg [3:0] bsel_ff;

always @(posedge clk or posedge rst) begin 
    if(rst==1'b1) begin 
        state_ff<=`WAIT; 
        bsel_ff<=4'b0;
    end
    else begin 
        state_ff<=next_state;
        bsel_ff<=next_bsel;
    end
end
  // Tri-state buffer control for data_bus
 reg [7:0] rdata_f_ramCtrl_8;
always @(*) begin
    out_data=32'b0;
    next_bsel=4'b0;
    allowIn_f_ramCtrl=1'b1;
    case(state_ff)
    `WAIT: begin
            finish_f_ramCtrl_r=1'b0;
            rdata_f_ramCtrl_r=32'b0;
            if(ce_f_bridge==1'b0) begin
                next_state=`WAIT;
                {ce_n_t_ram_r,oe_n_t_ram_r,we_n_t_ram_r}=3'b111; 
                      
            end
            else if(ce_f_bridge==1'b1 && we_f_bridge==1'b0) begin
                allowIn_f_ramCtrl=1'b0;
                next_state=`READ;
                {ce_n_t_ram_r,oe_n_t_ram_r,we_n_t_ram_r}=3'b001; 
                next_bsel=bsel_f_bridge;
            end
            else begin
                allowIn_f_ramCtrl=1'b0;
                next_state=`WRITE;
                out_data=wdata_f_bridge;
                {ce_n_t_ram_r,oe_n_t_ram_r,we_n_t_ram_r}=3'b010;  
                next_bsel=bsel_f_bridge; 
            end
        end
    `READ: begin
            allowIn_f_ramCtrl=1'b1;
            next_state=`WAIT;
            finish_f_ramCtrl_r=1'b1;
            if(bsel_ff==4'b0001||bsel_ff==4'b0010 ||bsel_ff==4'b0100 ||bsel_ff==4'b1000) begin
                        rdata_f_ramCtrl_8={8{bsel_ff[0]}} & in_data[7:0] |
                                          {8{bsel_ff[1]}}&in_data[15:8]  |
                                          {8{bsel_ff[2]}}&in_data[23:16] |
                                          {8{bsel_ff[3]}}&in_data[31:24];
                        rdata_f_ramCtrl_r=rdata_f_ramCtrl_8[7]==1'b1 ? {{24{1'b1}},rdata_f_ramCtrl_8} :{{24{1'b0}},rdata_f_ramCtrl_8};
              end
              else if(bsel_ff==4'b1111) begin
                 rdata_f_ramCtrl_r=in_data;
              end
              else begin
                  rdata_f_ramCtrl_r=32'b0;
              end
            {ce_n_t_ram_r,oe_n_t_ram_r,we_n_t_ram_r}=3'b101;
        end
    `WRITE: begin
            allowIn_f_ramCtrl=1'b1;
            next_state=`WAIT;
            finish_f_ramCtrl_r=1'b1;
            rdata_f_ramCtrl_r=32'b0;
            {ce_n_t_ram_r,oe_n_t_ram_r,we_n_t_ram_r}=3'b110;
        end
     default: begin
            allowIn_f_ramCtrl=1'b1;
            next_state=`WAIT;
            finish_f_ramCtrl_r=1'b0; 
            rdata_f_ramCtrl_r=32'b0; 
            {ce_n_t_ram_r,oe_n_t_ram_r,we_n_t_ram_r}=3'b111;  
        end
   endcase

end
assign rdata_f_ramCtrl=rdata_f_ramCtrl_r;
assign finish_f_ramCtrl=finish_f_ramCtrl_r;
assign ce_n_t_ram=ce_n_t_ram_r;
assign oe_n_t_ram=oe_n_t_ram_r;
assign we_n_t_ram=we_n_t_ram_r;
assign paddr_t_ram=paddr_f_bridge; 
assign bsel_n_t_ram=~bsel_f_bridge;


endmodule
