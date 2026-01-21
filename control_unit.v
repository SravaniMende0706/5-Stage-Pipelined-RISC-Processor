`timescale 1ns / 1ps

module control_unit (
    input wire [6:0] opcode,
    output reg RegWrite, MemtoReg, MemRead, MemWrite,
    output reg Branch, ALUSrc, Jump,
    output reg [2:0] ALUOp
);
    always @(*) begin
        RegWrite = 0; MemtoReg = 0; MemRead = 0; MemWrite = 0;
        Branch = 0; ALUSrc = 0; ALUOp = 3'b000; Jump = 0;
        
        case (opcode)
            7'b0110011: begin RegWrite = 1; ALUOp = 3'b010; end
            7'b0000011: begin RegWrite = 1; MemtoReg = 1; MemRead = 1; ALUSrc = 1; end
            7'b0100011: begin MemWrite = 1; ALUSrc = 1; end
            7'b1100011: begin Branch = 1; ALUOp = 3'b001; end
            7'b0010011: begin RegWrite = 1; ALUSrc = 1; ALUOp = 3'b011; end
            7'b0110111: begin RegWrite = 1; ALUSrc = 1; ALUOp = 3'b100; end
            7'b1101111: begin RegWrite = 1; Jump = 1; end
            7'b1100111: begin RegWrite = 1; Jump = 1; ALUSrc = 1; end
        endcase
    end
endmodule
