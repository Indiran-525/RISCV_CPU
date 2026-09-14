
// reg_file.v - register file for single-cycle RISC-V CPU
//              (with 32 registers, each of 32 bits)
//              having two read ports, one write port
//              write port is synchronous, read ports are combinational
//              register 0 is hardwired to 0

module reg_file #(parameter DATA_WIDTH = 32) (
    input       clk,
    input       wr_en,
    input       [4:0] rd_addr1, rd_addr2, wr_addr,
    input       [DATA_WIDTH-1:0] wr_data,
    output      [DATA_WIDTH-1:0] rd_data1, rd_data2
);

reg [DATA_WIDTH-1:0] reg_file_arr [0:31];

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        reg_file_arr[i] = 0;
    end
end

wire [31:0] dbg_x1_ra  = reg_file_arr[1];  // Return Address
wire [31:0] dbg_x2_sp  = reg_file_arr[2];  // Stack Pointer (Crucial for C code)
wire [31:0] dbg_x8_s0  = reg_file_arr[8];  // Frame Pointer
wire [31:0] dbg_x10_a0 = reg_file_arr[10]; // Function Argument / Return Value
wire [31:0] dbg_x14_a4 = reg_file_arr[14]; // Commonly used by GCC for math
wire [31:0] dbg_x15_a5 = reg_file_arr[15]; // Commonly used by GCC for math

// register file write logic (synchronous)
always @(posedge clk) begin
    if (wr_en) reg_file_arr[wr_addr] <= wr_data;
end

// register file read logic (combinational)
assign rd_data1 = ( rd_addr1 != 0 ) ? reg_file_arr[rd_addr1] : 0;
assign rd_data2 = ( rd_addr2 != 0 ) ? reg_file_arr[rd_addr2] : 0;

endmodule

