`timescale 1ns / 1ps

module mem_wb_reg (
    input wire clk,
    input wire reset,
    // Control signals
    input wire RegWrite_in, MemtoReg_in,
    // Data
    input wire [31:0] mem_data_in,
    input wire [31:0] alu_result_in,
    input wire [4:0] rd_in,
    input wire [31:0] pc_plus4_in,
    // Outputs
    output reg RegWrite_out, MemtoReg_out,
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] rd_out,
    output reg [31:0] pc_plus4_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 0;
            MemtoReg_out <= 0;
            mem_data_out <= 32'd0;
            alu_result_out <= 32'd0;
            rd_out <= 5'd0;
            pc_plus4_out <= 32'd0;
        end else begin
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            mem_data_out <= mem_data_in;
            alu_result_out <= alu_result_in;
            rd_out <= rd_in;
            pc_plus4_out <= pc_plus4_in;
        end
    end
endmodule
