module lab3b (
    input  clock50M,   // 50 MHz clock input
    input  reset,      // Active-low asynchronous reset
    output [7:0] d1,   // MSB digit (0 or 1)
    output [7:0] d0    // LSB digit (0–9)
);

    parameter DIV_COUNT = 26'd24_999_999; // Clock toggles every 25 million pulses

    // -------------------------
    // Clock divider
    // -------------------------
    reg [25:0] count_div;  // Counter for dividing 50MHz to 1Hz
    reg clk_1Hz;

    always @(posedge clock50M or negedge reset) begin
        if (!reset) begin
            count_div <= 26'd0;
            clk_1Hz <= 1'b0;
        end else if (count_div == DIV_COUNT) begin
            count_div <= 26'd0;
            clk_1Hz <= ~clk_1Hz;  // Toggle 1Hz clock
        end else begin
            count_div <= count_div + 1;
        end
    end

    // -------------------------
    // 4-bit synchronous up-counter
    // -------------------------
    reg [3:0] count_4bit;

    always @(posedge clk_1Hz or negedge reset) begin
        if (!reset)
            count_4bit <= 4'd0;
        else
            count_4bit <= count_4bit + 1; // Count 0–15
    end

    // -------------------------
    // Prepare tens and units for display modules
    // -------------------------
    wire gr;             // Comparator output for tens digit
    wire [2:0] aout;     // Output from circuita
    wire [3:0] m;        // Multiplexed value for LSB
    wire [7:0] d1out, d0out;

    // Compare for tens digit (0 or 1)
    lab2a_comp comparator(count_4bit, 4'b1001, gr);

    // Tens digit display
    lab2a_circuitb circuitb(gr, d1out);
    assign d1 = d1out;

    // Units digit display
    lab2a_circuita circuita(count_4bit, aout);

    genvar i;
    generate
        for(i=0; i<3; i=i+1) begin : inst_mux_loop
            lab2a_mux inst_mux(count_4bit[i], aout[i], gr, m[i]);
        end
    endgenerate

    lab2a_mux inst_mux_3(count_4bit[3], 1'b0, gr, m[3]);

    lab2a_d0 decoder(m, d0out);
    assign d0 = d0out;

endmodule
