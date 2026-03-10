`timescale 1ns/1ps

module tb_systolic_4x4;

reg clk;
reg reset;

reg [7:0] a0,a1,a2,a3;
reg [7:0] b0,b1,b2,b3;

wire [15:0] c00,c01,c02,c03;
wire [15:0] c10,c11,c12,c13;
wire [15:0] c20,c21,c22,c23;
wire [15:0] c30,c31,c32,c33;
wire [31:0] global_skips;
wire [31:0] global_reuses;


// DUT
systolic_4x4 dut(
clk,reset,
a0,a1,a2,a3,
b0,b1,b2,b3,
c00,c01,c02,c03,
c10,c11,c12,c13,
c20,c21,c22,c23,
c30,c31,c32,c33,
global_skips,    // NEW
global_reuses
);


// clock
always #5 clk = ~clk;


initial begin

clk=0;
reset=1;

a0=0;a1=0;a2=0;a3=0;
b0=0;b1=0;b2=0;b3=0;

#20
reset=0;


// Example matrices

// A
// 1 2 3 4
// 5 6 7 8
// 2 1 3 2
// 4 2 1 3

// B
// 1 2 0 1
// 3 1 2 0
// 2 1 1 3
// 0 2 3 1

@(posedge clk)
a0=1; a1=0; a2=0; a3=0;
b0=1; b1=0; b2=0; b3=0;

@(posedge clk)
a0=2; a1=5; a2=0; a3=0;
b0=3; b1=2; b2=0; b3=0;

@(posedge clk)
a0=3; a1=6; a2=2; a3=0;
b0=2; b1=1; b2=0; b3=0;

@(posedge clk)
a0=4; a1=7; a2=1; a3=4;
b0=0; b1=1; b2=2; b3=1;

@(posedge clk)
a0=0; a1=8; a2=3; a3=2;
b0=0; b1=2; b2=1; b3=3;

@(posedge clk)
a0=0; a1=0; a2=2; a3=1;
b0=0; b1=0; b2=3; b3=1;

@(posedge clk)
a0=0; a1=0; a2=0; a3=3;
b0=0; b1=0; b2=0; b3=1;


// flush pipeline
repeat(20) @(posedge clk);
$display("A Matrix:");
$display("%d %d %d %d", 1, 2, 3, 4);
$display("%d %d %d %d", 5, 6, 7, 8);
$display("%d %d %d %d", 2, 1, 3, 2);
$display("%d %d %d %d", 4, 2, 1, 3);

$display("B Matrix:");
$display("%d %d %d %d", 1, 2, 0, 1);
$display("%d %d %d %d", 3, 1, 2, 0);
$display("%d %d %d %d", 2, 1, 1, 3);
$display("%d %d %d %d", 0, 2, 3, 1);


$display("Result Matrix:");
$display("%d %d %d %d",c00,c01,c02,c03);
$display("%d %d %d %d",c10,c11,c12,c13);
$display("%d %d %d %d",c20,c21,c22,c23);
$display("%d %d %d %d",c30,c31,c32,c33);

$display("-----------------------------------------");
$display("POWER EFFICIENCY REPORT");
$display("-----------------------------------------");
$display("Total Zero-Skips (Clock Gated) : %0d", global_skips);
$display("Total Temporal Reuses          : %0d", global_reuses);
$display("-----------------------------------------");

$finish;

end

endmodule