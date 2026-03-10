module systolic_2x2 (
    input clk,
    input reset,

    input [7:0] a0,
    input [7:0] a1,

    input [7:0] b0,
    input [7:0] b1,

    output [15:0] c00,
    output [15:0] c01,
    output [15:0] c10,
    output [15:0] c11
);

wire [7:0] a00_to_01;
wire [7:0] a10_to_11;

wire [7:0] b00_to_10;
wire [7:0] b01_to_11;


// PE00
pe PE00 (
    .clk(clk),
    .reset(reset),
    .a_in(a0),
    .b_in(b0),
    .a_out(a00_to_01),
    .b_out(b00_to_10),
    .acc(c00)
);


// PE01
pe PE01 (
    .clk(clk),
    .reset(reset),
    .a_in(a00_to_01),
    .b_in(b1),
    .a_out(),
    .b_out(b01_to_11),
    .acc(c01)
);


// PE10
pe PE10 (
    .clk(clk),
    .reset(reset),
    .a_in(a1),
    .b_in(b00_to_10),
    .a_out(a10_to_11),
    .b_out(),
    .acc(c10)
);


// PE11
pe PE11 (
    .clk(clk),
    .reset(reset),
    .a_in(a10_to_11),
    .b_in(b01_to_11),
    .a_out(),
    .b_out(),
    .acc(c11)
);

endmodule