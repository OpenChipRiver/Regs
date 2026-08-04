module gpr (
    input  wire        clk,
    input  wire        rst_n,      // active-low reset

    // Read port 1
    input  wire [4:0]  rs1_addr,   // rs1 read address
    output wire [31:0] rs1_data,   // rs1 read data

    // Read port 2
    input  wire [4:0]  rs2_addr,   // rs2 read address
    output wire [31:0] rs2_data,   // rs2 read data

    // Write port
    input  wire        wen,        // write enable (active high)
    input  wire [4:0]  rd_addr,    // rd write address
    input  wire [31:0] rd_data     // rd write data
);

    // 32-entry register file
    reg [31:0] rf [0:31];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                rf[i] <= 32'h0;
            end
        end else if (wen && (rd_addr != 5'd0)) begin
            rf[rd_addr] <= rd_data;
        end
    end

    assign rs1_data = (rs1_addr == 5'd0) ? 32'h0 :
                      ((wen && (rs1_addr == rd_addr)) ? rd_data : rf[rs1_addr]);

    assign rs2_data = (rs2_addr == 5'd0) ? 32'h0 :
                      ((wen && (rs2_addr == rd_addr)) ? rd_data : rf[rs2_addr]);

endmodule