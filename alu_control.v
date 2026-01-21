`timescale 1ns / 1ps

module alu_control (
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    input wire [2:0] alu_op,
    output reg [3:0] alu_ctrl
);
    always @(*) begin
        case (alu_op)
            3'b000: alu_ctrl = 4'b0000;
            3'b001: alu_ctrl = 4'b0001;
            3'b010: begin
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_ctrl = 4'b0000;
                    {7'b0100000, 3'b000}: alu_ctrl = 4'b0001;
                    {7'b0000000, 3'b111}: alu_ctrl = 4'b0010;
                    {7'b0000000, 3'b110}: alu_ctrl = 4'b0011;
                    {7'b0000000, 3'b100}: alu_ctrl = 4'b0100;
                    {7'b0000000, 3'b010}: alu_ctrl = 4'b0101;
                    {7'b0000000, 3'b011}: alu_ctrl = 4'b0110;
                    {7'b0000000, 3'b001}: alu_ctrl = 4'b0111;
                    {7'b0000000, 3'b101}: alu_ctrl = 4'b1000;
                    {7'b0100000, 3'b101}: alu_ctrl = 4'b1001;
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            3'b011: begin
                case (funct3)
                    3'b000: alu_ctrl = 4'b0000;
                    3'b111: alu_ctrl = 4'b0010;
                    3'b110: alu_ctrl = 4'b0011;
                    3'b100: alu_ctrl = 4'b0100;
                    3'b010: alu_ctrl = 4'b0101;
                    3'b011: alu_ctrl = 4'b0110;
                    3'b001: alu_ctrl = 4'b0111;
                    3'b101: alu_ctrl = (funct7 == 7'b0100000) ? 4'b1001 : 4'b1000;
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            default: alu_ctrl = 4'b0000;
        endcase
    end
endmodule
