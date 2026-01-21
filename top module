`timescale 1ns / 1ps

module top (
    input  wire clk,      
    input  wire reset,

    output wire [7:0] pc_out,        
    output wire [7:0] alu_result_out, 
    output wire [7:0] mem_data_out,  
    output wire [4:0]  rd_out,      
    output wire        regwrite_out  
);

   
    // RESET SYNCHRONIZER 
  
    (* ASYNC_REG = "TRUE", KEEP = "TRUE" *) reg rst_sync1;
    (* ASYNC_REG = "TRUE", KEEP = "TRUE" *) reg rst_sync2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rst_sync1 <= 1'b1;
            rst_sync2 <= 1'b1;
        end else begin
            rst_sync1 <= 1'b0;
            rst_sync2 <= rst_sync1;
        end
    end
    wire reset_sync = rst_sync2;

    
    // IF STAGE
 
    reg [31:0] pc_reg;
    wire [31:0] pc_if       = pc_reg;
    wire [31:0] pc_plus4_if = pc_if + 4;
    wire [31:0] pc_next;
    wire [31:0] instruction_if;

    wire branch_taken;
    wire stall;
    wire [31:0] branch_target;
    wire if_id_flush;

    always @(posedge clk) begin
        if (reset_sync)
            pc_reg <= 32'd0;
        else if (!stall)
            pc_reg <= pc_next;
    end
    assign pc_next = branch_taken ? branch_target : pc_plus4_if;

    inst_memory IMEM (
        .address(pc_if),
        .instruction(instruction_if)
    );

    
    // IF / ID PIPELINE REGISTER
  
    wire [31:0] pc_id;
    wire [31:0] instruction_id;

    if_id_reg IF_ID (
        .clk(clk),
        .reset(reset_sync),
        .stall(stall),
        .flush(if_id_flush | branch_taken),
        .pc_in(pc_if),
        .instr_in(instruction_if),
        .pc_out(pc_id),
        .instr_out(instruction_id)
    );


    // ID STAGE
    wire [6:0] opcode_id = instruction_id[6:0];
    wire [4:0] rd_id     = instruction_id[11:7];
    wire [2:0] funct3_id = instruction_id[14:12];
    wire [4:0] rs1_id    = instruction_id[19:15];
    wire [4:0] rs2_id    = instruction_id[24:20];
    wire [6:0] funct7_id = instruction_id[31:25];

    wire RegWrite_id, MemtoReg_id, MemRead_id, MemWrite_id;
    wire Branch_id, ALUSrc_id, Jump_id;
    wire [2:0] ALUOp_id;

    wire [31:0] rs1_data_id, rs2_data_id, imm_id;

    control_unit CTRL (
        .opcode(opcode_id),
        .RegWrite(RegWrite_id),
        .MemtoReg(MemtoReg_id),
        .MemRead(MemRead_id),
        .MemWrite(MemWrite_id),
        .Branch(Branch_id),
        .ALUSrc(ALUSrc_id),
        .Jump(Jump_id),
        .ALUOp(ALUOp_id)
    );

    register_file RF (
        .clk(clk),
        .RegWrite(RegWrite_wb_final),
        .ReadReg1(rs1_id),
        .ReadReg2(rs2_id),
        .WriteReg(rd_wb),
        .WriteData(WriteData_wb),
        .ReadData1(rs1_data_id),
        .ReadData2(rs2_data_id)
    );

    sign_extend SIGNEXT (
        .instr(instruction_id),
        .imm_out(imm_id)
    );

   
    // ID / EX PIPELINE REGISTER
    wire [31:0] pc_ex, rs1_data_ex, rs2_data_ex, imm_ex;
    wire [4:0] rs1_ex, rs2_ex, rd_ex;
    wire [2:0] funct3_ex;
    wire [6:0] funct7_ex;

    wire RegWrite_ex, MemtoReg_ex, MemRead_ex, MemWrite_ex;
    wire Branch_ex, ALUSrc_ex, Jump_ex;
    wire [2:0] ALUOp_ex;

    id_ex_reg ID_EX (
        .clk(clk),
        .reset(reset_sync),
        .flush(if_id_flush | branch_taken),
        .RegWrite_in(RegWrite_id),
        .MemtoReg_in(MemtoReg_id),
        .MemRead_in(MemRead_id),
        .MemWrite_in(MemWrite_id),
        .Branch_in(Branch_id),
        .ALUSrc_in(ALUSrc_id),
        .Jump_in(Jump_id),
        .ALUOp_in(ALUOp_id),
        .pc_in(pc_id),
        .rs1_data_in(rs1_data_id),
        .rs2_data_in(rs2_data_id),
        .imm_in(imm_id),
        .rs1_in(rs1_id),
        .rs2_in(rs2_id),
        .rd_in(rd_id),
        .funct3_in(funct3_id),
        .funct7_in(funct7_id),
        .RegWrite_out(RegWrite_ex),
        .MemtoReg_out(MemtoReg_ex),
        .MemRead_out(MemRead_ex),
        .MemWrite_out(MemWrite_ex),
        .Branch_out(Branch_ex),
        .ALUSrc_out(ALUSrc_ex),
        .Jump_out(Jump_ex),
        .ALUOp_out(ALUOp_ex),
        .pc_out(pc_ex),
        .rs1_data_out(rs1_data_ex),
        .rs2_data_out(rs2_data_ex),
        .imm_out(imm_ex),
        .rs1_out(rs1_ex),
        .rs2_out(rs2_ex),
        .rd_out(rd_ex),
        .funct3_out(funct3_ex),
        .funct7_out(funct7_ex)
    );

    // EX STAGE
    wire [31:0] alu_result_ex;
    wire [1:0] forwardA, forwardB;
    wire [31:0] alu_inputA, alu_inputB;
    wire [31:0] forward_rs1, forward_rs2;
    wire [3:0] alu_ctrl_ex;
    wire zero_ex;

    wire [31:0] alu_result_mem;
    wire [4:0] rd_mem;
    wire RegWrite_mem;

    assign forward_rs1 = (forwardA == 2'b10) ? alu_result_mem :
                         (forwardA == 2'b01) ? WriteData_wb :
                         rs1_data_ex;

    assign forward_rs2 = (forwardB == 2'b10) ? alu_result_mem :
                         (forwardB == 2'b01) ? WriteData_wb :
                         rs2_data_ex;

    assign alu_inputA = forward_rs1;
    assign alu_inputB = ALUSrc_ex ? imm_ex : forward_rs2;

    alu_control ALUCTRL (
        .funct3(funct3_ex),
        .funct7(funct7_ex),
        .alu_op(ALUOp_ex),
        .alu_ctrl(alu_ctrl_ex)
    );

    alu ALU (
        .a(alu_inputA),
        .b(alu_inputB),
        .alu_ctrl(alu_ctrl_ex),
        .result(alu_result_ex),
        .zero(zero_ex)
    );

    assign branch_target = pc_ex + imm_ex;

    branch_unit BRANCH (
        .Branch(Branch_ex),
        .Jump(Jump_ex),
        .zero(zero_ex),
        .funct3(funct3_ex),
        .alu_result(alu_result_ex),
        .branch_taken(branch_taken)
    );

    // EX / MEM PIPELINE REGISTER
    wire MemtoReg_mem, MemRead_mem, MemWrite_mem;
    wire [31:0] rs2_data_mem, pc_plus4_mem;

    ex_mem_reg EX_MEM (
        .clk(clk),
        .reset(reset_sync),
        .RegWrite_in(RegWrite_ex),
        .MemtoReg_in(MemtoReg_ex),
        .MemRead_in(MemRead_ex),
        .MemWrite_in(MemWrite_ex),
        .alu_result_in(alu_result_ex),
        .rs2_data_in(forward_rs2),
        .rd_in(rd_ex),
        .pc_plus4_in(pc_ex + 4),
        .RegWrite_out(RegWrite_mem),
        .MemtoReg_out(MemtoReg_mem),
        .MemRead_out(MemRead_mem),
        .MemWrite_out(MemWrite_mem),
        .alu_result_out(alu_result_mem),
        .rs2_data_out(rs2_data_mem),
        .rd_out(rd_mem),
        .pc_plus4_out(pc_plus4_mem)
    );

    // MEM STAGE
    wire [31:0] mem_read_data;

    data_memory DMEM (
        .clk(clk),
        .MemRead(MemRead_mem),
        .MemWrite(MemWrite_mem),
        .Address(alu_result_mem),
        .WriteData(rs2_data_mem),
        .ReadData(mem_read_data)
    );

    // MEM / WB PIPELINE REGISTER
    wire [31:0] alu_result_wb;
    wire [31:0] mem_data_wb;
    wire [4:0]  rd_wb;
    wire        RegWrite_wb_final;
    wire        MemtoReg_wb;

    mem_wb_reg MEM_WB (
        .clk(clk),
        .reset(reset_sync),
        .RegWrite_in(RegWrite_mem),
        .MemtoReg_in(MemtoReg_mem),
        .mem_data_in(mem_read_data),
        .alu_result_in(alu_result_mem),
        .rd_in(rd_mem),
        .pc_plus4_in(pc_plus4_mem),
        .RegWrite_out(RegWrite_wb_final),
        .MemtoReg_out(MemtoReg_wb),
        .mem_data_out(mem_data_wb),
        .alu_result_out(alu_result_wb),
        .rd_out(rd_wb),
        .pc_plus4_out()
    );

    // WB STAGE
    wire [31:0] WriteData_wb;
    assign WriteData_wb = MemtoReg_wb ? mem_data_wb : alu_result_wb;

    // HAZARD & FORWARDING UNITS
    hazard_unit HAZARD (
        .rs1_id(rs1_id),
        .rs2_id(rs2_id),
        .rd_ex(rd_ex),
        .MemRead_ex(MemRead_ex),
        .stall(stall),
        .if_id_flush(if_id_flush)
    );

    forwarding_unit FORWARD (
        .rs1_ex(rs1_ex),
        .rs2_ex(rs2_ex),
        .rd_mem(rd_mem),
        .RegWrite_mem(RegWrite_mem),
        .rd_wb(rd_wb),
        .RegWrite_wb(RegWrite_wb_final),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    // OUTPUT ASSIGNMENTS
    assign pc_out         = pc_if[7:0];
    assign alu_result_out = alu_result_wb[7:0];
    assign mem_data_out   = mem_data_wb[7:0];
    assign rd_out         = rd_wb;
    assign regwrite_out   = RegWrite_wb_final;

endmodule
