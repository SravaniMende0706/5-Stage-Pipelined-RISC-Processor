`timescale 1ns / 1ps


module hazard_unit (
    // ID stage
    input wire [4:0] rs1_id,
    input wire [4:0] rs2_id,
    // EX stage
    input wire [4:0] rd_ex,
    input wire MemRead_ex,
    // Control
    output reg stall,
    output reg if_id_flush
);
    always @(*) begin
        // Load-use hazard detection
        stall = 0;
        if_id_flush = 0;
        
        if (MemRead_ex && ((rd_ex == rs1_id) || (rd_ex == rs2_id)) && (rd_ex != 0)) begin
            stall = 1;
            if_id_flush = 1; // Insert bubble (flush ID/EX)
        end
    end
endmodule
