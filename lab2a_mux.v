module lab2a_mux (
    input  a, b, s, 
    output m
);

assign m = s? b:a;

endmodule
