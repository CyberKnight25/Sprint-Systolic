module pe (
    input clk,
    input reset,
    input [7:0] a_in,
    input [7:0] b_in,

    output reg [7:0] a_out,
    output reg [7:0] b_out,

    output reg [15:0] acc,

    output wire skip_flag,
    output wire reuse_flag
);

// ----------------------------------
// Previous operand tracking
// ----------------------------------
reg [7:0] prev_a;
reg [7:0] prev_b;
reg [15:0] prev_mult;

wire same_operands;
wire skip_mac;

assign skip_mac = (a_in == 0 || b_in == 0);
assign same_operands = (a_in == prev_a) && (b_in == prev_b);

assign skip_flag = skip_mac;
assign reuse_flag = same_operands;

// ----------------------------------
// Multiplier
// ----------------------------------
wire [15:0] mult_new;
wire [15:0] mult;

assign mult_new = a_in * b_in;
assign mult = same_operands ? prev_mult : mult_new;


// ----------------------------------
// Data propagation (ALWAYS RUNS)
// ----------------------------------
always @(posedge clk) begin
    if(reset) begin
        a_out <= 0;
        b_out <= 0;
    end
    else begin
        a_out <= a_in;
        b_out <= b_in;
    end
end


// ----------------------------------
// MAC Accumulator
// ----------------------------------
always @(posedge clk or posedge reset) begin
    if(reset) begin
        acc <= 0;
        prev_a <= 0;
        prev_b <= 0;
        prev_mult <= 0;
    end
    else begin

        // store operands
        prev_a <= a_in;
        prev_b <= b_in;

        if(skip_mac) begin
            // skip multiplication but keep pipeline timing
            acc <= acc;
        end
        else begin
            acc <= acc + mult;
            prev_mult <= mult;
        end

    end
end

endmodule