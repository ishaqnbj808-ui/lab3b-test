module lab2a(

	input [3:0] v,
	output [7:0] d1, d0
);

wire gr;
wire[2:0] aout;
wire[3:0] m;
wire[7:0] d1out, d0out;

//display d1

lab2a_comp comparator (v, 4'b1001, gr);

lab2a_circuitb circuitb (gr, d1out);
assign d1 = d1out;

//display d0

lab2a_circuita circuita ( v[3:0], aout);

genvar i;

generate
for(i=0; i<3; i=i+1) begin : inst_mux_loop
	lab2a_mux inst_mux (v[i], aout[i], gr, m[i]);
end
endgenerate

lab2a_mux inst_mux_3(v[3], 0, gr, m[3]);

lab2a_d0 decoder(m, d0out);

assign d0 = d0out;

clk_divider_50M_to_1Hz u1 (
    .clk_in(clk_50MHz),
    .rst(rst),
    .clk_out(clk_1Hz)
);

up_counter_4bit u2 (
    .clk(clk_1Hz),
    .rst(rst),
    .q(counter_value)
);

endmodule

