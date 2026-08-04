`timescale 1ns / 1ps

// ============================================================================
// gpr_tb — 通用寄存器文件测试平台
// ============================================================================
module gpr_tb;

    // ====================================
    // 时钟 & 复位
    // ====================================
    reg         clk;
    reg         rst_n;

    // ====================================
    // 读端口 1
    // ====================================
    reg  [4:0]  rs1_addr;
    wire [31:0] rs1_data;

    // ====================================
    // 读端口 2
    // ====================================
    reg  [4:0]  rs2_addr;
    wire [31:0] rs2_data;

    // ====================================
    // 写端口
    // ====================================
    reg         wen;
    reg  [4:0]  rd_addr;
    reg  [31:0] rd_data;

    // ====================================
    // DUT 实例化
    // ====================================
    gpr u_gpr (
        .clk      (clk),
        .rst_n    (rst_n),
        .rs1_addr (rs1_addr),
        .rs1_data (rs1_data),
        .rs2_addr (rs2_addr),
        .rs2_data (rs2_data),
        .wen      (wen),
        .rd_addr  (rd_addr),
        .rd_data  (rd_data)
    );

    // ====================================
    // 时钟生成 (100MHz)
    // ====================================
    always #5 clk = ~clk;

    // ====================================
    // 测试激励
    // ====================================
    initial begin
        // 初始化
        clk      = 0;
        rst_n    = 0;
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        wen      = 0;
        rd_addr  = 5'd0;
        rd_data  = 32'h0;

        // 复位释放
        repeat (5) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // ================================================================
        // Test 1: 写入 x1~x5，回读验证
        // ================================================================
        wen     = 1;
        rd_addr = 5'd1;
        rd_data = 32'hAAAA_AAAA;
        @(posedge clk);

        rd_addr = 5'd2;
        rd_data = 32'hBBBB_BBBB;
        @(posedge clk);

        rd_addr = 5'd3;
        rd_data = 32'hCCCC_CCCC;
        @(posedge clk);

        rd_addr = 5'd4;
        rd_data = 32'hDDDD_DDDD;
        @(posedge clk);

        rd_addr = 5'd5;
        rd_data = 32'h1234_5678;
        @(posedge clk);

        wen = 0;

        // 回读 rs1 = x1, rs2 = x2
        @(posedge clk);
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;
        @(posedge clk);
        #1;
        if (rs1_data !== 32'hAAAA_AAAA) $display("[FAIL] x1: expected AAAA_AAAA, got %h", rs1_data);
        else                              $display("[PASS] x1 = %h", rs1_data);
        if (rs2_data !== 32'hBBBB_BBBB) $display("[FAIL] x2: expected BBBB_BBBB, got %h", rs2_data);
        else                              $display("[PASS] x2 = %h", rs2_data);

        // 回读 rs1 = x3, rs2 = x5
        rs1_addr = 5'd3;
        rs2_addr = 5'd5;
        @(posedge clk);
        #1;
        if (rs1_data !== 32'hCCCC_CCCC) $display("[FAIL] x3: expected CCCC_CCCC, got %h", rs1_data);
        else                              $display("[PASS] x3 = %h", rs1_data);
        if (rs2_data !== 32'h1234_5678) $display("[FAIL] x5: expected 1234_5678, got %h", rs2_data);
        else                              $display("[PASS] x5 = %h", rs2_data);

        // ================================================================
        // Test 2: x0 恒为 0
        // ================================================================
        rs1_addr = 5'd0;
        @(posedge clk);
        #1;
        if (rs1_data !== 32'h0) $display("[FAIL] x0: expected 0, got %h", rs1_data);
        else                      $display("[PASS] x0 = 0");

        // ================================================================
        // Test 3: 写转发 (write-forwarding for r1 read port)
        // ================================================================
        wen     = 1;
        rd_addr = 5'd10;
        rd_data = 32'hDEAD_BEEF;
        rs1_addr = 5'd10;  // 同一拍读数：应看到新值（组合转发）
        rs2_addr = 5'd0;
        #1;
        if (rs1_data !== 32'hDEAD_BEEF) $display("[FAIL] forwarding: expected DEAD_BEEF, got %h", rs1_data);
        else                              $display("[PASS] write-forwarding: rs1 = %h", rs1_data);

        // ================================================================
        // Test 4: 写 x0 应不生效
        // ================================================================
        wen     = 1;
        rd_addr = 5'd0;
        rd_data = 32'hFFFF_FFFF;
        @(posedge clk);
        rs1_addr = 5'd0;
        @(posedge clk);
        #1;
        if (rs1_data !== 32'h0) $display("[FAIL] x0: expected 0, got %h", rs1_data);
        else                      $display("[PASS] x0 still 0");

        #20;
        $finish;
    end

endmodule