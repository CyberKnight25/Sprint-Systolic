module pe (
    input clk,
    input reset,
    input [7:0] a_in,
    input [7:0] b_in,
    output reg [7:0] a_out,
    output reg [7:0] b_out,
    output reg [15:0] acc
);

wire [7:0] a_iso;
wire [7:0] b_iso;
wire [15:0] mult_new;
wire [15:0] mult;

reg [7:0] prev_a;
reg [7:0] prev_b;
reg [15:0] prev_mult;

reg [31:0] skip_count;
reg [31:0] reuse_count;

wire same_operands;
wire skip_mac;


// -----------------------------
// Operand Isolation
// -----------------------------
assign skip_mac = (a_in == 0 || b_in == 0);

assign a_iso = skip_mac ? 8'd0 : a_in;
assign b_iso = skip_mac ? 8'd0 : b_in;


// -----------------------------
// Temporal Reuse
// -----------------------------
assign same_operands = (a_in == prev_a) && (b_in == prev_b);

assign mult_new = a_iso * b_iso;

assign mult = same_operands ? prev_mult : mult_new;


// -----------------------------
// Sequential Logic
// -----------------------------
always @(posedge clk) begin

    if(reset) begin
        a_out <= 0;
        b_out <= 0;
        acc <= 0;

        prev_a <= 0;
        prev_b <= 0;
        prev_mult <= 0;

        skip_count <= 0;
        reuse_count <= 0;
    end

    else begin

        // forward operands
        a_out <= a_in;
        b_out <= b_in;

        // accumulate
        acc <= acc + mult;

        // update cache
        prev_a <= a_in;
        prev_b <= b_in;
        prev_mult <= mult;

        // skip counter
        if(skip_mac)
            skip_count <= skip_count + 1;

        // reuse counter
        if(same_operands)
            reuse_count <= reuse_count + 1;

    end
end

endmodule