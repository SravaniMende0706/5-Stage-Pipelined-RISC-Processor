`timescale 1ns / 1ps

module testbench;
    reg clk;
    reg reset;
    integer cycle_count;
    
    // Instantiate DUT
    top CPU (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generation (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;
    
    // Cycle counter
    initial cycle_count = 0;
    always @(posedge clk) begin
        if (!reset)
            cycle_count = cycle_count + 1;
    end
    
    // Reset and simulation control
    initial begin
        $display("=== Pipelined RISC-V CPU Simulation Start ===");
        
        reset = 1;
        #25;
        reset = 0;
        $display("Time=%0t: Reset released", $time);
        
        // Run simulation
        #500;
        
        $display("\n=== Simulation Complete after %0d cycles ===", cycle_count);
        
        //Display register file contents
        $display("\n=== Final Register File Contents ===");
        $display("x1  = %h (%0d)", CPU.RF.regs[1], CPU.RF.regs[1]);
        $display("x2  = %h (%0d)", CPU.RF.regs[2], CPU.RF.regs[2]);
        $display("x3  = %h (%0d)", CPU.RF.regs[3], CPU.RF.regs[3]);
        $display("x4  = %h (%0d)", CPU.RF.regs[4], CPU.RF.regs[4]);
        $display("x5  = %h (%0d)", CPU.RF.regs[5], CPU.RF.regs[5]);
        $display("x6  = %h (%0d)", CPU.RF.regs[6], CPU.RF.regs[6]);
        $display("x7  = %h (%0d)", CPU.RF.regs[7], CPU.RF.regs[7]);
        $display("x8  = %h (%0d)", CPU.RF.regs[8], CPU.RF.regs[8]);
        
        // Display memory
        $display("\n=== Data Memory ===");
        $display("mem[0] = %h (%0d)", CPU.DMEM.mem[0], CPU.DMEM.mem[0]);
        
        $finish;
    end
    
    // Monitor pipeline stages
    always @(posedge clk) begin
        if (!reset && cycle_count < 30) begin
            $display(
                "Cycle %0d: IF_PC=%h | ID_PC=%h ID_Instr=%h | EX_ALU=%h | MEM_Addr=%h | WB_Data=%h WB_Reg=x%0d",
                cycle_count,
                CPU.pc_if,
                CPU.pc_id, CPU.instruction_id,
                CPU.alu_result_ex,
                CPU.alu_result_mem,
                CPU.WriteData_wb,
                CPU.rd_wb          
            );
        end
    end
    
    // Hazard detection monitor
    always @(posedge clk) begin
        if (!reset && CPU.stall) begin
            $display("*** STALL detected at cycle %0d: Load-use hazard ***", cycle_count);
        end
        if (!reset && CPU.branch_taken) begin
            $display("*** BRANCH TAKEN at cycle %0d: Flushing pipeline ***", cycle_count);
        end
    end
    
    // Forwarding monitor
    always @(posedge clk) begin
        if (!reset && (CPU.forwardA != 2'b00 || CPU.forwardB != 2'b00)) begin
            $display(
                "    Forward at cycle %0d: A=%b B=%b",
                cycle_count,
                CPU.forwardA,
                CPU.forwardB
            );
        end
    end
    
endmodule
