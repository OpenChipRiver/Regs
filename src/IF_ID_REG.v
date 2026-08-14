// ============================================================================
// IF_ID_REG - IF/ID 流水线寄存器
// 职责：
//   1. 锁存 Fetch 输出的 PC + 预测 PC + 指令 + 有效位 + 预测元数据
//   2. 供给流水线控制模块和译码模块使用
//   3. 支持 stall 暂停和 flush 冲刷
// ============================================================================
module IF_ID_REG (
    input  wire        clk,
    input  wire        rst_n,

    // ---- 来自流水线控制 ----
    input  wire        stall,
    input  wire        flush,

    // ---- 输出到流水线控制 ----
    output wire [31:0] if_ctrl_pc,
    output wire [31:0] if_ctrl_inst,
    output wire        if_ctrl_valid,

    // ---- 来自 Fetch ----
    input  wire [31:0] pred_pc,        // 预测 PC（来自 Fetch1_Fetch2_Reg）
    input  wire [31:0] if_id_pc,
    input  wire [31:0] if_id_inst,
    input  wire        if_id_valid,
    input  wire [7:0]  if_id_gpht_index,
    input  wire [7:0]  if_id_lpht_index,
    input  wire        if_id_gpht_pred,
    input  wire        if_id_lpht_pred,

    // ---- 输出到 Decoder ----
    output wire [31:0] inst,

    // ---- 预测元数据输出（随流水线打到 EXU） ----
    output wire [31:0] if_ctrl_pred_pc,
    output wire [7:0]  if_ctrl_gpht_index,
    output wire [7:0]  if_ctrl_lpht_index,
    output wire        if_ctrl_gpht_pred,
    output wire        if_ctrl_lpht_pred

);

    // ====================================================================
    // 内部寄存器
    // ====================================================================
    reg [31:0] pc_r;
    reg [31:0] inst_r;
    reg        valid_r;
    reg [31:0] pred_pc_r;
    reg [7:0]  gpht_index_r;
    reg [7:0]  lpht_index_r;
    reg        gpht_pred_r;
    reg        lpht_pred_r;

    // ====================================================================
    // 时序逻辑
    // ====================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_r          <= 32'h0;
            inst_r        <= 32'h0;
            valid_r       <= 1'b0;
            pred_pc_r     <= 32'h0;
            gpht_index_r  <= 8'd0;
            lpht_index_r  <= 8'd0;
            gpht_pred_r   <= 1'b0;
            lpht_pred_r   <= 1'b0;
        end else if (flush) begin
            pc_r          <= 32'h0;
            inst_r        <= 32'h0;
            valid_r       <= 1'b0;
            pred_pc_r     <= 32'h0;
            gpht_index_r  <= 8'd0;
            lpht_index_r  <= 8'd0;
            gpht_pred_r   <= 1'b0;
            lpht_pred_r   <= 1'b0;
        end else if (!stall) begin
            pc_r          <= if_id_pc;
            inst_r        <= if_id_inst;
            valid_r       <= if_id_valid;
            pred_pc_r     <= pred_pc;
            gpht_index_r  <= if_id_gpht_index;
            lpht_index_r  <= if_id_lpht_index;
            gpht_pred_r   <= if_id_gpht_pred;
            lpht_pred_r   <= if_id_lpht_pred;
        end else begin
            pc_r          <= pc_r;
            inst_r        <= inst_r;
            valid_r       <= valid_r;
            pred_pc_r     <= pred_pc_r;
            gpht_index_r  <= gpht_index_r;
            lpht_index_r  <= lpht_index_r;
            gpht_pred_r   <= gpht_pred_r;
            lpht_pred_r   <= lpht_pred_r;
        end
    end

    // ====================================================================
    // 输出连接
    // ====================================================================
    assign if_ctrl_pc        = pc_r;
    assign if_ctrl_inst      = inst_r;
    assign if_ctrl_valid     = valid_r;
    assign inst              = inst_r;
    assign if_ctrl_pred_pc   = pred_pc_r;
    assign if_ctrl_gpht_index = gpht_index_r;
    assign if_ctrl_lpht_index = lpht_index_r;
    assign if_ctrl_gpht_pred  = gpht_pred_r;
    assign if_ctrl_lpht_pred  = lpht_pred_r;

endmodule