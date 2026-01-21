`timescale 1ns / 1ps

module forwarding_unit (
    // ID/EX stage
    input wire [4:0] rs1_ex,
    input wire [4:0] rs2_ex,
    // EX/MEM stage
    input wire [4:0] rd_mem,
    input wire RegWrite_mem,
    // MEM/WB stage
    input wire [4:0] rd_wb,
    input wire RegWrite_wb,
    // Forwarding control
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
    always @(*) begin
        // Forward A
        if (RegWrite_mem && (rd_mem != 0) && (rd_mem == rs1_ex))
            forwardA = 2'b10; // Forward from EX/MEM
        else if (RegWrite_wb && (rd_wb != 0) && (rd_wb == rs1_ex))
            forwardA = 2'b01; // Forward from MEM/WB
        else
            forwardA = 2'b00; // No forwarding
        
        // Forward B
        if (RegWrite_mem && (rd_mem != 0) && (rd_mem == rs2_ex))
            forwardB = 2'b10; // Forward from EX/MEM
        else if (RegWrite_wb && (rd_wb != 0) && (rd_wb == rs2_ex))
            forwardB = 2'b01; // Forward from MEM/WB
        else
            forwardB = 2'b00; // No forwarding
    end
endmodule

