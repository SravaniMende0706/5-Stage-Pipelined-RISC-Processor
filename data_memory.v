`timescale 1ns / 1ps

module data_memory (
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
    input wire [31:0] Address,
    input wire [31:0] WriteData,
    output reg [31:0] ReadData
);
    
    reg [31:0] mem [0:31];
    
    always @(posedge clk) begin
        if (MemWrite)
            mem[Address[6:2]] <= WriteData;
    end
    
    always @(*) begin
        ReadData = MemRead ? mem[Address[6:2]] : 32'd0;
    end
    
endmodule
