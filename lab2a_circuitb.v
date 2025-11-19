module lab2a_circuitb(
    input gr,
    output reg [6:0] d1
);

always @(*) begin
    case (gr)
        1'b1 : d1 = 7'b1111001;
        1'b0 : d1 = 7'b0111111;
        default : d1 = 7'b1111111;
    endcase
end

endmodule
