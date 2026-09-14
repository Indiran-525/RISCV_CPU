module hw_memory #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 12, MEM_SIZE = 4096) (
    input clk,
    input wr_en,
    input [2:0] funct3,
    input[ADDR_WIDTH-1:0] wr_addr,
    input [DATA_WIDTH-1:0] wr_data,
    output reg[DATA_WIDTH-1:0] rd_data_mem
);

reg [31:0] hw_memory_file [0:MEM_SIZE-1];

always @(posedge clk) begin
    if (wr_en) begin
		case(funct3)
			3'b000: begin
				case(wr_addr[1:0])
					2'b00: hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7:0] <= wr_data[7:0];
					2'b01: hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:8] <= wr_data[7:0];
					2'b10: hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][23:16] <= wr_data[7:0];
					2'b11: hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:24] <= wr_data[7:0];
					default: hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7:0] <= 8'bx;
				endcase
			end
			
			3'b001: begin
				if(!wr_addr[1])  hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:0] <= wr_data[15:0];
				else  hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:16] <= wr_data[15:0];
			end
			
			3'b010: hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE] <= wr_data;
			default: hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE] <= 32'bx;
			endcase
	 end
end

always@(*) begin
	case(funct3)
		3'b000: begin
			case(wr_addr[1:0])
				2'b00: rd_data_mem = {{24{hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7]}},hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7:0]};
				2'b01: rd_data_mem = {{24{hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15]}},hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:8]};
				2'b10: rd_data_mem = {{24{hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][23]}},hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][23:16]};
				2'b11: rd_data_mem = {{24{hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31]}},hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:24]};
			endcase
		end
		3'b001: begin
			if(!wr_addr[1]) rd_data_mem = {{16{hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15]}},hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:0]};
			else rd_data_mem = {{16{hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31]}},hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:16]};
		end
		3'b010: rd_data_mem = hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE];
		
		3'b100: begin
			case(wr_addr[1:0])
				2'b00: rd_data_mem = {24'b0,hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7:0]};
				2'b01: rd_data_mem = {24'b0,hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:8]};
				2'b10: rd_data_mem = {24'b0,hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][23:16]};
				2'b11: rd_data_mem = {24'b0,hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:24]};
			endcase
		end
		
		3'b101: begin
			if(!wr_addr[1]) rd_data_mem = {16'b0,hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:0]};
			else rd_data_mem = {16'b0,hw_memory_file[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:16]};
		end
		default: rd_data_mem = 32'bx;
	endcase
end

endmodule