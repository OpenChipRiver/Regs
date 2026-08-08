module ID_EXE_REG
(
    input wire clk,
    input wire rst,
    input wire stall_i,
    input wire flush_i,
    input wire valid_i,  

    //-------------------------
    // 数据通路
    //-------------------------

    input wire [31:0] id_pc_i,

    input wire [31:0] id_rs1_data_i,
    input wire [31:0] id_rs2_data_i,

    input wire [31:0] id_imm_i,

    input wire [4:0] id_rd_i,


    //-------------------------
    // decoder控制信号
    //-------------------------

    input wire id_load_i,

    input wire id_store_i,

    input wire id_branch_i,

    input wire id_jump_i,


    // 写回控制
    input wire id_rd_valid_i,

    input wire [1:0] id_wb_sel_i,


    // 跳转控制
    input wire id_jump_base_rs1_i,
    input wire [2:0] id_branch_type_i,

    // memory控制
    input wire [1:0] id_mem_size_i,

    input wire id_mem_unsigned_i,


    // ALU输入选择

    input wire id_alu_rs1_sel_i,

    input wire id_alu_rs2_sel_i,


    //-------------------------
    // ALU控制(one-hot)
    //-------------------------

    input wire id_alu_add_en_i,
    input wire id_alu_sub_en_i,

    input wire id_alu_sll_en_i,

    input wire id_alu_slt_en_i,

    input wire id_alu_sltu_en_i,

    input wire id_alu_xor_en_i,

    input wire id_alu_srl_en_i,

    input wire id_alu_sra_en_i,

    input wire id_alu_or_en_i,

    input wire id_alu_and_en_i,

    input wire id_alu_pass_b_en_i,
 //-------------------------
    // EX阶段
    //-------------------------

    output reg [31:0] ex_pc_o,

    output reg [31:0] ex_rs1_data_o,

    output reg [31:0] ex_rs2_data_o,

    output reg [31:0] ex_imm_o,


    output reg [4:0] ex_rd_o,


    //-------------------------
    // 控制信号
    //-------------------------

    output reg ex_load_o,

    output reg ex_store_o,

    output reg ex_branch_o,

    output reg ex_jump_o,


    output reg ex_rd_valid_o,


    output reg [1:0] ex_wb_sel_o,


    output reg ex_jump_base_rs1_o,
    output reg [2:0]  ex_branch_type_o,

    output reg [1:0] ex_mem_size_o,

    output reg ex_mem_unsigned_o,


    output reg ex_alu_rs1_sel_o,

    output reg ex_alu_rs2_sel_o,


    //-------------------------
    // ALU控制
    //-------------------------

    output reg ex_alu_add_en_o,

    output reg ex_alu_sub_en_o,

    output reg ex_alu_sll_en_o,

    output reg ex_alu_slt_en_o,

    output reg ex_alu_sltu_en_o,

    output reg ex_alu_xor_en_o,

    output reg ex_alu_srl_en_o,

    output reg ex_alu_sra_en_o,

    output reg ex_alu_or_en_o,

    output reg ex_alu_and_en_o,

    output reg ex_alu_pass_b_en_o
);




   always_ff @(posedge clk or posedge rst) begin

    // 异步复位 全部清零
    if (rst) begin

        ex_pc_o <= 32'h0;

        ex_rs1_data_o <= 32'h0;
        ex_rs2_data_o <= 32'h0;

        ex_imm_o <= 32'h0;

        ex_rd_o <= 5'h0;


        // 控制信号
        ex_load_o <= 1'b0;
        ex_store_o <= 1'b0;
        ex_branch_o <= 1'b0;
        ex_jump_o <= 1'b0;


        // 写回控制
        ex_rd_valid_o <= 1'b0;
        ex_wb_sel_o <= 2'b00;


        // 跳转控制
        ex_jump_base_rs1_o <= 1'b0;
        ex_branch_type_o <= 3'b0;

        // memory控制
        ex_mem_size_o <= 2'b00;
        ex_mem_unsigned_o <= 1'b0;


        // ALU输入选择
        ex_alu_rs1_sel_o <= 1'b0;
        ex_alu_rs2_sel_o <= 1'b0;


        // ALU控制
        ex_alu_add_en_o <= 1'b0;
        ex_alu_sub_en_o <= 1'b0;
        ex_alu_sll_en_o <= 1'b0;
        ex_alu_slt_en_o <= 1'b0;
        ex_alu_sltu_en_o <= 1'b0;
        ex_alu_xor_en_o <= 1'b0;
        ex_alu_srl_en_o <= 1'b0;
        ex_alu_sra_en_o <= 1'b0;
        ex_alu_or_en_o <= 1'b0;
        ex_alu_and_en_o <= 1'b0;
        ex_alu_pass_b_en_o <= 1'b0;

    end


    // 流水线冲刷
    else if (flush_i) begin

        // 数据清零
        ex_pc_o <= 32'h0;

        ex_rs1_data_o <= 32'h0;
        ex_rs2_data_o <= 32'h0;

        ex_imm_o <= 32'h0;

        ex_rd_o <= 5'h0;


        // 关闭所有控制
        ex_load_o <= 1'b0;
        ex_store_o <= 1'b0;
        ex_branch_o <= 1'b0;
        ex_jump_o <= 1'b0;


        ex_rd_valid_o <= 1'b0;
        ex_wb_sel_o <= 2'b00;


        ex_jump_base_rs1_o <= 1'b0;
        ex_branch_type_o <= 3'b0;


        ex_mem_size_o <= 2'b00;
        ex_mem_unsigned_o <= 1'b0;


        ex_alu_rs1_sel_o <= 1'b0;
        ex_alu_rs2_sel_o <= 1'b0;


        ex_alu_add_en_o <= 1'b0;
        ex_alu_sub_en_o <= 1'b0;
        ex_alu_sll_en_o <= 1'b0;
        ex_alu_slt_en_o <= 1'b0;
        ex_alu_sltu_en_o <= 1'b0;
        ex_alu_xor_en_o <= 1'b0;
        ex_alu_srl_en_o <= 1'b0;
        ex_alu_sra_en_o <= 1'b0;
        ex_alu_or_en_o <= 1'b0;
        ex_alu_and_en_o <= 1'b0;
        ex_alu_pass_b_en_o <= 1'b0;

    end


    // 正常流水传递
    else if (!stall_i) begin

        // 数据
        ex_pc_o <= id_pc_i;

        ex_rs1_data_o <= id_rs1_data_i;
        ex_rs2_data_o <= id_rs2_data_i;

        ex_imm_o <= id_imm_i;

        ex_rd_o <= id_rd_i;


        // 控制信号
        ex_load_o <= id_load_i;
        ex_store_o <= id_store_i;
        ex_branch_o <= id_branch_i;
        ex_jump_o <= id_jump_i;


        // 写回
        ex_rd_valid_o <= id_rd_valid_i;
        ex_wb_sel_o <= id_wb_sel_i;


        // 跳转
        ex_jump_base_rs1_o <= id_jump_base_rs1_i;
        ex_branch_type_o <= id_branch_type_i;


        // memory
        ex_mem_size_o <= id_mem_size_i;
        ex_mem_unsigned_o <= id_mem_unsigned_i;


        // ALU输入选择
        ex_alu_rs1_sel_o <= id_alu_rs1_sel_i;
        ex_alu_rs2_sel_o <= id_alu_rs2_sel_i;


        // ALU one-hot控制
        ex_alu_add_en_o <= id_alu_add_en_i;
        ex_alu_sub_en_o <= id_alu_sub_en_i;

        ex_alu_sll_en_o <= id_alu_sll_en_i;

        ex_alu_slt_en_o <= id_alu_slt_en_i;

        ex_alu_sltu_en_o <= id_alu_sltu_en_i;

        ex_alu_xor_en_o <= id_alu_xor_en_i;

        ex_alu_srl_en_o <= id_alu_srl_en_i;

        ex_alu_sra_en_o <= id_alu_sra_en_i;

        ex_alu_or_en_o <= id_alu_or_en_i;

        ex_alu_and_en_o <= id_alu_and_en_i;

        ex_alu_pass_b_en_o <= id_alu_pass_b_en_i;

    end

    // stall_i == 1:
    // 不执行任何操作，保持当前EX寄存器内容

end

    
endmodule
