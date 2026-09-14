
// t1c_riscv_cpu.v - Top Module to test riscv_cpu

module t1c_riscv_cpu (
    input         clk, reset,
    input         Ext_MemWrite,
    input  [31:0] Ext_WriteData, Ext_DataAdr,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PC, Result
);

wire [31:0] Instr;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire        MemWrite_rv32;
wire dmem_wr_en, hw_wr_en;
wire [31:0] FinalReadData, HardwareDataRead;

// instantiate processor and memories
riscv_cpu rvcpu    (clk, reset, PC, Instr,
                    MemWrite_rv32, DataAdr_rv32,
                    WriteData_rv32, FinalReadData, Result);
instr_mem instrmem (PC, Instr);
data_mem  datamem  (clk, dmem_wr_en, DataAdr, WriteData, Instr[14:12], ReadData);
memory_controller cntrl (DataAdr, MemWrite, HardwareDataRead, ReadData, FinalReadData, dmem_wr_en, hw_wr_en);
hw_memory hw (clk, hw_wr_en, Instr[14:12], DataAdr[11:0], WriteData, HardwareDataRead);

assign MemWrite  = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

endmodule

