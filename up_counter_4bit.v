module up_counter_4bit(
    input clk,       // Clock input
    input rst,       // Synchronous reset
    output reg [3:0] q  // 4-bit output
);

always @(posedge clk) begin
    if (rst)
        q <= 4'b0000; // Reset counter
    else
        q <= q + 1;   // Increment counter
end

endmodule
