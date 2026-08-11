// ============================================================================
// MEM_WB_REG - MEM2/WB 流水线寄存器
// ============================================================================
module MEM_WB_REG (
    input  wire        clk,
    input  wire        rst_n,

    // ---- 来自流水线控制 ----
    input  wire        stall,
    input  wire        flush,

    // ---- 来自 MEM2 ----
    input  wire [ 4:0] mem_wb_rd_idx_i,
    input  wire [31:0] mem_wb_alu_result_i,
    input  wire [31:0] mem_wb_load_data_i,
    input  wire [31:0] mem_wb_pc_plus4_i,
    input  wire [ 1:0] mem_wb_wb_sel_i,
    input  wire        mem_wb_rd_valid_i,

    // ---- 输出到 WB 阶段 ----
    output reg  [ 4:0] wb_rd_idx,
    output reg  [31:0] wb_alu_result,
    output reg  [31:0] wb_load_data,
    output reg  [31:0] wb_pc_plus4,
    output reg  [ 1:0] wb_wb_sel,
    output reg         wb_rd_valid
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_rd_idx    <= 5'd0;
            wb_alu_result <= 32'd0;
            wb_load_data <= 32'd0;
            wb_pc_plus4  <= 32'd0;
            wb_wb_sel    <= 2'b0;
            wb_rd_valid  <= 1'b0;
        end else if (flush) begin
            wb_rd_idx    <= 5'd0;
            wb_alu_result <= 32'd0;
            wb_load_data <= 32'd0;
            wb_pc_plus4  <= 32'd0;
            wb_wb_sel    <= 2'b0;
            wb_rd_valid  <= 1'b0;
        end else if (!stall) begin
            wb_rd_idx    <= mem_wb_rd_idx_i;
            wb_alu_result <= mem_wb_alu_result_i;
            wb_load_data <= mem_wb_load_data_i;
            wb_pc_plus4  <= mem_wb_pc_plus4_i;
            wb_wb_sel    <= mem_wb_wb_sel_i;
            wb_rd_valid  <= mem_wb_rd_valid_i;
        end
    end

endmodule