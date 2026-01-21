`timescale 1ns / 1ps


module id_ex_reg (
    input wire clk,
    input wire reset,
    input wire flush,
    // Control signals
    input wire RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in,
    input wire Branch_in, ALUSrc_in, Jump_in,
    input wire [2:0] ALUOp_in,
    // Data
    input wire [31:0] pc_in,
    input wire [31:0] rs1_data_in, rs2_data_in,
    input wire [31:0] imm_in,
    input wire [4:0] rs1_in, rs2_in, rd_in,
    input wire [2:0] funct3_in,
    input wire [6:0] funct7_in,
    // Outputs
    output reg RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out,
    output reg Branch_out, ALUSrc_out, Jump_out,
    output reg [2:0] ALUOp_out,
    output reg [31:0] pc_out,
    output reg [31:0] rs1_data_out, rs2_data_out,
    output reg [31:0] imm_out,
    output reg [4:0] rs1_out, rs2_out, rd_out,
    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            RegWrite_out <= 0;
            MemtoReg_out <= 0;
            MemRead_out <= 0;
            MemWrite_out <= 0;
            Branch_out <= 0;
            ALUSrc_out <= 0;
            Jump_out <= 0;
            ALUOp_out <= 3'b000;
            pc_out <= 32'd0;
            rs1_data_out <= 32'd0;
            rs2_data_out <= 32'd0;
            imm_out <= 32'd0;
            rs1_out <= 5'd0;
            rs2_out <= 5'd0;
            rd_out <= 5'd0;
            funct3_out <= 3'd0;
            funct7_out <= 7'd0;
        end else begin
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in;
            ALUSrc_out <= ALUSrc_in;
            Jump_out <= Jump_in;
            ALUOp_out <= ALUOp_in;
            pc_out <= pc_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            imm_out <= imm_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;
            funct3_out <= funct3_in;
            funct7_out <= funct7_in;
        end
    end
endmodule
