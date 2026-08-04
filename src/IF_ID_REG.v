// ============================================================================
// IF_ID_REG - IF/ID 流水线寄存器
// 职责：
//   1. 锁存 Fetch2 输出的 PC + 指令 + 有效位
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

    // ---- 来自 Fetch2 ----
    input  wire [31:0] if_id_pc,
    input  wire [31:0] if_id_inst,
    input  wire        inst_ok,

    // ---- 输出到 Decoder ----
    output wire [31:0] inst

);

    // ====================================================================
    // 内部寄存器
    // ====================================================================
    reg [31:0] pc_r;
    reg [31:0] inst_r;
    reg        valid_r;

    // ====================================================================
    // 时序逻辑
    // ====================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_r    <= 32'h0;
            inst_r  <= 32'h0;
            valid_r <= 1'b0;
        end else if (flush) begin
            pc_r    <= 32'h0;
            inst_r  <= 32'h0;
            valid_r <= 1'b0;
        end else if (!stall) begin
            pc_r    <= if_id_pc;
            inst_r  <= if_id_inst;
            valid_r <= inst_ok;
        end else begin
            pc_r    <= pc_r;
            inst_r  <= inst_r;
            valid_r <= valid_r;
        end
    end

    // ====================================================================
    // 输出连接
    // ====================================================================
    assign if_ctrl_pc    = pc_r;
    assign if_ctrl_inst  = inst_r;
    assign if_ctrl_valid = valid_r;
    assign inst          = inst_r;

endmodule