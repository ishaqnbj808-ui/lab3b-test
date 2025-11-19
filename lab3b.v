module lab3b(
    input clk_50MHz,    // 50 MHz clock input
    input rst,          // Synchronous reset
    output [7:0] d1,    // Tens digit display
    output [7:0] d0     // Units digit display
);

wire gr;
wire [2:0] aout;
wire [3:0] m;
wire [7:0] d1out, d0out;
wire clk_1Hz;
wire [3:0] counter_value;

// ---------------------------
// Clock Divider: 50 MHz -> 1 Hz
// ---------------------------
clk_divider_50M_to_1Hz u1 (
    .clk_in(clk_50MHz),
    .rst(rst),
    .clk_out(clk_1Hz)
);

// ---------------------------
// 4-bit Synchronous Up-Counter
// ---------------------------
up_counter_4bit u2 (
    .clk(clk_1Hz),
    .rst(rst),
    .q(counter_value)
);

// ---------------------------
// Display d1 (tens digit)
// ---------------------------
lab2a_comp comparator (counter_value, 4'b1001, gr);
lab2a_circuitb circuitb (gr, d1out);
assign d1 = d1out;

// ---------------------------
// Display d0 (units digit)
// ---------------------------
lab2a_circuita circuita (counter_value, aout);

genvar i;
generate
    for(i=0; i<3; i=i+1) begin : inst_mux_loop
        lab2a_mux inst_mux (counter_value[i], aout[i], gr, m[i]);
    end
endgenerate

// Handle MSB (bit 3) separately
lab2a_mux inst_mux_3(counter_value[3], 1'b0, gr, m[3]);

lab2a_d0 decoder(m, d0out);
assign d0 = d0out;

endmodule
