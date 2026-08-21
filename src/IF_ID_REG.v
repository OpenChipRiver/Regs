module IF_ID_REG (

    input  wire        clk_i,
    input  wire        rst_n_i,

    // ---- 流水线控制 ----
    input  wire        stall_i,
    input  wire        flush_i,

    // ---- Fetch -> IF_ID_REG ----
    input  wire [31:0] if_id_inst_i,
    input  wire [31:0] if_id_pc_i,
    input  wire [31:0] if_id_pc_plus4_i,

    // ---- 分支预测元数据 ----
    input  wire [31:0] pred_pc_i,
    input  wire [7:0]  if_id_gpht_index_i,
    input  wire [7:0]  if_id_lpht_index_i,
    input  wire        if_id_gpht_pred_i,
    input  wire        if_id_lpht_pred_i,

    // ---- IF_ID_REG -> ID / ID_EXE_REG ----
    output reg [31:0] id_inst_o,                 // 送 ID 阶段
    output reg [31:0] id_exe_pc_o,               // 送 ID_EXE_REG
    output reg [31:0] id_exe_pc_plus4_o,         // 送 ID_EXE_REG
    output reg [31:0] id_exe_pred_pc_o,          // 送 ID_EXE_REG

    output reg [7:0]  id_exe_gpht_index_o,       // 送 ID_EXE_REG
    output reg [7:0]  id_exe_lpht_index_o,       // 送 ID_EXE_REG

    output reg        id_exe_gpht_pred_o,        // 送 ID_EXE_REG
    output reg        id_exe_lpht_pred_o         // 送 ID_EXE_REG

);


always @(posedge clk_i or negedge rst_n_i) begin

    if (!rst_n_i) begin

        id_inst_o             <= 32'h0;
        id_exe_pc_o           <= 32'h0;
        id_exe_pc_plus4_o     <= 32'h0;
        id_exe_pred_pc_o      <= 32'h0;

        id_exe_gpht_index_o   <= 8'h0;
        id_exe_lpht_index_o   <= 8'h0;

        id_exe_gpht_pred_o    <= 1'b0;
        id_exe_lpht_pred_o    <= 1'b0;

    end

    else if (flush_i) begin

        id_inst_o             <= 32'h0;
        id_exe_pc_o           <= 32'h0;
        id_exe_pc_plus4_o     <= 32'h0;
        id_exe_pred_pc_o      <= 32'h0;

        id_exe_gpht_index_o   <= 8'h0;
        id_exe_lpht_index_o   <= 8'h0;

        id_exe_gpht_pred_o    <= 1'b0;
        id_exe_lpht_pred_o    <= 1'b0;

    end

    else if (!stall_i) begin

        id_inst_o             <= if_id_inst_i;
        id_exe_pc_o           <= if_id_pc_i;
        id_exe_pc_plus4_o     <= if_id_pc_plus4_i;
        id_exe_pred_pc_o      <= pred_pc_i;

        id_exe_gpht_index_o   <= if_id_gpht_index_i;
        id_exe_lpht_index_o   <= if_id_lpht_index_i;

        id_exe_gpht_pred_o    <= if_id_gpht_pred_i;
        id_exe_lpht_pred_o    <= if_id_lpht_pred_i;

    end

    // stall时保持原值

end


endmodule
