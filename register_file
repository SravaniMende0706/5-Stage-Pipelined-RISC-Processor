`timescale 1ns / 1ps

module register_file (
    input wire clk,
    input wire RegWrite,
    input wire [4:0] ReadReg1, ReadReg2, WriteReg,
    input wire [31:0] WriteData,
    output wire [31:0] ReadData1, ReadData2
);
    reg [31:0] regs [0:31];
    integer i;
    
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'd0;
    end
    
    always @(posedge clk) begin
        if (RegWrite && WriteReg != 5'd0)
            regs[WriteReg] <= WriteData;
    end
    
    // Write-through forwarding
    assign ReadData1 = (ReadReg1 == 5'd0) ? 32'd0 :
                       (RegWrite && WriteReg == ReadReg1 && WriteReg != 5'd0) ? WriteData :
                       regs[ReadReg1];
                       
    assign ReadData2 = (ReadReg2 == 5'd0) ? 32'd0 :
                       (RegWrite && WriteReg == ReadReg2 && WriteReg != 5'd0) ? WriteData :
                       regs[ReadReg2];
endmodule
