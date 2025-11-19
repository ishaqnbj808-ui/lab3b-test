module lab2a_comp (

	input [3:0] a, b,
	output gr
);

assign gr = (a > b)? 1:0;

endmodule