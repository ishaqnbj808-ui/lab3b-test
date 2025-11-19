module clk_divider_50M_to_1Hz(
    input clk_in,       // 50 MHz clock
    input rst,          // Synchronous reset
    output reg clk_out  // 1 Hz clock output
);

reg [25:0] counter; // Enough bits to count 50,000,000 cycles

always @(posedge clk_in) begin
    if (rst) begin
        counter <= 26'b0;
        clk_out <= 0;
    end else if (counter == 26'd24_999_999) begin
        counter <= 0;
        clk_out <= ~clk_out; // Toggle output every 25 million cycles
    end else
        counter <= counter + 1;
end

endmodule
