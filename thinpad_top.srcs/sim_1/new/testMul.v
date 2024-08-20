`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 09:43:41
// Design Name: 
// Module Name: testMul
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


module testMul;

// Inputs
reg CLK;
reg [31:0] A;
reg [31:0] B;

// Outputs
wire [63:0] P;

// Instantiate the Unit Under Test (UUT)
mult_gen_0 uut (
    .CLK(CLK), 
    .A(A), 
    .B(B), 
    .P(P)
);

// Clock generation
initial begin
    CLK = 0;
    forever #5 CLK = ~CLK; // Clock period = 10 time units
end

// Stimulus process
initial begin
    // Initialize Inputs
    A = 0;
    B = 0;

    // Wait for global reset
    #100;

    // Apply test vectors
    A = 32'h00000002; B = 32'h00000003; // Test case 1: 2 * 3
    #10;
    A = 32'h0000000F; B = 32'h0000000F; // Test case 2: 15 * 15
    #10;
    A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; // Test case 3: -1 * -1 (in 2's complement)
    #10;
    A = 32'h80000000; B = 32'h00000002; // Test case 4: -2147483648 * 2 (in 2's complement)
    #10;
    
    // Additional test cases
    A = 32'h00000005; B = 32'h00000005; // Test case 5: 5 * 5
    #10;
    A = 32'h7FFFFFFF; B = 32'h00000002; // Test case 6: 2147483647 * 2 (max positive value)
    #10;

    // End simulation
    #100;
    $stop;
end



endmodule
