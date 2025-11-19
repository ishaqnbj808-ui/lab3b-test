`timescale 1ns/1ps

module lab3b_tb;

    reg clock50M;
    reg reset;
    wire [6:0] d1, d0;

    // Instantiate the DUT
    lab3b uut (
        .clock50M(clock50M),
        .reset(reset),
        .d1(d1),
        .d0(d0)
    );

    // Clock generation: 50 MHz (20 ns period)
    always #10 clock50M = ~clock50M;

    // --- Simulation parameters for autograding ---
    // Shorten the divider to speed up simulation
    localparam SIM_DIV_COUNT = 24_999; // ~1 kHz simulated frequency

    // Override divider count if parameter exists
    // (optional; safe if lab3b doesn't define it)
    defparam uut.DIV_COUNT = SIM_DIV_COUNT;

    integer prev_count, new_count;
    integer i;
    reg test_passed;

    initial begin
        clock50M = 0;
        reset = 0;
        test_passed = 1'b1;

        // Hold reset low for 100 ns
        #100;
        reset = 1;

        // Wait for divider to generate a few pulses
        prev_count = uut.count_4bit;

 begin : TEST_LOOP
    for (i = 0; i < 20; i = i + 1) begin
        #(1_000_000);
        new_count = uut.count_4bit;
        if (new_count !== (prev_count + 1) % 16) begin
            $display("❌ Counter failed at iteration %0d: prev=%0d, new=%0d displaying %0b %0b, countdiv is %d", i, prev_count, new_count, d1, d0, uut.count_div);
            test_passed = 1'b0;
            disable TEST_LOOP; // <-- safe and clean
        end
        prev_count = new_count;
    end
end

        if (test_passed) begin
            $display("✅ TEST PASSED");
        end else begin
            $display("❌ TEST FAILED");
        end

        $finish;
    end

endmodule




