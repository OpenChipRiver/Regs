// ============================================================================
// MEM_WB_REG - MEM2/WB 流水线寄存器
// 锁存 mem2 处理好的三路写回数据（ALU 结果 / Load 数据 / PC+4）
// 以及 rd 编号、写回选择与有效位，送往 WB 阶段（Write_Back）。
// ============================================================================
module MEM_WB_REG (
    input  wire        clk_i,
    input  wire        rst_n_i,

    // ---- 流水线控制 ----
    input  wire        stall_i,        // 流水线暂停
    input  wire        flush_i,        // 流水线冲刷

    // ---- 来自 MEM2 ----
    input  wire [ 4:0] mem_wb_rd_idx_i,
    input  wire [31:0] mem_wb_alu_result_i,
    input  wire [31:0] mem_wb_load_data_i,
    input  wire [31:0] mem_wb_pc_plus4_i,
    input  wire [ 1:0] mem_wb_sel_i,
    input  wire        mem_wb_rd_valid_i,

    // ---- 输出到 WB 阶段（Write_Back） ----
    output reg  [ 4:0] wb_rd_idx_o,
    output reg  [31:0] wb_alu_result_o,
    output reg  [31:0] wb_load_data_o,
    output reg  [31:0] wb_pc_plus4_o,
    output reg  [ 1:0] wb_sel_o,
    output reg         wb_rd_valid_o
);

    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            wb_rd_idx_o     <= 5'd0;
            wb_alu_result_o <= 32'd0;
            wb_load_data_o  <= 32'd0;
            wb_pc_plus4_o   <= 32'd0;
            wb_sel_o        <= 2'b0;
            wb_rd_valid_o   <= 1'b0;
        end else if (flush_i) begin
            wb_rd_idx_o     <= 5'd0;
            wb_alu_result_o <= 32'd0;
            wb_load_data_o  <= 32'd0;
            wb_pc_plus4_o   <= 32'd0;
            wb_sel_o        <= 2'b0;
            wb_rd_valid_o   <= 1'b0;
        end else if (!stall_i) begin
            wb_rd_idx_o     <= mem_wb_rd_idx_i;
            wb_alu_result_o <= mem_wb_alu_result_i;
            wb_load_data_o  <= mem_wb_load_data_i;
            wb_pc_plus4_o   <= mem_wb_pc_plus4_i;
            wb_sel_o        <= mem_wb_sel_i;
            wb_rd_valid_o   <= mem_wb_rd_valid_i;
        end
        // stall_i == 1：保持原值
    end

endmodule
