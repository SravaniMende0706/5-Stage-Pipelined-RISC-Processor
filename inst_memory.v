`timescale 1ns / 1ps

module inst_memory (
    input  wire [31:0] address,
    output reg  [31:0] instruction
);
    

    always @(*) begin
        case (address[9:2])
            8'd0:  instruction = 32'h00500093; // addi x1, x0, 5
            8'd1:  instruction = 32'h00A00113; // addi x2, x0, 10
            8'd2:  instruction = 32'h002081B3; // add  x3, x1, x2
            8'd3:  instruction = 32'h40208233; // sub  x4, x1, x2
            8'd4:  instruction = 32'h0020F2B3; // and  x5, x1, x2
            8'd5:  instruction = 32'h0020E333; // or   x6, x1, x2
            8'd6:  instruction = 32'h00302023; // sw   x3, 0(x0)
            8'd7:  instruction = 32'h00002383; // lw   x7, 0(x0)
            8'd8:  instruction = 32'h00738463; // beq  x7, x7, 8
            8'd9:  instruction = 32'h00100413; // addi x8, x0, 1
            8'd10: instruction = 32'h00000013; // nop
            default: instruction = 32'h00000013; // nop
        endcase
    end
    
endmodule
