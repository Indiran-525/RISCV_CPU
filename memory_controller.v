module memory_controller (
    input[31:0] addr,
    input cpu_wr_en,
    input[31:0] rd_data_hw,
    input[31:0] rd_data_dm,
    output reg[31:0] rd_data,
    output reg dmem_wr_en,
    output reg hw_wr_en
);

localparam[31:0] DMEM_BEGIN = 32'h00001000;
localparam[31:0] DMEM_END   = 32'h00001FFF;
localparam[31:0] HW_MEM_BEGIN   = 32'h20000000;
localparam[31:0] HW_MEM_END   = 32'h20000FFF;

always@(*) begin
  if(cpu_wr_en) begin
    if(addr >= DMEM_BEGIN && addr <= DMEM_END) begin
      dmem_wr_en = 1'b1;
      hw_wr_en = 1'b0;
    end
    else if (addr >= HW_MEM_BEGIN && addr <= HW_MEM_END) begin
      dmem_wr_en = 1'b0;
      hw_wr_en = 1'b1;
    end
    else begin
      dmem_wr_en = 1'b0;
      hw_wr_en = 1'b0;
    end
  end
  else begin
    dmem_wr_en = 1'b0;
    hw_wr_en = 1'b0;
  end
end

always@(*) begin
    if(addr >= DMEM_BEGIN && addr <= DMEM_END) begin
      rd_data = rd_data_dm;
    end
    else if (addr >= HW_MEM_BEGIN && addr <= HW_MEM_END) begin
      rd_data = rd_data_hw;
    end
    else begin
      rd_data = 32'h0;
    end
end 

endmodule